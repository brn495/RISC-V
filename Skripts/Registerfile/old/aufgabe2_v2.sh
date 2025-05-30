rm work*.cf
ghdl -a --std=08 ../../Packages/constant_package.vhdl
ghdl -a --std=08 ../../Packages/type_packages.vhdl
ghdl -a --std=08 ../../Packages/types.vhdl
ghdl -a --std=08 ../../Komponenten/Registerfile/register_file.vhdl
ghdl -a --std=08 ../../Testbenches/Registerfile/register_file_tb.vhdl
ghdl -r --std=08 register_file_tb --wave=register_file_tb.ghw --stop-time=500ns
