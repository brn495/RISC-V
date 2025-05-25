-- Laboratory RA solutions/versuch5
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: 
-- 2. Participant First and Last Name:

-- ========================================================================
-- Author:       Marcel Rieß
-- Last updated: 22.05.2024
-- Description:  RUI-Only-RISC-V for an incomplete RV32I implementation, 
--               support only R/I/U-Instructions. 
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types.all;

entity ri_only_RISC_V is
    port (
        pi_rst : in std_logic;
        pi_clk : in std_logic;
        pi_instruction : in memory := (others => (others => '0'));
        po_registersOut : out registerMemory := (others => (others => '0'))
    );
end entity ri_only_RISC_V;

architecture structure of ri_only_RISC_V is

    constant PERIOD : time := 10 ns;
    constant ADD_FOUR_TO_ADDRESS : std_logic_vector(WORD_WIDTH - 1 downto 0) := std_logic_vector(to_signed((4), WORD_WIDTH));
    -- signals
    -- begin solution:

    -- n_bit_full_adder signals
    signal s_carry_in_full_adder : std_logic := '0';
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

    signal d : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal t : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');

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
    signal s_writeRegData_registerfile_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
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
    signal s_mem_web_res_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_mem_web_res_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- signextension signals
    signal s_signextension_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signextensionI_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- id_ex_se signals
    signal s_id_ex_se_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_id_ex_se_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- mux signals
    signal s_datain_mux : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_sel_mux : std_logic := '0';
    signal s_dataout_mux : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

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
            pi_A => ADD_FOUR_TO_ADDRESS,
            pi_B => s_dataout_pc,
            pi_CARRY_IN => s_carry_in_full_adder,
            po_SUM => s_p_sum_out_full_adder,
            po_CARRY_OUT => open
        );

    PC : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_p_sum_out_full_adder,
            po_data => s_dataout_pc
        );

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
            pi_adr => s_dataout_pc,
            pi_clk => not pi_clk,
            pi_rst => open,
            pi_instructionCache => pi_instruction,
            po_instruction => s_instruction_out_pc
        );

    -- end solution!!

    ---********************************************************************
    ---* Pipeline-Register (IF -> ID) start
    ---********************************************************************

    -- begin solution:
    gen_register : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_instruction_out_pc,
            po_data => s_dataout_genreg
        );

    --    s_datain_gen_reg <= s_instruction_out_pc;
    -- end solution!!

    ---********************************************************************
    ---* decode phase
    ---********************************************************************
    -- begin solution:
    d <= s_dataout_genreg(11 downto 7);
    s <= s_dataout_genreg(19 downto 15);
    t <= s_dataout_genreg(24 downto 20);

    decoder : entity work.decoder
        generic map(
            word_width => WORD_WIDTH
        )
        port map(
            pi_instruction => s_dataout_genreg,
            po_controlWord => s_controlWordout_decoder
        );

    signExtension : entity work.signExtension
        generic map(
            word_width => WORD_WIDTH
        )
        port map(
            pi_instr => s_dataout_genreg,
            po_storeImm => open,
            po_immediateImm => s_signextensionI_out,
            po_unsignedImm => open,
            po_branchImm => open,
            po_jumpImm => open
        );
    -- s_instructionin_decoder <= s_dataout_genreg;
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
            pi_data1 => s_op1_registerfile_out,
            po_data => s_dataout_idExOp1
        );

    id_ex_op2 : entity work.PipelineRegister1
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_op2_registerfile_out,
            po_data => s_dataout_idExOp2
        );

    ControlWordRegister1 : entity work.ControlWordRegister
        port map(
            pi_rst => pi_rst,
            pi_clk => pi_clk,
            pi_controlWord => s_controlWordout_decoder,
            po_controlWord => s_controlWordout_controlWordRegister1
        );

    gen_reg1 : entity work.PipelineRegister1
        generic map(
            registerWidth => REG_ADR_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => d,
            po_data => s_dataout_genreg1
        );

    id_ex_se : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_signextensionI_out,
            po_data => s_id_ex_se_out
        );

    mux : entity work.gen_mux
        generic map(
            dataWidth => WORD_WIDTH
        )
        port map(
            pi_sel => s_controlWordout_controlWordRegister1.I_IMM_SEL,
            pi_first => s_dataout_idExOp2,
            pi_second => s_id_ex_se_out,
            po_res => s_dataout_mux
        );
    -- end solution!!

    ---********************************************************************
    ---* execute phase
    ---********************************************************************
    -- begin solution:
    ALU : entity work.my_alu
        generic map(WORD_WIDTH, ALU_OPCODE_WIDTH)
        port map(
            pi_OP1 => s_dataout_idExOp1,
            pi_OP2 => s_dataout_mux,
            pi_aluOp => s_controlWordout_controlWordRegister1.ALU_OP,
            po_aluOut => s_aluout,
            po_carryOut => open
        );

    -- end solution!!

    ---********************************************************************
    ---* Pipeline-Register (EX -> MEM) 
    ---********************************************************************
    -- begin solution:
    ControlWordRegister2 : entity work.ControlWordRegister
        port map(
            pi_rst => pi_rst,
            pi_clk => pi_clk,
            pi_controlWord => s_controlWordout_controlWordRegister1,
            po_controlWord => s_controlWordout_controlWordRegister2
        );

    gen_reg2 : entity work.PipelineRegister1
        generic map(
            registerWidth => REG_ADR_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_dataout_genreg1,
            po_data => s_dataout_genreg2
        );

    ex_mem_res : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_aluout,
            po_data => s_ex_mem_res_out
        );

    -- end solution!!

    ---********************************************************************
    ---* memory phase
    ---********************************************************************
    -- begin solution:
    -- end solution!!

    ---********************************************************************
    ---* Pipeline-Register (MEM -> WB) 
    ---********************************************************************
    -- begin solution:
    ControlWordRegister3 : entity work.ControlWordRegister
        port map(
            pi_rst => pi_rst,
            pi_clk => pi_clk,
            pi_controlWord => s_controlWordout_controlWordRegister2,
            po_controlWord => s_controlWordout_controlWordRegister3
        );

    gen_reg3 : entity work.PipelineRegister1
        generic map(
            registerWidth => REG_ADR_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_dataout_genreg2,
            po_data => s_dataout_genreg3
        );

    -- end solution!!

    ---********************************************************************
    ---* write back phase
    ---********************************************************************
    mem_wb_res : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_ex_mem_res_out,
            po_data => s_mem_web_res_out
        );
    ---********************************************************************
    ---* register file (negative clock)
    ---********************************************************************
    -- begin solution:
    register_file : entity work.register_file
        port map(
            pi_clk => not pi_clk,
            pi_rst => pi_rst,
            pi_writeEnable => s_controlWordout_controlWordRegister3.REG_WRITE,
            pi_readRegAddr1 => s,
            pi_readRegAddr2 => t,
            pi_writeRegAddr => s_dataout_genreg3,
            pi_writeRegData => s_mem_web_res_out,
            po_readRegData1 => s_op1_registerfile_out,
            po_readRegData2 => s_op2_registerfile_out,
            po_registerOut => po_registersOut
        );

    s_writeRegData_registerfile_in <= s_mem_web_res_out;
    -- end solution!!
end architecture;