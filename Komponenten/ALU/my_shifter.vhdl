-- Laboratory GdTi solutions/versuch8
-- Winter Semester 24/25
-- Group Details
-- Lab Date: 29. Januar 2025
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
use IEEE.NUMERIC_STD.all;
use IEEE.MATH_REAL.all;
use work.CONSTANT_Package.all;

entity my_shifter is
    generic (
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN
    );
    port (
        -- begin solution:
        pi_OP1, pi_OP2 : in std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
        pi_SHIFT_TYPE, pi_SHIFT_DIR : in std_logic := '0';
        po_RES : out std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0')
        -- end solution!!
    );
end entity;

--architecture behavior of my_shifter is
--    --signal s_shamtInt : integer range 0 to (2 ** (integer(log2(real(G_DATA_WIDTH))))) := 0;
--    signal s_tmp_val : std_logic := '0';
--begin
--    --s_shamtInt <= to_integer(unsigned(pi_OP2(integer(log2(real(G_DATA_WIDTH))) - 1 downto 0)));
--    -- begin solution:
--    process (pi_OP1, pi_OP2, pi_SHIFT_TYPE, pi_SHIFT_DIR)
--    begin
--        if pi_SHIFT_TYPE = '0' then
--            if pi_SHIFT_DIR = '0' then
--                po_RES <= std_logic_vector(SHIFT_LEFT(unsigned(pi_OP1), to_integer(unsigned(pi_OP2))));
--            else
--                po_RES <= std_logic_vector(SHIFT_RIGHT(unsigned(pi_OP1), to_integer(unsigned(pi_OP2))));
--            end if;
--        else
--            if pi_SHIFT_DIR = '0' then
--                po_RES <= std_logic_vector(SHIFT_LEFT(signed(pi_OP1), to_integer(unsigned(pi_OP2))));
--            else
--                po_RES <= std_logic_vector(SHIFT_RIGHT(signed(pi_OP1), to_integer(unsigned(pi_OP2))));
--            end if;
--        end if;
--    end process;
--    -- end solution!!
--end architecture behavior;

architecture behavior of my_shifter is
begin
    process (pi_OP1, pi_OP2, pi_SHIFT_TYPE, pi_SHIFT_DIR)
        variable v_shamtInt : integer range 0 to G_DATA_WIDTH - 1;
    begin
        v_shamtInt := to_integer(unsigned(pi_OP2(integer(log2(real(G_DATA_WIDTH))) - 1 downto 0)));

        if pi_SHIFT_TYPE = '0' then
            if pi_SHIFT_DIR = '0' then
                po_RES <= std_logic_vector(SHIFT_LEFT(unsigned(pi_OP1), v_shamtInt));
            else
                po_RES <= std_logic_vector(SHIFT_RIGHT(unsigned(pi_OP1), v_shamtInt));
            end if;
        else
            if pi_SHIFT_DIR = '0' then
                po_RES <= std_logic_vector(SHIFT_LEFT(signed(pi_OP1), v_shamtInt));
            else
                po_RES <= std_logic_vector(SHIFT_RIGHT(signed(pi_OP1), v_shamtInt));
            end if;
        end if;
    end process;
end architecture behavior;
