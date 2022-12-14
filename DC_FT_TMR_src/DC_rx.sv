`timescale 1ns / 1ps

module DC_rx(
    input clk,
    input rstn,
    input signed [7:0][31:0] tx_sig ,
    input        [7:0]  tx_sig_tvalid,
    output reg signed [7:0][19:0] rx_sig_real ,
    output reg signed [7:0][19:0] rx_sig_imag ,
    output reg        [7:0]  rx_sig_tvalid
    );

wire signed [7:0][31:0] polyphase_output ;
wire [7:0] polyphase_output_tvalid;

polyphase_Rx polyphase_Rx_inst(
    .clk(clk),
    .rstn(rstn),
    .decimator_input(tx_sig),
    .decimator_input_tvalid(tx_sig_tvalid),
    .polyphase_output(polyphase_output),
    .polyphase_output_tvalid(polyphase_output_tvalid)
);

    wire signed [31:0] fft_m_data_tdata;
    wire        [2:0]  fft_m_data_tuser;
    wire               fft_m_data_tvalid;
    
fft_feed fft_feed_inst(
    .clk(clk),
    .rstn(rstn),
    .polyphase_input(polyphase_output),
    .polyphase_input_tvalid(polyphase_output_tvalid),
    .fft_m_data_tdata(fft_m_data_tdata),
    .fft_m_data_tuser(fft_m_data_tuser),
    .fft_m_data_tvalid(fft_m_data_tvalid)
);

se2pa se2pa_inst(
    .clk(clk),
    .rstn(rstn),
    .fft_m_data_tdata(fft_m_data_tdata),
    .fft_m_data_tuser(fft_m_data_tuser),
    .fft_m_data_tvalid(fft_m_data_tvalid),
    .receive_sig_real(rx_sig_real),
    .receive_sig_imag(rx_sig_imag),
    .Rx_tvalid(rx_sig_tvalid)
);

endmodule