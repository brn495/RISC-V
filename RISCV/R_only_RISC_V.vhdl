-- Laboratory RA solutions/versuch4
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 14.05.2025
-- Description:  RUI-Only-RISC-V for an incomplete RV32I implementation, 
--               support only R/I/U-Instructions. 
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types.all;

entity r_only_RISC_V is
    port (
        pi_rst : in std_logic;
        pi_clk : in std_logic;
        pi_instruction : in memory := (others => (others => '0'));
        po_registersOut : out registerMemory := (others => (others => '0'))
    );
end entity r_only_RISC_V;

architecture structure of r_only_RISC_V is

    constant PERIOD : time := 10 ns;
    constant ADD_FOUR_TO_ADDRESS : std_logic_vector(WORD_WIDTH - 1 downto 0) := std_logic_vector(to_signed((4), WORD_WIDTH));
    -- signals
    -- begin solution:

    -- n_bit_full_adder signals
    signal s_carry_in_full_adder : std_logic := '0';
    signal s_a_in_full_adder : std_logic_vector(WORD_WIDTH - 1 downto 0) := x"00000004";
    signal s_b_in_full_adder : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_p_sum_out_full_adder : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- pc signals
    signal s_datain_pc : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_pc : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- instruction cache signals
    signal s_addrin_instruction_cache : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_instruction_out_pc : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- gen register signals
    signal s_datain_gen_reg : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_genreg : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- decoder signals
    signal s_instructionin_decoder : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_controlWordout_decoder : controlWord := control_word_init;

    -- control word register 1-3 signals
    signal s_controlWordin_controlWordRegister1 : controlWord := control_word_init;
    signal s_controlWordout_controlWordRegister1 : controlWord := control_word_init;

    signal s_controlWordin_controlWordRegister2 : controlWord := control_word_init;
    signal s_controlWordout_controlWordRegister2 : controlWord := control_word_init;

    signal s_controlWordin_controlWordRegister3 : controlWord := control_word_init;
    signal s_controlWordout_controlWordRegister3 : controlWord := control_word_init;

    -- gen_register 1-3 signals
    signal s_datain_gen_reg1 : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_genreg1 : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');

    signal s_datain_gen_reg2 : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_genreg2 : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');

    signal s_datain_gen_reg3 : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_genreg3 : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');

    -- register file signals
    signal s_writeEnable_registerfile_in : std_logic := '0';
    signal s_writeRegData_registerfile_in : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_readRegAddr1_registerfile_in : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_readRegAddr2_registerfile_in : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_writeRegAddr_registerfile_in : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_op1_registerfile_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_op2_registerfile_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- id_ex_op1/op2 signals
    signal s_datain_idExOp1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_idExOp1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_datain_idExOp2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_idExOp2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- my_alu signals
    signal s_op1in_alu : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_op2in_alu : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_aluOp : std_logic_vector(ALU_OPCODE_WIDTH - 1 downto 0) := (others => '0');
    signal s_aluout : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- ex_mem_res signals
    signal s_ex_mem_res_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_ex_mem_res_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- mem_web_res signals
    signal mem_web_res_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal mem_web_res_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- end solution!!
begin

    ---********************************************************************
    ---* program counter adder and pc-register
    ---********************************************************************
    -- begin solution:  
    n_bit_full_adder : entity work.my_gen_n_bit_full_adder
        generic map(
            G_DATA_WIDTH => WORD_WIDTH
        )
        port map(
            pi_A => s_a_in_full_adder,
            pi_B => s_b_in_full_adder,
            pi_CARRY_IN => s_carry_in_full_adder,
            po_SUM => s_p_sum_out_full_adder,
            po_CARRY_OUT => open
        );

    PipelineRegister1_inst : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_datain_pc,
            po_data => s_dataout_pc
        );

    s_b_in_full_adder <= s_dataout_pc;
    s_datain_pc <= s_p_sum_out_full_adder;

    -- end solution!!

    ---********************************************************************
    ---* instruction fetch 
    ---********************************************************************
    -- begin solution:  
    instruction_cache_inst : entity work.instruction_cache
        generic map(
            adr_width => WORD_WIDTH
        )
        port map(
            pi_adr => s_addrin_instruction_cache,
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_instructionCache => pi_instruction,
            po_instruction => s_instruction_out_pc
        );
    -- end solution!!

    ---********************************************************************
    ---* Pipeline-Register (IF -> ID) start
    ---********************************************************************

    -- begin solution:
    -- end solution!!

    ---********************************************************************
    ---* decode phase
    ---********************************************************************
    -- begin solution:
    -- end solution!!

    ---********************************************************************
    ---* Pipeline-Register (ID -> EX) 
    ---********************************************************************
    -- begin solution: 
    id_ex_op1 : entity work.PipelineRegister1
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_datain_idExOp1,
            po_data => s_dataout_idExOp1
        );

    id_ex_op2 : entity work.PipelineRegister1
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_datain_idExOp2,
            po_data => s_dataout_idExOp2
        );
    -- end solution!!

    ---********************************************************************
    ---* execute phase
    ---********************************************************************
    -- begin solution:
    ALU : entity work.my_alu
        generic map(WORD_WIDTH, ALU_OPCODE_WIDTH)
        port map(
            pi_OP1 => s_op1in_alu,
            pi_OP2 => s_op2in_alu,
            pi_aluOp => s_aluOp,
            po_aluOut => s_aluout,
            po_carryOut => open
        );
    -- end solution!!

    ---********************************************************************
    ---* Pipeline-Register (EX -> MEM) 
    ---********************************************************************
    -- begin solution:
    -- end solution!!

    ---********************************************************************
    ---* memory phase
    ---********************************************************************

    ---********************************************************************
    ---* Pipeline-Register (MEM -> WB) 
    ---********************************************************************
    -- begin solution:
    -- end solution!!

    ---********************************************************************
    ---* write back phase
    ---********************************************************************

    ---********************************************************************
    ---* register file (negative clock)
    ---********************************************************************
    -- begin solution:
    register_file : entity work.register_file
        port map(
            pi_clk => not pi_clk,
            pi_rst => pi_rst,
            pi_writeEnable => s_writeEnable_registerfile_in,
            pi_readRegAddr1 => s_readRegAddr1_registerfile_in,
            pi_readRegAddr2 => s_readRegAddr2_registerfile_in,
            pi_writeRegAddr => s_writeRegAddr_registerfile_in,
            pi_writeRegData => s_writeRegData_registerfile_in,
            po_readRegData1 => s_datain_op1,
            po_readRegData2 => s_datain_op2
        );
    -- end solution!!
    ---********************************************************************
    ---********************************************************************

end architecture;