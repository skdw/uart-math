----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:59:50 05/28/2020 
-- Design Name: 
-- Module Name:    modifier - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity modifier is
    Port ( data_in : in  STD_LOGIC_VECTOR (7 downto 0);
				GOTOWE: in std_logic;
           data_out : out  STD_LOGIC_VECTOR (7 downto 0) );
end modifier;

architecture Behavioral of modifier is

signal data : signed(7 downto 0) := "00000000";
begin
--  process (GOTOWE)							-- proces bezwarunkowy
--  begin								-- czesc wykonawcza procesu
--  
--		if (GOTOWE = '1') then
        data <= signed(data_in);
        data_out <= std_logic_vector(data + 1);
--		end if;
--  end process;	
end Behavioral;

