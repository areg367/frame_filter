module pix_duplicator
#(
parameter pix_depth = 4,
parameter frame_width = 10,
parameter filter_size = 5,
parameter add_cells = (filter_size-1)/2
)
(
input clk,
input resetn,

input  [pix_depth-1:0] i_TDATA,
input                  i_TVALID,
input            [1:0] i_TUSER,

input READY_FROM_TB,

output s_tready,
output m_tvalid,

output [pix_depth-1:0]  o_d0,
output [pix_depth-1:0]  o_d1,
output [pix_depth-1:0]  o_d2,
output [pix_depth-1:0]  o_d3,
output [pix_depth-1:0]  o_d4
);

wire [pix_depth-1:0] o_TDATA_wr_in_d0;
wire i_TREADY_wr_s_tready;
wire o_TVALID_wr_s_tvalid;

duplicator
#(
.pix_depth  (pix_depth),
.frame_width(frame_width),
.filter_size(filter_size),
.add_cells  (add_cells)
)
duplicator_1
(
.clk(clk),
.resetn(resetn),

.i_TDATA(i_TDATA),
.i_TVALID(i_TVALID),
.i_TREADY(i_TREADY_wr_s_tready),
.i_TUSER(i_TUSER),

.o_TDATA(o_TDATA_wr_in_d0),
.o_TREADY(s_tready),
.o_TVALID(o_TVALID_wr_s_tvalid)
//.o_TUSER()
);

wire VALID_OUT;

rot_fifo
#(
.pix_depth  (pix_depth),
.frame_width(frame_width),
.filter_size(filter_size),
.add_cells  (add_cells)
)
rot_fifo_1
(
.clock(clk),
.resetn(resetn),

.TUSER(i_TUSER),

.s_tvalid(o_TVALID_wr_s_tvalid),
.s_tready(i_TREADY_wr_s_tready),//output
.m_tready(READY_FROM_TB),
.m_tvalid(m_tvalid),//output


.in_d0(o_TDATA_wr_in_d0),
.o_d0(o_d0),
.o_d1(o_d1),
.o_d2(o_d2),
.o_d3(o_d3),
.o_d4(o_d4)
);

endmodule
