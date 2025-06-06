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
        po_controlWord <= control_word_init;
        case pi_instruction(6 downto 0) is -- case um v_insFormat zu setzen
            when R_INS_OP =>
                v_insFormat := rFormat;
            when I_INS_OP | JALR_INS_OP =>
                v_insFormat := iFormat;
            when LUI_INS_OP | AUIPC_INS_OP | JAL_INS_OP =>
                v_insFormat := uFormat;
            when B_INS_OP =>
                v_insFormat := bFormat;
            when others =>
                v_insFormat := nullFormat;
        end case;

        case v_insFormat is -- case um output, controlWord zu bestimmen
            when rFormat =>
                po_controlWord.IS_BRANCH <= '0';

                po_controlWord.ALU_OP <= pi_instruction(30) & pi_instruction(14 downto 12);
                po_controlWord.I_IMM_SEL <= '0';
                po_controlWord.REG_WRITE <= '1';
            when iFormat =>
                po_controlWord.IS_BRANCH <= '0';

                case pi_instruction(6 downto 0) is
                    when JALR_INS_OP =>
                        po_controlWord.ALU_OP <= ADD_ALU_OP;
                        po_controlWord.I_IMM_SEL <= '1';
                        po_controlWord.WB_SEL <= "10";
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.A_SEL <= '0';
                        po_controlWord.PC_SEL <= '1';
                    when others =>
                        po_controlWord.ALU_OP <= pi_instruction(30) & pi_instruction(14 downto 12);
                        po_controlWord.I_IMM_SEL <= '1';
                        po_controlWord.REG_WRITE <= '1';
                end case;
            when uFormat =>
                po_controlWord.IS_BRANCH <= '0';
                
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
                    when JAL_INS_OP =>
                        po_controlWord.ALU_OP <= ADD_ALU_OP;
                        po_controlWord.I_IMM_SEL <= '1';
                        po_controlWord.WB_SEL <= "10";
                        po_controlWord.REG_WRITE <= '1';
                        po_controlWord.A_SEL <= '1';
                        po_controlWord.PC_SEL <= '1';
                    when others =>
                        po_controlWord <= control_word_init;
                end case;
            when bFormat =>
                -- B-Format (BEQ, BNE, BLT, BGE, BLTU, BGEU)
                -- Zunächst: IS_BRANCH aktivieren, damit im EX/MEM-Stage B_SEL berechnet wird
                po_controlWord.IS_BRANCH <= '1';

                case pi_instruction(14 downto 12) is

                    when FUNC3_BEQ =>
                        -- BEQ: Branch, falls rs1 == rs2 → ALU_OP = EQ_ALU_OP, CMP_RESULT= '0'
                        po_controlWord.ALU_OP       <= SUB_ALU_OP;
                        po_controlWord.CMP_RESULT   <= '0';   

                    when FUNC3_BNE =>
                        -- BNE: Branch, falls rs1 /= rs2 → ALU_OP = EQ_ALU_OP, CMP_RESULT= '1'
                        po_controlWord.ALU_OP       <= SUB_ALU_OP;
                        po_controlWord.CMP_RESULT   <= '1';

                    when FUNC3_BLT =>
                        -- BLT: Branch, falls rs1 < rs2 (signed) → ALU_OP = SLT_ALU_OP, CMP_RESULT = '1'
                        po_controlWord.ALU_OP       <= SLT_ALU_OP;
                        po_controlWord.CMP_RESULT   <= '1';

                    when FUNC3_BGE =>
                        -- BGE: Branch, falls rs1 >= rs2 (signed) → ALU_OP = SLT_ALU_OP, CMP_RESULT = '0'
                        po_controlWord.ALU_OP       <= SLT_ALU_OP;
                        po_controlWord.CMP_RESULT   <= '0';

                    when FUNC3_BLTU =>
                        -- BLTU: Branch, falls rs1 < rs2 (unsigned) → ALU_OP = SLTU_ALU_OP, CMP_RESULT = '1'
                        po_controlWord.ALU_OP       <= SLTU_ALU_OP;
                        po_controlWord.CMP_RESULT   <= '1';

                    when FUNC3_BGEU =>
                        -- BGEU: Branch, falls rs1 >= rs2 (unsigned) → ALU_OP = SLTU_ALU_OP, CMP_RESULT = '0'
                        po_controlWord.ALU_OP       <= SLTU_ALU_OP;
                        po_controlWord.CMP_RESULT   <= '0';

                    when others =>
                        -- Unbekanntes B-Funkt3, kein Branch
                        po_controlWord.IS_BRANCH <= '0';
                end case;
            when others => 
                po_controlWord <= control_word_init;
        end case;
    end process;
    -- end solution!!
end architecture;