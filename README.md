# 64 tap 16 bit FIR filter
This is a 64 tap 16 point serial FIR filter based on Distrubuted arithmetic(DA).  
There are also gate level files, and python for generating LUT and test result.   

## Block Diagram
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
<img width="1213" alt="image" src="https://user-images.githubusercontent.com/103384755/180323733-e07061e7-cbb0-4b90-a190-55dc539b16fd.png">.   

### Design Specification
| Spec     |     Value     |
|----------|---------------|
|Frequency |100 MHz        |
|Chip size |383409.94 µm^2 |
|Power     |5.46e-5 mW     |
|Technology|IBM 130nm      |

  

