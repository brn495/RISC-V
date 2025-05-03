library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use work.constant_package.all;

entity Single_Port_RAM_tb is
end Single_Port_RAM_tb;

architecture behavior of Single_Port_RAM_tb is
    signal s_clk : std_logic := '0';
    signal s_rst : std_logic := '0'; -- Reset-Signal
    signal s_we : std_logic := '0';
    signal s_add : std_logic_vector(ADR_WIDTH - 1 downto 0);
    signal s_datain : std_logic_vector(WORD_WIDTH - 1 downto 0);
    signal s_dataout : std_logic_vector(WORD_WIDTH - 1 downto 0);

    -- Taktprozess fuer Simulation
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
    uut : entity work.Single_Port_RAM
        generic map(16, 16)
        port map(
            pi_clk => s_clk,
            pi_rst => s_rst, -- Reset wird hier uebergeben
            pi_we => s_we,
            pi_add => s_add,
            pi_data => s_datain,
            po_data => s_dataout
        );

    -- Testprozess mit Assertions
    test_process : process
    begin
        -- Test 1: Setze Reset
        s_rst <= '1';
        wait for clk_period;
        s_rst <= '0';

        -- Test 2: Schreibe Wert 0xA5 an Adresse 0x2
        s_add <= "0000000000000010";
        s_datain <= "000000010100101"; -- 0xA5
        s_we <= '1';
        wait for clk_period;
        s_we <= '0';

        -- Test 3: Lese von Adresse 0x2
        wait for clk_period;
        assert s_dataout = "0000000010100101"
        report "Fehler: Speicherinhalt an Adresse 0x2 sollte 0xA5 sein!"
            severity error;

        -- Test 4: Setze Reset und ueberpruefe den Inhalt
        s_rst <= '1';
        wait for clk_period;
        assert s_dataout = "0000000000000000"
        report "Fehler: Nach Reset sollte der Speicherinhalt 0 sein!"
            severity error;
        s_rst <= '0';

        -- Test 5: Schreibe neuen Wert an Adresse 0x2
        s_add <= "0000000000000010";
        s_datain <= "0000000001010101"; -- 0x55
        s_we <= '1';
        wait for clk_period;
        s_we <= '0';

        -- Test 6: Lese von Adresse 0x2 erneut
        wait for clk_period;
        assert s_dataout = "000000000001010101"
        report "Fehler: Speicherinhalt an Adresse 0x2 sollte 0x55 sein!"
            severity error;

        report "Alle Tests erfolgreich abgeschlossen." severity note;
        wait;
    end process;
end behavior;