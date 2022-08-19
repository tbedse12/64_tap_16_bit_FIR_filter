# 64 tap 16 bit FIR filter
This is a 64 tap 16 point serial FIR filter based on Distrubuted arithmetic(DA).  
There are also gate level files, and python for generating LUT and test result.   

## Building Blocks
  Dual-clock FIFO (with designer-specified depth)    
  Fixed-point ALU(Design/employ distributed arithmetic hardware to perform the multiply-and-accumulate (MAC))     
  Register file      
  <img width="686" alt="image" src="https://user-images.githubusercontent.com/103384755/185696044-8bbf3216-0769-4886-a5b0-db8b0e48f0c6.png">

Testbench:    
  Provide input at clk1      
  Provide clk1 and clk2      
  The spec for clk1 is 10 kHz   
  that for clk2 is designer-specified          
  
### Result wave
<img width="1213" alt="image" src="https://user-images.githubusercontent.com/103384755/180323733-e07061e7-cbb0-4b90-a190-55dc539b16fd.png">.   

### Design Specification
| Spec     |     Value     |
|----------|---------------|
|Frequency |100 MHz        |
|Chip size |383409.94 µm^2 |
|Power     |5.46e-5 mW     |
|Technology|IBM 130nm      |

  

