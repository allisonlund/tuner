`ifndef BINPATH
 `define BINPATH ""
`endif
module ram_1r1w_sync
  #(parameter [31:0] width_p = 8
  ,parameter [31:0] depth_p = 512
  ,parameter string filename_p = "memory_init_file.bin")
  (input [0:0] pclk_i
  ,input [0:0] cclk_i
  ,input [0:0] preset_i
  ,input [0:0] creset_i

  ,input [0:0] wr_valid_i
  ,input [width_p-1:0] wr_data_i
  ,input [$clog2(depth_p) - 1 : 0] wr_addr_i

  ,input [0:0] rd_valid_i
  ,input [$clog2(depth_p) - 1 : 0] rd_addr_i
  ,output [width_p-1:0] rd_data_o);
   logic [width_p-1:0] ram [depth_p-1:0];

   initial begin
      // Display depth and width (You will need to match these in your init file)
      $display("%m: depth_p is %d, width_p is %d", depth_p, width_p);
      // wire [bar:0] foo [baz:0];
      // In order to get the memory contents in iverilog you need to run this for loop during initialization:
      for (int i = 0; i < depth_p; i++) begin
        ram[i] = '0;
   
      end
   end

   logic [width_p-1:0] rd_data_l;

   always @(posedge pclk_i) begin                                                                                                                                          
      if(preset_i) begin                                                                                                                                                   
         rd_data_l <= '0;                                                                                                                                                                
      end else if(rd_valid_i) begin                                                                                                                                       
          rd_data_l <= ram[rd_addr_i];                                                                                                                                     
      end                                                                                                                                                                 
   end                                                                                                                                                                    
                                                                                                                                                                          
   always @(posedge cclk_i) begin                                                                                                                                          
      if(creset_i) begin                                                                                                                                                   
         ram[wr_addr_i] <= ram[wr_addr_i];                                                                                                                                              
      end else if(wr_valid_i) begin                                                                                                                                       
          ram[wr_addr_i] <= wr_data_i;                                                                                                                                     
      end                                                                                                                                                                 
   end                                                                                                                                                                    
                                                                                                                                                                          
   assign rd_data_o = rd_data_l;

endmodule
