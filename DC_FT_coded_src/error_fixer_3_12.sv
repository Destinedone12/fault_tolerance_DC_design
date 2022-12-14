`timescale 1ns / 1ps



module error_fixer_3_12(
    input clk,
    input rstn,
    input [3:0] error_code,
    
    input [7:0][31:0] bit16_cn0,
    input [7:0][31:0] bit16_cn1,
    input [7:0][31:0] bit16_cn2,
    input [7:0][31:0] bit16_cn3,
    input [7:0][31:0] bit16_cn4,
    input [7:0][31:0] bit16_cn5,
    input [7:0][31:0] bit16_cn6,
    input [7:0][31:0] bit16_cn7,
    
    input en_i,
    
    input signed [16:0] delta1_real [7:0],
    input signed [16:0] delta1_imag [7:0],
    
    output reg  [7:0] error_fix_en,
    output reg  [7:0][31:0] error_fix_channel
    );
    
    
    reg [7:0][31:0] calc_temp;
    localparam IDLE = 0, WAT = 1, OUT = 3;
    
    reg [1:0] cur_state, next_state;
    reg [3:0] cnt;
    
    always@(posedge clk or negedge rstn) begin
        if (!rstn)
            cur_state <= IDLE;
        else
            cur_state <= next_state;
    end
    
    always @(*) begin
        next_state = IDLE;
        case (cur_state)
            IDLE: begin
                if (en_i)
                    next_state = WAT;
                else
                    next_state = IDLE;
            end
            WAT: begin
                if (cnt == 11)
                    next_state = OUT;
                else
                    next_state = WAT;
                end
            OUT: next_state = IDLE;
        endcase
    end
    
    //idx ctrl
    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            cnt <= 4'b0;
        end
        else begin
            case (cur_state)
                WAT: cnt <= cnt + 1;
                default: cnt <= 4'b0;
            endcase
        end
    end
    
    //wires that determine which cn should be in calc proc
    always@(error_code) begin
        case (error_code)
            4'd0: calc_temp <= bit16_cn0;
            4'd1: calc_temp <= bit16_cn1;
            4'd2: calc_temp <= bit16_cn2;
            4'd3: calc_temp <= bit16_cn3;
            4'd4: calc_temp <= bit16_cn4;
            4'd5: calc_temp <= bit16_cn5;
            4'd6: calc_temp <= bit16_cn6;
            4'd7: calc_temp <= bit16_cn7;
            default: calc_temp <= bit16_cn0;
        endcase
    end
    
    // calc ctrl
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        always@(posedge clk or negedge rstn) begin
            if (!rstn) begin
                error_fix_channel[i] <= 256'b0;
            end
            else begin
                case (cur_state)
                    OUT: begin
                        error_fix_channel[i][15:0] <= $signed(calc_temp[i][15:0]) - $signed(delta1_real[i]);
                        error_fix_channel[i][31:16] <= $signed(calc_temp[i][31:16]) - $signed(delta1_imag[i]);
                    end
                    default:begin
                        error_fix_channel[i] <= error_fix_channel[i];
                    end
                endcase
            end
        end
    end
endgenerate

    always@(posedge clk or negedge rstn) begin
        if (!rstn) begin
            error_fix_en <= 8'h0;
        end
        else begin
            case (cur_state)
                OUT: begin
                    case (error_code)
                        4'd0: error_fix_en <= 8'h1;
                        4'd1: error_fix_en <= 8'h2;
                        4'd2: error_fix_en <= 8'h4;
                        4'd3: error_fix_en <= 8'h8;
                        4'd4: error_fix_en <= 8'h10;
                        4'd5: error_fix_en <= 8'h20;
                        4'd6: error_fix_en <= 8'h40;
                        4'd7: error_fix_en <= 8'h80;
                        default: error_fix_en <= 8'h0;
                    endcase
                end
                default: error_fix_en <= 8'h0;
            endcase
        end
    end
endmodule
