rm work*.cf
ghdl -a --std=08 ../../Packages/constant_package.vhdl
ghdl -a --std=08 ../../Packages/type_packages.vhdl
ghdl -a --std=08 ../../Packages/types.vhdl
ghdl -a --std=08 ../../Packages/Util_Asm_Package.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_or.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_and.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_xor.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_half_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_gen_n_bit_full_adder.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_shifter.vhdl
ghdl -a --std=08 ../../Komponenten/ALU/my_alu.vhdl
ghdl -a --std=08 ../../Komponenten/Register/PipelineRegister1.vhdl
ghdl -a --std=08 ../../Komponenten/Registerfile/register_file.vhdl
ghdl -a --std=08 ../../Komponenten/RAM/Single_Port_RAM.vhdl
ghdl -a --std=08 ../../Komponenten/Multiplexer/gen_mux.vhdl
ghdl -a --std=08 ../../Komponenten/SignExtender/signExtension.vhdl
ghdl -a --std=08 ../../Komponenten/Decoder/decoder.vhdl
ghdl -a --std=08 ../../Komponenten/Cache/instruction_cache.vhdl
ghdl -a --std=08 ../../Komponenten/Register/controlwordregister.vhdl
ghdl -a --std=08 ../../RISCV/R_only_RISC_V.vhdl
ghdl -a --std=08 ../../Testbenches/RISCV/R_only_RISC_V_tb.vhdl
ghdl -r --std=08 R_only_RISC_V_tb --vcd=R_only_RISC_V_tb.vcd