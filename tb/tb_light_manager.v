`timescale 1 ns / 1 ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.08.2018 16:38:49
// Design Name: 
// Module Name: tb_light_measurer
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


module tb_light_manager();

parameter     CLOCK_SEMI_PERIOD_NS  = 5;
parameter     EXPECTED_DELAY_IN_US  = 50;

// 3 <= CLOCK_FREQ_MHZ <= 655, CLOCK_FREQ_MHZ = 1000 / ( 2 * CLOCK_SEMI_PERIOD_NS )
parameter     CLOCK_FREQ_MHZ        = 100;
parameter     DELAY_IN_US           = 50;
parameter     PWM_VALUE_SIZE        = 8;
parameter     BRIGHTNESS_INC        = 5;

reg           clk, rst_n;

wire  [3 : 0] future_leds;

// GPIO interface signals
wire           a_i, b_i;

// ( dir == 1 ) ? ( right rotate ) : ( left rotate )
reg             dir;
reg             a, b;
  
light_manager #(
  .CLOCK_FREQ_MHZ         ( CLOCK_FREQ_MHZ   ),
  .DELAY_IN_US            ( DELAY_IN_US      ),
  .PWM_VALUE_SIZE         ( PWM_VALUE_SIZE   ),
  .BRIGHTNESS_INC         ( BRIGHTNESS_INC   )
) light_manager_0 (
  .clk_i                  ( clk              ),
  .rst_n_i                ( rst_n            ),
  
  .leds_o                 ( future_leds      ),
  
  // GPIO interface signals
  .a_i                    ( a_i              ),
  .b_i                    ( b_i              )
);

assign a_i = ( dir ) ? ( a ) : ( b );
assign b_i = ( dir ) ? ( b ) : ( a );

task put_rotate_waves();
  fork
    put_rotate_wave_a();
    #( 3 * EXPECTED_DELAY_IN_US * 1000 ) put_rotate_wave_b();
    #( 12 * EXPECTED_DELAY_IN_US * 1000 );
  join
endtask

task put_rotate_wave_a();  
  integer i;
  begin
    for ( i = 0; i < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; i = i + 1 )
      begin
        @( posedge clk );
        a = $urandom % 2;
      end
    a = 0;
    #( 5 * EXPECTED_DELAY_IN_US * 1000 );
    for ( i = 0; i < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; i = i + 1 )
      begin
        @( posedge clk );
        a = $urandom % 2;
      end
    a = 1;
  end
endtask

task put_rotate_wave_b();  
  integer i;
  begin
    for ( i = 0; i < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; i = i + 1 )
      begin
        @( posedge clk );
        b = $urandom % 2;
      end
    b = 0;
    #( 5 * EXPECTED_DELAY_IN_US * 1000 );
    for ( i = 0; i < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; i = i + 1 )
      begin
        @( posedge clk );
        b = $urandom % 2;
      end
    b = 1;
  end
endtask

initial
  begin
    clk = 0;
    forever #CLOCK_SEMI_PERIOD_NS 
      clk = ~clk;
  end

initial
  begin
    a = 1;
    b = 1;
    rst_n = 0;
    #1000;
    rst_n = 1;
    // increase PWM value
    dir = 1;
    put_rotate_waves();
    // decrease PWM value
    dir = 0;
    put_rotate_waves();
    // and increase again
    dir = 1;
    put_rotate_waves();
    dir = 1;
    put_rotate_waves();
    dir = 1;
    put_rotate_waves();
  end  

endmodule
