library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;

entity Single_Port_RAM is
    generic (
        word_width : integer := WORD_WIDTH;
        address_width : integer := ADR_WIDTH
    );
    port (
        pi_clk : in std_logic;
        pi_we : in std_logic := '0';
        pi_rst : in std_logic;
        pi_add : in std_logic_vector(address_width - 1 downto 0) := (others => '0');
        pi_data : in std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_data : out std_logic_vector(word_width - 1 downto 0) := (others => '0')
    );
end entity Single_Port_RAM;
-- alles untere von Copilot abi
architecture behaviour of Single_Port_RAM is
    type memory is array (0 to 2 ** address_width - 1) of std_logic_vector (word_width - 1 downto 0);
    signal regs : memory := (others => (others => '0'));
begin
    process (pi_clk, pi_rst)
    begin
        if pi_rst = '1' then
            regs <= (others => (others => '0'));
            po_data <= (others => '0');
        elsif rising_edge(pi_clk) then
            if pi_we = '1' then
                regs(to_integer(unsigned(pi_add))) <= pi_data;
            end if;
            po_data <= regs(to_integer(unsigned(pi_add)));
        end if;
    end process;
end architecture behaviour;