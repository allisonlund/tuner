module uart_tx #(parameter [11:0] cc_per_bit = 1250) (
    input [0:0] clk_i,
    input [0:0] reset_i,
    input [7:0] data_i,
    input [0:0] valid_i,
    output [0:0] tx_o,
    output [0:0] ready_o
);

typedef enum logic [2:0] {IDLE, START, TRANSMIT, STOP} STATE_E;

STATE_E current_state_l, next_state_l;

logic [0:0] tx_d;
logic [0:0] tx_q;
logic [0:0] ready_d;
logic [0:0] ready_q;
logic [7:0] data_d;
logic [7:0] data_q;
logic [0:0] bit_counter_reset_d;
logic [0:0] bit_counter_reset_q;
logic [0:0] bit_counter_en_d;
logic [0:0] bit_counter_en_q;
logic [0:0] cc_counter_reset_d;
logic [0:0] cc_counter_reset_q;
logic [4:0] bit_counter; // counts to 8
logic [11:0] cc_counter; // counts to cc_per_bit

// state transitions
always_ff @(posedge clk_i) begin
    if(reset_i) begin
        current_state_l <= IDLE;
        tx_q <= 1'b1;
        ready_q <= 1'b0;
        data_q <= '0;
        bit_counter_reset_q <= 1'b1;
        bit_counter_en_q <= 1'b0;
        cc_counter_reset_q <= 1'b1;
    end
    else begin
        current_state_l <= next_state_l;
        tx_q <= tx_d;
        ready_q <= ready_d;
        data_q <= data_d;
        bit_counter_reset_q <= bit_counter_reset_d;
        bit_counter_en_q <= bit_counter_en_d;
        cc_counter_reset_q <= cc_counter_reset_d;
    end
end

//bit counter
always_ff @(posedge clk_i) begin
    if(reset_i || bit_counter_reset_q) begin
        bit_counter <= '0;
    end
    else if (bit_counter_en_q) begin
        bit_counter <= bit_counter + 1;
    end
    else begin
        bit_counter <= bit_counter;
    end
end


// clock cycle counter per bit transmitted
always_ff @(posedge clk_i) begin
    if(reset_i || cc_counter_reset_q) begin
        cc_counter <= '0;
    end
    else begin
        cc_counter <= cc_counter + 1;
    end
end


always_comb begin : state_machine

    tx_d = tx_q;
    ready_d = ready_q;
    data_d = data_q;
    bit_counter_reset_d = bit_counter_reset_q;
    bit_counter_en_d = bit_counter_en_q;
    cc_counter_reset_d = cc_counter_reset_q;
    next_state_l = current_state_l;

    unique case (current_state_l)
    IDLE: begin
        tx_d = 1;
        cc_counter_reset_d = 1'b0;
        bit_counter_reset_d = 1'b0;
        ready_d = 1'b1;
        if(valid_i && ready_o) begin
            data_d = data_i;
            next_state_l = START;
            cc_counter_reset_d = 1'b1;
            ready_d = 1'b0;
        end
        else begin
            next_state_l = IDLE;
        end

    end
    START: begin
        cc_counter_reset_d = 1'b0;
        tx_d = 1'b0;
        if(cc_counter === cc_per_bit) begin
            next_state_l = TRANSMIT;
            cc_counter_reset_d = 1'b1;
            bit_counter_reset_d = 1'b1;
        end
        else begin
            next_state_l = START;
        end 

    end
    TRANSMIT: begin
        cc_counter_reset_d = 1'b0;
        bit_counter_reset_d = 1'b0;
        bit_counter_en_d = 1'b0;
        tx_d = data_q[bit_counter];
        if(cc_counter === cc_per_bit) begin
            if(bit_counter === 5'd7) begin
                next_state_l = STOP;
                cc_counter_reset_d = 1'b1;
                bit_counter_reset_d = 1'b1;
            end
            else begin
                cc_counter_reset_d = 1'b1;
                bit_counter_en_d = 1'b1;
                next_state_l = TRANSMIT;
            end
        end
        else begin
            next_state_l = TRANSMIT;
        end
    end
    STOP: begin
        cc_counter_reset_d = 1'b0;
        bit_counter_reset_d = 1'b0;
        bit_counter_en_d = 1'b0;
        tx_d = 1'b1;
        if(cc_counter === cc_per_bit) begin
            next_state_l = IDLE;
            cc_counter_reset_d = 1'b1;
            bit_counter_reset_d = 1'b1;
        end
        else begin
            next_state_l = STOP;
        end 
    end
    endcase
end


assign ready_o = ready_q;
assign tx_o = tx_q;
endmodule
