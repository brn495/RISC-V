-- Laboratory RA solutions/versuch5
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Baran Sönmez
-- 2. Participant First and Last Name: Mashal Khan

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

entity riu_only_RISC_V is
    port (
        pi_rst : in std_logic;
        pi_clk : in std_logic;
        pi_instruction : in memory := (others => (others => '0'));
        po_registersOut : out registerMemory := (others => (others => '0'))
    );
end entity riu_only_RISC_V;

architecture structure of riu_only_RISC_V is

    constant PERIOD : time := 10 ns;
    constant ADD_FOUR_TO_ADDRESS : std_logic_vector(WORD_WIDTH - 1 downto 0) := std_logic_vector(to_signed((4), WORD_WIDTH));
    -- signals
    -- begin solution:

    -- n_bit_full_adder signals
    signal s_carry_in_full_adder : std_logic := '0';
    signal s_p_sum_out_full_adder : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- n_bit_full_adder_plus4 signals
    signal s_p_sum_out_full_adder_plus4 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- pipeline reg für pc_plus4 bis wb
    signal s_dataout_mem_pc_plus4 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_wb_pc_plus4 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    -- pc signals
    signal s_datain_pc : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_pc : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- instruction cache signals
    signal s_addrin_instruction_cache : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_instruction_out_instruction_cache : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

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

    -- gen_register_pc 1-2 signals
    signal s_datain_gen_reg_pc1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_gen_reg_pc1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    signal s_datain_gen_reg_pc2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout_gen_reg_pc2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

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

    -- ex_mem_Immidiant signals
    signal s_ex_mem_Immidiant_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_ex_mem_Immidiant_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- mem_web_res signals
    signal s_mem_web_res_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_mem_web_res_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- mem_web_Immidiant signals
    signal s_mem_web_Immidiant_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_mem_web_Immidiant_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- signextension signals
    signal s_signextension_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signextension_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signextensionI_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signextensionU_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signextensionJ_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    -- id_ex_se signals
    signal s_id_ex_se_in : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_id_ex_se_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- mux signals
    signal s_dataout_mux : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- mux_pc signals
    signal s_dataout_mux_pc : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- mux_wb signals
    signal s_dataout_mux_wb : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- mux_pc_plus4 signals
    signal s_dataout_mux_pc_plus4 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

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
            pi_data1 => s_dataout_mux_pc_plus4,
            po_data => s_dataout_pc
        );

    gen_mux_pc_plus4 : entity work.gen_mux
        generic map(
            dataWidth => WORD_WIDTH
        )
        port map(
            pi_sel => s_controlWordout_controlWordRegister2.PC_SEL,
            pi_first => s_p_sum_out_full_adder,
            pi_second => s_ex_mem_res_out,
            po_res => s_dataout_mux_pc_plus4
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
            po_instruction => s_instruction_out_instruction_cache
        );

    gen_reg_pc1 : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_dataout_pc,
            po_data => s_dataout_gen_reg_pc1
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
            pi_data1 => s_instruction_out_instruction_cache,
            po_data => s_dataout_genreg
        );

    gen_reg_pc2 : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_dataout_gen_reg_pc1,
            po_data => s_dataout_gen_reg_pc2
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
            po_unsignedImm => s_signextensionU_out,
            po_branchImm => open,
            po_jumpImm => s_signextensionJ_out
        );

    with s_dataout_genreg(6 downto 0) select
    s_signextension_out <=
                          s_signextensionU_out when LUI_INS_OP | AUIPC_INS_OP,
                          s_signextensionI_out when I_INS_OP,
                          s_signextensionJ_out when JAL_INS_OP,
                          x"00000000" when others;
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
            pi_data1 => s_signextension_out,
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

    mux_pc : entity work.gen_mux
        generic map(
            dataWidth => WORD_WIDTH
        )
        port map(
            pi_sel => s_controlWordout_controlWordRegister1.A_SEL,
            pi_first => s_dataout_idExOp1,
            pi_second => s_dataout_gen_reg_pc2,
            po_res => s_dataout_mux_pc
        );
    -- end solution!!

    ---********************************************************************
    ---* execute phase
    ---********************************************************************
    -- begin solution:
    ALU : entity work.my_alu
        generic map(WORD_WIDTH, ALU_OPCODE_WIDTH)
        port map(
            pi_OP1 => s_dataout_mux_pc,
            pi_OP2 => s_dataout_mux,
            pi_aluOp => s_controlWordout_controlWordRegister1.ALU_OP,
            po_aluOut => s_aluout,
            po_carryOut => open
        );

    n_bit_full_adder_plus4 : entity work.my_gen_n_bit_full_adder
        generic map(
            G_DATA_WIDTH => WORD_WIDTH
        )
        port map(
            pi_A => ADD_FOUR_TO_ADDRESS,
            pi_B => s_dataout_gen_reg_pc2,
            pi_CARRY_IN => s_carry_in_full_adder,
            po_SUM => s_p_sum_out_full_adder_plus4,
            po_CARRY_OUT => open
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

    ex_mem_Immidiant : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_id_ex_se_out,
            po_data => s_ex_mem_Immidiant_out
        );

    pc_plus4_mem : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_p_sum_out_full_adder_plus4,
            po_data => s_dataout_mem_pc_plus4
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

    pc_plus4_wb : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_dataout_mem_pc_plus4,
            po_data => s_dataout_wb_pc_plus4
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

    mem_wb_Immidiant : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_ex_mem_Immidiant_out,
            po_data => s_mem_web_Immidiant_out
        );

    gen_mux4to1_inst : entity work.gen_mux4to1
        generic map(
            dataWidth => WORD_WIDTH
        )
        port map(
            pi_sel => s_controlWordout_controlWordRegister3.WB_SEL,
            pi_first => s_mem_web_res_out,
            pi_second => s_mem_web_Immidiant_out,
            pi_third => s_dataout_wb_pc_plus4,
            pi_fourth => open,
            po_res => s_dataout_mux_wb
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
            pi_writeRegData => s_dataout_mux_wb,
            po_readRegData1 => s_op1_registerfile_out,
            po_readRegData2 => s_op2_registerfile_out,
            po_registerOut => po_registersOut
        );

    s_writeRegData_registerfile_in <= s_mem_web_res_out;
    -- end solution!!
end architecture;