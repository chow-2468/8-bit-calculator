`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Yu Heng
// 
// Create Date: 20.04.2025 14:23:23
// File Name: tb_b_op.sv
// Module Name: tb_b_op
// Project Name: 8-bit integer calculator
// Code Type: Behavioural
// Description: Testbench for operator keypad code generator
// 
//////////////////////////////////////////////////////////////////////////////////

module tb_b_op;
    
    logic       tb_i_sys_clock;
    logic       tb_i_sys_reset;
    logic [3:0] tb_i_b_op_keypad_row;
    logic       tb_i_b_op_hex_new_input;
    logic [3:0] tb_o_b_op_keypad_column;
    logic [3:0] tb_o_b_op_keycode;
    logic       tb_o_b_op_valid_key_pressed;
    logic       tb_o_b_op_neg_flag;
    
    // Instantiate the b_hex module
b_op 
b_op_dut (
    .i_sys_clock(tb_i_sys_clock),
    .i_sys_reset(tb_i_sys_reset),
    .i_b_op_keypad_row(tb_i_b_op_keypad_row),
    .i_b_op_hex_new_input(tb_i_b_op_hex_new_input),
    .o_b_op_keycode(tb_o_b_op_keycode),
    .o_b_op_valid_key_pressed(tb_o_b_op_valid_key_pressed),
    .o_b_op_neg_flag(tb_o_b_op_neg_flag),
    .o_b_op_keypad_column(tb_o_b_op_keypad_column)
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
    
    initial begin
        // Initialize all input signals.
        tb_i_b_op_keypad_row = 4'b1111; 
        tb_o_b_op_keypad_column = 4'b1111;
        tb_i_b_op_hex_new_input = 0;
        //-----------------------------------------
        // Test Case 1: No key pressed
        //-----------------------------------------
        #50; // Wait for a few clock cycles
    
        //-----------------------------------------
        // Test Case 2: Change sign button pressed
        //-----------------------------------------
        #30; // Wait for column to become 4'b0111
        tb_i_b_op_keypad_row = 4'b1110;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
        
        //-----------------------------------------
        // Test Case 3: New input keyed in when negative flag is high
        //-----------------------------------------
        #50
        tb_i_b_op_hex_new_input = 1;//set new input flag to high for 1 clock cycle
        #10
        tb_i_b_op_hex_new_input = 0;
        #40
    
        //-----------------------------------------
        // Test Case 4: "Add" operation chosen
        //-----------------------------------------
        #10; // Wait for column to become 4'b1110
        tb_i_b_op_keypad_row = 4'b1110;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 5: "Minus" operation chosen
        //-----------------------------------------
        #40; // Wait for column to become 4'b1110
        tb_i_b_op_keypad_row = 4'b1101;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 6: "Multiply" operation chosen
        //-----------------------------------------
        #40; // Wait for column to become 4'b1110
        tb_i_b_op_keypad_row = 4'b1011;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 7: "Divide" operation chosen
        //-----------------------------------------
        #40; // Wait for column to become 4'b1110
        tb_i_b_op_keypad_row = 4'b0111;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 8: "NOT" operation chosen
        //-----------------------------------------
        #50; // Wait for column to become 4'b1101
        tb_i_b_op_keypad_row = 4'b1110;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 9: "AND" operation chosen
        //-----------------------------------------
        #40; // Wait for column to become 4'b1101
        tb_i_b_op_keypad_row = 4'b1101;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 10: "OR" operation chosen
        //-----------------------------------------
        #40; // Wait for column to become 4'b1101
        tb_i_b_op_keypad_row = 4'b1011;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the buttoncapture
    
        //-----------------------------------------
        // Test Case 11: "XOR" operation chosen
        //-----------------------------------------
        #40; // Wait for column to become 4'b1101
        tb_i_b_op_keypad_row = 4'b0111;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 12: "Bitwise right shift" operation chosen
        //-----------------------------------------
        #50; // Wait for column to become 4'b1011
        tb_i_b_op_keypad_row = 4'b1110;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 13: "Bitwise left shift" operation chosen
        //-----------------------------------------
        #40; // Wait for column to become 4'b1011
        tb_i_b_op_keypad_row = 4'b1101;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 14: "Arithmetic right shift" operation chosen
        //-----------------------------------------
        #40; // Wait for column to become 4'b1011
        tb_i_b_op_keypad_row = 4'b1011;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
    
        //-----------------------------------------
        // Test Case 15: "Arithmetic left shift" operation chosen
        //-----------------------------------------
        #40; // Wait for column to become 4'b1011
        tb_i_b_op_keypad_row = 4'b0111;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
        
        //-----------------------------------------
        // Test Case 16: Invalid operator input for empty key chosen
        //-----------------------------------------
        #50; // Wait for column to become 4'b0111
        tb_i_b_op_keypad_row = 4'b1011;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button

        //-----------------------------------------
        // Test Case 17: Reset button pressed when operator is valid
        //-----------------------------------------
        #30; // Wait for column to become 4'b1011
        tb_i_b_op_keypad_row = 4'b0111;//set a random valid operator button pressed
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
        #50
        tb_i_sys_reset = 1;//Simulate reset button pressed
        #10
        tb_i_sys_reset = 0;
        
        //-----------------------------------------
        // Test Case 18: Reset button pressed when negative flag is high
        //-----------------------------------------
        #20; // Wait for column to become 4'b0111
        tb_i_b_op_keypad_row = 4'b1110;
        #10; // Simulate holding the button for 1 clock cycle
        tb_i_b_op_keypad_row = 4'b1111; // Release the button
        #50
        tb_i_sys_reset = 1;//Simulate reset button pressed
        #10
        tb_i_sys_reset = 0;

        #100
        
        $stop;  
    end

endmodule