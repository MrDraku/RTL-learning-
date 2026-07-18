# Sequential

This folder contains sequential logic examples and related Verilog files.

## Contents
- counters/
  - reg.v
  - reg_tb.v

## Notes
- Use iverilog to compile and simulate the Verilog files.
- Example:
  ```bash
  cd sequential/counters
  iverilog -o sim reg.v reg_tb.v
  vvp sim
  ```
