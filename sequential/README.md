# Sequential
> always@(posedge clk or negedge clk )  => synchronous
   We mainly use positive (pos) edge =>  Wakes up only on the active  clk egde 
> always@(posedge clk or posedge rst)  => Asynchronous 
 => wake up on the clk edge or when "rst" changes to 1...
# counters
> register
  => better to do reg on enable , reset  separetly for better understanding of how the data gets register at every clk edge.Then with both enable & Reset
  => For testing better manuval data  input ...

## Notes
- Use iverilog to compile and simulate the Verilog files.
- Example:
  ```bash
  cd sequential/counters
  iverilog -o sim reg.v reg_tb.v
  vvp sim
  ```
