-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date: 29. April
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- ========================================================================
-- Author:       Baran Ali Sönmez/Mashal Khan
-- Last updated: 29.04.2025
-- Description:  Testbench for the PipelineRegister.vhdl
-- ========================================================================

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    use work.constant_package.all;

entity PipelineRegister_tb is
end PipelineRegister_tb;

architecture behavior of PipelineRegister_tb is

    signal s_datain5        : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout5       : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_datain6        : std_logic_vector(OPCODE_WIDTH - 2 downto 0) := (others => '0');
    signal s_dataout6       : std_logic_vector(OPCODE_WIDTH - 2 downto 0) := (others => '0');
    signal s_datain8        : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    signal s_dataout8       : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    signal s_datain16        : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout16       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_datain32        : std_logic_vector(ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_dataout32       : std_logic_vector(ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_clk            : std_logic;
    signal s_rst            : std_logic;

    constant clock_period: time := 10 ns;

begin
    -- Pipeline initialisierung von unterschiedlichen Bitgrößen
    dut1: entity work.PipelineRegister
    generic map (5)
    port map (
      pi_clk        => s_clk,
      pi_rst        => s_rst,
      pi_data       => s_datain5,
      po_data       => s_dataout5
    );

    dut2: entity work.PipelineRegister
    generic map (6)
    port map (
      pi_clk        => s_clk,
      pi_rst        => s_rst,
      pi_data       => s_datain6,
      po_data       => s_dataout6
    );

    dut3: entity work.PipelineRegister
    generic map (8)
    port map (
      pi_clk        => s_clk,
      pi_rst        => s_rst,
      pi_data       => s_datain8,
      po_data       => s_dataout8
    );

    dut4: entity work.PipelineRegister
    generic map (16)
    port map (
      pi_clk        => s_clk,
      pi_rst        => s_rst,
      pi_data       => s_datain16,
      po_data       => s_dataout16
    );

    dut5: entity work.PipelineRegister
    generic map (32)
    port map (
      pi_clk        => s_clk,
      pi_rst        => s_rst,
      pi_data       => s_datain32,
      po_data       => s_dataout32
    );

    -- Clock process
    clock: process
    begin
        s_clk <= '0';
        wait for clock_period / 2;
        S_CLK <= '1';
        wait for clock_period / 2;
    end process;


    -- Test process
    process
    begin
        -- Setting and testing reset
        s_rst <= '1';
        wait for clock_period / 2;
        s_rst <= '0';
        assert (s_dataout5 = "00000") report "Reset 5 bits failed" severity error;
        assert (s_dataout6 = "000000") report "Reset 6 bits failed" severity error;
        assert (s_dataout8 = "00000000") report "Reset 8 bits failed" severity error;
        assert (s_dataout16 = "0000000000000000") report "Reset 16 bits failed" severity error;
        assert (s_dataout32 = "00000000000000000000000000000000") report "Reset 32 bits failed" severity error;
        wait for clock_period / 2;
        
        -- Testing offset
        s_datain5 <= "01010";
        s_datain6 <= "010101";
        s_datain8 <= "01010101";
        s_datain16 <= "0101010101010101";
        s_datain32 <= "01010101010101010101010101010101";
        wait for clock_period / 2;
        assert (s_dataout5 = "00000") report "Offset 5 bits failed" severity error;
        assert (s_dataout6 = "000000") report "Offset 6 bits failed" severity error;
        assert (s_dataout8 = "00000000") report "Offset 8 bits failed" severity error;
        assert (s_dataout16 = "0000000000000000") report "Offset 16 bits failed" severity error;
        assert (s_dataout32 = "00000000000000000000000000000000") report "Offset 32 bits failed" severity error;
        wait for clock_period * 2;
        assert (s_dataout5 = "01010") report "Set 5 bits failed" severity error;
        assert (s_dataout6 = "010101") report "Set 6 bits failed" severity error;
        assert (s_dataout8 = "01010101") report "Set 8 bits failed" severity error;
        assert (s_dataout16 = "0101010101010101") report "Set 16 bits failed" severity error;
        assert (s_dataout32 = "01010101010101010101010101010101") report "Set 32 bits failed" severity error;
        wait for clock_period;
        s_rst <= '1';
        assert (s_dataout5 = "01010") report "Offset reset 5 bits failed" severity error;
        assert (s_dataout6 = "010101") report "Offset reset 6 bits failed" severity error;
        assert (s_dataout8 = "01010101") report "Offset reset 8 bits failed" severity error;
        assert (s_dataout16 = "0101010101010101") report "Offset reset 16 bits failed" severity error;
        assert (s_dataout32 = "01010101010101010101010101010101") report "Offset reset 32 bits failed" severity error;
        wait for clock_period;
        assert (s_dataout5 = "00000") report "Reset 5 bits failed" severity error;
        assert (s_dataout6 = "000000") report "Reset 6 bits failed" severity error;
        assert (s_dataout8 = "00000000") report "Reset 8 bits failed" severity error;
        assert (s_dataout16 = "0000000000000000") report "Reset 16 bits failed" severity error;
        assert (s_dataout32 = "00000000000000000000000000000000") report "Reset 32 bits failed" severity error;
        
        report "End of Test!!!";
        wait;
    end process;
end behavior;
