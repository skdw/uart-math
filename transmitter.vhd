library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;

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
           tx : out  STD_LOGIC;
ind:out integer range 0 to 9);			-- wyjscie szeregowe
end transmitter;

architecture Behavioral of transmitter is

    signal pos: natural range 0 to 7;		-- pozycja
    signal buff: STD_LOGIC_VECTOR(7 downto 0);			-- bufor
	 signal count : std_logic;								--flaga 
	 signal counter : integer range 0 to 3;
	 signal state : integer range 0 to 10;
begin
    
process (r, clk)			
begin
if(r='1') then				-- asynchroniczna inicjalizacja rejestrow
	pos <= 0;
	count<='0';
	tx<='0';
ind<=state;
	state<= 0;
elsif(rising_edge(clk)) then
		
		if(count='0') then
				tx<='1';
				if(unsigned(buff)/=unsigned(data_in)) then
					buff<=data_in;
					count<='1';
				end if;
		
		elsif (counter = 0) then
case (state) is
        when 0 =>
										  tx<='0';   --start bit
											state <= 1;
										  ind<=state;
        when 1 => tx <= buff(0);        -- zapisujemy bity po kolei
                                state <= 2;
										  ind<=state;
        when 2 => tx <= buff(1);
                               state <= 3;
										  ind<=state;
        when 3 => tx <= buff(2);
                                state <= 4;
										  ind<=state;
        when 4 => tx <= buff(3);
                                state <= 5;
										  ind<=state;
        when 5 => tx <= buff(4);
                                state <= 6;
										  ind<=state;
        when 6 => tx <= buff(5);
                                state <= 7;
										  ind<=state;
        when 7 => tx <= buff(6);
                                state <= 8;
										  ind<=state;
        when 8 => tx <= buff(7);
                                state <= 9;
										  ind<=state;
        when 9 =>
										  state <= 10;
										  ind<=state;
								tx<='1'; -- stop bit
		when 10 =>
										  state <= 0;
										  ind<=state;
											count <= '0';
											tx<='1';  -- czekamy ma kolejne dane
end case;
end if;

		end if;
    end process;
	 
	 
process (clk)
begin
if (clk = '1' and clk'event) then       
        if (count = '1') then
                counter <= (counter + 1)mod 4;         -- ������ ������� ����� ������� ��������� ���
        else counter <= 0;
        end if;
end if;
end process;

end Behavioral;

