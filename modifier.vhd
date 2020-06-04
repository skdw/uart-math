library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity modifier is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
				GOTOWE: in std_logic;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0) );
end modifier;

architecture Behavioral of modifier is

signal data : signed(7 downto 0) := "00000000";

begin

        data <= signed(data_in);
        data_out <= std_logic_vector(data + 1);
	
end Behavioral;
