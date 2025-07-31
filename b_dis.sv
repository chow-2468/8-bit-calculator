`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Jing Xuan
// 
// Create Date: 20.04.2025 12:23:51
// File Name: b_dis.sv
// Module Name: b_dis
// Project Name: 8-bit integer calculator
// Code Type: RTL level
// Description: Modelling of 7-segment display decoder 
// 
//////////////////////////////////////////////////////////////////////////////////

module b_dis
(input logic i_sys_clock,
input logic i_sys_reset,
input logic i_b_dis_result_overflow_flag,
input logic i_b_dis_hex_overflow_flag,
input logic i_b_dis_op_valid_key_pressed,
input logic i_b_dis_equal,
input logic i_b_dis_neg_flag,
input logic i_b_dis_neg_result,
input logic [7:0] i_b_dis_result,
input logic [7:0] i_b_dis_hex_keycode,
output logic [6:0] o_b_dis_dis_code,
output logic [3:0] o_b_dis_sel);

logic [7:0] dis_value;
logic [7:0] dis_decimal;
logic [3:0] num1,num2,num3,num4;
logic [2:0] count = 3'b0;
logic keycode = 1'b0, result = 1'b0;  //use to determine whether the displayed output is result or hex keypad input
logic [8:0] is_posedge = 1'b0;  //set as condition to change display value

initial begin  //initialization
    o_b_dis_sel = 4'b1000;
    o_b_dis_dis_code = 7'h00;
end

always @(posedge i_sys_clock) //change to select different 7-segement display to turn on each cycle
    o_b_dis_sel <= {o_b_dis_sel[2:0],o_b_dis_sel[3]};


always @(posedge i_sys_clock)begin
    if(i_b_dis_equal || i_b_dis_op_valid_key_pressed)
    is_posedge += 1;
end


always @(i_b_dis_hex_keycode, i_b_dis_result,is_posedge) begin
    if (i_b_dis_equal || i_b_dis_op_valid_key_pressed)begin
        dis_value = i_b_dis_result;
    result <= 1'b1;  //displayed output is result
    keycode <= 1'b0;
    end
    else begin  //if condition true display hex keycode value
    dis_value = i_b_dis_hex_keycode;
    keycode <= 1'b1;  //displayed output is hex keycode value
    result <= 1'b0;
    end
end


//function to convert binary to correct value for display
function [6:0] dis_code(input [3:0] num);
    case(num)
        4'b0000: dis_code = 7'h3F;  //"0"
        4'b0001: dis_code = 7'h06;  //"1"
        4'b0010: dis_code = 7'h5B;  //"2"
        4'b0011: dis_code = 7'h4F;  //"3"
        4'b0100: dis_code = 7'h66;  //"4"
        4'b0101: dis_code = 7'h6D;  //"5"
        4'b0110: dis_code = 7'h7D;  //"6"
        4'b0111: dis_code = 7'h07;  //"7"
        4'b1000: dis_code = 7'h7F;  //"8"
        4'b1001: dis_code = 7'h6F;  //"9"
        4'b1100: dis_code = 7'h40;  //"-" (negative)
        4'b1101: dis_code = 7'h50;  //"r"
        4'b1110: dis_code = 7'h79;  //"E"
        4'b1111: dis_code = 7'h00;  //" " (blank)
        default: dis_code = 7'h00;  //" " (blank)
    endcase
endfunction


always @(posedge i_sys_clock)begin
    num1 <= 4'b1111;  //initialize to blank
    num2 <= 4'b1111;
    num3 <= 4'b1111;
    num4 <= 4'b1111;
    dis_decimal = dis_value;
    
    if(i_sys_reset) //display "0" during reset
        num1 = 4'b0000;
    else if (i_b_dis_result_overflow_flag || i_b_dis_hex_overflow_flag)begin //display "Err"
        num1 = 4'b1101;
        num2 = 4'b1101;
        num3 = 4'b1110;
    end
    else begin
        if ((keycode && i_b_dis_neg_flag) || (result && i_b_dis_neg_result))  //display "-"
            num4 = 4'b1100;
            
        num3 = dis_decimal / 100;  //get the value for each digit
        dis_decimal %= 100;
        num2 = dis_decimal / 10;
        num1 = dis_decimal % 10;
        
        if(num2 == 0 && num3 == 0)begin //display blank for num2 and num3 if it is single digit only
            num2 = 4'b1111;
            num3 = 4'b1111;
        end
        else if(num3 == 0)  //display blank for num3 if it is double digit only
            num3 = 4'b1111;    
    end
end


always @(posedge i_sys_clock)begin  //call function to get the correct value to display
case(count)
    3'b000: o_b_dis_dis_code <= dis_code(num1);
    3'b001: o_b_dis_dis_code <= dis_code(num2);
    3'b010: o_b_dis_dis_code <= dis_code(num3);
    3'b011: o_b_dis_dis_code <= dis_code(num4);
    default: o_b_dis_dis_code <= dis_code(num4);
endcase
    
    count++;
    if (count ==4)  //reset to 0 for looping
    count <= 0;
end
endmodule
