`timescale 1ns / 1ps

module sum_up_errors_single_cn_new#(parameter INWIDTH_DELTA = 20, parameter OUTWIDTH = 26)
(
    input clk,
    input rstn,
    input unsigned [INWIDTH_DELTA-1:0] err_chk_cn_i[15:0],
    input          [15:0]              exceed_map_en_i,
    output  reg  [OUTWIDTH-1:0]      err_chk_sumup_o,
    output  reg                      err_chk_sumup_en_o
    );
    
    reg unsigned [OUTWIDTH-1:0] result_temp[2:0];
    
    wire unsigned [INWIDTH_DELTA-1:0] err_chk_cn_i_temp[15:0]; 
    genvar i;
    generate
        for (i = 0; i < 16; i=i+1) begin
            assign err_chk_cn_i_temp[i] = (exceed_map_en_i[i] == 1) ? err_chk_cn_i[i] : 0;
        end
    endgenerate
    
    
    
    always@(posedge clk or negedge rstn) begin 
        if(!rstn) begin
            result_temp <= {0,0,0};
        end
        else begin
            if (exceed_map_en_i) begin
                result_temp[2] <= result_temp[1];
                result_temp[1] <= result_temp[0];
                result_temp[0] <= err_chk_cn_i_temp[0] + err_chk_cn_i_temp[1]+ err_chk_cn_i_temp[2]+ err_chk_cn_i_temp[3]
                                + err_chk_cn_i_temp[4]+ err_chk_cn_i_temp[5]+ err_chk_cn_i_temp[6]+ err_chk_cn_i_temp[7]
                                + err_chk_cn_i_temp[8]+ err_chk_cn_i_temp[9]+ err_chk_cn_i_temp[10]+ err_chk_cn_i_temp[11]
                                + err_chk_cn_i_temp[12]+ err_chk_cn_i_temp[13]+ err_chk_cn_i_temp[14]+ err_chk_cn_i_temp[15];
            end
        end
    end
    
    //delay 1 clk
    reg exceed_map_en_d1;
    always@(posedge clk or negedge rstn) begin 
        if(!rstn) begin
            exceed_map_en_d1 <= 1'b0;
        end
        else begin
            if (exceed_map_en_i) begin
                exceed_map_en_d1 <= 1'b1;
            end
            else begin
                exceed_map_en_d1 <= 1'b0;
            end
        end
    end
    
    // get sum-up  result
    always@(posedge clk or negedge rstn) begin 
        if(!rstn) begin
            err_chk_sumup_en_o <= 0;
            err_chk_sumup_o <= {OUTWIDTH{1'b0}};
        end
        else begin
            if (exceed_map_en_d1) begin
                err_chk_sumup_en_o <= 1;
                err_chk_sumup_o <= result_temp[0] + result_temp[1] + result_temp[2];
            end
            else begin
                err_chk_sumup_en_o <= 0;
            end
        end
    end
endmodule
