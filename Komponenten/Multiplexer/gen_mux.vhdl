-- Laboratory RA solutions/versuch1
-- Sommersemester 25
-- Group Details
-- Lab Date: 29. April
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- ========================================================================
-- Author:       Baran Ali Sönmez/Mashal Khan
-- Last updated: 29.04.2025
-- Description:  generic Mulitplexer
-- ========================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Constant_Package.ALL;


entity gen_mux is
    generic (
        dataWidth  : integer := ADR_WIDTH
    );
    port (
        pi_sel : in std_logic := '0';
        pi_first, pi_second : in std_logic_vector(dataWidth - 1 downto 0) := (others => '0');
        po_res : out std_logic_vector(dataWidth - 1 downto 0) := (others => '0')
    );

end entity gen_mux;

architecture dataflow of gen_mux is
begin
    -- Multiplexer
    po_res <= pi_first when pi_sel = '0' else
    pi_second;
end architecture dataflow;
