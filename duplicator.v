module duplicator
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
input                  i_TREADY,
input            [1:0] i_TUSER,

output [pix_depth-1:0] o_TDATA,
output reg             o_TREADY,
output reg             o_TVALID,
output           [1:0] o_TUSER
);

reg [pix_depth+pix_depth*(frame_width+2*add_cells)-1:0] row_buffer = 0;

reg [10:0] pix_cnt = 0; //write with parameters

always@(posedge clk)
begin
	if(resetn == 0)
	begin
	    pix_cnt  <= 0;
		o_TVALID <= 0;
		o_TREADY <= 0;
	end
	else
	begin
		if(pix_cnt < add_cells && i_TVALID == 1)
		begin
			row_buffer                <= row_buffer << pix_depth;
			if(pix_cnt + 1 < add_cells)
			begin
				o_TREADY                  <= 0;
			end
			else
			begin
				o_TREADY                  <= 1;
			end	
			row_buffer[pix_depth-1:0] <= i_TDATA;
			o_TVALID                  <= 1;
			pix_cnt                   <= pix_cnt + 1;
		end
		else if(pix_cnt >= add_cells && pix_cnt < frame_width && i_TVALID == 1)
		begin
			row_buffer                <= row_buffer << pix_depth;
			o_TREADY                  <= 1;
			row_buffer[pix_depth-1:0] <= i_TDATA;
			o_TVALID                  <= 1;
			pix_cnt                   <= pix_cnt + 1;
		end
		else if(pix_cnt >=  frame_width && pix_cnt < (frame_width+2*add_cells) && i_TVALID == 1)
		begin
			row_buffer                <= row_buffer << pix_depth;
			o_TREADY                  <= 0;
			if(pix_cnt==(frame_width+2*add_cells)-1)
				o_TREADY              <= 1;
			row_buffer[pix_depth-1:0] <= i_TDATA;
			o_TVALID                  <= 1;
			pix_cnt                   <= pix_cnt + 1;
		end
		else
		begin
			o_TVALID <= 0;
			pix_cnt  <= 0;
			o_TREADY <= 0;
		end
	end
end

assign o_TDATA = (resetn == 1)? row_buffer[pix_depth-1:0] :     0;
assign o_TUSER = (resetn == 1)? i_TUSER                   : 2'b00;

endmodule