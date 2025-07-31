`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Jing Xuan  
// 
// Create Date: 20.04.2025 16:01:24
// File Name: tb_b_dis.sv
// Module Name: tb_b_dis
// Project Name: 8-bit integer calculator
// Code Type: Behavioural 
// Description: Testbench for 7-segment display decoder
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_b_dis;

logic tb_sys_clock;
logic tb_sys_reset;
logic tb_b_dis_result_overflow_flag;
logic tb_b_dis_hex_overflow_flag;
logic tb_b_dis_op_valid_key_pressed;
logic tb_b_dis_equal;
logic tb_b_dis_neg_flag;
logic tb_b_dis_neg_result;
logic [7:0] tb_b_dis_result;
logic [7:0] tb_b_dis_hex_keycode;
wire [6:0] tb_b_dis_dis_code;
wire [3:0] tb_b_dis_sel;

b_dis dut_b_dis
(.i_sys_clock(tb_sys_clock),
.i_sys_reset(tb_sys_reset),
.i_b_dis_result_overflow_flag(tb_b_dis_result_overflow_flag),
.i_b_dis_hex_overflow_flag(tb_b_dis_hex_overflow_flag),
.i_b_dis_op_valid_key_pressed(tb_b_dis_op_valid_key_pressed),
.i_b_dis_equal(tb_b_dis_equal),
.i_b_dis_neg_flag(tb_b_dis_neg_flag),
.i_b_dis_neg_result(tb_b_dis_neg_result),
.i_b_dis_result(tb_b_dis_result),
.i_b_dis_hex_keycode(tb_b_dis_hex_keycode),
.o_b_dis_dis_code(tb_b_dis_dis_code),
.o_b_dis_sel(tb_b_dis_sel));

initial begin
tb_sys_clock = 1'b1;
forever #5 tb_sys_clock = ~tb_sys_clock;
end


//Test case 1 (No input)
initial begin
tb_sys_reset = 1'b0;
tb_b_dis_result_overflow_flag = 1'b0; 
tb_b_dis_hex_overflow_flag = 1'b0; 
tb_b_dis_op_valid_key_pressed = 1'b0; 
tb_b_dis_equal = 1'b0; 
tb_b_dis_neg_flag = 1'b0; 
tb_b_dis_neg_result = 1'b0; 
tb_b_dis_result = 8'b0; 
tb_b_dis_hex_keycode = 8'b0; 


//Test case 2 (Reset is triggered)
#80tb_sys_reset = 1'b1;
tb_b_dis_result_overflow_flag = 1'b0; 
tb_b_dis_hex_overflow_flag = 1'b0; 
tb_b_dis_op_valid_key_pressed = 1'b0; 
tb_b_dis_equal = 1'b0; 
tb_b_dis_neg_flag = 1'b0; 
tb_b_dis_neg_result = 1'b0; 
tb_b_dis_result = 8'b0; 
tb_b_dis_hex_keycode = 8'b0; 


//Test case 3 (Result overflow)
#40tb_sys_reset = 1'b0;
tb_b_dis_result_overflow_flag = 1'b1; 
tb_b_dis_hex_overflow_flag = 1'b0; 
tb_b_dis_op_valid_key_pressed = 1'b0; 
tb_b_dis_equal = 1'b0; 
tb_b_dis_neg_flag = 1'b0; 
tb_b_dis_neg_result = 1'b0; 
tb_b_dis_result = 8'b0; 
tb_b_dis_hex_keycode = 8'b0; 


//Test case 4 (Hex input overflow)
#40tb_sys_reset = 1'b0;
tb_b_dis_result_overflow_flag = 1'b0; 
tb_b_dis_hex_overflow_flag = 1'b1; 
tb_b_dis_op_valid_key_pressed = 1'b0; 
tb_b_dis_equal = 1'b0; 
tb_b_dis_neg_flag = 1'b0; 
tb_b_dis_neg_result = 1'b0; 
tb_b_dis_result = 8'b0; 
tb_b_dis_hex_keycode = 8'b0; 


//Test case 5 (Display hex keypad value)
#40tb_sys_reset = 1'b0;
tb_b_dis_result_overflow_flag = 1'b0; 
tb_b_dis_hex_overflow_flag = 1'b0; 
tb_b_dis_op_valid_key_pressed = 1'b0; 
tb_b_dis_equal = 1'b0; 
tb_b_dis_neg_flag = 1'b0; 
tb_b_dis_neg_result = 1'b0; 
tb_b_dis_result = 8'b0; 
tb_b_dis_hex_keycode = 8'b01100100; 


//Test case 6 (Display negative value)
#40tb_sys_reset = 1'b0;
tb_b_dis_result_overflow_flag = 1'b0; 
tb_b_dis_hex_overflow_flag = 1'b0; 
tb_b_dis_op_valid_key_pressed = 1'b0; 
tb_b_dis_equal = 1'b0; 
tb_b_dis_neg_flag = 1'b1; 
tb_b_dis_neg_result = 1'b0; 
tb_b_dis_result = 8'b0; 
tb_b_dis_hex_keycode = 8'b01100100; 


//Test case 7 (Display result)
#40tb_sys_reset = 1'b0;
tb_b_dis_result_overflow_flag = 1'b0; 
tb_b_dis_hex_overflow_flag = 1'b0; 
tb_b_dis_op_valid_key_pressed = 1'b1; 
tb_b_dis_equal = 1'b0; 
tb_b_dis_neg_flag = 1'b0; 
tb_b_dis_neg_result = 1'b0; 
tb_b_dis_result = 8'b01000010; 
tb_b_dis_hex_keycode = 8'b00000000; 


//Test case 8 (Display negative result)
#40tb_sys_reset = 1'b0;
tb_b_dis_result_overflow_flag = 1'b0; 
tb_b_dis_hex_overflow_flag = 1'b0; 
tb_b_dis_op_valid_key_pressed = 1'b0; 
tb_b_dis_equal = 1'b1; 
tb_b_dis_neg_flag = 1'b0; 
tb_b_dis_neg_result = 1'b1; 
tb_b_dis_result = 8'b01000010; 
tb_b_dis_hex_keycode = 8'b0; 
end

initial #360 $stop;
endmodule
