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

entity riub_only_RISC_V is
    port (
        pi_rst : in std_logic;
        pi_clk : in std_logic;
        pi_instruction : in memory := (others => (others => '0'));
        po_registersOut : out registerMemory := (others => (others => '0'))
    );
end entity riub_only_RISC_V;

architecture structure of riub_only_RISC_V is

    constant PERIOD : time := 10 ns;
    constant ADD_FOUR_TO_ADDRESS : std_logic_vector(WORD_WIDTH - 1 downto 0) := std_logic_vector(to_signed((4), WORD_WIDTH));
    -- signals
    -- begin solution:

    -- n_bit_full_adder 
    signal s_sum_pc : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- n_bit_full_adder_plus4 
    signal s_sum_pc_plus4 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- branch adder
    signal s_sum_branch_adder : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- branch adder register EX -> MEM
    signal s_branchAdder_EX_MEM : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- PC Register
    signal s_pc_register : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    --  PC Register to fullAdder for PC+4 IF->EX
    signal s_pc_to_pcPlus4_registerIF_ID : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pc_to_pcPlus4_registerID_EX : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- pipeline reg für pc_plus4 bis wb
    signal s_pc_plus4_EX_MEM : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_pc_plus4_MEM_WB : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- instruction cache signals
    signal s_instruction_cache : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- gen register signals
    signal s_instructionCacheRegisterIF_ID : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    ---------------------decoder----------------------
    signal s_decoder : controlWord := control_word_init;

    signal d : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0'); -- Write Address
    signal s : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0'); -- Read Address 1
    signal t : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0'); -- Read Address 2

    --------control word register für ID -> WB--------
    signal s_controlWordRegisterID_EX : controlWord := control_word_init;
    signal s_controlWordRegisterEX_MEM : controlWord := control_word_init;
    signal s_controlWordRegisterMEM_WB : controlWord := control_word_init;

    -- PipelineRegister for Address ID -> WB
    signal s_dAddr_ID_EX : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_dAddr_EX_MEM : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_dAddr_MEM_WB : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');

    -- register file signals
    signal s_op1_registerfile_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_op2_registerfile_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- id_ex_op1/op2 of ALU(Input Register)
    signal s_idExOp1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_idExOp2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- my_alu
    signal s_alu : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_alu_zero : std_logic := '0';

    -- ALU Output Register EX -> WB
    signal s_ex_mem_res : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_mem_wb_res : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- Immidiant Pipeline Register ID -> WB
    signal s_id_ex_Immediat : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_ex_mem_Immediat : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_mem_wb_Immediat : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- signextension signals
    signal s_signextension_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signextensionI_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signextensionU_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signextensionJ_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_signextensionB_out : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- Immediat Select Mux
    signal s_immidatSel_mux : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- A Select Mux
    signal s_aSel_mux : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- Write Back Mux
    signal s_wbSelect_mux : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- Program Counter Mux
    signal s_pcSel_mux : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- B Select Mux
    signal s_select_for_branch : std_logic := '0';
    signal s_select_for_branchEX_MEM : std_logic := '0';
    signal s_bSel_mux : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- Flush (einfach B_SEL und den Reset mir OR verküpfen)
    signal s_flush : std_logic := '0';
    -- end solution!!
