-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date: 29. April
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- ========================================================================
-- Author:       Baran Ali Sönmez/Mashal Khan
-- Last updated: 29.04.2025
-- Description:  Testbench for generic Mulitplexer
-- ========================================================================

library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    use ieee.numeric_std.all;
    use ieee.math_real.all;
    use work.constant_package.all;

entity gen_mux_tb is
end gen_mux_tb;

architecture behavior of gen_mux_tb is

    signal s_first5         : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_second5        : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_first6         : std_logic_vector(OPCODE_WIDTH - 2 downto 0) := (others => '0');
    signal s_second6        : std_logic_vector(OPCODE_WIDTH - 2 downto 0) := (others => '0');
    signal s_first8         : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    signal s_second8        : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    signal s_first16        : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_second16       : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_first32        : std_logic_vector(ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_second32       : std_logic_vector(ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_res5           : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_res6           : std_logic_vector(OPCODE_WIDTH - 2 downto 0) := (others => '0');
    signal s_res8           : std_logic_vector(DATA_WIDTH_GEN - 1 downto 0) := (others => '0');
    signal s_res16          : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_res32          : std_logic_vector(ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_sel            : std_logic;

    constant clock_period: time := 10 ns;

begin
    -- Multipexer entities initialisierung
    dut1: entity work.gen_mux
    generic map (5)
    port map (
        pi_sel      => s_sel,
        pi_first    => s_first5,
        pi_second   => s_second5,
        po_res      => s_res5
    );

    dut2: entity work.gen_mux
    generic map (6)
    port map (
        pi_sel      => s_sel,
        pi_first    => s_first6,
        pi_second   => s_second6,
        po_res      => s_res6
    );

    dut3: entity work.gen_mux
    generic map (8)
    port map (
        pi_sel      => s_sel,
        pi_first    => s_first8,
        pi_second   => s_second8,
        po_res      => s_res8
    );

    dut4: entity work.gen_mux
    generic map (16)
    port map (
        pi_sel      => s_sel,
        pi_first    => s_first16,
        pi_second   => s_second16,
        po_res      => s_res16
    );

    dut5: entity work.gen_mux
    generic map (32)
    port map (
        pi_sel      => s_sel,
        pi_first    => s_first32,
        pi_second   => s_second32,
        po_res      => s_res32
    );

    -- Clock process

    -- Test process
    process
    begin
        -- Setting first and second/Testing selection of first
        s_sel <= '0';
        s_first5    <= "00011";
        s_first6    <= "000111";
        s_first8    <= "00001111";
        s_first16   <= "0000000011111111";
        s_first32   <= "00000000000000001111111111111111";

        s_second5   <= "11000";
        s_second6   <= "111000";
        s_second8   <= "11110000";
        s_second16  <= "1111111100000000";
        s_second32  <= "11111111111111110000000000000000";

        wait for clock_period;
        assert (s_res5 = "00011") report "Select of first5 failed" severity error;
        assert (s_res6 = "000111") report "Select of first6 failed" severity error;
        assert (s_res8 = "00001111") report "Select of first8 failed" severity error;
        assert (s_res16 = "0000000011111111") report "Select of first16 failed" severity error;
        assert (s_res32 = "00000000000000001111111111111111") report "Select of first32 failed" severity error;
        wait for clock_period / 2;

        -- Testing selection of second
        s_sel <= '1';

        wait for clock_period * 2;
        assert (s_res5 = "11000") report "Select of second5 failed" severity error;
        assert (s_res6 = "111000") report "Select of second6 failed" severity error;
        assert (s_res8 = "11110000") report "Select of second8 failed" severity error;
        assert (s_res16 = "1111111100000000") report "Select of second16 failed" severity error;
        assert (s_res32 = "11111111111111110000000000000000") report "Select of second32 failed" severity error;
        wait for clock_period;
        
        report "End of Test!!!";
        wait;
    end process;
end behavior;
