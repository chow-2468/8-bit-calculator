`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Chow Bin Lin
// 
// Create Date: 04/21/2025 01:29:31 AM
// File Name:b_alu.sv 
// Module Name: b_alu
// Project Name: 8-bit integer calculator
// Code type: RTL Level 
// Description: Modelling of ALU calculator
//////////////////////////////////////////////////////////////////////////////////


module b_alu(
output logic[8:0] o_b_alu_result, // result output
output logic o_b_alu_overflow_flag,// overflow or invalid
input logic  i_sys_clock, // system clock
i_sys_reset, // system reset
i_b_alu_equal, // equal button is trigger
i_b_alu_en,// 
input logic[3:0] i_b_alu_op_keycode, // operator keycode
input logic[8:0] i_b_alu_operand// operand get 
);

logic invert_active,overflow_flag_reg,invert_mode,previous_en,previous_equal;// internal reg
logic[3:0] op_reg;
logic[8:0] result_reg, temp_result,temp_overflow, invert_result;
logic[8:0] shift_reg[4:0];
logic signed [8:0]  operand_A, operand_B;

assign operand_A = result_reg[8]? (result_reg == 9'b1_0000_0000 ?'0:{1'b1,-result_reg[7:0]}):result_reg;
assign operand_B = i_b_alu_operand[8]? (i_b_alu_operand == 9'b1_0000_0000 ?'0:{1'b1,-i_b_alu_operand[7:0]}):i_b_alu_operand;        
assign o_b_alu_result = result_reg;
assign o_b_alu_overflow_flag = overflow_flag_reg;


always_comb begin
            temp_overflow = overflow_flag_reg;
            shift_reg[0]= operand_A;// ~
            if(i_b_alu_en) begin// input    
                if (operand_B[8])
                    invert_mode = 1'b1;
                if (invert_mode)
                    invert_result = ~operand_B; 
                else 
                    invert_result = {1'b0,~operand_B[7:0]};
            end
            else begin
                if (operand_A[8])
                    invert_mode = 1'b1;
                if (invert_mode)// result
                    invert_result = ~operand_A;
                else 
                    invert_result = {1'b0,~operand_A[7:0]};
            end

            case(op_reg)
            4'b0000:// +
            begin 
                temp_result = operand_A + operand_B;
                temp_overflow = (temp_result[8]^operand_A[8])&(operand_A[8]~^operand_B[8]);
            end 
            4'b0001://-
            begin 
                temp_result = operand_A - operand_B;
                temp_overflow = (temp_result[8]^operand_A[8])&(operand_A[8]~^(~operand_B[8]));
            end
            4'b0010: // *
            begin
                if(result_reg[7:0]*i_b_alu_operand[7:0]>255)
                    temp_overflow = 1'b1;
                else
                    temp_result = operand_A * operand_B;
            end
            4'b0011:// /
            begin
                if(~|operand_B)// if zero
                    temp_overflow = 1'b1;
                else
                    temp_result = operand_A / operand_B; // as default 
            end
            4'b0101:// &
            temp_result = operand_A & operand_B;
            4'b0110:// |
            temp_result = operand_A | operand_B;
            4'b0111:// ^
            temp_result = operand_A ^ operand_B;
            4'b1000,4'b1010:// >> or >>>
            begin
            casez(operand_B)
            9'b1_????_????: temp_overflow = 1'b1;
            
            9'b0_0000_0???,9'b0_0000_100?: begin
            for (int col = 0; col < 4; col++) begin
                for (int row = 0; row < 9; row++) // Each column
                    if (row >= 9-2**col) 
                    
                    shift_reg[col+1][row] = operand_B[col] ? (op_reg[1]?shift_reg[col][8]:0): shift_reg[col][row] ; 
                    else
                    
                    shift_reg[col+1][row] = operand_B[col] ? shift_reg[col][row+2**col] : shift_reg[col][row];
                
                end // end of for loop
            end
            default:
            shift_reg[4] = 9'b0;
            endcase
            temp_result = shift_reg[4];
            end
            4'b1001,4'b1011:// << or <<<
                begin
            
            casez(operand_B)
            9'b1_????_????: temp_overflow = 1'b1;
            
            9'b0_0000_0???,9'b0_0000_100?: begin
            for (int col = 0; col < 4; col++) begin
                for (int row = 0; row < 9; row++)begin // Each column
                
                    if (row < 2**col) 
                    
                    shift_reg[col+1][row] = operand_B[col] ? 0 : shift_reg[col][row]; 
                    else
                    
                    shift_reg[col+1][row] = operand_B[col] ? shift_reg[col][row-2**col] : shift_reg[col][row];
                    end
                end // end of for loop
            end
            default:
            shift_reg[4] = 9'b0;
            endcase
            temp_result = shift_reg[4];
            end
            default: 
            temp_result = operand_A;
            endcase

        casez(invert_result) // convert back to signed 
        9'b1_0000_0000: temp_overflow = 1; // special case -256
        9'b1_????_????: invert_result = {1'b1,-invert_result[7:0]};
        default : invert_result = invert_result; 
        endcase
        
        casez(temp_result) // convert back to signed 
        9'b1_0000_0000: temp_overflow = 1; // special case -256
        9'b1_????_????: temp_result = {1'b1,-temp_result[7:0]};
        default: temp_result = temp_result; 
        endcase
end


always_ff @(posedge i_sys_clock)begin
    if(i_sys_reset)begin
        invert_mode <= 1'b0;
        result_reg <= 9'b0;
        overflow_flag_reg <=1'b0;
        previous_en<=1'b0;
        invert_active<=1'b0;
        op_reg <= 4'b0;
    end
    
    else begin
    previous_en<= i_b_alu_en;
    previous_equal<=i_b_alu_equal;
    
    if(~(i_b_alu_op_keycode== 4'b0100||i_b_alu_op_keycode== 4'b1111))
        op_reg<= i_b_alu_op_keycode;


    if((~previous_en&&i_b_alu_en)^(~previous_equal&&i_b_alu_equal))begin // ensure only run once
        if (i_b_alu_op_keycode == 4'b0100)begin
            invert_active<=1;
            if(!invert_active||(~previous_equal&&i_b_alu_equal))begin
                result_reg<=invert_result;
                overflow_flag_reg<=temp_overflow;
            end
        end
        else begin
            result_reg<=temp_result;
            overflow_flag_reg<=temp_overflow;
        end
    end
    if (i_b_alu_op_keycode != 4'b0100)
        invert_active<=0;
    end
    end
endmodule
