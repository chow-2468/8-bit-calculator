`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Yu Heng
// 
// Create Date: 19.04.2025 22:54:00
// File Name: b_hex.sv
// Module Name: b_hex
// Project Name: 8-bit integer calculator
// Code Type: RTL level
// Description: Modelling of hex keypad code generator
// 
//////////////////////////////////////////////////////////////////////////////////

module b_hex (
    input  logic        i_sys_clock,
    input  logic        i_sys_reset,
    input  logic [3:0]  i_b_hex_keypad_row,
    input  logic        i_b_hex_clear,
    input  logic        i_b_hex_op_valid_key_pressed,
    output logic [3:0]  o_b_hex_keypad_column,
    output logic [7:0]  o_b_hex_keycode,
    output logic        o_b_hex_overflow_flag,
    output logic        o_b_hex_new_input
);

    logic [1:0] key_press_count;//to indicate key press count
    logic [3:0] temp_hex;//register to store readed key in value
    logic key_pressed_flag;//to indicate if the button is pressed
    logic valid_press;//to indicate valid key press
    logic [3:0] row_delayed;      // delay row by one clock cycle to synchronize wave output with the column

    // Delay the Row signal by one clock cycle
    always_ff @(posedge i_sys_clock or posedge i_sys_reset) begin
        if (i_sys_reset)
            row_delayed <= 4'b1111; // idle state (all unpressed)
        else
            row_delayed <= i_b_hex_keypad_row;
    end

    
    // Drive the column cycling
    always_ff @(posedge i_sys_clock or posedge i_sys_reset) begin//loop to scan the column keypad 
        if (i_sys_reset)
        o_b_hex_keypad_column <= 4'b1110; // Start with column 0 active
        else begin
            case (o_b_hex_keypad_column)
                4'b1110: o_b_hex_keypad_column <= 4'b1101; // col 1
                4'b1101: o_b_hex_keypad_column <= 4'b1011; // col 2
                4'b1011: o_b_hex_keypad_column <= 4'b0111; // col 3
                4'b0111: o_b_hex_keypad_column <= 4'b1111; // idle
                default: o_b_hex_keypad_column <= 4'b1110; // loop back to col 0
            endcase
        end
    end
    
    function logic [3:0] decode_key (input logic [3:0] row, input logic [3:0] col);
    //function to convert row and column read into hex decoded key
        case ({row, col})
            {4'b1110, 4'b1110}: decode_key = 4'h0;
            {4'b1110, 4'b1101}: decode_key = 4'h1;
            {4'b1110, 4'b1011}: decode_key = 4'h2;
            {4'b1110, 4'b0111}: decode_key = 4'h3;
            {4'b1101, 4'b1110}: decode_key = 4'h4;
            {4'b1101, 4'b1101}: decode_key = 4'h5;
            {4'b1101, 4'b1011}: decode_key = 4'h6;
            {4'b1101, 4'b0111}: decode_key = 4'h7;
            {4'b1011, 4'b1110}: decode_key = 4'h8;
            {4'b1011, 4'b1101}: decode_key = 4'h9;
            {4'b1011, 4'b1011}: decode_key = 4'hA;
            {4'b1011, 4'b0111}: decode_key = 4'hB;
            {4'b0111, 4'b1110}: decode_key = 4'hC;
            {4'b0111, 4'b1101}: decode_key = 4'hD;
            {4'b0111, 4'b1011}: decode_key = 4'hE;
            {4'b0111, 4'b0111}: decode_key = 4'hF;
            default:         decode_key = 4'h0;//input=0
        endcase
    endfunction
    
    assign temp_hex = decode_key(row_delayed, o_b_hex_keypad_column);  
    assign valid_press = (o_b_hex_keypad_column != 4'b1111 && row_delayed != 4'b1111);
    
    always_ff @(posedge i_sys_clock or posedge i_sys_reset) begin
        if (i_sys_reset||i_b_hex_clear) begin// Reset all states and outputs
            key_press_count <= 0;
            o_b_hex_keycode <= 0;
            o_b_hex_overflow_flag <= 0;
            key_pressed_flag <= 0;
            o_b_hex_new_input <= 0;
        end  
        
        else if(i_b_hex_op_valid_key_pressed)begin
            key_press_count <= 2'd0;
            key_pressed_flag <= 0;
        end
        
        else if(valid_press &&!key_pressed_flag) begin//start when key is pressed
            key_pressed_flag<=1;
                
            case(key_press_count)
            2'b00: begin
                if (temp_hex!=4'h0)begin//remain input=0 if continuous 0 pressed
                    o_b_hex_keycode<={4'h0,temp_hex};
                    key_press_count<= 2'd1;
                    o_b_hex_new_input <= 1;//set high a new input flag to clear negative flag of operator
                end
            end
            2'b01: begin//1 key is pressed
                o_b_hex_keycode<={o_b_hex_keycode[3:0],temp_hex};//push the 1st digit to most significant digit
                key_press_count<= 2'd2;
                o_b_hex_new_input <= 0;
            end
            default: begin
                o_b_hex_keycode <= 8'b0;
                o_b_hex_overflow_flag <= 1;
                o_b_hex_new_input <= 0;
            end
            endcase
        end
        else if(!valid_press) begin
            key_pressed_flag <= 0;
            o_b_hex_new_input <= 0;
        end
    end

endmodule
