module Core(
input clk1, 
input clk2,
input rstn, 
input [15:0] data_in, 
input in_write_ctrlX,
output signed [37:0] sum,
output able2write_out
);

reg  in_read_ctrlX;
wire out_is_fullX, out_is_emptyX;
wire signed [15:0] out_read_dataX;
reg  signed [37:0] sum_partial;
reg  signed [37:0] sum_out;
wire signed [31:0] DA_out_1, DA_out_2, DA_out_3,DA_out_4;
reg  signed [15:0] fifo_out_reg [63:0];
reg  [6:0]  read_count_buffer_1, read_count_buffer_2;
reg  able2write;
wire [5:0] read_count;
reg  signed [15:0] out_read_dataX_1, out_read_dataX_2, out_read_dataX_3, out_read_dataX_4, out_read_dataX_buffer_1, out_read_dataX_buffer_2;
reg  enable_inWr, enable_outRd;
integer DA_Wr_count, i, DA_Rd_count;

fifo fifo( 
.clk_r(clk1), 
.clk_w(clk1), 
.rstn(rstn), 
.in_read_ctrl(in_read_ctrlX), 
.in_write_ctrl(in_write_ctrlX), 
.in_write_data(data_in), 
.out_read_data(out_read_dataX), 
.full(out_is_fullX), 
.empty(out_is_emptyX), 
.read_count(read_count)
);

DA_table_1 DA_table_1(
.table_in_1(out_read_dataX_1), 
.table_out_1(DA_out_1)
);
	
DA_table_2 DA_table_2(
.table_in_2(out_read_dataX_2), 
.table_out_2(DA_out_2)
);
	
DA_table_3 DA_table_3(
.table_in_3(out_read_dataX_3), 
.table_out_3(DA_out_3)
);
	
DA_table_4 DA_table_4(
.table_in_4(out_read_dataX_4), 
.table_out_4(DA_out_4)
);


assign sum = sum_out;
assign able2write_out = able2write; 

always@(posedge clk1 or negedge rstn)begin

	if(!rstn)begin
		in_read_ctrlX 		<= 0;
 		sum_partial   		<= 0;
		read_count_buffer_1     <= 0;
		read_count_buffer_2     <= 0;	
		out_read_dataX_buffer_1 <= 0;
		out_read_dataX_buffer_2 <= 0;
		DA_Wr_count		<= 0;
		DA_Rd_count		<= 0;
		enable_inWr		<= 0;
		enable_outRd		<= 0;
		for(i=0;i<64;i=i+1)begin 
			fifo_out_reg[i]	<= 0;
				   end
	end
	else begin 
	read_count_buffer_1 <= read_count[5:0];
	read_count_buffer_2 <= read_count_buffer_1;
	out_read_dataX_buffer_1 <= out_read_dataX;
	out_read_dataX_buffer_2 <= out_read_dataX;
	//fifo logic
	if(out_is_emptyX)begin // if empty, write till full, if full, read till empty
		in_read_ctrlX  <= 0;
		able2write     <= 1;
	     end
	else if(out_is_fullX) begin 
		in_read_ctrlX  <= 1;
		able2write     <= 0;
	     end
	else begin
		in_read_ctrlX  <= in_read_ctrlX;
		able2write     <= able2write;
	     end


	if(read_count[5:0] != 0 || read_count_buffer_1 == 63)begin //create reg to transfer fifo data
		if(read_count_buffer_1 < 16)begin 
			for(i=0; i<16; i=i+1)begin 
				fifo_out_reg[i][read_count_buffer_1] <= out_read_dataX[i];
					     end
					    end
		else if(read_count_buffer_1 > 15 && read_count_buffer_1 < 32)begin
			for(i=0; i<16; i=i+1)begin 
				fifo_out_reg[i+16][read_count_buffer_1 - 16] <= out_read_dataX[i];
					     end
					    end
		else if(read_count_buffer_1 > 31 && read_count_buffer_1 < 48)begin  
			for(i=0; i<16; i=i+1)begin 
				fifo_out_reg[i+32][read_count_buffer_1 - 32] <= out_read_dataX[i];
					     end
					    end
		else if(read_count_buffer_1 > 47)begin
			for(i=0; i<16; i=i+1)begin 
				fifo_out_reg[i+48][read_count_buffer_1 - 48] <= out_read_dataX[i];
					     end
					    end
		else fifo_out_reg[read_count_buffer_1] <= fifo_out_reg[read_count_buffer_1];		
							     end
	else fifo_out_reg[read_count_buffer_1] <= fifo_out_reg[read_count_buffer_1];




	if(enable_inWr)begin  // input data into LUT
			if(DA_Wr_count < 16)begin
				out_read_dataX_4 <= fifo_out_reg[DA_Wr_count + 48];
				out_read_dataX_3 <= 0;
				DA_Wr_count 		 <= DA_Wr_count + 1 ;
					    end
			else begin 
				enable_inWr	<= 0;
				DA_Wr_count		<= 0;
			end
			end

	else if (read_count_buffer_1 > 47 && read_count_buffer_1 < 64)begin
				out_read_dataX_3 <= fifo_out_reg[read_count_buffer_1-16];
				out_read_dataX_2 <= 0;
				if(read_count_buffer_1 == 63)
					enable_inWr <= 1;
					   			      end

	else if (read_count_buffer_1 > 31 && read_count_buffer_1 < 48)begin
				out_read_dataX_2 <= fifo_out_reg[read_count_buffer_1-16];
				out_read_dataX_1 <= 0;
					    			      end

	else if (read_count_buffer_1 > 15 && read_count_buffer_1 < 32)begin
				out_read_dataX_1 <= fifo_out_reg[read_count_buffer_1-16];
				out_read_dataX_4 <= 0;
								      end
	else out_read_dataX_1 <= 0;	



	if(read_count_buffer_2 > 15 && read_count_buffer_2 < 32) begin //accumulating LUT outputs
			if(read_count_buffer_2 == 31)
				sum_partial <= sum_partial - (DA_out_1 <<< (read_count_buffer_2-16));
			else
				sum_partial <= sum_partial + (DA_out_1 <<< (read_count_buffer_2-16));
					   end
	else if(read_count_buffer_2 > 31 && read_count_buffer_2 < 48) begin 
			if(read_count_buffer_2 == 47)
				sum_partial <= sum_partial - (DA_out_2 <<< (read_count_buffer_2-32));
			else
				sum_partial <= sum_partial + (DA_out_2 <<< (read_count_buffer_2-32));
					   end				    
	else if(read_count_buffer_2 > 47 && read_count_buffer_2 < 64) begin 
			if(read_count_buffer_2 == 63)begin
				sum_partial <= sum_partial - (DA_out_3 <<< (read_count_buffer_2-48));
				enable_outRd <= 1;
							end
			else
				sum_partial <= sum_partial + (DA_out_3 <<< (read_count_buffer_2-48));
					   end	
	else if(enable_outRd) begin  
			if(DA_Rd_count == 15) begin 
				sum_partial <= sum_partial - (DA_out_4 <<< DA_Rd_count);
				DA_Rd_count <= DA_Rd_count + 1;
				end
			else if(DA_Rd_count >= 0 && DA_Rd_count < 15)begin 
				sum_partial <= sum_partial + (DA_out_4 <<< DA_Rd_count);
				DA_Rd_count <= DA_Rd_count + 1;
					   end	
			else begin 
					sum_out <= sum_partial;
					sum_partial 	<= 0;
					enable_outRd	<= 0;
					DA_Rd_count	<= 0;		 
						end
			end
end

end

endmodule
