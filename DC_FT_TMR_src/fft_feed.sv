`timescale 1ns / 1ps


module fft_feed(
    input clk,
    input rstn,
    input signed [7:0][31:0] polyphase_input ,
    input        [7:0]  polyphase_input_tvalid,
    output reg signed [31:0] fft_m_data_tdata,
    output reg        [2:0]  fft_m_data_tuser,
    output reg               fft_m_data_tvalid
);

reg signed [31:0] poly_input_save [7:0];
reg        [7:0]  poly_input_tvalid_save;

wire                        fft_s_config_tready;
reg signed [31:0]   fft_s_data_tdata; //输入数据
reg                         fft_s_data_tvalid; //输入使能
wire                        fft_s_data_tready; //输入允许
reg                         fft_s_data_tlast; //输入数据末尾

//wire signed [47:0]          fft_m_data_tdata; //输出结果
//wire signed [2:0]           fft_m_data_tuser;
//wire                        fft_m_data_tvalid; //输出使能
reg                         fft_m_data_tready; //输出允许
wire                        fft_m_data_tlast; //输出数据末尾
reg [7:0] count;

wire          fft_event_frame_started;
wire          fft_event_tlast_unexpected;
wire          fft_event_tlast_missing;
wire          fft_event_status_channel_halt;
wire          fft_event_data_in_channel_halt;
wire          fft_event_data_out_channel_halt;

//控制标识位与存储位
always @ (posedge clk or negedge rstn) begin
if (!rstn) begin //清空标识位,内存
    poly_input_tvalid_save <= 8'b00000000;
    poly_input_save[0] <= 31'b0;
    poly_input_save[1] <= 31'b0;
    poly_input_save[2] <= 31'b0;
    poly_input_save[3] <= 31'b0;
    poly_input_save[4] <= 31'b0;
    poly_input_save[5] <= 31'b0;
    poly_input_save[6] <= 31'b0;
    poly_input_save[7] <= 31'b0;
end
else if (poly_input_tvalid_save == 8'b11111111 && count == 7) begin
    poly_input_tvalid_save <= 8'b00000000;
end
else begin //根据tvalid对标识位进行置位
    case(polyphase_input_tvalid)
        8'b00000001: begin
            poly_input_tvalid_save[0] <= 1'b1;
            poly_input_save[0] <= polyphase_input[0];
        end
        8'b00000010: begin
            poly_input_tvalid_save[1] <= 1'b1;
            poly_input_save[1] <= polyphase_input[1];
        end
        8'b00000100: begin
            poly_input_tvalid_save[2] <= 1'b1;
            poly_input_save[2] <= polyphase_input[2];
        end
        8'b00001000: begin
            poly_input_tvalid_save[3] <= 1'b1;
            poly_input_save[3] <= polyphase_input[3];
        end
        8'b00010000: begin
            poly_input_tvalid_save[4] <= 1'b1;
            poly_input_save[4] <= polyphase_input[4];
        end
        8'b00100000: begin
            poly_input_tvalid_save[5] <= 1'b1;
            poly_input_save[5] <= polyphase_input[5];
        end
        8'b01000000: begin
            poly_input_tvalid_save[6] <= 1'b1;
            poly_input_save[6] <= polyphase_input[6];
        end
        8'b10000000: begin
            poly_input_tvalid_save[7] <= 1'b1;
            poly_input_save[7] <= polyphase_input[7];
        end
    endcase
end
end

//当标识位满置位时，开始fft
always @ (posedge clk or negedge rstn) begin
if (!rstn) begin
    fft_s_data_tvalid <= 1'b0; //输入使能关闭
    fft_s_data_tdata <= 31'b0; //输入清空
    fft_s_data_tlast <= 1'b0; //输入末尾置底
count <= 8'b0;
end
else if (poly_input_tvalid_save == 8'b11111111) begin 
    if (count == 7) begin
        fft_s_data_tvalid <= 1'b1;
        fft_s_data_tlast <= 1'b1; //达到数据末尾
        fft_s_data_tdata <= poly_input_save[count];
        count <= 8'd0;
        //poly_input_tvalid_save <= 8'b00000000; //处理结束
    end
    else begin
        fft_s_data_tvalid <= 1'b1;
        fft_s_data_tlast <= 1'b0; //未达到数据末尾
        fft_s_data_tdata <= poly_input_save[count];
        count <= count + 1;
    end 
end
else begin
    fft_s_data_tvalid <= 0;
    fft_s_data_tlast <= 0;
    fft_s_data_tdata <= fft_s_data_tdata;
end
end

xfft u_fft(
.aclk(clk),                                                // 时钟信号（input）
.aresetn(rstn),                                           // 复位信号，低有效（input）
.s_axis_config_tdata(8'd1),                                // ip核设置参数内容，为1时做FFT运算，为0时做IFFT运算（input）
.s_axis_config_tvalid(1'b1),                               // ip核配置输入有效，可直接设置为1（input）
.s_axis_config_tready(fft_s_config_tready),                // output wire s_axis_config_tready
//作为接收时域数据时是从设备
.s_axis_data_tdata(fft_s_data_tdata),                      // 把时域信号往FFT IP核传输的数据通道,[31:16]为虚部，[15:0]为实部（input，主->从）
.s_axis_data_tvalid(fft_s_data_tvalid),                    // 表示主设备正在驱动一个有效的传输（input，主->从）
.s_axis_data_tready(fft_s_data_tready),                    // 表示从设备已经准备好接收一次数据传输（output，从->主），当tvalid和tready同时为高时，启动数据传输
.s_axis_data_tlast(fft_s_data_tlast),                      // 主设备向从设备发送传输结束信号（input，主->从，拉高为结束）
//作为发送频谱数据时是主设备
.m_axis_data_tdata(fft_m_data_tdata),                      // FFT输出的频谱数据，[47:24]对应的是虚部数据，[23:0]对应的是实部数据(output，主->从)。
.m_axis_data_tuser(fft_m_data_tuser),                      // 输出频谱的索引(output，主->从)，该值*fs/N即为对应频点；
.m_axis_data_tvalid(fft_m_data_tvalid),                    // 表示主设备正在驱动一个有效的传输（output，主->从）
//    .m_axis_data_tready(fft_m_data_tready),                    // 表示从设备已经准备好接收一次数据传输（input，从->主），当tvalid和tready同时为高时，启动数据传输
.m_axis_data_tready(1),
.m_axis_data_tlast(fft_m_data_tlast),                      // 主设备向从设备发送传输结束信号（output，主->从，拉高为结束）
//其他输出数据
.event_frame_started(fft_event_frame_started),                  // output wire event_frame_started
.event_tlast_unexpected(fft_event_tlast_unexpected),            // output wire event_tlast_unexpected
.event_tlast_missing(fft_event_tlast_missing),                  // output wire event_tlast_missing
.event_status_channel_halt(fft_event_status_channel_halt),      // output wire event_status_channel_halt
.event_data_in_channel_halt(fft_event_data_in_channel_halt),    // output wire event_data_in_channel_halt
.event_data_out_channel_halt(fft_event_data_out_channel_halt)   // output wire event_data_out_channel_halt
);
 
endmodule
