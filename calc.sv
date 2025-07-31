`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Jing Xuan
// 
// Create Date: 20.04.2025 12:23:51
// File Name: calc.sv
// Module Name: cal
// Project Name: 8-bit integer calculator
// Code Type: RTL level
// Description: Modelling of 8-bit integer calculator
// 
//////////////////////////////////////////////////////////////////////////////////
module calc(
input logic VCC,
input logic GROUND,
input logic i_sys_clock,
input logic i_sys_reset,
input logic i_calc_clear,
input logic i_calc_equal,
input logic [3:0] i_calc_op_keypad_row,
input logic [3:0] i_calc_hex_keypad_row,
output logic [3:0] o_calc_op_keypad_column,
output logic [3:0] o_calc_hex_keypad_column,
output logic [7:0] o_calc_dis,
output logic [3:0] o_calc_sel);

wire clear, equal, valid, hex_overflow, overflow, hex_new_input;
wire [3:0] hex_row;
wire [3:0] op_row;
logic r_calc_neg_flag;
logic [3:0] r_calc_operator;
logic [7:0] r_calc_operand;
logic [8:0] r_calc_result;

b_sync
sync
(.i_sys_clock(i_sys_clock),
.i_sys_reset(i_sys_reset),
.i_b_sync_clear(i_calc_clear),
.i_b_sync_equal(i_calc_equal),
.i_b_sync_op_keypad_row(i_calc_op_keypad_row),
.i_b_sync_hex_keypad_row(i_calc_hex_keypad_row),
.o_b_sync_clear(clear),
.o_b_sync_equal(equal),
.o_b_sync_hex_keypad_row(hex_row),
.o_b_sync_op_keypad_row(op_row));


b_hex
hex
(.i_sys_clock(i_sys_clock),
.i_sys_reset(i_sys_reset),
.i_b_hex_keypad_row(hex_row),
.i_b_hex_clear(clear),
.i_b_hex_op_valid_key_pressed(valid),
.o_b_hex_keypad_column(o_calc_hex_keypad_column),
.o_b_hex_keycode(r_calc_operand),
.o_b_hex_overflow_flag(hex_overflow),
.o_b_hex_new_input(hex_new_input));


b_op
op
(.i_sys_clock(i_sys_clock),
.i_sys_reset(i_sys_reset),
.i_b_op_hex_new_input(hex_new_input),
.i_b_op_keypad_row(op_row),
.o_b_op_keycode(r_calc_operator),
.o_b_op_valid_key_pressed(valid),
.o_b_op_neg_flag(r_calc_neg_flag),
.o_b_op_keypad_column(o_calc_op_keypad_column));


b_alu
alu
(.i_sys_clock(i_sys_clock),
.i_sys_reset(i_sys_reset),
.i_b_alu_equal(equal),
.i_b_alu_en(valid),
.i_b_alu_op_keycode(r_calc_operator),
.i_b_alu_operand({r_calc_neg_flag,r_calc_operand}),
.o_b_alu_result(r_calc_result),
.o_b_alu_overflow_flag(overflow));


b_dis
dis
(.i_sys_clock(i_sys_clock),
.i_sys_reset(i_sys_reset),
.i_b_dis_result_overflow_flag(overflow),
.i_b_dis_hex_overflow_flag(hex_overflow),
.i_b_dis_op_valid_key_pressed(valid),
.i_b_dis_equal(equal),
.i_b_dis_neg_flag(r_calc_neg_flag),
.i_b_dis_neg_result(r_calc_result[8]),
.i_b_dis_result(r_calc_result[7:0]),
.i_b_dis_hex_keycode(r_calc_operand),
.o_b_dis_dis_code(o_calc_dis),
.o_b_dis_sel(o_calc_sel));

endmodule
