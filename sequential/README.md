# Sequential Logic

## Sequential Blocks

> `always @(posedge clk or negedge clk)` → Synchronous

- We mainly use the positive edge (`posedge clk`).
- The hardware wakes up only on the active clock edge.

> `always @(posedge clk or posedge rst)` → Asynchronous Reset

- The hardware wakes up on the clock edge or immediately when `rst` becomes `1`.

---

## Clock Generation

### `always`

```verilog
always #10 clk = ~clk;
```

- Used outside the `initial` block.
- Represents a continuous hardware process.
- The easiest way to generate a clock.

### `initial`

```verilog
initial begin
    forever #10 clk = ~clk;
end
```

- Used when we want to initialize something before the clock starts.
- `forever` creates an infinite loop inside the `initial` block.

---

# Registers

- It is better to understand the register in stages:
  1. Register
  2. Register with Enable
  3. Register with Reset
  4. Register with Enable + Reset

This makes it easier to understand how data is stored on every clock edge.

### Testing

- While learning, manually provide the data input.
- This makes debugging much easier.

### Shift Registers

Right Shift

```verilog
q <= {q[WIDTH-2:0], serial_in};
```

- MSB is discarded.
- Serial input enters the LSB.

Left Shift

```verilog
q <= {serial_in, q[WIDTH-1:1]};
```

- LSB is discarded.
- Serial input enters the MSB.

### Bit Manipulation

- Use `<<` and `>>` for simple bit shifting.

---

# Counters

My first parameterized Verilog design where I applied verification concepts such as:

- Tasks
- Functions
- Repeat
- While
- For loops

### Learning

- I spent the most time understanding this project.
- I still need to improve my understanding of parameters.
- The testbench includes almost every verification concept I currently know.
- From here onward, the focus is on improving verification quality, not just making the design work.

### Future Direction

- Use parameterization whenever possible for better flexibility.
- Move towards self-checking testbenches.
- Prefer `@(posedge clk)` over unnecessary delays when appropriate.

---

# Notes

Compile and simulate using Icarus Verilog.

```bash
cd sequential/counters

iverilog -o sim reg.v reg_tb.v

vvp sim
```
