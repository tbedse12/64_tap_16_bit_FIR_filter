module Core(
input 		clk, 
input 		clk_fifo,
input 		rstn, 
input [15:0] 	data_in, 
input		in_write_ctrlX,
output[37:0]	sum,
output		able2write_out
);


wire	out_is_fullX, out_is_emptyX, out_is_fullB, out_is_emptyB;
wire [15:0] out_read_dataX;
wire [15:0] out_read_dataB;
wire [31:0] Y, Y_1, Y_2, Y_3,Y_4;
wire [6:0] read_count;
reg  [37:0] sum_partial, sum_partial_buffer;
reg  [37:0] sum_out;
reg  [37:0] sum_out_buffer;
reg  [31:0] Y_buffer;
reg  [15:0] register [63:0];
reg  [15:0] Y_register [63:0];
reg  [5:0] sum_count, read_count_buffer_1, read_count_buffer_2;
reg  [4:0] counter;
reg  [15:0] out_read_dataX_1, out_read_dataX_2, out_read_dataX_3, out_read_dataX_4, out_read_dataX_buffer_1, out_read_dataX_buffer_2;
reg	able2write;
reg	in_read_ctrlX;
reg	enable_1, enable_2;
integer v, i, x;

	fifo 
fifo( .clk_r(clk), .clk_w(clk), .rstn(rstn), .in_read_ctrl(in_read_ctrlX), 
.in_write_ctrl(in_write_ctrlX), .in_write_data(data_in), .out_read_data(out_read_dataX), 
.full(out_is_fullX), .empty(out_is_emptyX), .read_count(read_count));

	DA_table_1 
DA_table_1(.table_in_1(out_read_dataX_1), .table_out_1(Y_1));
	DA_table_2 
DA_table_2(.table_in_2(out_read_dataX_2), .table_out_2(Y_2));
	DA_table_3 
DA_table_3(.table_in_3(out_read_dataX_3), .table_out_3(Y_3));
	DA_table_4 
DA_table_4(.table_in_4(out_read_dataX_4), .table_out_4(Y_4));

assign able2write_out = able2write;
assign sum = sum_out;

always@(posedge clk or negedge rstn)begin
	if(!rstn)begin
		in_read_ctrlX 		<= 0;
 		sum_partial   		<= 0;
		sum_count    		<= 0;
		read_count_buffer_1     <= 0;
		read_count_buffer_2     <= 0;
		Y_buffer       		<= 0;
		out_read_dataX_buffer_1 <= 0;
		out_read_dataX_buffer_2 <= 0;
		v			<= 0;
		x			<= 0;
		enable_1		<= 0;
		enable_2		<= 0;
		for(i=0;i<64;i=i+1)begin 
			register[i] 	<= 0;
			Y_register[i]	<= 0;
				   end
	end
	else begin 
		read_count_buffer_1 <= read_count;
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


	if(read_count[5:0] != 0 || read_count_buffer_1 == 63)begin //create reg to store and transfer fifo data for DA 
		register[read_count_buffer_1] <= out_read_dataX;
		if(read_count_buffer_1 < 16)begin 
			for(i=0; i<16; i=i+1)begin 
				Y_register[i][read_count_buffer_1] <= out_read_dataX[i];
					     end
					    end
		else if(read_count_buffer_1 > 15 && read_count_buffer_1 < 32)begin
			for(i=0; i<16; i=i+1)begin 
				Y_register[i+16][read_count_buffer_1 - 16] <= out_read_dataX[i];
					     end
					    end
		else if(read_count_buffer_1 > 31 && read_count_buffer_1 < 48)begin  
			for(i=0; i<16; i=i+1)begin 
				Y_register[i+32][read_count_buffer_1 - 32] <= out_read_dataX[i];
					     end
					    end
		else if(read_count_buffer_1 > 47)begin
			for(i=0; i<16; i=i+1)begin 
				Y_register[i+48][read_count_buffer_1 - 48] <= out_read_dataX[i];
					     end
					    end		
							     end



		
	if(enable_1)begin  // input data to LUT
			if(v < 16)begin
				out_read_dataX_4 <= Y_register[v + 48];
				out_read_dataX_3 <= 0;
				v 		 <= v + 1 ;
					    end
			else begin 
				enable_1	<= 0;
				v		<= 0;
			end
			end

	else if (read_count_buffer_1 > 47 && read_count_buffer_1 < 64)begin
				out_read_dataX_3 <= Y_register[read_count_buffer_1-16];
				out_read_dataX_2 <= 0;
				if(read_count_buffer_1 == 63)
					enable_1 <= 1;
					   			      end

	else if (read_count_buffer_1 > 31 && read_count_buffer_1 < 48)begin
				out_read_dataX_2 <= Y_register[read_count_buffer_1-16];
				out_read_dataX_1 <= 0;
					    			      end

	else if (read_count_buffer_1 > 15 && read_count_buffer_1 < 32)begin
				out_read_dataX_1 <= Y_register[read_count_buffer_1-16];
				out_read_dataX_4 <= 0;
								      end



	if(read_count_buffer_2 > 15 && read_count_buffer_2 < 32) begin //sum the partial results 
			if(read_count_buffer_2 == 31)
				sum_partial <= sum_partial - (Y_1 <<< (read_count_buffer_2-16));
			else
				sum_partial <= sum_partial + (Y_1 <<< (read_count_buffer_2-16));
					   end
	else if(read_count_buffer_2 > 31 && read_count_buffer_2 < 48) begin 
			if(read_count_buffer_2 == 47)
				sum_partial <= sum_partial - (Y_2 <<< (read_count_buffer_2-32));
			else
				sum_partial <= sum_partial + (Y_2 <<< (read_count_buffer_2-32));
					   end				    
	else if(read_count_buffer_2 > 47 && read_count_buffer_2 < 64) begin 
			if(read_count_buffer_2 == 63)begin
				sum_partial <= sum_partial - (Y_3 <<< (read_count_buffer_2-48));
				enable_2 <= 1;
							end
			else
				sum_partial <= sum_partial + (Y_3 <<< (read_count_buffer_2-48));
					   end	
	if(enable_2) begin  
			if(x == 15) begin 
				sum_partial <= sum_partial - (Y_4 <<< x);
				x <= x + 1;
				end
			else if(x >= 0 && x < 15)begin 
				sum_partial <= sum_partial + (Y_4 <<< x);
				x <= x + 1;
					   end	
				if (x == 16) begin 
					sum_out_buffer  <= sum_partial;
					sum_partial 	<= 0;
					enable_2	<= 0;
					x		<= 0;		 
						end
			end
		end		
end

always@(posedge clk_fifo) begin 
	sum_out <= sum_out_buffer;
	end
		
endmodule		
				
