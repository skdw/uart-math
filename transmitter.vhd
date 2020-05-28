library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity transmitter is
    Port ( r : in STD_LOGIC;				-- sygnal resetujacy
	   clk : in  STD_LOGIC;				-- zegar taktujacy
           data_in : in  STD_LOGIC_VECTOR(7 downto 0);	-- wejscie rownolegle
           tx : out  STD_LOGIC);			-- wyjscie szeregowe
end transmitter;

architecture Behavioral of transmitter is

    signal pos: natural range 0 to 7;		-- pozycja
    signal buff: STD_LOGIC;			-- bufor

begin
    
    process (r, clk) is				-- proces odbiornika
    begin
    
        if(r='1') then				-- asynchroniczna inicjalizacja rejestrow
	
            pos <= 0;
	    buff <= '0';
	    
        elsif(rising_edge(clk)) then		-- synchroniczna praca odbiornika
	    
            buff <= data_in(pos);
	    tx <= buff;				-- wypisanie bitu
	    
	    if(pos < 7) then
		pos <= pos + 1;			-- przejscie na kolejny bit
	    else
	        pos <= 0;			-- resetujemy pozycje, gdy dochodzimy do konca bajtu
	    end if;
            
	end if;
    
    end process;

end Behavioral;

