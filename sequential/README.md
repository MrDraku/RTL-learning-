# Sequential
> always@(posedge clk or negedge clk )  => synchronous
   We mainly use positive (pos) edge =>  Wakes up only on the active  clk egde 
> always@(posedge clk or posedge rst)  => Asynchronous 
 => wake up on the clk edge or when "rst" changes to 1...
 ```bash 
 =>always( outside of the initial block, -> its a process) #10 clk =~clk; -> the easiest way to generate a clock
=>initial... forever( inside the initial block -> its a loop )-> when we wount to initialize something or delay the clock before ity starts
## counters
>> register
  => better to do reg on enable , reset  separetly for better understanding of how the data gets register at every clk edge.Then with both enable & Reset
  => For testing better manuval data  input ...
  -> for shift reg we use q<= {q[width-2:0], serial_in} for right shift(through away msb ). And  for left sift q <= {serial_in,q[WIDTH-1:1]} (Through away LSB so we give WIDTH-1:1)
  => we can use << or >>  for bit manupulation / simple data movement

## Notes
- Use iverilog to compile and simulate the Verilog files.
- Example:
  ```bash
  cd sequential/counters
  iverilog -o sim reg.v reg_tb.v
  vvp sim
  ```
