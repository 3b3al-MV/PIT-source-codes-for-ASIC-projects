# Programmable Interval Timer (PIT) Design

## Introduction

Briefly introduce the project and its purpose. Describe the features provided by the PIT design.

## Files Included

- `pit_count.v`: Description of the main counter module.
- `pit_prescale.v`: Description of the prescaler module.
- `pit_regs.v`: Description of the control register module.
- `pit_wb_bus.v`: Description of the Wishbone bus interface module.
- `pit_top.v`: Description of the top-level module integrating all components.
- Other Verilog files (if any) related to the project.

## Usage

Explain how to use the PIT design in a Verilog project. Provide instructions for instantiating the `pit_top` module and connecting its inputs and outputs.

## Parameters

- `COUNT_SIZE`: Main counter size. (Default: 16)
- `NO_PRESCALE`: Set to 1 to disable prescaler functionality. (Default: 0)
- Other parameters and their descriptions.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
