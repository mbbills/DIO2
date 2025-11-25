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
--           MODULE NAME: DIO2 CPLD Testbench
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

entity d2io_tb is
end d2io_tb;


architecture rtl of d2io_tb is

type item is (buttons7to0, buttons15to8, switches7to0,LEDs7to0,LEDs15to8,SevenSeg1and2,SevenSeg3and4);
signal addressItem : item;
signal addrSig     : std_logic_vector( 5 downto 0);
signal btnsSig     : std_logic_vector(14 downto 0);
signal clk256Sig   : std_logic;
signal csSig       : std_logic;
signal oeSig       : std_logic;
signal switchsSig  : std_logic_vector( 7 downto 0);
signal weSig       : std_logic;
signal dataSig     : std_logic_vector( 7 downto 0);
signal ledsSig     : std_logic_vector(15 downto 0);
signal ssegSig     : std_logic_vector( 6 downto 0);
signal ssegdpSig   : std_logic;
signal ssegselSig  : std_logic_vector( 3 downto 0);



component d2io
   port ( 
      addr    : in    std_logic_vector( 5 downto 0);
      btns    : in    std_logic_vector(14 downto 0);
      clk256  : in    std_logic;
      cs      : in    std_logic;
      oe      : in    std_logic;
      switchs : in    std_logic_vector( 7 downto 0);
      we      : in    std_logic; 
      data    : inout std_logic_vector( 7 downto 0);
      leds    : out   std_logic_vector(15 downto 0);
      sseg    : out   std_logic_vector( 6 downto 0);
      ssegdp  : out   std_logic;
      ssegsel : out   std_logic_vector( 3 downto 0)
   );
end component;

begin


addrProc : process
begin
   addrSig <= "000000"; -- Address 0 	Buttons 7 - 0 
   oeSig   <= '0';
   weSig   <= '0';
   wait for 20 ns;
   oeSig   <= '1';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   addrSig <= "000001"; -- Address 1 	Buttons 15 - 8 	 
   wait for 20 ns;
   oeSig   <= '1';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   addrSig <= "000010"; -- Address 2 	Switches 7 - 0 	
   wait for 20 ns;
   oeSig   <= '1';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   addrSig <= "000100"; -- Address 4 	LEDs 7 - 0 	 
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   dataSig <= "10101010";
   wait for 20 ns;
   weSig   <= '1';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   dataSig <= "ZZZZZZZZ";
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   addrSig <= "000101"; -- Address 5 	LEDs 15 - 8 	 
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   dataSig <= "10101010";
   wait for 20 ns;
   weSig   <= '1';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   dataSig <= "ZZZZZZZZ";
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   addrSig <= "000110"; -- Address 6 	7S digits 1 & 2 	
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   dataSig <= "10101010";
   wait for 20 ns;
   weSig   <= '1';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   dataSig <= "ZZZZZZZZ";
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   addrSig <= "000111"; -- Address 7 	7S digits 3 & 4 	 
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
   dataSig <= "10101010";
   wait for 20 ns;
   weSig   <= '1';
   wait for 20 ns;
   weSig   <= '0';
   wait for 20 ns;
   dataSig <= "ZZZZZZZZ";
   wait for 20 ns;
   oeSig   <= '0';
   wait for 20 ns;
end process;


bttnProc : process
begin
   btnsSig <= "000000000000000";
   wait;
end process;


clk256Proc : process
begin
   clk256Sig <= '0';
   wait;
end process;


csProc : process
begin
   csSig <= '1';
   wait;
end process;


switchsProc : process
begin
   switchsSig <= "00000000";
   wait for 2 us;
   switchsSig <= "00100010";
   wait;
end process;


uut : d2io
   port map( 
      addr    => addrSig,
      btns    => btnsSig,
      clk256  => clk256Sig,
      cs      => csSig,
      oe      => oeSig,
      switchs => switchsSig,
      we      => weSig,
      data    => dataSig,
      leds    => ledsSig,
      sseg    => ssegSig,
      ssegdp  => ssegdpSig,
      ssegsel => ssegselSig
   );
   
 


end rtl;