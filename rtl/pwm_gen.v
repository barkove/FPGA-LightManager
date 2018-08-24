`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2018 18:45:22
// Design Name: 
// Module Name: pwm_gen
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


module pwm_gen #(
  parameter SIZE_OF_VALUE = 8
)(
  input                          clk_i,
  input                          rst_i,
  
  input  [SIZE_OF_VALUE - 1 : 0] value_i,
  
  output                         pwm_o 
);

reg [SIZE_OF_VALUE - 1 : 0] counter;

assign pwm_o = !rst_i && ( counter < value_i ) ;

always @( posedge clk_i or posedge rst_i ) 
  if ( rst_i )
    counter <= 0;
  else 
    counter <= counter + 1;

endmodule
