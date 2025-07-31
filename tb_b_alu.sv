timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Chow Bin Lin
// 
// Create Date: 05/05/2025 12:28:34 PM
// File Name:tb_b_alu.sv 
// Module Name: tb_b_alu
// Project Name: 8-bit integer calculator
// Code type: Behavioural 
// Description: Teshbench for ALU calculator
// 
//////////////////////////////////////////////////////////////////////////////////


module b_alu_testbench();
logic tb_i_sys_clock=0, tb_i_sys_reset=0, tb_i_b_alu_equal=0, tb_i_b_alu_en=0, tb_o_b_alu_overflow_flag;
logic [3:0] tb_i_b_alu_op_keycode=0;
logic [8:0] tb_i_b_alu_operand=0, tb_o_b_alu_result;



always
 #5 tb_i_sys_clock = ~tb_i_sys_clock;
 
 b_alu alu(.o_b_alu_result(tb_o_b_alu_result),.o_b_alu_overflow_flag(tb_o_b_alu_overflow_flag),.i_sys_clock(tb_i_sys_clock),.i_sys_reset(tb_i_sys_reset)
 ,.i_b_alu_equal(tb_i_b_alu_equal),.i_b_alu_en(tb_i_b_alu_en),.i_b_alu_op_keycode(tb_i_b_alu_op_keycode),.i_b_alu_operand(tb_i_b_alu_operand));
  
 initial begin
    // case 1： reset
    #2 tb_i_sys_reset <= 1;
    
    // case 2: input
    #10 tb_i_sys_reset = 0;
    #10 tb_i_b_alu_operand<= 9'b0_0000_0010; 
        tb_i_b_alu_equal<= 1; 

    // case 3: +
    #10 tb_i_sys_reset <= 1; // reset 
        tb_i_b_alu_op_keycode<=4'b0000;// when reset is trigger 4'b0000 would be received
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b0000;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0100; 
    #10 tb_i_b_alu_equal<=1;
    
    // case 4: -
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b0001;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0100;
    #10 tb_i_b_alu_equal<=1;    
    
    // case 5: *
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b0010;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0100;
    #10 tb_i_b_alu_equal<=1;
    
    // case 6: /
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b0011;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0100;
    #10 tb_i_b_alu_equal<=1;
    
    // case 7a: ~ With positive value

    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b0100;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_equal<=1;
    
    // case 7b: ~ With negative value 
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b1_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b0100;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_equal<=1;
    
    // case 8: &    
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_1111_0110;
    #10 tb_i_b_alu_op_keycode<=4'b0101;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0010;
    #10 tb_i_b_alu_equal<=1;
    
    // case 9: |
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_1111_0110;
    #10 tb_i_b_alu_op_keycode<=4'b0110;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0011;
    #10 tb_i_b_alu_equal<=1;
    
    // case 10: ^
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_1111_0110;
    #10 tb_i_b_alu_op_keycode<=4'b0111;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0011;
    #10 tb_i_b_alu_equal<=1;
    
        // case 11: >>
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0010_0000;
    #10 tb_i_b_alu_op_keycode<=4'b1000;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0100;
     #10 tb_i_b_alu_equal<=1;
    
    // case 12: <<
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b1001;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0100;
    #10 tb_i_b_alu_equal<=1;
    
    

    
    // case 13: >>>
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b1_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b1010;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0100;
    #10 tb_i_b_alu_equal<=1;
    
    
    // case 14: <<<
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b1011;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0100;
    #10 tb_i_b_alu_equal<=1;
    

    
    
    // case 15: Continuous Calculation and press equal button multiple times

    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_1010;
    #10 tb_i_b_alu_op_keycode<=4'b0000;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_1000;
    #10 tb_i_b_alu_op_keycode<=4'b0010;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0010;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0010;
    #10 tb_i_b_alu_equal<=1;
    #10 tb_i_b_alu_equal<=0;
    #10 tb_i_b_alu_equal<=1;

    
    // case 16: overflow
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_1111_1111;
    #10 tb_i_b_alu_op_keycode<=4'b0000;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_1111_1111;
    #10 tb_i_b_alu_equal<=1;
    
    
    // case 17: Invalid calculation
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b0011;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b0_0000_0000;
    #10 tb_i_b_alu_equal<=1;


    // case 18: Invalid input for swifter
    #10 tb_i_sys_reset <= 1;
        tb_i_b_alu_op_keycode<=4'b0000; 
        tb_i_b_alu_equal<= 0;        
    #10 tb_i_sys_reset <= 0;
        tb_i_b_alu_operand<= 9'b0_0000_0010;
    #10 tb_i_b_alu_op_keycode<=4'b1011;
        tb_i_b_alu_en<= 1;
    #10 tb_i_b_alu_en <= 0;
        tb_i_b_alu_operand <=9'b1_0000_0001;
    #10 tb_i_b_alu_equal<=1;
        
end
endmodule  