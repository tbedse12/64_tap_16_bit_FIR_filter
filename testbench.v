`timescale 1ns/1ps
`define SD #0.010
`define HALF_CLOCK_PERIOD #500
`define HALF_CLOCK_RFIFO_PERIOD #50000
`define HALF_CLOCK_WFIFO_PERIOD #50000
module testbench();


	reg signed [15:0] matlabX;
	reg signed [15:0] matlabB;
	reg signed [37:0] matlabY;
	reg reset;
	wire signed [37:0] Y;
	reg clk, clk_fifo, write; 
	integer ret_readY;
	integer ret_readB;
	integer ret_readX;
	integer ret_write;
	//integer signed matlabY;
	integer matlab_out_fileY;
	integer matlab_out_fileB;
	integer matlab_out_fileX;
	parameter    SIN_DATA_NUM = 64 ;  
	integer error_count = 0;
	integer Y_buffer;
	integer i, m ;
	integer signed Sum = 0;
	integer signed Z = 0;
	wire able2write;
	
	always begin
		`HALF_CLOCK_RFIFO_PERIOD;
		clk_fifo = ~clk_fifo;
	end	
	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end	
	assign enable = 1;


	Core Core(.B(matlabB), .X(matlabX), .clk(clk), .clk_fifo(clk_fifo), .reset(reset), 
.sum(Y), .able2write_out(able2write), .in_write_ctrlX(write));
 

	initial begin
		
	 	matlab_out_fileX = $fopen("hw1X.txt","r");
	 	matlab_out_fileB = $fopen("hw1B_rev.txt","r");
		matlab_out_fileY = $fopen("hw1Y.txt","r");
		clk = 1;
		reset = 1;
		clk_fifo = 1;
		#1000;
		reset = 0;
		write = 0;
		end
	always@(posedge clk)begin 
		@(posedge clk_fifo)
		for (m=0 ; m <7; m = m + 1) begin
		@(posedge clk);
		if(able2write == 1)begin 
			for (i=0 ; i <64; i = i + 1) begin
			write = 1;
			ret_readX = $fscanf(matlab_out_fileX, "%b", matlabX);
			ret_readB = $fscanf(matlab_out_fileB, "%b", matlabB);

 
			@(posedge clk);
			end
			write =0;
			@(posedge clk_fifo);
			end
				end
	
		end
	
		
		always@(Y)begin
		ret_readY = $fscanf(matlab_out_fileY, "%b", matlabY);
		//Y_buffer <= matlabY;
		if(Y != matlabY) begin
		error_count = error_count + 1;
		end
		end
		



endmodule 

