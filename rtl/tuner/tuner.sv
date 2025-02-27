module tuner
 #(parameter int_in_lp = 2
  ,parameter frac_in_lp = 10
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i
  ,input [int_in_lp - 1:-frac_in_lp] audio_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 
  ,output [7:0] note_o
  ,output [0:0] update_o
  );

  localparam [11:0] width_p = int_in_lp + frac_in_lp;

  wire [int_in_lp-1:-frac_in_lp] sinusoid_o_A, sinusoid_o_B, sinusoid_o_C, sinusoid_o_D, sinusoid_o_E, sinusoid_o_F, sinusoid_o_G;
  

  sinusoid
  #(.width_p(width_p)
   ,.note_freq_p(440.0)
   )
  sinusoid_inst_A
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.ready_i(valid_i)
  ,.data_o(sinusoid_o_A)
  ,.valid_o()
  );

  sinusoid
  #(.width_p(width_p)
   ,.note_freq_p(493)
   )
  sinusoid_inst_B
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.ready_i(valid_i)
  ,.data_o(sinusoid_o_B) 
  ,.valid_o()
  );

  sinusoid
  #(.width_p(width_p)
   ,.note_freq_p(261)
   )
  sinusoid_inst_C
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.ready_i(valid_i)
  ,.data_o(sinusoid_o_C) 
  ,.valid_o()
  );

  sinusoid
  #(.width_p(width_p)
   ,.note_freq_p(293)
   )
  sinusoid_inst_D
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.ready_i(valid_i)
  ,.data_o(sinusoid_o_D) 
  ,.valid_o()
  );

  sinusoid
  #(.width_p(width_p)
   ,.note_freq_p(329)
   )
  sinusoid_inst_E
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.ready_i(valid_i)
  ,.data_o(sinusoid_o_E) 
  ,.valid_o()
  );

  sinusoid
  #(.width_p(width_p)
   ,.note_freq_p(349)
   )
  sinusoid_inst_F
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.ready_i(valid_i)
  ,.data_o(sinusoid_o_F) 
  ,.valid_o()
  );

  sinusoid
  #(.width_p(width_p)
   ,.note_freq_p(392)
   )
  sinusoid_inst_G
  (.clk_i(clk_i)
  ,.reset_i(reset_i)
  ,.ready_i(valid_i)
  ,.data_o(sinusoid_o_G) 
  ,.valid_o()
  );

  //mac input for all 7 notes
  wire [16:-15] mac_A_ow, mac_B_ow, mac_C_ow, mac_D_ow, mac_E_ow, mac_F_ow, mac_G_ow;
  logic [0:0] ready_ol;


  mac
  #(.int_out_lp(17)
    ,.frac_out_lp(15)
    ) 
    mac_inst_A
    (.clk_i(clk_i)
    ,.reset_i(reset_i || (sample_count_l == 65536))
    ,.a_i(audio_i[int_in_lp - 1:-frac_in_lp])
    ,.b_i(sinusoid_o_A)
    ,.valid_i(valid_i && ready_o)
    ,.ready_o(ready_ol)
    ,.ready_i(1'b1)
    ,.valid_o()
    ,.data_o(mac_A_ow)
    );

  mac
  #(.int_out_lp(17)
    ,.frac_out_lp(15)
    ) 
    mac_inst_B
    (.clk_i(clk_i)
    ,.reset_i(reset_i || (sample_count_l == 65536))
    ,.a_i(audio_i[int_in_lp - 1:-frac_in_lp])
    ,.b_i(sinusoid_o_B)
    ,.valid_i(valid_i && ready_o)
    ,.ready_o()
    ,.ready_i(1'b1)
    ,.valid_o()
    ,.data_o(mac_B_ow)
    );

  mac
  #(.int_out_lp(17)
    ,.frac_out_lp(15)
    ) 
    mac_inst_C
    (.clk_i(clk_i)
    ,.reset_i(reset_i || (sample_count_l == 65536))
    ,.a_i(audio_i[int_in_lp - 1:-frac_in_lp])
    ,.b_i(sinusoid_o_C)
    ,.valid_i(valid_i && ready_o)
    ,.ready_o()
    ,.ready_i(1'b1)
    ,.valid_o()
    ,.data_o(mac_C_ow)
    );

  mac
  #(.int_out_lp(17)
    ,.frac_out_lp(15)
    ) 
    mac_inst_D
    (.clk_i(clk_i)
    ,.reset_i(reset_i || (sample_count_l == 65536))
    ,.a_i(audio_i[int_in_lp - 1:-frac_in_lp])
    ,.b_i(sinusoid_o_D)
    ,.valid_i(valid_i && ready_o)
    ,.ready_o()
    ,.ready_i(1'b1)
    ,.valid_o()
    ,.data_o(mac_D_ow)
    );

  mac
  #(.int_out_lp(17)
    ,.frac_out_lp(15)
    ) 
    mac_inst_E
    (.clk_i(clk_i)
    ,.reset_i(reset_i || (sample_count_l == 65536))
    ,.a_i(audio_i[int_in_lp - 1:-frac_in_lp])
    ,.b_i(sinusoid_o_E)
    ,.valid_i(valid_i && ready_o)
    ,.ready_o()
    ,.ready_i(1'b1)
    ,.valid_o()
    ,.data_o(mac_E_ow)
    );

  mac
  #(.int_out_lp(17)
    ,.frac_out_lp(15)
    ) 
    mac_inst_F
    (.clk_i(clk_i)
    ,.reset_i(reset_i || (sample_count_l == 65536))
    ,.a_i(audio_i[int_in_lp - 1:-frac_in_lp])
    ,.b_i(sinusoid_o_F)
    ,.valid_i(valid_i && ready_o)
    ,.ready_o()
    ,.ready_i(1'b1)
    ,.valid_o()
    ,.data_o(mac_F_ow)
    );

  mac
  #(.int_out_lp(17)
    ,.frac_out_lp(15)
    ) 
    mac_inst_G
    (.clk_i(clk_i)
    ,.reset_i(reset_i || (sample_count_l == 65536))
    ,.a_i(audio_i[int_in_lp - 1:-frac_in_lp])
    ,.b_i(sinusoid_o_G)
    ,.valid_i(valid_i && ready_o)
    ,.ready_o()
    ,.ready_i(1'b1)
    ,.valid_o()
    ,.data_o(mac_G_ow)
    );

//save and restart logic
logic [16:0] sample_count_l;
logic [16:-15] abs_mac_out_A_l, abs_mac_out_B_l, abs_mac_out_C_l, abs_mac_out_D_l, abs_mac_out_E_l, abs_mac_out_F_l, abs_mac_out_G_l;


  always_comb begin
    abs_mac_out_A_l = mac_A_ow;
      if (abs_mac_out_A_l[16] === 1'b1) begin
      abs_mac_out_A_l = -abs_mac_out_A_l;
    end
  end

  always_comb begin
    abs_mac_out_B_l = mac_B_ow;
    if (abs_mac_out_B_l[16] == 1'b1) begin
      abs_mac_out_B_l = -abs_mac_out_B_l;
    end
  end

  always_comb begin
    abs_mac_out_C_l = mac_C_ow;
    if (abs_mac_out_C_l[16] == 1'b1) begin
      abs_mac_out_C_l = -abs_mac_out_C_l;
    end
  end

  always_comb begin
    abs_mac_out_D_l = mac_D_ow;
    if (abs_mac_out_D_l[16] == 1'b1) begin
      abs_mac_out_D_l = -abs_mac_out_D_l;
    end
  end

  always_comb begin
    abs_mac_out_E_l = mac_E_ow;
    if (abs_mac_out_E_l[16] == 1'b1) begin
      abs_mac_out_E_l = -abs_mac_out_E_l;
    end
  end

  always_comb begin
    abs_mac_out_F_l = mac_F_ow;
    if (abs_mac_out_F_l[16] == 1'b1) begin
      abs_mac_out_F_l = -abs_mac_out_F_l;
    end
  end

  always_comb begin
    abs_mac_out_G_l = mac_G_ow;
    if (abs_mac_out_G_l[16] == 1'b1) begin
      abs_mac_out_G_l = -abs_mac_out_G_l;
    end
  end
  
logic [15:0] abs_mac_out_l [6:0];

  always_comb begin
    abs_mac_out_l = {{abs_mac_out_G_l[15:0]}, {abs_mac_out_F_l[15:0]}, {abs_mac_out_E_l[15:0]}, 
    {abs_mac_out_D_l[15:0]}, {abs_mac_out_C_l[15:0]}, {abs_mac_out_B_l[15:0]}, {abs_mac_out_A_l[15:0]}};
  end

wire [2:0] index_o;
logic [7:0] max_note_l;




//instntiate max
max_val 
max_val_inst
( .clk_i(clk_i),
  .reset_i(reset_i),
  .valid_i(1'b1),
  .ready_i(1'b1),
  .data_i(abs_mac_out_l),
  .index_o(index_o),
  .valid_o(),
  .ready_o()
);

always_comb begin
  case (index_o)
    3'b000: max_note_l = 8'd65;
    3'b001: max_note_l = 8'd66;
    3'b010: max_note_l = 8'd67;
    3'b011: max_note_l = 8'd68;
    3'b100: max_note_l = 8'd69;
    3'b101: max_note_l = 8'd70;
    3'b110: max_note_l = 8'd71;
    default: max_note_l = 8'd88;
  endcase
end


logic [0:0] update_ol;
logic [7:0] note_ol;

always_ff @(posedge clk_i) begin
  if(reset_i) begin
    update_ol <= 1'b0;
    note_ol <= '0;
    
  end
  else if (sample_count_l == 65535) begin
    update_ol <= 1'b1;
    note_ol <= max_note_l;
  end
  else begin
    update_ol <= 1'b0;
    note_ol <= note_ol;
  end
end


// sample counter to count 1 second
always_ff @(posedge clk_i) begin
  if(reset_i) begin
    sample_count_l <= '0;
  end
  else begin
    if (sample_count_l == 65538) begin
      sample_count_l <= '0;

    end
    else if (valid_i && ready_o) begin
      sample_count_l <= sample_count_l + 1;
    end
    else begin
      sample_count_l <= sample_count_l;
    end
  end
end


  assign note_o = note_ol;
  assign update_o = update_ol;
  assign ready_o = ready_ol;


endmodule
