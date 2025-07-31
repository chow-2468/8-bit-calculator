`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Yu Heng
// 
// Create Date: 20.04.2025 00:48:59
// File Name: tb_b_hex.sv
// Module Name: tb_b_hex
// Project Name: 8-bit integer calculator
// Code Type: Behavioural
// Description: Testbench for hex keypad code generator
// 
//////////////////////////////////////////////////////////////////////////////////



module tb_b_hex;
  // Signals for the b_hex module
    logic tb_i_sys_clock;
    logic tb_i_sys_reset;
    logic [3:0] tb_i_b_hex_keypad_row;
    logic tb_i_b_hex_clear;
    logic tb_i_b_hex_op_valid_key_pressed;
    logic [3:0] tb_o_b_hex_keypad_column;
    logic [7:0] tb_o_b_hex_keycode;
    logic tb_o_b_hex_overflow_flag;
    logic tb_o_b_hex_new_input;

  // Instantiate the b_hex module
b_hex dut (
    .i_sys_clock(tb_i_sys_clock),
    .i_sys_reset(tb_i_sys_reset),
    .i_b_hex_keypad_row(tb_i_b_hex_keypad_row),
    .i_b_hex_clear(tb_i_b_hex_clear),
    .i_b_hex_op_valid_key_pressed(tb_i_b_hex_op_valid_key_pressed),
    .o_b_hex_keypad_column(tb_o_b_hex_keypad_column),
    .o_b_hex_keycode(tb_o_b_hex_keycode),
    .o_b_hex_overflow_flag(tb_o_b_hex_overflow_flag),
    .o_b_hex_new_input(tb_o_b_hex_new_input)
);

    // Clock generation
    always #5ns tb_i_sys_clock = ~tb_i_sys_clock; // 10ns period, 50MHz
    
    // Reset generation, changed to use tb_i_sys_reset
    
    // Testbench stimulus, changed to use tb_ signals
    // Reset generation
    initial begin
        tb_i_sys_clock = 1;
        tb_i_sys_reset = 1;
        #10;
        tb_i_sys_reset = 0;
    end
        
        // Testbench stimulus
    initial begin
        // Initialize all input signals. 
        tb_i_b_hex_keypad_row = 4'b1111;
        tb_o_b_hex_keypad_column=4'b1111;
        tb_i_b_hex_clear = 0;
        tb_i_b_hex_op_valid_key_pressed = 0;
        
        //-----------------------------------------
        // Test Case 1: Clear Input to Zero
        //-----------------------------------------
        #20;
        tb_i_b_hex_keypad_row = 4'b1011; // Key '9'
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #50;
        tb_i_b_hex_keypad_row = 4'b1110;// Key '1'
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #50
        tb_i_b_hex_clear = 1;
        #10;
        tb_i_b_hex_clear = 0;//reset
        
        //-----------------------------------------
        // Test Case 2: Use clear to reset Input and flags to Zero when input overflow
        //-----------------------------------------
        #20;
        tb_i_b_hex_keypad_row = 4'b1011; // First press
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #40;
        tb_i_b_hex_keypad_row = 4'b1011; // Second press
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #40;
        tb_i_b_hex_keypad_row = 4'b1011; // Third press (causing overflow)
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #50
        tb_i_b_hex_clear = 1;
        #10
        tb_i_b_hex_clear = 0;
        
        //-----------------------------------------
        // Test Case 3: Overflow on 3rd Hex Input (Input F59)
        //-----------------------------------------
        #40
        tb_i_b_hex_keypad_row = 4'b0111; // 'F'
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #70;
        tb_i_b_hex_keypad_row = 4'b1101; // '5'
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #40;
        tb_i_b_hex_keypad_row = 4'b1011; // '6' -> Overflow
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #40;
        
        //-----------------------------------------
        tb_i_b_hex_clear = 1;//reset accumulated input
        #10//wait
        tb_i_b_hex_clear = 0;
        
        //-----------------------------------------
        // Test Case 4: Valid Accumulated 8-bit Input (Input F5)
        //-----------------------------------------
        #10
        tb_i_b_hex_keypad_row = 4'b0111; // 'F'
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #70;
        tb_i_b_hex_keypad_row = 4'b1101; // '5'
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #50
        
        //-----------------------------------------
        #50;//wait
        //-----------------------------------------
        // Test Case 5: Second input after operator button is pressed
        //-----------------------------------------
        //not resetting previous input
        tb_i_b_hex_op_valid_key_pressed = 1;//set to high simulating operator button pressed to reset input count flag
        #10
        tb_i_b_hex_op_valid_key_pressed = 0;
        #30
        tb_i_b_hex_keypad_row = 4'b1011; // '9' 
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #40;
        tb_i_b_hex_keypad_row = 4'b1101; // '5'
        #10;
        tb_i_b_hex_keypad_row = 4'b1111;//reset
        #30;
        
        
        //-----------------------------------------
        #50//wait
        //-----------------------------------------
        // Test Case 5: Second input after operator button is pressed
        //-----------------------------------------
        //not resetting previous input
        tb_i_sys_reset = 1;
        #10
        tb_i_sys_reset = 0;
        
        #100
        
        $stop;  // Keep this, it stops the simulation after the stimulus.
    
    end
    
endmodule


