`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Yu Heng
// 
// Create Date: 20.04.2025 10:34:46
// File Name: b_op.sv
// Module Name: b_op
// Project Name: 8-bit integer calculator
// Code Type: RTL level
// Description: Modelling of operator keypad code generator
// 
//////////////////////////////////////////////////////////////////////////////////


module b_op (
    input  logic        i_sys_clock,
    input  logic        i_sys_reset,
    input  logic        i_b_op_hex_new_input,
    input  logic [3:0]  i_b_op_keypad_row,
    output logic [3:0]  o_b_op_keycode,
    output logic        o_b_op_valid_key_pressed,
    output logic        o_b_op_neg_flag,
    output logic [3:0]  o_b_op_keypad_column
);
    
    logic [3:0] temp_op;
    logic key_pressed_flag;//to indicate if the button is pressed
    logic valid_press;//to indicate valid key press
    logic [3:0] row_delayed;      // delay row by one clock cycle to synchronize wave output with the column

    // Delay the Row signal by one clock cycle
    always_ff @(posedge i_sys_clock or posedge i_sys_reset) begin
        if (i_sys_reset)
            row_delayed <= 4'b1111; // idle state (all unpressed)
        else
            row_delayed <= i_b_op_keypad_row;
    end

    
    // Drive the column cycling
    always_ff @(posedge i_sys_clock or posedge i_sys_reset) begin//loop to scan the column keypad 
        if (i_sys_reset)
        o_b_op_keypad_column <= 4'b1110; // Start with column 0 active
        else begin
            case (o_b_op_keypad_column)
                4'b1110: o_b_op_keypad_column <= 4'b1101; // col 1
                4'b1101: o_b_op_keypad_column <= 4'b1011; // col 2
                4'b1011: o_b_op_keypad_column <= 4'b0111; // col 3
                4'b0111: o_b_op_keypad_column <= 4'b1111; // idle
                default: o_b_op_keypad_column <= 4'b1110; // loop back to col 0
            endcase
        end
    end
    
    function logic [3:0] decode_key (input logic [3:0] row, input logic [3:0] col);
      // function to convert row and column read into hex decoded key
        case ({row, col})
            {4'b1110, 4'b1110}: decode_key = 4'b0000; // "Add" operation
            {4'b1101, 4'b1110}: decode_key = 4'b0001; // "Minus" operation
            {4'b1011, 4'b1110}: decode_key = 4'b0010; // "Multiply" operation
            {4'b0111, 4'b1110}: decode_key = 4'b0011; // "Divide" operation
            {4'b1110, 4'b1101}: decode_key = 4'b0100; // "NOT" operation
            {4'b1101, 4'b1101}: decode_key = 4'b0101; // "AND" operation
            {4'b1011, 4'b1101}: decode_key = 4'b0110; // "OR" operation
            {4'b0111, 4'b1101}: decode_key = 4'b0111; // "XOR" operation
            {4'b1110, 4'b1011}: decode_key = 4'b1000; // "Bitwise right shift" operation
            {4'b1101, 4'b1011}: decode_key = 4'b1001; // "Bitwise left shift" operation
            {4'b1011, 4'b1011}: decode_key = 4'b1010; // "Arithmetic right shift" operation
            {4'b0111, 4'b1011}: decode_key = 4'b1011; // "Arithmetic left shift" operation
            {4'b1110, 4'b0111}: decode_key = 4'b1100; // Change sign: + to - / - to +
            default:              decode_key = 4'b1111; // Invalid operator input for empty key
          endcase
    endfunction
    
    assign temp_op = decode_key(row_delayed, o_b_op_keypad_column);  
    assign valid_press = (o_b_op_keypad_column != 4'b1111 && row_delayed != 4'b1111);
    
    always_ff @(posedge i_sys_clock or posedge i_sys_reset) begin
        if (i_sys_reset) begin// Reset all states and outputs
            o_b_op_keycode <= 4'b1111;//default no operation key pressed
            o_b_op_valid_key_pressed <= 0;
            o_b_op_neg_flag <= 0;
        end  
        
        else if(valid_press &&!key_pressed_flag) begin//start when key is pressed
            case (temp_op)
                4'b1100: begin//when the input is change sign function
                    o_b_op_neg_flag <= 1;
                    key_pressed_flag <= 0;
                    o_b_op_keycode <= 4'b1111;//pass the decoded keycode to other blocks
                    o_b_op_valid_key_pressed <= 0;
                end
                
                4'b1111: begin//when the input empty key
                    o_b_op_neg_flag <= 0;
                    key_pressed_flag <= 0;
                    o_b_op_keycode <= 4'b1111;//pass the decoded keycode to other blocks
                    o_b_op_valid_key_pressed <= 0;
                end
                
                default: begin//when the input is valid keys
                    key_pressed_flag <= 1;
                    o_b_op_keycode <= temp_op;//pass the decoded keycode to other blocks
                    o_b_op_valid_key_pressed <= 1;//valid key
                end
            endcase
        end  
        
        else if (i_b_op_hex_new_input)                              
            o_b_op_neg_flag <= 0;//clear the negative flag if new input is keyed in
        
        else if(!valid_press) begin
            key_pressed_flag <= 0;//release key
            o_b_op_valid_key_pressed <= 0;//only set high the flag for 1 clock cycle
        end
    end

endmodule
