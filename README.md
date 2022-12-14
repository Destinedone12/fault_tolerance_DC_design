# On the Privacy of fault tolerant DC designs

This repository includes the source code of the fault tolerant design of coding-Based parallel digital channelizers written in SystemVerilog.

# Dependencies
- Vivado 2018.2

# Content

each ***_src directory contains the source code and a configuration guide (named 'README.docx') of a Vivado project. 

- single_DC_src: Instance of single digital channelizer with no protection.
- DC_FT_TMR_src: Fault tolerant design of digital channelizers using TMR method.
- DC_FT_coded_src: Redundant part of coding-based fault tolerant design for 8 digital channelizers

# Generation of Utilization & Power report
- Set up a new project in Vivado, then follow the instructions in the configuration guide.
- Create a new .xdc file, then add user-defined clock constraints, like
`create_clock -period 10 [get_ports clk]`.
- Run Synthesis.
- After Synthesis is complete, click "Report Utilization" and "Report Power" in Flow Navigator.