begin

    ---********************************************************************
    ---* program counter adder and pc-register
    ---********************************************************************
    -- begin solution:  
    PC : entity work.my_gen_n_bit_full_adder
        generic map(
            G_DATA_WIDTH => WORD_WIDTH
        )
        port map(
            pi_A => ADD_FOUR_TO_ADDRESS,
            pi_B => s_pc_register,
            pi_CARRY_IN => '0',
            po_SUM => s_sum_pc,
            po_CARRY_OUT => open
        );

    PC_register : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_pcSel_mux,
            po_data => s_pc_register
        );

    gen_mux_pc_plus4 : entity work.gen_mux
        generic map(
            dataWidth => WORD_WIDTH
        )
        port map(
            pi_sel => s_controlWordRegisterEX_MEM.PC_SEL,
            pi_first => s_bSel_mux,
            pi_second => s_ex_mem_res,
            po_res => s_pcSel_mux
        );

    gen_mux_pc_branchAddress : entity work.gen_mux
        generic map(
            dataWidth => WORD_WIDTH
        )
        port map(
            pi_sel => s_select_for_branchEX_MEM,
            pi_first => s_sum_pc,
            pi_second => s_branchAdder_EX_MEM,
            po_res => s_bSel_mux
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
            pi_adr => s_pc_register,
            pi_clk => not pi_clk,
            pi_rst => open,
            pi_instructionCache => pi_instruction,
            po_instruction => s_instruction_cache
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
            pi_rst => pi_rst or s_select_for_branchEX_MEM or s_controlWordRegisterEX_MEM.PC_SEL,
            pi_data1 => s_instruction_cache,
            po_data => s_instructionCacheRegisterIF_ID
        );

    PC_to_PC_plus4_IF_ID : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst or s_select_for_branchEX_MEM or s_controlWordRegisterEX_MEM.PC_SEL,
            pi_data1 => s_pc_register,
            po_data => s_pc_to_pcPlus4_registerIF_ID
        );

    --    s_datain_gen_reg <= s_instruction_out_pc;
    -- end solution!!

    ---********************************************************************
    ---* decode phase
    ---********************************************************************
    -- begin solution:
    d <= s_instructionCacheRegisterIF_ID(11 downto 7);
    s <= s_instructionCacheRegisterIF_ID(19 downto 15);
    t <= s_instructionCacheRegisterIF_ID(24 downto 20);

    decoder : entity work.decoder
        generic map(
            word_width => WORD_WIDTH
        )
        port map(
            pi_instruction => s_instructionCacheRegisterIF_ID,
            po_controlWord => s_decoder
        );

    signExtension : entity work.signExtension
        generic map(
            word_width => WORD_WIDTH
        )
        port map(
            pi_instr => s_instructionCacheRegisterIF_ID,
            po_storeImm => open,
            po_immediateImm => s_signextensionI_out,
            po_unsignedImm => s_signextensionU_out,
            po_branchImm => s_signextensionB_out,
            po_jumpImm => s_signextensionJ_out
        );

    with s_instructionCacheRegisterIF_ID(6 downto 0) select
    s_signextension_out <=
                          s_signextensionU_out when LUI_INS_OP | AUIPC_INS_OP,
                          s_signextensionI_out when I_INS_OP | JALR_INS_OP,
                          s_signextensionJ_out when JAL_INS_OP,
                          s_signextensionB_out when B_INS_OP,
                          x"00000000" when others;
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
            pi_rst => pi_rst or s_select_for_branchEX_MEM or s_controlWordRegisterEX_MEM.PC_SEL,
            pi_data1 => s_op1_registerfile_out,
            po_data => s_idExOp1
        );

    id_ex_op2 : entity work.PipelineRegister1
        generic map(
            WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst or s_select_for_branchEX_MEM or s_controlWordRegisterEX_MEM.PC_SEL,
            pi_data1 => s_op2_registerfile_out,
            po_data => s_idExOp2
        );

    ControlWordRegister1 : entity work.ControlWordRegister
        port map(
            pi_rst => pi_rst or s_select_for_branchEX_MEM or s_controlWordRegisterEX_MEM.PC_SEL,
            pi_clk => pi_clk,
            pi_controlWord => s_decoder,
            po_controlWord => s_controlWordRegisterID_EX
        );

    gen_reg1_dAddr : entity work.PipelineRegister1
        generic map(
            registerWidth => REG_ADR_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst or s_select_for_branchEX_MEM or s_controlWordRegisterEX_MEM.PC_SEL,
            pi_data1 => d,
            po_data => s_dAddr_ID_EX
        );

    id_ex_se : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst or s_select_for_branchEX_MEM or s_controlWordRegisterEX_MEM.PC_SEL,
            pi_data1 => s_signextension_out,
            po_data => s_id_ex_Immediat
        );

    PC_to_PC_plus4_ID_EX : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst or s_select_for_branchEX_MEM or s_controlWordRegisterEX_MEM.PC_SEL,
            pi_data1 => s_pc_to_pcPlus4_registerIF_ID,
            po_data => s_pc_to_pcPlus4_registerID_EX
        );

    -- s_flush <= s_select_for_branchEX_EX or s_controlWordRegisterID_EX.PC_SEL;
    -- end solution!!

    ---********************************************************************
    ---* execute phase
    ---********************************************************************
    -- begin solution:

    ImmSel_mux : entity work.gen_mux
        generic map(
            dataWidth => WORD_WIDTH
        )
        port map(
            pi_sel => s_controlWordRegisterID_EX.I_IMM_SEL,
            pi_first => s_idExOp2,
            pi_second => s_id_ex_Immediat,
            po_res => s_immidatSel_mux
        );

    mux_a_sel : entity work.gen_mux
        generic map(
            dataWidth => WORD_WIDTH
        )
        port map(
            pi_sel => s_controlWordRegisterID_EX.A_SEL,
            pi_first => s_idExOp1,
            pi_second => s_pc_to_pcPlus4_registerID_EX,
            po_res => s_aSel_mux
        );
    ALU : entity work.my_alu
        generic map(WORD_WIDTH, ALU_OPCODE_WIDTH)
        port map(
            pi_OP1 => s_aSel_mux,
            pi_OP2 => s_immidatSel_mux,
            pi_aluOp => s_controlWordRegisterID_EX.ALU_OP,
            po_aluOut => s_alu,
            po_carryOut => open,
            po_zero => s_alu_zero
        );

    n_bit_full_adder_plus4 : entity work.my_gen_n_bit_full_adder
        generic map(
            G_DATA_WIDTH => WORD_WIDTH
        )
        port map(
            pi_A => ADD_FOUR_TO_ADDRESS,
            pi_B => s_pc_to_pcPlus4_registerID_EX,
            pi_CARRY_IN => '0',
            po_SUM => s_sum_pc_plus4,
            po_CARRY_OUT => open
        );

    branch_adder : entity work.my_gen_n_bit_full_adder
        generic map(
            G_DATA_WIDTH => WORD_WIDTH
        )
        port map(
            pi_A => s_pc_to_pcPlus4_registerID_EX,
            pi_B => s_id_ex_Immediat,
            pi_CARRY_IN => '0',
            po_SUM => s_sum_branch_adder,
            po_CARRY_OUT => open
        );

    s_select_for_branch <= s_controlWordRegisterID_EX.IS_BRANCH and (s_alu_zero xor s_controlWordRegisterID_EX.CMP_RESULT);
    -- end solution!!

    ---********************************************************************
    ---* Pipeline-Register (EX -> MEM) 
    ---********************************************************************
    -- begin solution:
    ControlWordRegister2 : entity work.ControlWordRegister
        port map(
            pi_rst => pi_rst,
            pi_clk => pi_clk,
            pi_controlWord => s_controlWordRegisterID_EX,
            po_controlWord => s_controlWordRegisterEX_MEM
        );

    gen_reg2_dAddr : entity work.PipelineRegister1
        generic map(
            registerWidth => REG_ADR_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_dAddr_ID_EX,
            po_data => s_dAddr_EX_MEM
        );

    ex_mem_res : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_alu,
            po_data => s_ex_mem_res
        );

    ex_mem_Immidiant : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_id_ex_Immediat,
            po_data => s_ex_mem_Immediat
        );

    pc_plus4_ex_mem : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_sum_pc_plus4,
            po_data => s_pc_plus4_EX_MEM
        );

    branch_adder_EX_MEM : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_sum_branch_adder,
            po_data => s_branchAdder_EX_MEM
        );

    process (pi_clk, pi_rst)
    begin
        if (pi_rst) then
            s_select_for_branchEX_MEM <= '0';
        elsif rising_edge (pi_clk) then
            s_select_for_branchEX_MEM <= s_select_for_branch;
        end if;
    end process;
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
            pi_controlWord => s_controlWordRegisterEX_MEM,
            po_controlWord => s_controlWordRegisterMEM_WB
        );

    gen_reg3_dAddr : entity work.PipelineRegister1
        generic map(
            registerWidth => REG_ADR_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_dAddr_EX_MEM,
            po_data => s_dAddr_MEM_WB
        );

    mem_wb_res : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_ex_mem_res,
            po_data => s_mem_wb_res
        );

    mem_wb_Immidiant : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_ex_mem_Immediat,
            po_data => s_mem_wb_Immediat
        );

    pc_plus4_mem_wb : entity work.PipelineRegister1
        generic map(
            registerWidth => WORD_WIDTH
        )
        port map(
            pi_clk => pi_clk,
            pi_rst => pi_rst,
            pi_data1 => s_pc_plus4_EX_MEM,
            po_data => s_pc_plus4_MEM_WB
        );

    -- end solution!!

    ---********************************************************************
    ---* write back phase
    ---********************************************************************
    gen_mux4to1_inst : entity work.gen_mux4to1
        generic map(
            dataWidth => WORD_WIDTH
        )
        port map(
            pi_sel => s_controlWordRegisterMEM_WB.WB_SEL,
            pi_first => s_mem_wb_res,
            pi_second => s_mem_wb_Immediat,
            pi_third => s_pc_plus4_MEM_WB,
            pi_fourth => open,
            po_res => s_wbSelect_mux
        );
    ---********************************************************************
    ---* register file (negative clock)
    ---********************************************************************
    -- begin solution:
    register_file : entity work.register_file
        port map(
            pi_clk => not pi_clk,
            pi_rst => pi_rst,
            pi_writeEnable => s_controlWordRegisterMEM_WB.REG_WRITE,
            pi_readRegAddr1 => s,
            pi_readRegAddr2 => t,
            pi_writeRegAddr => s_dAddr_MEM_WB,
            pi_writeRegData => s_wbSelect_mux,
            po_readRegData1 => s_op1_registerfile_out,
            po_readRegData2 => s_op2_registerfile_out,
            po_registerOut => po_registersOut
        );

    -- end solution!!
end architecture;