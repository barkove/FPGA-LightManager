`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2018 18:01:50
// Design Name: 
// Module Name: pmod_enc_rot
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pmod_enc_rot #(
  // 3 <= CLOCK_FREQ_MHZ <= 655
  parameter CLOCK_FREQ_MHZ = 100,
  parameter DELAY_IN_US    = 55
)(
  input  clk_i,
  input  rst_n_i,
  
  // GPIO interface signals
  input  a_i,
  input  b_i,
  
  output left_o,
  output right_o
);

localparam      DELAY_TICKS = CLOCK_FREQ_MHZ * DELAY_IN_US;

wire            flag_reset;
reg             fe_is_handled, re_is_handled;

reg   [3 : 0]   a_catcher;
reg   [2 : 0]   b_catcher;

wire            counter_en;
reg   [14 : 0]  counter;

assign flag_reset = counter == ( DELAY_TICKS - 2 );

assign counter_en = fe_is_handled || re_is_handled;

assign left_o     = ( counter == ( DELAY_TICKS - 2 ) ) && re_is_handled && b_catcher[2];
assign right_o    = ( counter == ( DELAY_TICKS - 2 ) ) && re_is_handled && !b_catcher[2];

always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i )
    b_catcher <= 3'b0;
  else
    b_catcher <= { b_catcher[1 : 0], b_i };

always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i )
    a_catcher <= 4'b1111;
  else
    a_catcher <= { a_catcher[2 : 0], a_i };

always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i )
    fe_is_handled <= 1'b0;
  else
    if ( flag_reset )
      fe_is_handled <= 1'b0;
    else 
      if ( !counter_en )
        fe_is_handled <= !a_catcher[2] && a_catcher[3];
      
always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i )
    re_is_handled <= 1'b0;
  else
    if ( flag_reset )
      re_is_handled <= 1'b0;
    else
      if ( !counter_en )
        re_is_handled <= a_catcher[2] && !a_catcher[3];
      
always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i ) 
    counter <= 15'b0;
  else
    if ( !counter_en )
      counter <= 15'b0;
    else 
      counter <= counter + 15'b1;

endmodule