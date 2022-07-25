module fifo(clk_r, clk_w, rstn, in_read_ctrl, in_write_ctrl, out_read_data, in_write_data, full, empty, read_count);

parameter mem_depth = 63;
parameter databits  = 16;
parameter depth = 6; //addr bits

input	clk_r, clk_w, rstn, in_read_ctrl, in_write_ctrl;
input	[databits-1:0] in_write_data;
output wire full, empty;
output reg [databits-1:0] out_read_data;
wire [depth:0] gray_r_addr, gray_w_addr;
reg [databits-1:0] mem [mem_depth:0];
reg [depth:0] r_addr, w_addr, w2r_1, w2r_2, r2w_1, r2w_2;//extend 1 bits
output wire [depth-1:0] read_count;   


assign gray_w_addr = (w_addr >> 1) ^ w_addr;
assign gray_r_addr = (r_addr >> 1) ^ r_addr;
assign empty = (gray_r_addr == w2r_2);
assign full = (gray_w_addr == {~r2w_2[6:5],r2w_2[4:0]});
assign read_count = r_addr[depth-1:0];
	

always@(posedge clk_r or negedge rstn)begin 
	if (!rstn)begin 
		r_addr <= 0;
		w2r_1 <= 0;
		w2r_2 <= 0;
	end
	else if (in_read_ctrl && !empty && !in_write_ctrl)begin  //in_read_ctrl
		out_read_data <= mem[r_addr[depth-1:0]];
		r_addr <= r_addr + 1;
		w2r_1 <= gray_w_addr;
		w2r_2 <= w2r_1;
	end
	else begin
		w2r_1 <= gray_w_addr;
		w2r_2 <= w2r_1;
	end
end 

always@(posedge clk_w or negedge rstn)begin 
	if (!rstn)begin 
		w_addr <= 0;
		r2w_1 <= 0;
		r2w_2 <= 0;
	end
	else if (in_write_ctrl && !full && !in_read_ctrl)begin  //in_write_ctrl
		mem[w_addr[depth-1:0]] <= in_write_data;
		w_addr <= w_addr + 1;
		r2w_1 <= gray_r_addr;
		r2w_2 <= r2w_1;
	end
	else begin 
		r2w_1 <= gray_r_addr;
		r2w_2 <= r2w_1;
	end
end 

endmodule

