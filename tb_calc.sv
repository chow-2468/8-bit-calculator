`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Author: Ng Jing Xuan  
// 
// Create Date: 20.04.2025 16:01:24
// File Name: tb_calc.sv
// Module Name: tb_calc
// Project Name: 8-bit integer calculator
// Code Type: Behavioural 
// Description: Testbench for 8-bit integer calculator
// 
//////////////////////////////////////////////////////////////////////////////////
`define PERIOD_CLK 10

module tb_calc();

logic tb_VCC, tb_GROUND, tb_sys_clock, tb_sys_reset, tb_calc_clear, tb_calc_equal;
logic [3:0] tb_calc_op_keypad_row;
logic [3:0] tb_calc_hex_keypad_row;
wire  [3:0] tb_calc_op_keypad_column;
wire  [3:0] tb_calc_hex_keypad_column;
wire  [6:0] tb_calc_dis;
wire  [3:0] tb_calc_sel;


calc
dut_calc
(.VCC(tb_VCC),
.GROUND(tb_GROUND),
.i_sys_clock(tb_sys_clock),
.i_sys_reset(tb_sys_reset),
.i_calc_clear(tb_calc_clear),
.i_calc_equal(tb_calc_equal),
.i_calc_op_keypad_row(tb_calc_op_keypad_row),
.i_calc_hex_keypad_row(tb_calc_hex_keypad_row),
.o_calc_op_keypad_column(tb_calc_op_keypad_column),
.o_calc_hex_keypad_column(tb_calc_hex_keypad_column),
.o_calc_dis(tb_calc_dis),
.o_calc_sel(tb_calc_sel));


initial begin
tb_sys_clock = 1'b1;
forever #(`PERIOD_CLK/2) tb_sys_clock = ~tb_sys_clock;
end

//initialization
initial begin
tb_sys_reset = 1'b1;
#(`PERIOD_CLK*4)
tb_VCC = 1'b1;
tb_GROUND = 1'b0;
tb_sys_reset = 1'b0;
tb_calc_clear = 1'b0;
tb_calc_equal = 1'b0;
tb_calc_hex_keypad_row = 4'b1111;
tb_calc_op_keypad_row = 4'b1111;


//--------------------------------------------------------------
// Test Case 1: Reset input
//--------------------------------------------------------------
wait (tb_calc_hex_keypad_column == 4'b1111)  //represent 1011 since there are 3 clock cycle delay for row
tb_calc_hex_keypad_row = 4'b1110;  
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)  // represent 1110
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2)  //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //set reset high for 2 clock cycle and back to low
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0; 


//--------------------------------------------------------------
// Test Case 2: Clear input
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait (tb_calc_hex_keypad_column == 4'b0111)  // represent 1101
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_clear = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_clear = 1'b0;


//--------------------------------------------------------------
// Test Case 3: Input overflow  (input 555 -> display Err)
//--------------------------------------------------------------
#(`PERIOD_CLK*8)  //delay after reset before start next test case
wait (tb_calc_hex_keypad_column == 4'b0111)  // represent 1101
tb_calc_hex_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b0111)  // represent 1101
tb_calc_hex_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b0111)  // represent 1101
tb_calc_hex_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0; 


//--------------------------------------------------------------
// Test Case 4: Add operation (2+3)
//--------------------------------------------------------------
#(`PERIOD_CLK*8)  //delay after reset before start next test case
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0; 


//--------------------------------------------------------------
// Test Case 5: Add with negative number (-2+3)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
#(`PERIOD_CLK*2)
wait (tb_calc_op_keypad_column == 4'b1110) 
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 6: Addition overflow (FF+F)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 7: Minus operation (7-3)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 8: Minus with negative number (-7-8)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1110) 
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1011)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 9: Minus result overflow (-FE-2)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)   //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
#(`PERIOD_CLK*2)
wait (tb_calc_op_keypad_column == 4'b1110) 
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 10: Multiply operation (AxB)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 11: Multiply with negative number (-AxB)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)   //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
#(`PERIOD_CLK*2)
wait (tb_calc_op_keypad_column == 4'b1110) 
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 12: Multiplication overflow (20xE)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1011)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 13: Divide operation (F/2)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 14: Divide with negative number (F/-2)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
#(`PERIOD_CLK*2)
wait (tb_calc_op_keypad_column == 4'b1110) 
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 15: Divide by zero (0/0)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1011)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1011)
tb_calc_op_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1011)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 16: Not operation (~A5)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b0111)
tb_calc_hex_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b0111)
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*12)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 17: AND operation (FA & A0)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b0111)
tb_calc_op_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
#(`PERIOD_CLK*2)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1011)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 18: OR operation (FA | A0)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b0111)
tb_calc_op_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
#(`PERIOD_CLK*2)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1011)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*6)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 19: XOR operation (FA ^ A0)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b0111)
tb_calc_op_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
#(`PERIOD_CLK*2)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1011)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*6)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 20: Bitwise right shift operation (FA>>2)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1111)
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 21: Bitwise left shift operation (FA<<9)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1111)
tb_calc_op_keypad_row = 4'b1101; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b0111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 22: Arithmetic right shift operation (FA>>>2)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1111)
tb_calc_op_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 23: Arithmetic right shift of negative number (-FA>>>2)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
#(`PERIOD_CLK*2)
wait (tb_calc_op_keypad_column == 4'b1110)
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1111)
tb_calc_op_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 24: Arithmetic left shift operation (FA<<<2)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1111)
tb_calc_op_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0;
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;


//--------------------------------------------------------------
// Test Case 25: Invalid shifting (FA>>-2)
//--------------------------------------------------------------
#(`PERIOD_CLK*4)  //delay after reset before start next test case
wait(tb_calc_sel == 4'b0001)
wait (tb_calc_hex_keypad_column == 4'b1110)
tb_calc_hex_keypad_row = 4'b0111; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1011; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_op_keypad_column == 4'b1111)
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
wait (tb_calc_hex_keypad_column == 4'b1111)
tb_calc_hex_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_hex_keypad_row = 4'b1111;

#(`PERIOD_CLK*5)
#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait (tb_calc_op_keypad_column == 4'b1110)
tb_calc_op_keypad_row = 4'b1110; 
#(`PERIOD_CLK*2) //set row for 2 cycle
tb_calc_op_keypad_row = 4'b1111;

#(`PERIOD_CLK*4)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_calc_equal = 1'b1;
#(`PERIOD_CLK*2)
tb_calc_equal = 1'b0; 
#(`PERIOD_CLK*8)  //delay to see the complete waveform of display
wait(tb_calc_sel == 4'b0001)
tb_sys_reset = 1'b1; //reset for the next test case
#(`PERIOD_CLK*2)
tb_sys_reset = 1'b0;

end
endmodule
