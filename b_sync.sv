`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Yu Heng
// 
// Create Date: 21.04.2025 18:24:32
// File Name: b_sync.sv
// Module Name: b_sync
// Project Name: 8-bit integer calculator
// Code Type: RTL level
// Description: Modelling of synchronizer
// 
//////////////////////////////////////////////////////////////////////////////////

module b_sync (
    input  logic        i_b_sync_clear,
    input  logic        i_b_sync_equal,
    input  logic [3:0]  i_b_sync_hex_keypad_row,
    input  logic [3:0]  i_b_sync_op_keypad_row,
    input  logic        i_sys_clock,
    input  logic        i_sys_reset,
    output logic        o_b_sync_clear,
    output logic        o_b_sync_equal,
    output logic [3:0]  o_b_sync_hex_keypad_row,
    output logic [3:0]  o_b_sync_op_keypad_row
);

    // First stage registers
    logic        sync_clear_1;
    logic        sync_equal_1;
    logic [3:0]  sync_hex_keypad_row_1;
    logic [3:0]  sync_op_keypad_row_1;
    
    // Second stage registers
    logic        sync_clear_2;
    logic        sync_equal_2;
    logic [3:0]  sync_hex_keypad_row_2;
    logic [3:0]  sync_op_keypad_row_2;
    
    // Double flip flop synchronizer
    always_ff @(posedge i_sys_clock or posedge i_sys_reset) begin
        if (i_sys_reset) begin
            // Reset all registers
            sync_clear_1 <= 1'b0;
            sync_equal_1 <= 1'b0;
            sync_hex_keypad_row_1 <= 4'b1111;
            sync_op_keypad_row_1 <= 4'b1111;
            
            sync_clear_2 <= 1'b0;
            sync_equal_2 <= 1'b0;
            sync_hex_keypad_row_2 <= 4'b1111;
            sync_op_keypad_row_2 <= 4'b1111;
        end
        
        else begin
            // First stage flip flop (capture inputs to stage 1 registers)
            sync_clear_1 <= i_b_sync_clear;
            sync_equal_1 <= i_b_sync_equal;
            sync_hex_keypad_row_1 <= i_b_sync_hex_keypad_row;
            sync_op_keypad_row_1 <= i_b_sync_op_keypad_row;
            
            // Second stage flip flop(transfer from stage 1 to stage 2 registers)
            sync_clear_2 <= sync_clear_1;
            sync_equal_2 <= sync_equal_1;
            sync_hex_keypad_row_2 <= sync_hex_keypad_row_1;
            sync_op_keypad_row_2 <= sync_op_keypad_row_1;
        end
    end
    
    // Connect synchronized registers to outputs
    assign o_b_sync_clear = sync_clear_2;
    assign o_b_sync_equal = sync_equal_2;
    assign o_b_sync_hex_keypad_row = sync_hex_keypad_row_2;
    assign o_b_sync_op_keypad_row = sync_op_keypad_row_2;
endmodule
