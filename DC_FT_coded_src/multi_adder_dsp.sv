`timescale 1ns / 1ps

//DELAY = 11 CLK;

module multi_adder_dsp(
    input prj_clk,
    input prj_rst_n,
    input signed [7:0][31:0] input_16bit_channel_0 ,
    input signed [7:0][31:0] input_16bit_channel_1,
    input signed [7:0][31:0] input_16bit_channel_2,
    input signed [7:0][31:0] input_16bit_channel_3,
    input signed [7:0][31:0] input_16bit_channel_4,
    input signed [7:0][31:0] input_16bit_channel_5,
    input signed [7:0][31:0] input_16bit_channel_6,
    input signed [7:0][31:0] input_16bit_channel_7,

    input               input_16bit_tvalid    ,
    output reg signed [47:0] output_22bit_channel_1 [7:0],
    output reg signed [47:0] output_22bit_channel_2 [7:0],
    output reg          output_22bit_tvalid
    );

    reg [2:0] index;
    reg en;
    reg signed [47:0] output_22bit_channel_1_temp [7:0];
    reg signed [47:0] output_22bit_channel_2_temp [7:0];
    
    
    // data ctrl
    localparam IDLE = 3'd0, CALC = 3'd1, DELAY = 3'd2 , WRITE = 3'd3, OUT = 3'd4;
    reg [2:0] cur_state, next_state;
    
    always@(posedge prj_clk or negedge prj_rst_n) begin
        if (!prj_rst_n)
            cur_state <= IDLE;
        else
            cur_state <= next_state;
    end
    
    always @(*) begin
        next_state = IDLE;
        case (cur_state)
            IDLE: begin
                if (input_16bit_tvalid)
                    next_state = CALC;
                else
                    next_state = IDLE;
            end
            CALC: begin
                if (index == 7)
                    next_state = DELAY;
                else
                    next_state = CALC;
                end
            DELAY:next_state = WRITE;
            WRITE:next_state = OUT;
            OUT: next_state = IDLE;
        endcase
    end
    
    //idx ctrl
    always@(posedge prj_clk or negedge prj_rst_n) begin
        if (!prj_rst_n) begin
            index <= 3'b000;
        end
        else begin
            case (cur_state)
                CALC: index <= index + 1;
                default: index <= 3'b000;
            endcase
        end
    end
    
    // data_ctrl
wire [7:0][31:0] data[7:0];

genvar i;
generate
    for (i = 0; i < 8; i++) begin
     assign data[i] = {input_16bit_channel_7[i],input_16bit_channel_6[i],input_16bit_channel_5[i],input_16bit_channel_4[i],
                                    input_16bit_channel_3[i],input_16bit_channel_2[i],input_16bit_channel_1[i],input_16bit_channel_0[i]};                 
    end
endgenerate

    // en ctrl
    always@(posedge prj_clk or negedge prj_rst_n) begin
        if (!prj_rst_n) begin
            en <= 0;
        end
        else begin
            case (cur_state)
                CALC: en <= 1;
                default: en <= 0;
            endcase
        end
    end
    
    //data out ctrl
    always@(posedge prj_clk or negedge prj_rst_n) begin
        if (!prj_rst_n) begin
            output_22bit_channel_1 <= {48'b0,48'b0,48'b0,48'b0,48'b0,48'b0,48'b0,48'b0};
            output_22bit_channel_2 <= {48'b0,48'b0,48'b0,48'b0,48'b0,48'b0,48'b0,48'b0};
        end
        else begin
            case (cur_state)
                OUT: begin 
                    output_22bit_channel_1 <= output_22bit_channel_1_temp;
                    output_22bit_channel_2 <= output_22bit_channel_2_temp;
                end
                default:begin 
                    output_22bit_channel_1 <= output_22bit_channel_1;
                    output_22bit_channel_2 <= output_22bit_channel_2;
                end
            endcase
        end
    end
    
    //en out ctrl
    always@(posedge prj_clk or negedge prj_rst_n) begin
        if (!prj_rst_n) begin
            output_22bit_tvalid <= 0;
        end
        else begin
            case (cur_state)
                OUT: output_22bit_tvalid <= 1;
                default: output_22bit_tvalid <= 0;
            endcase
        end
    end
    
generate
    for (i = 0; i < 8; i++) begin
        adder_inst_3_9 adder_inst_3_9_inst
        (
            .clk(prj_clk),
            .rstn(prj_rst_n),
            .index(index),
            .en(en),
            .data(data[i]),
            .res(output_22bit_channel_1_temp[i])
        );
        
        add_mult_inst_3_9 add_mult_inst_3_9_inst
        (
            .clk(prj_clk),
            .rstn(prj_rst_n),
            .index(index),
            .en(en),
            .data(data[i]),
            .res(output_22bit_channel_2_temp[i])
        );
    end
endgenerate
endmodule

