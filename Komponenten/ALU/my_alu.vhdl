-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date: 29. April
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- ========================================================================
-- Author:       Baran Ali Sönmez/Mashal Khan
-- Last updated: 29.04.2025
-- Description:  Code for ALU
-- ========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.Constant_Package.all;

entity my_alu is
    generic (
        G_DATA_WIDTH : integer := DATA_WIDTH_GEN;
        G_OP_WIDTH : integer := OPCODE_WIDTH
    );
    port (
        -- begin solution:
        pi_OP1, pi_OP2 : in std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
        pi_aluOp : in std_logic_vector(G_OP_WIDTH - 1 downto 0) := (others => '0');
        po_aluOut : out std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
        po_carryOut : out std_logic := '0';
        po_zero : out std_logic := '0'
        -- end solution!!
    );

end entity my_alu;

architecture behavior of my_alu is
    signal s_res1, s_res2, s_res3, s_res4, s_res5, s_res6, s_res7, s_res8, s_slt, s_sltu : std_logic_vector(G_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal s_cIn, s_cOut, s_shiftType, s_shiftDirection : std_logic := '0';

begin
    XOR1 : entity work.my_gen_xor generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2, s_res1);
    OR1 : entity work.my_gen_or generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2, s_res2);
    AND1 : entity work.my_gen_and generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2, s_res3);
    Shift : entity work.my_shifter generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2, s_shiftType, s_shiftDirection, s_res4);
    ADD1 : entity work.my_gen_n_bit_full_adder generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2, s_cIn, s_res5, s_cOut);
    --COMP : entity work.my_comparer generic map (G_DATA_WIDTH) port map (pi_op1, pi_op2, s_signed, s_outputVergleich);

    -- begin solution:
    s_shiftType <= pi_aluOp(G_OP_WIDTH - 1);
    s_cIn <= pi_aluOp(G_OP_WIDTH - 1);
    s_slt <= std_logic_vector(to_unsigned(1, G_DATA_WIDTH)) when signed(pi_op1) < signed(pi_op2)
             else
             (others => '0');
    s_sltu <= std_logic_vector(to_unsigned(1, G_DATA_WIDTH)) when unsigned(pi_op1) < unsigned(pi_op2)
              else
              (others => '0');
    with pi_aluOp select
        s_shiftDirection <= '1' when SRA_ALU_OP | SRL_ALU_OP,
        '0' when others;

    with pi_aluOp select
        po_aluOut <= s_res1 when XOR_ALU_OP,
        s_res2 when OR_ALU_OP,
        s_res3 when AND_ALU_OP,
        s_res4 when SRL_ALU_OP | SRA_ALU_OP | SLL_ALU_OP,
        s_res5 when ADD_ALU_OP | SUB_ALU_OP,
        s_slt when SLT_ALU_OP | SLTI_ALU_OP,
        s_sltu when SLTU_ALU_OP | SLTIU_ALU_OP,
        (others => '0') when others;

    with po_aluOut select
        po_zero <= '1' when x"00000000",
        '0' when others;
    po_carryOut <= s_cOut;
    -- end solution!!
end architecture behavior;
