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

entity my_full_adder is
    port (
        -- begin solution:
        pi_A, pi_B, pi_CARRY_IN  : in STD_LOGIC;
        po_SUM, po_CARRY_OUT    : out STD_LOGIC
        -- end solution!!
    );
end my_full_adder;

-- CARRY_OUT = Carry_in_1 XOR Carry_in_1
-- Siehe Halbaddierer für XOR

-- structure
architecture structure of my_full_adder is
-- begin solution:
signal s_SUM, s_CARRYA, s_CARRYB: STD_LOGIC := '0';
begin 
    Halfadder1: entity work.my_half_adder(dataflow)
        port map(
            pi_A => pi_A,
            pi_B => pi_B,
            po_SUM => s_SUM,
            po_CARRY_OUT => s_CARRYA
        );

    Halfadder2: entity work.my_half_adder(dataflow)
        port map(
            pi_A => s_SUM,
            pi_B => pi_CARRY_IN,
            po_SUM => po_SUM,
            po_CARRY_OUT => s_CARRYB
        );

    po_CARRY_OUT <= (s_CARRYA NAND s_CARRYA) NAND (s_CARRYB NAND s_CARRYB);
-- end solution!!
end structure;
