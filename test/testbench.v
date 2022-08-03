`timescale 1ns/1ps
`define SD #0.010
`define HALF_CLOCK_PERIOD #500
`define HALF_CLOCK_RFIFO_PERIOD #50000
`define HALF_CLOCK_WFIFO_PERIOD #50000
module testbench();


	reg signed [15:0] data_in;
	reg signed [15:0] coe;
	reg signed [37:0] py_output;
	reg rstn;
	wire signed [37:0] Output;
	reg clk1, clk2, write; 
	integer ret_readY;
	integer ret_readB;
	integer ret_readX;
	integer ret_write;
	integer matlab_out_fileY;
	integer matlab_out_fileB;
	integer matlab_out_fileX; 
	integer error_count = 0;
	integer i, m ;
	integer signed Sum = 0;
	wire able2write;

	always begin
		`HALF_CLOCK_RFIFO_PERIOD;
		clk2 = ~clk2;
	end	
	always begin
		`HALF_CLOCK_PERIOD;
		clk1 = ~clk1;
	end	
	assign enable = 1;


	Core Core(.data_in(data_in), .clk1(clk1), .clk2(clk2), .rstn(rstn), 
.sum(Output), .able2write_out(able2write), .in_write_ctrlX(write));


	initial begin

	 	matlab_out_fileX = $fopen("hw1X.txt","r");
	 	matlab_out_fileB = $fopen("hw1B_rev.txt","r");
		matlab_out_fileY = $fopen("hw1Y.txt","r");
		clk1 = 1;
		rstn = 0;
		clk2 = 1;
		#1000;
		rstn = 1;
		write = 0;
		#2000000;
		$finish;
		end
	always@(posedge clk1)begin 
		@(posedge clk2)
		for (m=0 ; m <7; m = m + 1) begin
		@(posedge clk1);
		if(able2write == 1)begin 
			for (i=0 ; i <64; i = i + 1) begin
			write = 1;
			ret_readX = $fscanf(matlab_out_fileX, "%b", data_in);
			ret_readB = $fscanf(matlab_out_fileB, "%b", coe);


			@(posedge clk1);
			end
			write =0;
			@(posedge clk2);
			end
				end
		
		end


		always@(Output)begin
		ret_readY = $fscanf(matlab_out_fileY, "%b", py_output);
		if(Output != py_output) begin
		error_count = error_count + 1;
		end
		end




endmodule 
