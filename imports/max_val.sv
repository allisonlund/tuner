module max_val
(   input [0:0] clk_i, 
    input [0:0] reset_i,
    input [0:0] valid_i,
    input [0:0] ready_i,
    input [15:0] data_i [6:0], 
    output [2:0] index_o,
    output [0:0] valid_o,
    output [0:0] ready_o
);

    logic [2:0] index_first_level_ol [2:0];
    logic [2:0] index_second_level_ol [1:0];
    logic [2:0] index_ol;

    logic [0:0] valid_ol; 
    logic [0:0] valid_stage1_ol; 
    logic [0:0] valid_stage2_ol; 


    always_ff @(posedge clk_i) begin
        if(reset_i) begin
            index_first_level_ol[0] <= '0;
            index_first_level_ol[1] <= '0;
            index_first_level_ol[2] <= '0;
            index_second_level_ol[0] <= '0;
            index_second_level_ol[1] <= '0;
            valid_ol <= 0; 
            valid_stage1_ol <= 0; 
            valid_stage2_ol <= 0; 
            index_ol <= '0;
        end
        else if(valid_i && ready_o) begin
            index_first_level_ol[0] <= (data_i[0] >= data_i[1]) ? 3'b000 : 3'b001;
            index_first_level_ol[1] <= (data_i[2] >= data_i[3]) ? 3'b010 : 3'b011;
            index_first_level_ol[2] <= (data_i[4] >= data_i[5]) ? 3'b100 : 3'b101;
            valid_stage1_ol <= 1;
        end
        else if (valid_stage1_ol) begin
            index_second_level_ol[0] <= (data_i[index_first_level_ol[0]] >= data_i[index_first_level_ol[1]]) ? 
                                        index_first_level_ol[0] : index_first_level_ol[1];
            index_second_level_ol[1] <= (data_i[index_first_level_ol[2]] >= data_i[6]) ? 
                                        index_first_level_ol[2] : 3'b110;

            valid_stage2_ol <= 1;
            valid_stage1_ol <= 0;
        end
        else if (valid_stage2_ol) begin
            index_ol <= (data_i[index_second_level_ol[0]] >= data_i[index_second_level_ol[1]]) ? 
                        index_second_level_ol[0] : index_second_level_ol[1];

            valid_stage2_ol <= 0;
            valid_ol <= 1;
        end
        else if (ready_i) begin
            valid_stage1_ol <= 0;
            valid_stage2_ol <= 0;
            valid_ol <= 0;
        end
    end



    assign index_o = index_ol;
    assign valid_o = valid_ol;
    assign ready_o = (~valid_ol && ~valid_stage1_ol && ~valid_stage2_ol);

endmodule
