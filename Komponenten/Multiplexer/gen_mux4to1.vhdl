-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date: 29. April
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- ========================================================================
-- Author:       Baran Ali Sönmez/Mashal Khan
-- Last updated: 01.06.2025
-- Description:  generic 4 to 1 Mulitplexer
-- ========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.Constant_Package.all;

entity gen_mux4to1 is
    generic (
        dataWidth : integer := ADR_WIDTH
    );
    port (
        pi_sel : in std_logic_vector(1 downto 0) := "00";
        pi_first, pi_second, pi_third, pi_fourth : in std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
        po_res : out std_logic_vector(dataWidth - 1 downto 0) := (others => '0')
    );

end entity gen_mux4to1;

architecture dataflow of gen_mux4to1 is
begin
    -- Multiplexer
    with pi_sel select
        po_res <= pi_first when "00",
        pi_second when "01",
        pi_third when "10",
        pi_fourth when others;
end architecture dataflow;