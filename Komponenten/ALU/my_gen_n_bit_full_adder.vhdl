-- Laboratory GdTi solutions/versuch7
-- Winter Semester 24/25
-- Group Details
-- Lab Date: 22. Januar 2025
-- 1. Participant First and  Last Name: Baran Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

library ieee;
use ieee.std_logic_1164.all;
use work.Constant_Package.all;

entity my_gen_n_bit_full_adder is
    generic (
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port (
        -- begin solution:
        pi_A, pi_B : in std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
        pi_CARRY_IN : in std_logic := '0';
        po_SUM : out std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
        po_CARRY_OUT : out std_logic := '0'
        -- end solution!!
    );
end my_gen_n_bit_full_adder;

-- structure
architecture structure of my_gen_n_bit_full_adder is
    -- begin solution:
    signal s_CARRY : std_logic_vector(G_DATA_WIDTH downto 0);
    signal s_B : std_logic_vector(G_DATA_WIDTH - 1 downto 0);
begin
    s_CARRY(0) <= pi_CARRY_IN;
    GEN : for i in 0 to G_DATA_WIDTH - 1 generate
        FA : entity work.my_full_adder(structure)
            port map(
                pi_A => pi_A(i),
                pi_B => s_B(i),
                pi_CARRY_IN => s_CARRY(i),
                po_SUM => po_SUM(i),
                po_CARRY_OUT => s_CARRY(i + 1)
            );
        s_B(i) <= s_CARRY(0) xor pi_B(i);
    end generate;
    po_CARRY_OUT <= s_CARRY(G_DATA_WIDTH);
    -- end solution!!
end structure;
