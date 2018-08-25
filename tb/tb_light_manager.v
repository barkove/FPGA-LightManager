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

// 1 < CLOCK_FREQ_MHZ <= 655, CLOCK_FREQ_MHZ = 1000 / ( 2 * CLOCK_SEMI_PERIOD_NS )
parameter     CLOCK_FREQ_MHZ        = 100;
parameter     DELAY_IN_US           = 50;
parameter     PWM_VALUE_SIZE        = 8;
parameter     BRIGHTNESS_INC        = 5;

reg           clk, rst_n;

wire  [3 : 0] future_leds;

// GPIO interface signals
reg           a_i, b_i;
  
light_manager #(
  .CLOCK_FREQ_MHZ         ( CLOCK_FREQ_MHZ   ),
  .DELAY_IN_US            ( DELAY_IN_US      ),
  .PWM_VALUE_SIZE         ( PWM_VALUE_SIZE   ),
  .BRIGHTNESS_INC         ( BRIGHTNESS_INC   )
) light_manager_0 (
  .clk_i                  ( clk              ),
  .rst_n_i                  ( rst_n              ),
  
  .leds_o                 ( future_leds      ),
  
  // GPIO interface signals
  .a_i                    ( a_i              ),
  .b_i                    ( b_i              )
);

/*
// my unsuccessful attempts are commented

integer a, b, c, d;

task rotate_the_shaft(
  // 0 - left, 1 - right
  input dir
);
  if ( dir )
    fork
      // below is equivalent to put_rotate_wave( .wave( a_i ) );
      begin
        for ( a = 0; a < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; a = a + 1 )
          begin
            @( posedge clk );
            a_i = $urandom % 2;
            $display("YA V 1ST FORE GDE A");
          end
        a_i = 0;
        #( 5 * EXPECTED_DELAY_IN_US * 1000 );
        for ( a = 0; a < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; a = a + 1 )
          begin
            @( posedge clk );
            a_i = $urandom % 2;
            $display("YA V 2ND FORE GDE A");
          end
        a_i = 1;
      end
      // below is equivalent to #( 3 * EXPECTED_DELAY_IN_US * 1000 ) put_rotate_wave( .wave( b_i ) );
      #( 3 * EXPECTED_DELAY_IN_US * 1000 ) 
      begin
        for ( b = 0; b < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; b = b + 1 )
          begin
            @( posedge clk );
            b_i = $urandom % 2;
            $display("YA V 1ST FORE GDE B");
          end
        b_i = 0;
        #( 5 * EXPECTED_DELAY_IN_US * 1000 );
        for ( b = 0; b < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; b = b + 1 )
          begin
            @( posedge clk );
            b_i = $urandom % 2;
            $display("YA V 2ND FORE GDE B");
          end
        b_i = 1;
      end
    join
  else
    fork
      // below is equivalent to put_rotate_wave( .wave( b_i ) );
      begin
        for ( c = 0; c < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; c = c + 1 )
          begin
            @( posedge clk );
            b_i = $urandom % 2;
            $display("YA V 1ST FORE GDE C");
          end
        b_i = 0;
        #( 5 * EXPECTED_DELAY_IN_US * 1000 );
        for ( c = 0; c < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; c = c + 1 )
          begin
            @( posedge clk );
            b_i = $urandom % 2;
            $display("YA V 2ND FORE GDE C");
          end
        b_i = 1;
      end
      // below is equivalent to #( 3 * EXPECTED_DELAY_IN_US * 1000 ) put_rotate_wave( .wave( a_i ) );
      #( 3 * EXPECTED_DELAY_IN_US * 1000 )
      begin
        for ( d = 0; d < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; d = d + 1 )
          begin
            @( posedge clk );
            a_i = $urandom % 2;
            $display("YA V 1ST FORE GDE D");
          end
        a_i = 0;
        #( 5 * EXPECTED_DELAY_IN_US * 1000 );
        for ( d = 0; d < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; d = d + 1 )
          begin
            @( posedge clk );
            a_i = $urandom % 2;
            $display("YA V 2ND FORE GDE D");
          end
        a_i = 1;
      end
    join
endtask

/*
task rotate_the_shaft(
  // 0 - left, 1 - right
  input dir
);
  if ( dir )
    fork
      put_rotate_wave( .wave( a_i ) );
      #( 3 * EXPECTED_DELAY_IN_US * 1000 ) put_rotate_wave( .wave( b_i ) );
    join
  else
    fork
      put_rotate_wave( .wave( b_i ) );
      #( 3 * EXPECTED_DELAY_IN_US * 1000 ) put_rotate_wave( .wave( a_i ) );
    join
endtask

integer i;

task automatic put_rotate_wave(
  output reg wave
);
  begin
    for ( i = 0; i < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; i = i + 1 )
      begin
        @( posedge clk );
        wave = $urandom % 2;
      end
    wave = 0;
    #( 5 * EXPECTED_DELAY_IN_US * 1000 );
    for ( i = 0; i < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; i = i + 1 )
      begin
        @( posedge clk );
        wave = $urandom % 2;
      end
    wave = 1;
  end
endtask

initial
  begin
    a_i = 1;
    b_i = 1;
    rst = 1;
    #CLOCK_SEMI_PERIOD_NS;
    rst = 0;
    fork
      clock_start();
      begin
        rotate_the_shaft( .dir( 1'b1 ) );
        $finish;
      end
    join
  end
*/

