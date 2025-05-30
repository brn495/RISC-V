-- Laboratory GdTi solutions/versuch5
-- Winter Semester 24/25
-- Group Details
-- Lab Date: 11. Dezember 2024
-- 1. Participant First and  Last Name: Baran Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.Constant_Package.all;

-- begin solution:
entity my_gen_and is
    generic (
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port (
        pi_op1 : in std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
        pi_op2 : in std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
        po_result : out std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0')
    );
end my_gen_and;
architecture behavior of my_gen_and is
begin
    po_result <= pi_op1 and pi_op2;
end architecture behavior;
-- end solution!!
