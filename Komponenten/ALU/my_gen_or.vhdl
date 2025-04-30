-- Laboratory GdTi solutions/versuch5
-- Winter Semester 24/25
-- Group Details
-- Lab Date: 11. Dezember 2024
-- 1. Participant First and  Last Name: Baran Sönmez
-- 2. Participant First and Last Name: Alexander Shorstkin
 
 
-- coding conventions
-- g_<name> Generics
-- p_<name> Ports
-- c_<name> Constants
-- s_<name> Signals
-- v_<name> Variables

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Constant_Package.ALL;

-- begin solution:
entity my_gen_or is
    generic (
        G_DATA_WIDTH : Integer := DATA_WIDTH_GEN
    );
    port (
        pi_op1 : in STD_LOGIC_VECTOR(G_DATA_WIDTH - 1 downto 0);
        pi_op2 : in STD_LOGIC_VECTOR(G_DATA_WIDTH - 1 downto 0);
        po_result : out STD_LOGIC_VECTOR(G_DATA_WIDTH - 1 downto 0)
    );
end my_gen_or;
architecture behavior of my_gen_or is
    begin
      po_result <= pi_op1 or pi_op2;
end architecture behavior;
-- end solution!!
