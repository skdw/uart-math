library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity receiver is
        port ( rx : in std_logic;
					rst: in std_logic;
                        clk : in std_logic;
                        data_out : out std_logic_vector (7 downto 0);
GOTOWE : out std_logic;
BLAD : out std_logic;
ind:out integer range 0 to 9								);
								
end receiver;

architecture behavioural of receiver is
signal count : std_logic;								--flaga 
signal counter : integer range 0 to 3;
signal state : integer range 0 to 9 := 0;
signal data : std_logic_vector (7 downto 0);
signal rx_p : std_logic;								--previous rx;
begin

process (clk,rst)	--bufer
begin
if (rst = '1') then
data_out  <= (others => '0');
GOTOWE <='0';
BLAD <='0';
count<='0';
elsif (clk = '1' and clk'event) then

if (rx_p = '1' and rx = '0') then       -- jesli start        count <= '1';
        rx_p <= rx;
		  count<='1';
		  GOTOWE<='0';
		  BLAD<='0';
else rx_p <= rx;
end if;

if (counter = 2) then
case (state) is
        when 0 =>
                        if (rx = '0') then   
										  ind<=state;     -- jeszcze raz sprawdzamy start bit
                                state <= 1;   
                        else 
											BLAD<='1';
											state <= 0;
										  ind<=state;
                                count <= '0';
                        end if;
        when 1 => data(0) <= rx;        -- zapisujemy bity po kolei
										  ind<=state;
                                state <= 2;
        when 2 => data(1) <= rx;
										  ind<=state;
                                state <= 3;
        when 3 => data(2) <= rx;
										  ind<=state;
                                state <= 4;
        when 4 => data(3) <= rx;
										  ind<=state;
                                state <= 5;
        when 5 => data(4) <= rx;
										  ind<=state;
                                state <= 6;
        when 6 => data(5) <= rx;
										  ind<=state;
                                state <= 7;
        when 7 => data(6) <= rx;
										  ind<=state;
                                state <= 8;
        when 8 => data(7) <= rx;
										  ind<=state;
                                state <= 9;
        when 9 => 
										  ind<=state;
										  state <= 0;
                        count <= '0';
                        if (rx = '1') then              -- sprawdzamy stop bit
                                data_out <= data;       -- zwracamy caly bufer
										  GOTOWE <='1';
								else
									BLAD<='1';
                        end if;
end case;
end if;

end if;
end process;

process (clk)
begin
if (clk = '1' and clk'event) then       
        if (count = '1') then
                counter <= (counter + 1)mod 4;         -- счечик времени через которое считывать бит
        else counter <= 0;
        end if;
end if;
end process;

end architecture;


