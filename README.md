# RTL Learning — Verilog Design & Verification

Hands-on Verilog RTL design and simulation-based verification, built while working through a self-directed RTL/DV engineering roadmap. Every design here is implemented and verified with a matching testbench — this repo tracks actual hands-on work, not tutorial follow-alongs.

**Tools:** Icarus Verilog, GTKWave, VS Code, Git

---

## Repository Structure

---

## Featured Project

### Smart Washing Machine Controller (`Projects/project_0/`)
An 8-state Moore FSM (`Idle → Fill → Wash → Drain → Spin → Done`, with `Pause` and `Error` handling) modeling a washing machine's control logic — including door/temperature safety behavior and motor/heater/pump control signals.

- `Washing_Mac_moore.v` — DUT
- `Washing-Mac_moore_tb.v` — self-checking testbench with clock-synchronous stimulus

---

## Sequential (`sequential/`)
- **Register** — basic register design
- **counters** — parameterized counter with a parameterized, loop-driven testbench

## Combinational (`combinational/`)
- **CLA** — Carry Look-Ahead Adder (including a 16-bit variant)
- **ALU** — modular arithmetic/logic unit
- Logic gate fundamentals: AND, OR, NAND, OR-NAND composite logic
- **Full Adder**
- **Mux/Demux** — 2-to-1 multiplexer, demultiplexer
- **Priority Encoder**
- **Comparator** — 2-bit comparator
- **Parity generators** — even and odd parity

Every design above has a matching `_tb.v` testbench validating its behavior.

---

## Verification Approach

Each design follows a consistent flow: define expected behavior → write test scenarios → build a self-checking testbench → simulate → check pass/fail. Testbenches use clock-synchronous stimulus timing (`posedge`-driven, delayed assignment) to avoid race conditions, with waveform-based debugging via GTKWave.

---

## Currently In Progress

This repo will grow alongside an ongoing RTL/DV roadmap: RTL synthesis and static timing analysis, protocol RTL (UART/SPI), SystemVerilog, and UVM-based verification tied to real designs. New work is added as it's actually completed and verified — not in advance.

---

## Contact

Guguloth Laxman — gugulothlaxman369@gmail.com · [LinkedIn](https://linkedin.com/in/guguloth-laxman-282a86425)