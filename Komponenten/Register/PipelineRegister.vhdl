-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date: 29. April
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- ========================================================================
-- Author:       Baran Ali Sönmez/Mashal Khan
-- Last updated: 29.04.2025
-- Description:  Pipeline register
-- ========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Constant_Package.ALL;


entity PipelineRegister is
    generic (
        registerWidth  : integer := ADR_WIDTH
    );
    port (
        pi_clk, pi_rst : in std_logic := '0';
        pi_data : in std_logic_vector(registerWidth - 1 downto 0);
        po_data : out std_logic_vector(registerWidth - 1 downto 0)
    );

end entity PipelineRegister;

architecture behavior of PipelineRegister is
    signal s_regdata  : STD_LOGIC_VECTOR(registerWidth - 1 downto 0) := (others => '0');

begin
    -- Pipelining
    process (pi_clk, pi_rst)
    begin
        if rising_edge(pi_clk) then
            if pi_rst = '0' then
                s_regdata <= pi_data; -- Vorbereiten fürs offset schreiben
            else
                s_regdata <= (others => '0');
            end if;
            po_data <= s_regdata; -- Offset schreiben
        elsif pi_rst = '1' then -- Reset
            po_data <= (others => '0'); 
        end if;
    end process;
end architecture behavior;
