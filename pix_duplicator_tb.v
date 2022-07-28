`timescale 10ns/1ns 

module pix_duplicator_tb();

reg tb_clk = 1'b0;
reg tb_resetn;

reg [3:0]tb_data = 1;

reg t_valid = 1;
reg drsi_ready = 1;

wire s_tready;
wire [3:0]o_data;
wire m_tvalid;

reg [10:0]cnt = 0;
wire [1:0]TUSER;
wire [1:0]o_tuser;
wire o_tvalid;
wire o_tready;

reg [3:0]data_mixer=0;

assign TUSER = (cnt<10)? 2'b11:2'b00;

always
begin
  #5 tb_clk = ~tb_clk;
end

always@(posedge tb_clk)
begin	
	if(o_tready == 1)
	begin
		if(tb_resetn == 1)
		begin
			cnt = cnt + 1;
			tb_data = tb_data+ 1;
			if(tb_data == 11)
			begin
				tb_data = 1;
			end
		end
	end	
end

initial
begin
	tb_resetn = 1'b0;
	repeat(2)@(posedge tb_clk);
	#3;
	tb_resetn = 1'b1;
	#1000;
$stop;
end

pix_duplicator
#(
.pix_depth(4),
.frame_width(10),
.filter_size(5),
.add_cells(2)//(filter_size-1)/2
)
pix_duplicator_1
(
.clk(tb_clk),
.resetn(tb_resetn),
.READY_FROM_TB(drsi_ready),

.i_TDATA(tb_data),
.i_TVALID(t_valid),
.i_TUSER(TUSER),

.s_tready(o_tready),
.m_tvalid(o_tvalid),

.o_d0(),
.o_d1(),
.o_d2(),
.o_d3(),
.o_d4()
);



endmodule 