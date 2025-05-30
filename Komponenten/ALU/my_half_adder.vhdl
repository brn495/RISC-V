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

entity my_half_adder is
  port (
    pi_A, pi_B           : in  STD_LOGIC:='0';
    po_SUM, po_CARRY_OUT : out STD_LOGIC:='0'
  );
end my_half_adder;

	--Notieren Sie ihre Umformungsschritte unter diesem Kommentar:
  
	-- begin solution:                 
    -- SUM = A XOR B = (-A * B) + (A * -B) = -(-((-A * B) + (A * -B))) = -(-(-A * B) * -(A * -B))
    -- = ((A NAND A) NAND B) NAND (A NAND (B NAND B))
    
    -- CARRY = A AND B = -(-(A AND B)) = -(A NAND B) = (A NAND B) NAND (A NAND B)
	-- end solution!!	

-- dataflow
architecture dataflow of my_half_adder is
signal s_temp : std_logic;
begin
-- begin solution:
        po_SUM <= ((pi_A NAND pi_A) NAND pi_B) NAND (pi_A NAND (pi_B NAND pi_B));
        po_CARRY_OUT <= (pi_A NAND pi_B) NAND (pi_A NAND pi_B);
-- end solution!!
end dataflow;
