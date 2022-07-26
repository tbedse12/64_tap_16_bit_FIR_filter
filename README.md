# FA21_4823_FIR_project
This is a 64 tap 16 point serial FIR filter based on Distrubuted arithmetic(DA).  
There are also gate level files, and python for generating LUT and test result.   

## Block Diagram
<img width="944" alt="image" src="https://user-images.githubusercontent.com/103384755/180321194-88e515f7-8ea1-46e0-a1d1-873cb14d3bb2.png">







  Load all the inputs in the FIFO (FIFO)   
  Load all the coefficients in the coeff. memory (CMEM)     
  Compute for the throughput of 10 kS/s (exclude data loading time)   
  Use only one adder and one multiplier (or less) in the core      

### Building Blocks.  
  Dual-clock FIFO (with designer-specified depth)    
  Coefficient memory, CMEM (64 x 2B)   
  Fixed-point ALU(Design/employ distributed arithmetic hardware to perform the multiply-and-accumulate (MAC))     
  Register file      
  
Testbench needs to     
  Provide input at clk1      
  Provide clk1 and clk2      
  The spec for clk1 is 10 kHz   
  that for clk2 is designer-specified        
  Perform the signature analyzer     
  
### Result wave
<img width="1213" alt="image" src="https://user-images.githubusercontent.com/103384755/180323733-e07061e7-cbb0-4b90-a190-55dc539b16fd.png">

###Design Specification 
| Spec |  Value  |
|------|---------|
|Frequency|100MHz|
|Chip size|.     |
|Power|.         |
|Technology|IBM 130nm|

  

