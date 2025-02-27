module counter
  #(parameter width_p = 4,
    // Students: Using lint_off/lint_on commands to avoid lint checks,
    // will result in 0 points for the lint grade.
    /* verilator lint_off WIDTHTRUNC */
    parameter [width_p-1:0] reset_val_p = '0)
    /* verilator lint_on WIDTHTRUNC */
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] count_o);

   // Your code here:
   logic [width_p-1:0] count_l;


   always_ff @(posedge clk_i) begin
    if (reset_i == 1) begin
      count_l <= reset_val_p;
    end
    else if ((up_i) && (~down_i)) begin
      count_l <= count_o + 1;

    end
    else if((down_i) && (~up_i)) begin
      count_l <= count_o - 1;
    end
    else begin
      count_l <= count_o;
    end
   end
   assign count_o = count_l;
      
endmodule
