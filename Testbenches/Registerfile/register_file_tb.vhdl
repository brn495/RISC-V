-- Laboratory RA solutions/versuch2
-- Sommersemester 25
-- Group Details
-- Lab Date: 06.05.2005
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use work.constant_package.all;

entity register_file_tb is
end entity register_file_tb;

architecture behavior of register_file_tb is

    signal s_clk : std_logic := '0';
    signal s_rst : std_logic := '0';
    signal s_we : std_logic := '0';
    signal s_readRegAddr1 : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_readRegAddr2 : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_writeRegAddr : std_logic_vector(REG_ADR_WIDTH - 1 downto 0) := (others => '0');
    signal s_writeRegData : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_readRegData1 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_readRegData2 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_writeRegData_32 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_readRegData1_32 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');
    signal s_readRegData2_32 : std_logic_vector(WORD_WIDTH - 1 downto 0) := (others => '0');

    -- Taktprozess für Simulation
    constant clk_period : time := 10 ns;
begin
    clk_process : process
    begin
        s_clk <= '0';
        wait for clk_period / 2;
        s_clk <= '1';
        wait for clk_period / 2;
    end process;

    -- Instanz des RAM-Moduls
    dut1 : entity work.register_file
        generic map(16)
        port map(
            pi_clk => s_clk,
            pi_rst => s_rst, -- Reset wird hier uebergeben
            pi_writeEnable => s_we,
            pi_readRegAddr1 => s_readRegAddr1,
            pi_readRegAddr2 => s_readRegAddr2,
            pi_writeRegAddr => s_writeRegAddr,
            pi_writeRegData => s_writeRegData,
            po_readRegData1 => s_readRegData1,
            po_readRegData2 => s_readRegData2
        );

    dut2 : entity work.register_file
        generic map(32)
        port map(
            pi_clk => s_clk,
            pi_rst => s_rst, -- Reset wird hier uebergeben
            pi_writeEnable => s_we,
            pi_readRegAddr1 => s_readRegAddr1,
            pi_readRegAddr2 => s_readRegAddr2,
            pi_writeRegAddr => s_writeRegAddr,
            pi_writeRegData => s_writeRegData_32,
            po_readRegData1 => s_readRegData1_32,
            po_readRegData2 => s_readRegData2_32
        );

    -- Testprozess mit Assertions
    test_process : process
    begin
        -- Reset setzten
        s_rst <= '1';
        wait for clk_period;
        s_rst <= '0';

        -- Test 1: Versuchen die 0 Vektoren zu lesen
        s_readRegAddr1 <= "00001";
        s_readRegAddr2 <= "00010";
        s_writeRegAddr <= "00100";
        s_writeRegData <= "0000000010100101";
        s_writeRegData_32 <= "00000000000000000000000010100101"; -- 0xA5
        wait for clk_period;
        assert (s_readRegData1 = "0000000000000000") report "Reading Out1 after reset not right" severity error;
        assert (s_readRegData2 = "0000000000000000") report "Reading Out2 after reset not right" severity error;
        assert (s_readRegData1_32 = "00000000000000000000000000000000") report "Reading Out1_32 after reset not right" severity error;
        assert (s_readRegData2_32 = "00000000000000000000000000000000") report "Reading Out2_32 after reset not right" severity error;

        -- Schreiben von 0xA5 in Register 0x4
        s_we <= '1';
        wait for clk_period;
        s_we <= '0';

        -- Test 2: Versuchen die geschriebenen 0x4 Adresse zu lesen
        s_readRegAddr1 <= "00100";
        wait for clk_period;
        assert (s_readRegData1 = "0000000010100101") report "Reading Out1 after writing not right" severity error;
        assert (s_readRegData2 = "0000000000000000") report "Reading Out2 after writing not right" severity error;
        assert (s_readRegData1_32 = "00000000000000000000000010100101") report "Reading Out1_32 after writing not right" severity error;
        assert (s_readRegData2_32 = "00000000000000000000000000000000") report "Reading Out2_32 after writing not right" severity error;

        -- Schreiben von 0x1 in Register 0x1
        s_writeRegAddr <= "00001";
        s_writeRegData <= "0000000000000001";
        s_writeRegData_32 <= "00000000000000000000000000000001";
        s_we <= '1';
        wait for clk_period;
        s_readRegAddr2 <= "00001";
        wait for clk_period;

        -- Test 3: Versuchen die geschriebenen Werte in Out2 auszugeben
        assert (s_readRegData1 = "0000000010100101") report "Reading Out1 after number 2 writing not right" severity error;
        assert (s_readRegData2 = "0000000000000001") report "Reading Out2 after number 2 writing not right" severity error;
        assert (s_readRegData1_32 = "00000000000000000000000010100101") report "Reading Out1_32 after number 2 writing not right" severity error;
        assert (s_readRegData2_32 = "00000000000000000000000000000001") report "Reading Out2_32 after writing number 2 not right" severity error;

        -- Nochmals reset testen
        s_rst <= '1';
        wait for clk_period;
        s_rst <= '0';
        assert (s_readRegData1 = "0000000000000000") report "Reading Out1 after reset not right" severity error;
        assert (s_readRegData2 = "0000000000000000") report "Reading Out2 after reset not right" severity error;
        assert (s_readRegData1_32 = "00000000000000000000000000000000") report "Reading Out1_32 after reset not right" severity error;
        assert (s_readRegData2_32 = "00000000000000000000000000000000") report "Reading Out2_32 after reset not right" severity error;

        report "Alle Tests erfolgreich abgeschlossen." severity note;

        wait;
    end process;
end architecture behavior;