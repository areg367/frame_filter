`timescale 10ns/1ns 

module duplicator_tb();

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

assign TUSER = (cnt<14)? 2'b11:2'b00;

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

duplicator duplicator_1(
.clk(tb_clk),
.resetn(tb_resetn),

.i_TDATA(tb_data),
.i_TVALID(t_valid),
.i_TREADY(drsi_ready),
.i_TUSER(TUSER),

.o_TDATA(o_data),
.o_TREADY(o_tready),
.o_TVALID(o_tvalid),
.o_TUSER(o_tuser)
);

endmodule 