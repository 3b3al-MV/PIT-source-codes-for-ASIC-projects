# Programmable Interval Timer (PIT) Design

## Introduction

This Verilog project implements a Programmable Interval Timer (PIT) suitable for use in FPGA or ASIC designs. The PIT supports features such as:

- Configurable main counter size
- Prescaler functionality with an optional decade counter
- Wishbone bus interface for register access
- Support for synchronous and asynchronous reset
- PIT interrupt generation

## Files Included

- `pit_count.v`: Main counter module.
- `pit_prescale.v`: Prescaler module.
- `pit_regs.v`: Control register module.
- `pit_wb_bus.v`: Wishbone bus interface module.
- `pit_top.v`: Top-level module integrating all components.

## Usage

Explain how to use the PIT design in a Verilog project. Provide instructions for instantiating the `pit_top` module and connecting its inputs and outputs.

## Parameters

- `COUNT_SIZE`: Main counter size. (Default: 16)
- `NO_PRESCALE`: Set to 1 to disable prescaler functionality. (Default: 0)
- Other parameters and their descriptions.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
