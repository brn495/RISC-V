rm work*.cf
ghdl -a --std=08 ../../Packages/constant_package.vhdl
ghdl -a --std=08 ../../Komponenten/RAM/Single_Port_RAM.vhdl
ghdl -a --std=08 ../../Testbenches/RAM/Single_Port_RAM_tb.vhdl
ghdl -r --std=08 Single_Port_RAM_tb --vcd=Single_Port_RAM_tb.vcd --stop-time=500ns