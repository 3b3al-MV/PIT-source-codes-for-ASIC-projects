# PIT-source-codes-for-ASIC-projects
Programmable Interval Timer (PIT) Design
This Verilog project implements a Programmable Interval Timer (PIT) suitable for use in FPGA or ASIC designs. The PIT supports features such as:

Configurable main counter size
Prescaler functionality with optional decade counter
Wishbone bus interface for register access
Support for synchronous and asynchronous reset
PIT interrupt generation
Files Included
pit_count.v: Main counter module.
pit_prescale.v: Prescaler module.
pit_regs.v: Control register module.
pit_wb_bus.v: Wishbone bus interface module.
pit_top.v: Top-level module integrating all components.
Other Verilog files (if any) related to the project.
Usage
To use the PIT design, instantiate the pit_top module in your Verilog project and connect the appropriate inputs and outputs according to your system requirements.

Parameters
COUNT_SIZE: Main counter size.
NO_PRESCALE: Set to 1 to disable prescaler functionality.
Other parameters for specific features and configurations.
