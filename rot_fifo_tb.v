`timescale 10ns/1ns 

module rot_fifo_tb();

reg tb_clk = 1'b0;
reg tb_resetn;

reg [3:0]tb_data= 1;

reg t_valid = 1;
reg drsi_ready = 1;

wire s_tready;
wire o_data;
wire m_tvalid;

reg [10:0]cnt = 0;
wire [1:0]TUSER;

assign TUSER = (cnt<14)? 2'b11:2'b00;

always
begin
  #5 tb_clk = ~tb_clk;
end

always@(posedge tb_clk)
begin	
	if(tb_resetn == 1)
	begin
		cnt = cnt + 1;
		tb_data = tb_data+ 1;
		if(tb_data == 15)
		begin
			tb_data = 1;
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

rot_fifo rot_fifo_1(
.clock(tb_clk),
.resetn(tb_resetn),
.TUSER(TUSER),

.s_tready(s_tready),
.s_tvalid(t_valid),
.in_d0(tb_data),

.m_tready(drsi_ready),
.m_tvalid(m_tvalid)
);

endmodule 