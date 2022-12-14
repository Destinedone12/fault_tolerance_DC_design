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
reg signed [31:0]   fft_s_data_tdata; //��������
reg                         fft_s_data_tvalid; //����ʹ��
wire                        fft_s_data_tready; //��������
reg                         fft_s_data_tlast; //��������ĩβ

//wire signed [47:0]          fft_m_data_tdata; //������
//wire signed [2:0]           fft_m_data_tuser;
//wire                        fft_m_data_tvalid; //���ʹ��
reg                         fft_m_data_tready; //�������
wire                        fft_m_data_tlast; //�������ĩβ
reg [7:0] count;

wire          fft_event_frame_started;
wire          fft_event_tlast_unexpected;
wire          fft_event_tlast_missing;
wire          fft_event_status_channel_halt;
wire          fft_event_data_in_channel_halt;
wire          fft_event_data_out_channel_halt;

//���Ʊ�ʶλ��洢λ
always @ (posedge clk or negedge rstn) begin
if (!rstn) begin //��ձ�ʶλ,�ڴ�
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
else begin //����tvalid�Ա�ʶλ������λ
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

//����ʶλ����λʱ����ʼfft
always @ (posedge clk or negedge rstn) begin
if (!rstn) begin
    fft_s_data_tvalid <= 1'b0; //����ʹ�ܹر�
    fft_s_data_tdata <= 31'b0; //�������
    fft_s_data_tlast <= 1'b0; //����ĩβ�õ�
count <= 8'b0;
end
else if (poly_input_tvalid_save == 8'b11111111) begin 
    if (count == 7) begin
        fft_s_data_tvalid <= 1'b1;
        fft_s_data_tlast <= 1'b1; //�ﵽ����ĩβ
        fft_s_data_tdata <= poly_input_save[count];
        count <= 8'd0;
        //poly_input_tvalid_save <= 8'b00000000; //�������
    end
    else begin
        fft_s_data_tvalid <= 1'b1;
        fft_s_data_tlast <= 1'b0; //δ�ﵽ����ĩβ
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
.aclk(clk),                                                // ʱ���źţ�input��
.aresetn(rstn),                                           // ��λ�źţ�����Ч��input��
.s_axis_config_tdata(8'd1),                                // ip�����ò������ݣ�Ϊ1ʱ��FFT���㣬Ϊ0ʱ��IFFT���㣨input��
.s_axis_config_tvalid(1'b1),                               // ip������������Ч����ֱ������Ϊ1��input��
.s_axis_config_tready(fft_s_config_tready),                // output wire s_axis_config_tready
//��Ϊ����ʱ������ʱ�Ǵ��豸
.s_axis_data_tdata(fft_s_data_tdata),                      // ��ʱ���ź���FFT IP�˴��������ͨ��,[31:16]Ϊ�鲿��[15:0]Ϊʵ����input����->�ӣ�
.s_axis_data_tvalid(fft_s_data_tvalid),                    // ��ʾ���豸��������һ����Ч�Ĵ��䣨input����->�ӣ�
.s_axis_data_tready(fft_s_data_tready),                    // ��ʾ���豸�Ѿ�׼���ý���һ�����ݴ��䣨output����->��������tvalid��treadyͬʱΪ��ʱ���������ݴ���
.s_axis_data_tlast(fft_s_data_tlast),                      // ���豸����豸���ʹ�������źţ�input����->�ӣ�����Ϊ������
//��Ϊ����Ƶ������ʱ�����豸
.m_axis_data_tdata(fft_m_data_tdata),                      // FFT�����Ƶ�����ݣ�[47:24]��Ӧ�����鲿���ݣ�[23:0]��Ӧ����ʵ������(output����->��)��
.m_axis_data_tuser(fft_m_data_tuser),                      // ���Ƶ�׵�����(output����->��)����ֵ*fs/N��Ϊ��ӦƵ�㣻
.m_axis_data_tvalid(fft_m_data_tvalid),                    // ��ʾ���豸��������һ����Ч�Ĵ��䣨output����->�ӣ�
//    .m_axis_data_tready(fft_m_data_tready),                    // ��ʾ���豸�Ѿ�׼���ý���һ�����ݴ��䣨input����->��������tvalid��treadyͬʱΪ��ʱ���������ݴ���
.m_axis_data_tready(1),
.m_axis_data_tlast(fft_m_data_tlast),                      // ���豸����豸���ʹ�������źţ�output����->�ӣ�����Ϊ������
//�����������
.event_frame_started(fft_event_frame_started),                  // output wire event_frame_started
.event_tlast_unexpected(fft_event_tlast_unexpected),            // output wire event_tlast_unexpected
.event_tlast_missing(fft_event_tlast_missing),                  // output wire event_tlast_missing
.event_status_channel_halt(fft_event_status_channel_halt),      // output wire event_status_channel_halt
.event_data_in_channel_halt(fft_event_data_in_channel_halt),    // output wire event_data_in_channel_halt
.event_data_out_channel_halt(fft_event_data_out_channel_halt)   // output wire event_data_out_channel_halt
);
 
endmodule
