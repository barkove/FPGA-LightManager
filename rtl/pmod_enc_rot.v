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
  // 1 <= CLOCK_FREQ_MHZ <= 655
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

reg   [1 : 0]   edge_catcher;

wire            counter_en;
reg   [14 : 0]  counter;

assign flag_reset = counter == ( DELAY_TICKS - 1 );

assign counter_en = fe_is_handled || re_is_handled;

assign left_o     = ( counter == ( DELAY_TICKS - 1 ) ) && re_is_handled && b_i;
assign right_o    = ( counter == ( DELAY_TICKS - 1 ) ) && re_is_handled && !b_i;

always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i )
    edge_catcher <= 2'b11;
  else
    begin 
      edge_catcher[0] <= a_i;
      edge_catcher[1] <= edge_catcher[0];
    end

always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i )
    fe_is_handled <= 1'b0;
  else
    if (flag_reset)
      fe_is_handled <= 1'b0;
    else 
      if ( !counter_en )
        fe_is_handled <= !edge_catcher[0] && edge_catcher[1];
      
always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i)
    re_is_handled <= 1'b0;
  else
    if (flag_reset)
      re_is_handled <= 1'b0;
    else
      if ( !counter_en )
        re_is_handled <= edge_catcher[0] && !edge_catcher[1];
      
always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i || !counter_en )
    counter <= 15'b0;
  else 
    counter <= counter + 15'b1;

endmodule