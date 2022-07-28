module fifo_0
#(
parameter pix_depth = 4,
parameter frame_width = 10,
parameter filter_size = 5,
parameter add_cells = (filter_size-1)/2
)
(
input clock,
input resetn,

input [1:0] TUSER,

input      s_tvalid,
output reg s_tready,
input      m_tready,
output reg m_tvalid,
 

input  [pix_depth-1:0] in_d0,
output [pix_depth-1:0]  o_d0,
output [pix_depth-1:0]  o_d1,
output [pix_depth-1:0]  o_d2,
output [pix_depth-1:0]  o_d3,
output [pix_depth-1:0]  o_d4
);

reg empty;
reg full;

reg [filter_size*pix_depth-1:0] pix_2d_buffer [frame_width + 2*add_cells - 1 : 0];


reg [((pix_depth)*5*(frame_width+2*add_cells)):0] buffer = 0;
reg [10:0] cnt = 0;

reg rd_pnt;
reg wr_pnt;


always@(posedge clock)
begin
	if(resetn == 0)
	begin
		full     <= 0;
		empty    <= 1;
		cnt      <= 0;
		s_tready <= 0;
		m_tvalid <= 0;
	end
	else
	begin
		s_tready <= 1;
		if(s_tvalid == 1)
		begin
			if(TUSER[0] == 1 && TUSER[1] == 1)
			begin
				buffer    <= buffer << pix_depth;
				empty     <= 0;
				// data assignment(frame start);
				// pointer logic;
				cnt <= cnt + 3;
			end
			else
			begin
				// pointer logic;
				// data assignment;
				empty     <= 0;
				cnt       <= cnt + 1;     
			end
		end
		
		if(cnt == 5*(frame_width+2*add_cells) - 1)
		begin
			cnt      <= 0;
			full     <= 1;
			m_tvalid <= 1;
			s_tready <= 0;
		end 
		end
end

assign o_d0 = (resetn != 0 && full == 1 && m_tready == 1)? buffer[1*pix_depth*(frame_width+2*add_cells)-1:1*pix_depth*(frame_width+2*add_cells)-pix_depth]: 0;
assign o_d1 = (resetn != 0 && full == 1 && m_tready == 1)? buffer[2*pix_depth*(frame_width+2*add_cells)-1:2*pix_depth*(frame_width+2*add_cells)-pix_depth]: 0;
assign o_d2 = (resetn != 0 && full == 1 && m_tready == 1)? buffer[3*pix_depth*(frame_width+2*add_cells)-1:3*pix_depth*(frame_width+2*add_cells)-pix_depth]: 0;
assign o_d3 = (resetn != 0 && full == 1 && m_tready == 1)? buffer[4*pix_depth*(frame_width+2*add_cells)-1:4*pix_depth*(frame_width+2*add_cells)-pix_depth]: 0;
assign o_d4 = (resetn != 0 && full == 1 && m_tready == 1)? buffer[5*pix_depth*(frame_width+2*add_cells)-1:5*pix_depth*(frame_width+2*add_cells)-pix_depth]: 0;

endmodule