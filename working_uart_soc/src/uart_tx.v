module uart_tx
  #(
    parameter clk_freq_hz = 30 * 1000000, // 100 MHz
    parameter baud_rate = 115200)
  (
   input wire 	    i_clk,
   input wire 	    i_rst,
   input wire [7:0] i_data,
   input wire 	    i_valid,
   output reg 	    o_ready,
   output wire 	    o_uart_tx);



   localparam START_VALUE = clk_freq_hz/baud_rate;
   
   localparam WIDTH = $clog2(START_VALUE);
   
   reg [WIDTH:0]  cnt;
   
   reg [9:0] 	    data;


   reg o_ready_d;

   assign o_uart_tx = (|data) ? data[0] : 1'b1;

   always @(posedge i_clk) begin
      
      if (i_rst) begin
            cnt <= {WIDTH{1'b0}};
            data <= 10'h0;
            o_ready <= 1'b0;
            o_ready_d <= 1'b0;

      end

      else begin

            o_ready_d <= o_ready;

            if (cnt[WIDTH] & !(|data))
            o_ready <= 1'b1;
            else if (i_valid & o_ready_d)
            o_ready <= 1'b0;
      
            if (o_ready | cnt[WIDTH])
            cnt <= {1'b0,START_VALUE[WIDTH-1:0]};
            else
            cnt <= cnt-1;
            
            if (cnt[WIDTH])
            data <= {1'b0, data[9:1]};
            else if (i_valid & o_ready_d)
            data <= {1'b1, i_data, 1'b0};
      end
   end
      
endmodule
