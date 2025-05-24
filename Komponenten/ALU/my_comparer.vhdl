-- Laboratory GdTi solutions/versuch8
-- Winter Semester 24/25
-- Group Details
-- Lab Date: 29. Januar 2025
-- 1. Participant First and  Last Name: Baran Sönmez
-- 2. Participant First and Last Name: Alexander Shorstkin

-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use work.CONSTANT_Package.all;

entity my_comparer is
    generic (
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port (
        -- begin solution:
        pi_OP1, pi_OP2 : in std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
        pi_signed : in std_logic := '0';
        po_comparer : out std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0')
        -- end solution!!
    );
end entity;

architecture behavior of my_comparer is
begin -- begin solution:
    process (pi_OP1, pi_OP2, pi_signed)
    begin
        if pi_signed = '1' then
            if (to_integer(signed(pi_OP1)) < to_integer(signed(pi_OP2))) then
                po_comparer <= std_logic_vector(to_unsigned(1, G_DATA_WIDTH));
            else
                po_comparer <= std_logic_vector(to_unsigned(0, G_DATA_WIDTH));
            end if;
        else
            if to_integer(unsigned(pi_OP1)) < to_integer(unsigned(pi_OP2)) then
                po_comparer <= std_logic_vector(to_unsigned(1, G_DATA_WIDTH));
            else
                po_comparer <= std_logic_vector(to_unsigned(0, G_DATA_WIDTH));
            end if;
        end if;
    end process;
    -- end solution!!
end architecture behavior;