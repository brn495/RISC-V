-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Mashal Khan
-- 2. Participant First and Last Name: Baran Sönmez

-- ========================================================================
-- Author:       Baran Ali Sönmez/Mashal Khan
-- Last updated: 31.03.2025
-- Description:  A simple register with clock and reset.
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use work.constant_package.all;

entity PipelineRegister1 is
    generic (
        registerWidth : integer := 8
    );
    port (
        pi_clk : in std_logic; -- Clock
        pi_rst : in std_logic; -- Reset
        pi_data1 : in std_logic_vector(registerWidth - 1 downto 0); -- Eingang
        po_data : out std_logic_vector(registerWidth - 1 downto 0) -- Ausgang
    );
end entity PipelineRegister1;

architecture behaviour of PipelineRegister1 is
begin
    process (pi_clk, pi_rst)
    begin
        if pi_rst = '1' then
            po_data <= (others => '0');
        elsif rising_edge(pi_clk) then
            po_data <= pi_data1;
        end if;
    end process;
end architecture behaviour;