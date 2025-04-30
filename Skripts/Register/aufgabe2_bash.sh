rm work*.cf
ghdl -a --std=08 ../../Packages/constant_package.vhdl
ghdl -a --std=08 ../../Komponenten/Register/PipelineRegister.vhdl
ghdl -a --std=08 ../../Testbenches/Register/PipelineRegister_tb.vhdl
ghdl -e --std=08 PipelineRegister_tb
ghdl -r --std=08 PipelineRegister_tb --vcd=PipelineRegister_tb.vcd --stop-time=500ns
