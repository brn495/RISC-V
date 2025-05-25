-- Laboratory RA solutions/versuch2
-- Sommersemester 25
-- Group Details
-- Lab Date: 06.05.2005
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constant_package.all;
use work.types.all;

entity register_file is
    generic (
        word_width : integer := WORD_WIDTH;
        adr_width : integer := REG_ADR_WIDTH;
        reg_amount : integer := 2 ** REG_ADR_WIDTH
    );
    port (
        pi_clk, pi_rst, pi_writeEnable : in std_logic := '0';
        pi_readRegAddr1 : in std_logic_vector(adr_width - 1 downto 0) := (others => '0');
        pi_readRegAddr2 : in std_logic_vector(adr_width - 1 downto 0) := (others => '0');
        pi_writeRegAddr : in std_logic_vector(adr_width - 1 downto 0) := (others => '0');
        pi_writeRegData : in std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_readRegData1 : out std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_readRegData2 : out std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_registerOut : out registerMemory := (others => (others => '0'))
    );
end entity register_file;

architecture behavior of register_file is

    -- type registermemory is array (0 to reg_amount - 1) of std_logic_vector(word_width - 1 downto 0);
    signal reg_array : registerMemory := (
        1 => std_logic_vector(to_unsigned(9, WORD_WIDTH)), -- x1 = 9
        2 => std_logic_vector(to_unsigned(8, WORD_WIDTH)), -- x2 = 8
        others => (others => '0'));
    signal s_read1, s_read2 : std_logic_vector(word_width - 1 downto 0) := (others => '0');

begin
    process (pi_clk, pi_rst) -- Registerfile implementiert
    begin
        if pi_rst = '1' then -- Reset
            reg_array <= (others => (others => '0'));
        elsif rising_edge(pi_clk) then -- Output
            if pi_writeEnable = '1' and to_integer(unsigned(pi_writeRegAddr)) /= 0 then -- Writing
                reg_array(to_integer(unsigned(pi_writeRegAddr))) <= pi_writeRegData;
            end if;
            s_read1 <= reg_array(to_integer(unsigned(pi_readRegAddr1)));
            s_read2 <= reg_array(to_integer(unsigned(pi_readRegAddr2)));
        end if;
    end process;
    po_readRegData1 <= s_read1;
    po_readRegData2 <= s_read2;
    po_registerOut <= reg_array;
end architecture behavior;