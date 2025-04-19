module uart_rx
#(
    parameter clk_freq_hz = 30 * 1000000,
    parameter baud_rate = 115200                // how much bit per sec
)
(
    input    wire       i_clk,
    input    wire       i_rst,
    input    wire       i_uart_rx,
    input     wire      i_ready,
    output    reg      o_valid,
    output   reg [7:0]    o_data
);

localparam START_VALUE = clk_freq_hz/baud_rate;     //how much clk is one bit
   
localparam WIDTH = $clog2(START_VALUE);

reg [WIDTH-1:0]  cnt;
reg [2:0] bit_cnt;
reg [7:0] shift_reg;

reg [15:0] valid_counter;


reg [1:0] state, next_state;

localparam IDLE = 2'b00;
localparam START = 2'b01;
localparam DATA = 2'b10;
localparam STOP = 2'b11;

always @(posedge i_clk) begin
    if(i_rst) begin
        state       <= IDLE;
        cnt         <= 0;
        bit_cnt     <= 0;
        shift_reg   <= 0;
        o_data      <= 0;
        o_valid     <= 0;
        valid_counter  <= 0;
    end
    else begin
        state <= next_state;

        if (state == IDLE || cnt == START_VALUE) begin
            cnt <= 0;
        end
        else begin
            cnt <= cnt + 1'b1;
        end


        if (state == DATA && cnt == START_VALUE) begin
            shift_reg <= {i_uart_rx, shift_reg[7:1]};
            if(bit_cnt == 7) begin
                bit_cnt <= 0;
            end
            else begin
                bit_cnt <= bit_cnt + 1'b1;
            end
        end
        else if (state == IDLE) begin
            bit_cnt <= 0;
        end


        if (state == STOP && cnt == START_VALUE && i_uart_rx == 1) begin
            o_data <= shift_reg;
            o_valid <= 1;
            valid_counter <= 40;
        end
        else if (valid_counter != 0) begin
            valid_counter <= valid_counter - 1;
            if (valid_counter == 1)
                o_valid <= 0;
        end
    end
end

always @(*) begin
    next_state = state;
    case(state)
    IDLE : begin
        if (i_uart_rx == 0) begin
            next_state = START;
        end
    end

    START : begin
        if (cnt == START_VALUE / 2) begin
            if (i_uart_rx == 0) begin
                next_state = DATA;
            end
            else begin
                next_state = IDLE;
            end
        end
    end

    DATA : begin
        if (cnt == START_VALUE) begin
            if (bit_cnt == 7) begin
                next_state = STOP;
            end
        end
    end

    STOP : begin
        if (cnt == START_VALUE) begin
            next_state = IDLE;
        end
    end
    endcase
end
endmodule

