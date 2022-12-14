`timescale 1ns / 1ps

module error_check_division#(
    parameter INWIDTH_DELTA = 17,
    parameter DELTA1_THRES = 7'd7,
    parameter DELTA2_THRES = 7'd36)
(
    input clk,
    input rstn,
    input signed [INWIDTH_DELTA-1:0] delta1_real_imag[15:0],
    input signed [INWIDTH_DELTA-1:0] delta2_real_imag[15:0],
    input delta1_delta2_en,

    output reg [3:0] judge_result_smoother,
    output reg       judge_result_smoother_en
    );
    
    wire [INWIDTH_DELTA-1:0] delta1_real_imag_exceed_o[15:0];
    wire [INWIDTH_DELTA-1:0] delta2_real_imag_exceed_o[15:0];
    wire        [15:0]              exceed_map_en_o;
    
    send_exceed_abs_delta_5_4 #(INWIDTH_DELTA) check_exceed_delta
    (
        .clk(clk),
        .rstn(rstn),
        .delta1_thres_i(DELTA1_THRES),
        .delta2_thres_i(DELTA2_THRES),
        .delta1_delta2_en(delta1_delta2_en),
        .delta1_real_imag_i(delta1_real_imag),
        .delta2_real_imag_i(delta2_real_imag),
        .delta1_real_imag_exceed_o(delta1_real_imag_exceed_o),
        .delta2_real_imag_exceed_o(delta2_real_imag_exceed_o),
        .exceed_map_en_o(exceed_map_en_o)
    );
    
    wire unsigned [INWIDTH_DELTA+6-1:0]     delta1_sumup_o;
    wire unsigned [INWIDTH_DELTA+6-1:0]     delta2_sumup_o;
    wire                             sumup_en;
    
    sum_up_delta_1_2 #(INWIDTH_DELTA,INWIDTH_DELTA+6) delta_avg_in_time_space
    (
        .clk(clk),
        .rstn(rstn),
        .delta1_i(delta1_real_imag_exceed_o),
        .delta2_i(delta2_real_imag_exceed_o),
        .exceed_map_en_i(exceed_map_en_o),
        .delta1_sumup_o(delta1_sumup_o),
        .delta2_sumup_o(delta2_sumup_o),
        .sumup_en(sumup_en)
    );
    
    wire [31:0] division_o;
    wire        division_o_tvalid;
    div_gen_0 div_gen_0_inst
    (
        .aclk(clk),
        .aresetn(rstn),
        .s_axis_divisor_tdata({1'b0,delta1_sumup_o}),
        .s_axis_dividend_tdata({1'b0,delta2_sumup_o}),
        .s_axis_dividend_tvalid(sumup_en),
        .s_axis_divisor_tvalid(sumup_en),
        .m_axis_dout_tdata(division_o),
        .m_axis_dout_tvalid(division_o_tvalid)
    );
    
    wire [8:0] judge_result;
    wire       judge_result_en;
    err_code_gen error_code_gen_inst
    (
        .clk(clk),
        .rstn(rstn),
        .division_o(division_o),
        .division_o_tvalid(division_o_tvalid),
        .judge_result(judge_result),
        .judge_result_en(judge_result_en)
    );
    
    judge_result_smoother judge_result_smoother_inst0
    (
        .clk(clk),
        .rstn(rstn),
        .judge_result_i(judge_result),
        .judge_result_en_i(judge_result_en),
        .judge_result_smoother_o(judge_result_smoother),
        .judge_result_smoother_en_o(judge_result_smoother_en)
    );
endmodule