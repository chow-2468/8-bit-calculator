`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Yu Heng
// 
// Create Date: 21.04.2025 19:16:19
// File Name: tb_b_sync.sv
// Module Name: tb_b_sync
// Project Name: 8-bit integer calculator
// Code Type: Behavioural
// Description: Testbench for synchronizer
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_b_sync;

  logic        tb_i_sys_clock;
  logic        tb_i_sys_reset;
  logic        tb_i_b_sync_clear;
  logic        tb_i_b_sync_equal;
  logic [3:0]  tb_i_b_sync_hex_keypad_row;
  logic [3:0]  tb_i_b_sync_op_keypad_row;
  logic        tb_o_b_sync_clear;
  logic        tb_o_b_sync_equal;
  logic [3:0]  tb_o_b_sync_hex_keypad_row;
  logic [3:0]  tb_o_b_sync_op_keypad_row;
  
  b_sync b_sync_dut (
    .i_b_sync_clear(tb_i_b_sync_clear),
    .i_b_sync_equal(tb_i_b_sync_equal),
    .i_b_sync_hex_keypad_row(tb_i_b_sync_hex_keypad_row),
    .i_b_sync_op_keypad_row(tb_i_b_sync_op_keypad_row),
    .i_sys_clock(tb_i_sys_clock),
    .i_sys_reset(tb_i_sys_reset),
    .o_b_sync_clear(tb_o_b_sync_clear),
    .o_b_sync_equal(tb_o_b_sync_equal),
    .o_b_sync_hex_keypad_row(tb_o_b_sync_hex_keypad_row),
    .o_b_sync_op_keypad_row(tb_o_b_sync_op_keypad_row)
  );

    // Clock generation
    always #5 tb_i_sys_clock = ~tb_i_sys_clock; // 10ns period, 50MHz
    
    // Reset
    initial begin
        tb_i_sys_clock = 1;
        tb_i_sys_reset = 1;
        #10;
        tb_i_sys_reset = 0;
    end
 
    initial begin
        // Initialize all inputs
        tb_i_b_sync_clear = 0;
        tb_i_b_sync_equal = 0;
        tb_i_b_sync_hex_keypad_row = 4'b1111;
        tb_i_b_sync_op_keypad_row = 4'b1111;
        
        //----------------------------------------------------------------------
        // Test Case 1: Asynchronous input change of clear button
        //----------------------------------------------------------------------
        #20; 
        tb_i_b_sync_clear = 1;
        #50; //5 clock cycles
        tb_i_b_sync_clear = 0;
        #20; 
        
        //----------------------------------------------------------------------
        // Test Case 2: Asynchronous input change of equal button
        //----------------------------------------------------------------------
        #20;
        tb_i_b_sync_equal = 1;
        #50;// 5 clock cycles
        tb_i_b_sync_equal = 0;
        #20;
        
        //----------------------------------------------------------------------
        // Test Case 3: Asynchronous input change of hex keypad row signal
        //----------------------------------------------------------------------
        #20;
        tb_i_b_sync_hex_keypad_row = 4'b1011;
        #50;//5 clock cycles
        tb_i_b_sync_hex_keypad_row = 4'b1111; // Return to default
        #20;
        
        //----------------------------------------------------------------------
        // Test Case 4: Asynchronous input change of operator keypad row signal
        //----------------------------------------------------------------------
        #20;
        tb_i_b_sync_op_keypad_row = 4'b1110;
        #50;//5 clock cycles
        tb_i_b_sync_op_keypad_row = 4'b1111;
        #20;
        
        //----------------------------------------------------------------------
        // Test Case 5: Reset button pressed
        //----------------------------------------------------------------------
        #20;
        tb_i_b_sync_clear = 1;
        tb_i_b_sync_equal = 1;
        tb_i_b_sync_hex_keypad_row = 4'b1011;
        tb_i_b_sync_op_keypad_row = 4'b1110;
        #20
        tb_i_sys_reset = 1;
        #50; // simulate pressing reset button
        tb_i_sys_reset = 0;
    
        #150; 
        $stop;
  end


endmodule
