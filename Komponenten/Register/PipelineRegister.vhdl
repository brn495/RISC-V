-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date: 29. April
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- ========================================================================
-- Author:       Baran Ali Sönmez/Mashal Khan
-- Last updated: 30.04.2025
-- Description:  Pipeline register
-- ========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.Constant_Package.all;

entity PipelineRegister is
    generic (
        registerWidth : integer := ADR_WIDTH
    );
    port (
        pi_clk, pi_rst : in std_logic := '0';
        pi_data : in std_logic_vector(registerWidth - 1 downto 0);
        po_data : out std_logic_vector(registerWidth - 1 downto 0)
    );

end entity PipelineRegister;

architecture behavior of PipelineRegister is

begin
    -- Pipelining
    process (pi_clk, pi_rst)
    begin
        if pi_rst = '1' then -- Reset
            po_data <= (others => '0');
        elsif rising_edge(pi_clk) then -- Write
            po_data <= pi_data;
        end if;
    end process;
end architecture behavior;