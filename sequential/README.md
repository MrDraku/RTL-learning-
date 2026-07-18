# Sequential
# counters
> register
  => better to do reg on enable , reset  separetly for better understanding of how the data gets register at every clk edge.Then with both enable & Reset
  => For testing better manuval data ..
  
## Notes
- Use iverilog to compile and simulate the Verilog files.
- Example:
  ```bash
  cd sequential/counters
  iverilog -o sim reg.v reg_tb.v
  vvp sim
  ```
