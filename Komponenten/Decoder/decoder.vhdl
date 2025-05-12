-- Laboratory RA solutions/versuch3
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Constant_package.all;
use work.types.all;

entity decoder is
    -- begin solution:
    generic (
        word_width : integer := WORD_WIDTH
    );
    port (
        pi_instruction : in std_logic_vector(word_width - 1 downto 0) := (others => '0');
        po_controlWord : out controlWord := control_word_init
    );
    -- end solution!!
end entity decoder;
architecture arc of decoder is
    -- begin solution:
begin
    process (pi_instruction)
        variable v_insFormat : t_instruction_type := nullFormat;
    begin
        case pi_instruction(6 downto 0) is
            when R_INS_OP =>
                v_insFormat := rFormat;
            when others =>
                v_insFormat := nullFormat;
        end case;

        case v_insFormat is
            when rFormat =>
                po_controlWord.ALU_OP <= pi_instruction(30) & pi_instruction(14 downto 12);
                po_controlWord.I_IMM_SEL <= '0';
                po_controlWord.REG_WRITE <= '1';
            when others =>
                po_controlWord.ALU_OP <= (others => '0');
                po_controlWord.I_IMM_SEL <= '0';
                po_controlWord.REG_WRITE <= '0';
        end case;
    end process;
    -- end solution!!
end architecture;