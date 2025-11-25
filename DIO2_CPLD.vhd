------------------------------------------------------------------------------
--                                                                          --
--          #     #   #####   #####    #     #  #        #######            --
--          ##   ##  #     #  #    #   #     #  #        #                  --
--          # # # #  #     #  #     #  #     #  #        #                  --
--          #  #  #  #     #  #     #  #     #  #        ######             --
--          #     #  #     #  #     #  #     #  #        #                  --
--          #     #  #     #  #    #   #     #  #        #                  --
--          #     #   #####   #####    #######  #######  #######            --
--                                                                          --
------------------------------------------------------------------------------
--
--           MODULE NAME: DIO2 CPLD
--
------------------------------------------------------------------------------
--
--  DESIGNER              :  Digilent Inc.
--  LOCATION              :  
--  DATE                  :  
--
--  DESIGN                :  
--  PROJECT               :  
--  PART NUMBER           :  N/A
--  REFERENCE DESIGNATOR  :  N/A
--  ALTERED ITEM NUMBER   :  N/A
--  SOURCE FILE FORMAT    :  VHDL
--  SOURCE FILE NAME      :  DIO2_CPLD.vhd
--  LAST REVISION NUMBER  :  0
--
--  INSTALL ON            :  N/A
--  ASSEMBLY NUMBER       :  XXXXXXXX
-- 
--  DESCRIPTION:
--  Digital IO 2 CPLD
--
--CPLD Address Map 	
-- Address 0 	Buttons 7 - 0 	 
-- Address 1 	Buttons 15 - 8 	 
-- Address 2 	Switches 7 - 0 	 
-- Address 3 	Not Used 	 
-- Address 4 	LEDs 7 - 0 	 
-- Address 5 	LEDs 15 - 8 	 
-- Address 6 	7S digits 1 & 2 	 
-- Address 7 	7S digits 3 & 4 	 
-- Address 8-63 	Not Used 	 
--
--  
--  REVISION HISTORY:
--  
--
------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity d2io is
   Port (
      cs       : in std_logic;
      we       : in std_logic;
      oe       : in std_logic;
      clk256   : in std_logic;
      btns     : in std_logic_vector(14 downto 0);
      switchs  : in std_logic_vector(7 downto 0);
      leds     : out std_logic_vector(15 downto 0);
      data     : inout std_logic_vector(7 downto 0);
      addr     : in std_logic_vector(5 downto 0);
      sseg     : out std_logic_vector(6 downto 0);
      ssegdp   : out std_logic;
      ssegsel  : out std_logic_vector(3 downto 0)
   );
end d2io;

architecture rtl of d2io is

signal data_out   : std_logic_vector(7 downto 0);
signal sseg_reg   : std_logic_vector(15 downto 0);
signal leds_i     : std_logic_vector(15 downto 0);
signal sseg1      : std_logic_vector(6 downto 0);
signal digit      : std_logic_vector(3 downto 0);
signal count      : unsigned(1 downto 0);
signal testentry  : std_logic;
signal testmode   : std_logic;
signal ssegsel1   : std_logic_vector(3 downto 0);

begin

--
-- Button and switch reads (non-registered)
--

data <= data_out when (oe = '1' and cs = '1') else (others => 'Z');
data_out <= btns(7 downto 0) when addr(1 downto 0) = "00" 
            else '0' & btns(14 downto 8) when addr(1 downto 0) = "01" 
            else switchs;
--
-- LED and SSD register writes
--
process(we)
begin
   if(falling_edge(we) and cs = '1') then
      case addr is
      when "000100" => leds_i(7 downto 0) <= data;
      when "000101" => leds_i(15 downto 8) <= data;
      when "000110" => sseg_reg(15 downto 8) <= data;
      when "000111" => sseg_reg(7 downto 0) <= data;
      when others => NULL;
      end case;
   end if;
end process;

--
-- Seven segment controller
--
-- Generates anode and cathode signals from an input clock
-- and two 8-bit registers containing four 4-bit digit fields.
--
process(clk256)
begin
   if clk256'event and clk256 = '1' then
      count <= count + 1;
   end if;
end process;

with count select
   digit <= sseg_reg(7 downto 4) when "00",
            sseg_reg(3 downto 0) when "01",
            sseg_reg(15 downto 12) when "10",
            sseg_reg(11 downto 8) when others;
            
with digit select
   sseg1 <= "1001111" when "0001", --1
            "0010010" when "0010", --2
            "0000110" when "0011", --3
            "1001100" when "0100", --4
            "0100100" when "0101", --5
            "0100000" when "0110", --6
            "0001111" when "0111", --7
            "0000000" when "1000", --8
            "0000100" when "1001", --9
            "0001000" when "1010", --A
            "1100000" when "1011", --b
            "0110001" when "1100", --C
            "1000010" when "1101", --d
            "0110000" when "1110", --E
            "0111000" when "1111", --F
            "0000001" when others; --0

with count select
   ssegsel1 <= "1000" when "00",
               "0100" when "01",
               "0010" when "10",
               "0001" when others;
--
-- Test mode
--
testentry <= switchs(0) and not switchs(7) and btns(14) and btns(7);
process (btns(0))
begin
   if (btns(0)'event and btns(0) = '1') then 
      testmode <= testentry;
   end if;
end process;

leds     <= not(leds_i) when testmode = '0' else not(btns(14)&btns(14 downto 1) & btns(1));
sseg     <= sseg1 when testmode = '0' else switchs (6 downto 0);
ssegdp   <= '1' when testmode = '0' else switchs(7);
ssegsel  <= ssegsel1 when testmode = '0' else "1111";

end rtl;