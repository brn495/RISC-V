-- Laboratory RA solutions/versuch3
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

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
        variable v_insFormat : t_instruction_type := nullFormat; -- Variable anlegen
    begin
        case pi_instruction(6 downto 0) is -- case um v_insFormat zu setzen
            when R_INS_OP =>
                v_insFormat := rFormat;
            when I_INS_OP =>
                v_insFormat := iFormat;
            when LUI_INS_OP | AUIPC_INS_OP =>
                v_insFormat := uFormat;
            when JAL_INS_OP =>
                v_insFormat := jFormat;
            when others =>
                v_insFormat := nullFormat;
        end case;

        case v_insFormat is -- case um output, controlWord zu bestimmen
            when rFormat =>
                po_controlWord.ALU_OP <= pi_instruction(30) & pi_instruction(14 downto 12);
                po_controlWord.I_IMM_SEL <= '0';
                po_controlWord.REG_WRITE <= '1';
            when iFormat =>
                po_controlWord.ALU_OP <= pi_instruction(30) & pi_instruction(14 downto 12);
                po_controlWord.I_IMM_SEL <= '1';
                po_controlWord.REG_WRITE <= '1';
            when uFormat =>
                case pi_instruction(6 downto 0) is
                    when LUI_INS_OP =>
                        po_controlWord.ALU_OP <= ADD_ALU_OP;
                        po_controlWord.I_IMM_SEL <= '1';
                        po_controlWord.WB_SEL <= "01";
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.A_SEL <= '0';
                        po_controlWord.PC_SEL <= '0';
                    when AUIPC_INS_OP =>
                        po_controlWord.ALU_OP <= ADD_ALU_OP;
                        po_controlWord.I_IMM_SEL <= '1';
                        po_controlWord.WB_SEL <= "00";
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.A_SEL <= '1';
                        po_controlWord.PC_SEL <= '0';
                    when others =>
                        po_controlWord <= control_word_init;
                end case;
            when jFormat =>
                po_controlWord.ALU_OP <= ADD_ALU_OP;
                po_controlWord.I_IMM_SEL <= '1';
                po_controlWord.WB_SEL <= "10";
                po_controlWord.REG_WRITE <= '1';
                po_controlWord.A_SEL <= '1';
                po_controlWord.PC_SEL <= '0';
            when others =>
                po_controlWord <= control_word_init;
        end case;
    end process;
    -- end solution!!
end architecture;