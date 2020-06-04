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
               ind:out integer range 0 to 9);
								
end receiver;

architecture behavioural of receiver is
signal count : std_logic;						-- flaga 
signal counter : integer range 0 to 3;
signal state : integer range 0 to 9 := 0;
signal data : std_logic_vector (7 downto 0);
signal rx_p : std_logic;						-- poprzednie rx;
begin

process (clk,rst)	 						-- bufor
begin
if (rst = '1') then
data_out <= (others => '0');
GOTOWE <='0';
BLAD <='0';
count<='0';
elsif (clk = '1' and clk'event) then

if (rx_p = '1' and rx = '0') then       				-- jesli start   count <= '1';
        rx_p <= rx;
	count<='1';
	GOTOWE<='0';
	BLAD<='0';
else rx_p <= rx;
end if;

if (counter = 2) then
case (state) is
        when 0 =>
            if (rx = '0') then       					-- jeszcze raz sprawdzamy start bit
                state <= 1;  
		ind<=state;  
            else 
		BLAD<='1';
		state <= 0;
		ind<=state;
                count <= '0';
            end if;
        when 1 => data(0) <= rx;        				-- zapisujemy bity po kolei
                state <= 2;
                ind<=state;
        when 2 => data(1) <= rx;
                state <= 3;
                ind<=state;
        when 3 => data(2) <= rx;
                state <= 4;
                ind<=state;
        when 4 => data(3) <= rx;
                state <= 5;
                ind<=state;
        when 5 => data(4) <= rx;
                state <= 6;
                ind<=state;
        when 6 => data(5) <= rx;
                state <= 7;
                ind<=state;
        when 7 => data(6) <= rx;
                state <= 8;
                ind<=state;
        when 8 => data(7) <= rx;
                state <= 9;
                ind<=state;
        when 9 => 
                state <= 0;
                ind<=state;
                count <= '0';
                if (rx = '1') then              			-- sprawdzamy stop bit
                    data_out <= data;       				-- zwracamy caly bufor
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
                counter <= (counter + 1)mod 4;         			-- zwiekszamy licznik az do dlugosci bodu
        else counter <= 0;
        end if;
end if;

end process;

end architecture;


