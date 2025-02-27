`ifndef SYNTHESIS
module testbench ();

// logic [0:0] clk_i;
// logic [0:0] reset_i;
// logic [7:0] data_i;
// logic [0:0] valid_i;
// logic [0:0] tx_o;
// logic [0:0] ready_o;

 logic [0:0] clk_i;
 logic [0:0] reset_i;
 logic [1:-10] audio_i;
 logic [0:0] valid_i;
 logic [0:0] ready_o;
 logic [7:0] note_o;
 logic [0:0] update_o;

localparam integer ClockPeriod = 5000000;

initial begin
    clk_i = 0;
    forever begin
        #(ClockPeriod/2);
        clk_i = !clk_i;
    end
end

// uart_tx #(
// ) uart_tx_dut (.*);

tuner #(
) tuner_dut (.*);




always begin

   $dumpfile( "dump.fst" );
   $dumpvars(0, testbench); // Dump all signals
   $display( "Begin simulation." );
   $urandom(100);
   $timeformat( -3, 3, "ms", 0);

   repeat(10) reset();
   repeat(1) @(posedge clk_i);

   repeat(1) begin
      // uart_tx_data(8'd65);
      // uart_tx_data(8'd1);
      tuner_compare();
   end
   $display( "End simulation." );
   $finish;

end

// task automatic uart_tx_data(logic [7:0] data);
//    data_i <= data;
//    repeat(10) @(posedge clk_i);
//    valid_i <= 1'b1;
//    repeat(950) @(posedge clk_i);
//    valid_i <= 1'b0;
//    repeat(950) @(posedge clk_i);

// endtask

task automatic reset();
   reset_i <= 1;
   @(posedge clk_i);
   reset_i <= 0;
endtask

logic [31:0] itervar;
logic [31:0] i;
localparam real max_val_lp = (1 << (12 - 1)) - 1;
localparam real pi_lp = 3.14159;



task automatic tuner_compare();
   // compare an A tune sin wave
   audio_i = '0;

   repeat(1) @(posedge clk_i);

   i = 0;

   for(i = 0; i < 1500; i++) begin
      itervar = 0;
      for(itervar = 0; itervar < $rtoi((41.1 * 10 ** 3) / (440.0)); itervar++) begin
         valid_i = 1;
         audio_i = $rtoi((max_val_lp) * $sin((440.0) * itervar * 2 * pi_lp / (41.1 * 10 ** 3)));
         @(negedge ready_o);
      end
   end

endtask

endmodule
`endif
