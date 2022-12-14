`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/04 13:34:23
// Design Name: 
// Module Name: sum_up_delta_1_2
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sum_up_delta_1_2#(parameter INWIDTH_DELTA = 13, parameter OUTWIDTH=19)
(
    input clk,
    input rstn,
    input unsigned [INWIDTH_DELTA-1:0] delta1_i[15:0],
    input unsigned [INWIDTH_DELTA-1:0] delta2_i[15:0],
    input       [15:0] exceed_map_en_i,
    output unsigned [OUTWIDTH-1:0]     delta1_sumup_o,
    output unsigned [OUTWIDTH-1:0]     delta2_sumup_o,
    output                             sumup_en
    );
    
    sum_up_errors_single_cn_new #(INWIDTH_DELTA, OUTWIDTH) sum_up_errors_single_delta1_inst
    (
        .clk(clk),
        .rstn(rstn),
        .err_chk_cn_i(delta1_i),
        .exceed_map_en_i(exceed_map_en_i),
        .err_chk_sumup_o(delta1_sumup_o),
        .err_chk_sumup_en_o(sumup_en)
    );
    
    sum_up_errors_single_cn_new #(INWIDTH_DELTA, OUTWIDTH) sum_up_errors_single_delta2_inst
    (
        .clk(clk),
        .rstn(rstn),
        .err_chk_cn_i(delta2_i),
        .exceed_map_en_i(exceed_map_en_i),
        .err_chk_sumup_o(delta2_sumup_o),
        .err_chk_sumup_en_o()
    );
endmodule
