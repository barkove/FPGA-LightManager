`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.08.2018 18:45:22
// Design Name: 
// Module Name: light_measurer
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


module light_manager #(
  // 3 <= CLOCK_FREQ_MHZ <= 655
  parameter CLOCK_FREQ_MHZ          = 100,
  parameter DELAY_IN_US             = 50, 
  parameter PWM_VALUE_SIZE          = 8,
  parameter BRIGHTNESS_INC          = 5
)(
  input               clk_i,
  input               rst_n_i,
  
  output [3 : 0]      leds_o,
  
  // GPIO interface signals
  input               a_i,
  input               b_i
); 

wire                                      pwm_out;

wire                                      increase, decrease;
reg   [ PWM_VALUE_SIZE - 1 : 0 ]          brightness_value;

pmod_enc_rot #(
  // 3 <= CLOCK_FREQ_MHZ <= 655
  .CLOCK_FREQ_MHZ   ( CLOCK_FREQ_MHZ          ),
  .DELAY_IN_US      ( DELAY_IN_US             )
) pmod_enc_rot_0 (
  .clk_i            ( clk_i                   ),
  .rst_n_i          ( rst_n_i                 ),
  
  // GPIO interface signals
  .a_i              ( a_i                     ),
  .b_i              ( b_i                     ),
  
  .left_o           ( decrease                ),
  .right_o          ( increase                )
);

pwm_gen #(
  .SIZE_OF_VALUE    ( PWM_VALUE_SIZE          )
) pwm_gen_0 (
  .clk_i            ( clk_i                   ),
  .rst_n_i          ( rst_n_i                 ),
  
  .value_i          ( brightness_value        ),
  
  .pwm_o            ( pwm_out                 ) 
);

assign leds_o = { 4 { pwm_out } };

always @( posedge clk_i or negedge rst_n_i )
  if ( !rst_n_i )
    brightness_value <= { PWM_VALUE_SIZE{ 1'b0 } };
  else
    if ( increase && ( { PWM_VALUE_SIZE{ 1'b1 } } -  BRIGHTNESS_INC >= brightness_value ) )
      brightness_value <= brightness_value + BRIGHTNESS_INC;
    else 
      if ( decrease && ( BRIGHTNESS_INC <= brightness_value ) )
        brightness_value <= brightness_value - BRIGHTNESS_INC;
      
endmodule