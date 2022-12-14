`timescale 1ns / 1ps

module polyphase_Rx(
    input clk,
    input rstn,
    input signed [7:0][31:0] decimator_input ,
    input        [7:0]  decimator_input_tvalid,
    output reg signed [7:0][31:0] polyphase_output ,
    output reg        [7:0] polyphase_output_tvalid
    );

fir_Rx_0 fir_Rx_0_inst(
    .aclk(clk),
    .aresetn(rstn),
    .s_axis_data_tready(),
    .s_axis_data_tvalid(decimator_input_tvalid[0]),
    .s_axis_data_tdata(decimator_input[0]),
    .m_axis_data_tdata(polyphase_output[0]),
    .m_axis_data_tvalid(polyphase_output_tvalid[0]) 
);

fir_Rx_1 fir_Rx_1_inst(
    .aclk(clk),
    .aresetn(rstn),
    .s_axis_data_tready(),
    .s_axis_data_tvalid(decimator_input_tvalid[1]),
    .s_axis_data_tdata(decimator_input[1]),
    .m_axis_data_tdata(polyphase_output[1]),
    .m_axis_data_tvalid(polyphase_output_tvalid[1]) 
);

fir_Rx_2 fir_Rx_2_inst(
    .aclk(clk),
    .aresetn(rstn),
    .s_axis_data_tready(),
    .s_axis_data_tvalid(decimator_input_tvalid[2]),
    .s_axis_data_tdata(decimator_input[2]),
    .m_axis_data_tdata(polyphase_output[2]),
    .m_axis_data_tvalid(polyphase_output_tvalid[2]) 
);

fir_Rx_3 fir_Rx_3_inst(
    .aclk(clk),
    .aresetn(rstn),
    .s_axis_data_tready(),
    .s_axis_data_tvalid(decimator_input_tvalid[3]),
    .s_axis_data_tdata(decimator_input[3]),
    .m_axis_data_tdata(polyphase_output[3]),
    .m_axis_data_tvalid(polyphase_output_tvalid[3]) 
);

fir_Rx_4 fir_Rx_4_inst(
    .aclk(clk),
    .aresetn(rstn),
    .s_axis_data_tready(),
    .s_axis_data_tvalid(decimator_input_tvalid[4]),
    .s_axis_data_tdata(decimator_input[4]),
    .m_axis_data_tdata(polyphase_output[4]),
    .m_axis_data_tvalid(polyphase_output_tvalid[4]) 
);

fir_Rx_5 fir_Rx_5_inst(
    .aclk(clk),
    .aresetn(rstn),
    .s_axis_data_tready(),
    .s_axis_data_tvalid(decimator_input_tvalid[5]),
    .s_axis_data_tdata(decimator_input[5]),
    .m_axis_data_tdata(polyphase_output[5]),
    .m_axis_data_tvalid(polyphase_output_tvalid[5]) 
);

fir_Rx_6 fir_Rx_6_inst(
    .aclk(clk),
    .aresetn(rstn),
    .s_axis_data_tready(),
    .s_axis_data_tvalid(decimator_input_tvalid[6]),
    .s_axis_data_tdata(decimator_input[6]),
    .m_axis_data_tdata(polyphase_output[6]),
    .m_axis_data_tvalid(polyphase_output_tvalid[6]) 
);

fir_Rx_7 fir_Rx_7_inst(
    .aclk(clk),
    .aresetn(rstn),
    .s_axis_data_tready(),
    .s_axis_data_tvalid(decimator_input_tvalid[7]),
    .s_axis_data_tdata(decimator_input[7]),
    .m_axis_data_tdata(polyphase_output[7]),
    .m_axis_data_tvalid(polyphase_output_tvalid[7]) 
);
endmodule
