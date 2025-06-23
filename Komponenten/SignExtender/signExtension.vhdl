-- Laboratory RA solutions/versuch3
-- Sommersemester 25
-- Group Details
-- Lab Date:
-- 1. Participant First and Last Name: Baran Ali Sönmez
-- 2. Participant First and Last Name: Mashal Khan

-- ========================================================================
-- Description:  Sign extender for a RV32I processor. Takes the entire instruction
--               and produces a 32-Bit value by sign-extending, shifting and piecing
--               together the immedate value in the instruction.
-- ========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constant_package.all;

entity signExtension is
    -- begin solution:
    generic (
        word_width : integer := WORD_WIDTH
    );
    port (
        pi_instr : in std_logic_vector(word_width - 1 downto 0);
        po_storeImm : out std_logic_vector(word_width - 1 downto 0);
        po_immediateImm : out std_logic_vector(word_width - 1 downto 0);
        po_unsignedImm : out std_logic_vector(word_width - 1 downto 0);
        po_branchImm : out std_logic_vector(word_width - 1 downto 0);
        po_jumpImm : out std_logic_vector(word_width - 1 downto 0)
    );
    -- end solution!!
end entity signExtension;

architecture arc of signExtension is
    -- Fürs i-immediate: 5 bit fürs shift oder 
    signal s_imm : std_logic_vector(31 downto 0) := std_logic_vector(resize(signed(pi_instr(31 downto 20)), 32));
    signal s_shamt : std_logic_vector(31 downto 0) := (26 downto 0 => '0') & pi_instr(24 downto 20);

    -- begin solution:
begin -- immediates rausholen und durch die resize Funktion an Ausgang in 32 bit ausgeben
    with pi_instr(14 downto 12) select
    po_immediateImm <=
                      s_shamt when "101" | "001",
                      s_imm when others;
    po_storeImm <= std_logic_vector(resize(signed(pi_instr(31 downto 25) & pi_instr(11 downto 7)), 32));
    po_unsignedImm <= std_logic_vector(resize(signed(pi_instr(31 downto 12) & x"000"), 32));
    po_branchImm <= std_logic_vector(resize(signed(pi_instr(31) & pi_instr(7) & pi_instr(30 downto 25) & pi_instr(11 downto 8) & '0'), 32));
    po_jumpImm <= std_logic_vector(resize(signed(pi_instr(31) & pi_instr(19 downto 12) & pi_instr(20) & pi_instr(30 downto 21) & '0'), 32));
    -- end solution!!
end architecture arc;