initial
  begin
    clk = 0;
    forever #CLOCK_SEMI_PERIOD_NS 
      clk = ~clk;
  end

reg a_req_strobe = 0, b_req_strobe = 0;

task make_a_req_strobe();
  begin
    @( posedge clk ); 
    a_req_strobe = 1'b0;
    @( posedge clk );
    a_req_strobe = 1'b1;
    @( posedge clk );
    a_req_strobe = 1'b0;
  end
endtask

task make_b_req_strobe();
  begin
    @( posedge clk ); 
    b_req_strobe = 1'b0;
    @( posedge clk );
    b_req_strobe = 1'b1;
    @( posedge clk );
    b_req_strobe = 1'b0;
  end
endtask

task left();
  fork
    make_b_req_strobe();
    #( 3 * EXPECTED_DELAY_IN_US * 1000 ) make_a_req_strobe();
  join
endtask

task right();
  fork
    make_a_req_strobe();
    #( 3 * EXPECTED_DELAY_IN_US * 1000 ) make_b_req_strobe();
  join
endtask

integer i, j;

always @( posedge a_req_strobe )
  begin
    for ( i = 0; i < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; i = i + 1 )
      begin
        @( posedge clk );
        a_i = $urandom % 2;
      end
    a_i = 0;
    #( 5 * EXPECTED_DELAY_IN_US * 1000 );
    for ( i = 0; i < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; i = i + 1 )
      begin
        @( posedge clk );
        a_i = $urandom % 2;
      end
    a_i = 1;
  end
  
always @( posedge b_req_strobe )
  begin
    for ( j = 0; j < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; j = j + 1 )
      begin
        @( posedge clk );
        b_i = $urandom % 2;
      end
    b_i = 0;
    #( 5 * EXPECTED_DELAY_IN_US * 1000 );
    for ( j = 0; j < CLOCK_FREQ_MHZ * EXPECTED_DELAY_IN_US; j = j + 1 )
      begin
        @( posedge clk );
        b_i = $urandom % 2;
      end
    b_i = 1;
  end

initial
  begin
    a_i = 1;
    b_i = 1;
    rst_n = 0;
    #1000;
    rst_n = 1;
    //clock_start();
  end
  
initial
  begin
    // increase shim value
    right();
    #( ( 10 + 2 ) * EXPECTED_DELAY_IN_US * 1000 );
    // decrease shim value
    left();
    #( ( 10 + 2 ) * EXPECTED_DELAY_IN_US * 1000 );
    right();
    #( ( 10 + 2 ) * EXPECTED_DELAY_IN_US * 1000 );
    right();
    #( ( 10 + 2 ) * EXPECTED_DELAY_IN_US * 1000 );
    right();
    #( ( 10 + 2 ) * EXPECTED_DELAY_IN_US * 1000 );    
  end  

endmodule
