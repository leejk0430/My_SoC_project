module uart_ip #(
    parameter ADDR_W = 32,
    parameter DATA_W = 32,
    parameter STRB_W = DATA_W / 8
)(

    // System
    input clk,
    input rst,

    // Local Bus
    input  [ADDR_W-1:0] waddr,
    input  [DATA_W-1:0] wdata,
    input               wen,
    input  [STRB_W-1:0] wstrb,
    output              wready,
    input  [ADDR_W-1:0] raddr,
    input               ren,
    output [DATA_W-1:0] rdata,
    output              rvalid,

    // uart tx

    output  o_uart_tx,

    // uart rx

    input   i_uart_rx


);

    reg o_ready_reg;

    

    wire [7:0] csr_u_tx_data_data_out;
    wire       o_ready;
    wire       csr_u_tx_ctrl_tx_start_out;

    wire [7:0] csr_u_rx_data_data_in;
    wire       o_valid;


    regs_uart  uart_regs_interface_u0(

        .clk(clk),
        .rst(rst),
        .csr_u_tx_data_data_out(csr_u_tx_data_data_out),
        .csr_u_tx_stat_ready_in(o_ready),
        .csr_u_tx_stat_tx_done_in( !o_ready_reg & o_ready  ),
        .csr_u_tx_ctrl_tx_start_out(csr_u_tx_ctrl_tx_start_out),


        .csr_u_rx_data_data_in(csr_u_rx_data_data_in),
        .csr_u_rx_stat_rx_overrun_in(),
        .csr_u_rx_stat_rx_valid_in(o_valid),
        .csr_u_rx_ctrl_rx_start_in( ),
        .csr_u_rx_ctrl_rx_clear_in(),



        .waddr(waddr),
        .wdata(wdata),
        .wen(wen),
        .wstrb(wstrb),
        .wready(wready),
        .raddr(raddr),
        .ren(ren),
        .rdata(rdata),
        .rvalid(rvalid)

    );


    uart_tx uart_transmitter_u1 (

        .i_clk(clk),
        .i_rst(rst),
        .i_data(csr_u_tx_data_data_out),
        .i_valid(csr_u_tx_ctrl_tx_start_out),
        .o_ready(o_ready),
        .o_uart_tx(o_uart_tx)

    );

    uart_rx uart_receiver_u2 (

        .i_clk(clk),
        .i_rst(rst),
        .i_uart_rx(i_uart_rx),
        .i_ready(1'b1),
        .o_valid(o_valid),
        .o_data(csr_u_rx_data_data_in)

    );





    always @(posedge clk) begin
        o_ready_reg <= o_ready;
    end



endmodule