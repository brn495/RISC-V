-- Laboratory RA solutions/versuch4
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 14.05.2025
-- Description:  R-Only-RISC-V foran incomplete RV32I implementation, support
--               only R-Instructions. 
--
-- ========================================================================

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;	
  use work.constant_package.all;
  use work.types.all;
  use work.util_asm_package.all;
  
entity R_only_RISC_V_2_tb is
end entity R_only_RISC_V_2_tb;

architecture structure of R_only_RISC_V_2_tb is

  constant PERIOD                : time                                           := 10 ns;
  -- signals
  signal s_rst : std_logic := '0';
  signal s_clk : std_logic := '0';
    -- begin solution:
    signal s_registersOut    : registerMemory := (others => (others => '0'));
    signal s_instruction : memory                                     := (
    -- begin solution:
    1 => Asm2Std("ADD", 2, 2, 1),
    5 => Asm2Std("ADD", 2, 2, 1),
    9 => Asm2Std("ADD", 2, 2, 1),
    13 => Asm2Std("ADD", 2, 2, 1),
    17 => Asm2Std("ADD", 2, 2, 1),
    others => (others => '0')
  -- end solution!!
                                  );

begin
-- Instanziierung der Entity
riscv_inst : entity work.R_only_RISC_V
  port map (
    pi_rst             => s_rst,
    pi_clk             => s_clk,
    pi_instruction     => s_instruction,
    po_registersOut    => s_registersOut
  );

  process is


  begin
   wait for PERIOD/2;
   for i in 1 to 21 loop
      s_clk <= '1';
      wait for PERIOD / 2;
      s_clk <= '0';
      wait for PERIOD / 2;

    -- begin solution:
    -- Kontrolle
    if (i = 1) then -- after 5 clock clock cycles
        assert (to_integer(signed(s_registersOut(1))) = 9)
         report "Reg 1 test failed. Register 1 contains " & integer'image(to_integer(signed(s_registersOut(1)))) & " but should contain " & integer'image(9) & " in first cycle"
          severity error;
          
        assert (to_integer(signed(s_registersOut(2))) = 8)
         report "Reg 2 test failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(8) & " in first cycle"
          severity error;
     end if;
     
     -- Erste Addition
    if (i = 5) then -- after 6 clock clock cycles
        assert (to_integer(signed(s_registersOut(2))) = 17)
         report "Add 1 failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(17) & " in first cycle"
          severity error;
    end if;
    
    if (i = 9) then -- after 6 clock clock cycles
        assert (to_integer(signed(s_registersOut(2))) = 26)
         report "Add 2 failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(26) & " in first cycle"
          severity error;
    end if;
    
    if (i = 13) then -- after 6 clock clock cycles
        assert (to_integer(signed(s_registersOut(2))) = 35)
         report "Add 3 failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(35) & " in first cycle"
          severity error;
    end if;
    
    if (i = 17) then -- after 6 clock clock cycles
        assert (to_integer(signed(s_registersOut(2))) = 44)
         report "Add 4 failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(44) & " in first cycle"
          severity error;
    end if;
    
    if (i = 21) then -- after 6 clock clock cycles
        assert (to_integer(signed(s_registersOut(2))) = 53)
         report "Add 5 failed. Register 2 contains " & integer'image(to_integer(signed(s_registersOut(2)))) & " but should contain " & integer'image(53) & " in first cycle"
          severity error;
    end if;
-- end solution!!

    end loop;
    report "End of test!!!";
wait;

  end process;

end architecture;
