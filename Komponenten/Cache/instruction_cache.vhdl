-- Laboratory RA solutions/versuch4
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Baran Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- ========================================================================
-- Author:       Marcel Riess
-- Last updated: 14.05.2025
-- Description:  Generic instruction cache (read only) with debug port,
--               to allow writing data in testbenches
-- ========================================================================

-- exercise 4 revised: synchronous instruction cache with separate register and read
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;
use work.types.all;

entity instruction_cache is
    generic (
        adr_width : integer := ADR_WIDTH; -- Address bus width
        mem_size  : integer := 2**10      -- Number of entries in cache
    );
    port (
        pi_adr             : in  std_logic_vector(adr_width-1 downto 0); -- instruction address
        pi_clk             : in  std_logic;
        pi_rst             : in  std_logic;
        pi_instructionCache: in  memory;  -- initialization/debug input
        po_instruction     : out std_logic_vector(WORD_WIDTH-1 downto 0) -- fetched instruction
    );
end entity instruction_cache;

architecture sync of instruction_cache is
    -- register array storing instructions
    signal instructions : memory := (others => (others => '0'));
begin
    -- load and store instructions in register on clock
    process(pi_clk, pi_rst) is
    begin
        if pi_rst = '1' then
            instructions <= pi_instructionCache;  -- load all on reset
        elsif rising_edge(pi_clk) then
            instructions <= pi_instructionCache;  -- update for debug or testbench
        end if;
    end process;

    -- asynchronous read of instruction
    po_instruction <= instructions(to_integer(unsigned(pi_adr(adr_width-1 downto 2))));
end architecture sync;
