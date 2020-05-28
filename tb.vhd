library ieee;
use     ieee.std_logic_1164.all;
use     ieee.std_logic_unsigned.all;
use     ieee.std_logic_misc.all;

entity receive_TB is
  generic (
    constant F_ZEGARA      :natural := 20_000_000;		-- czestotliwosc zegara systemowego w [Hz]
    constant L_BODOW       :natural := 5_000_000;		-- predkosc nadawania w [bodach]
    constant B_SLOWA       :natural := 8;			-- liczba bitow slowa danych (5-8)
    constant B_PARZYSTOSCI :natural := 1;			-- liczba bitow parzystosci (0-1)
    constant B_STOPOW      :natural := 1;			-- liczba bitow stopu (1-2)
    constant N_RX          :boolean := FALSE;			-- negacja logiczna sygnalu szeregowego
    constant N_SLOWO       :boolean := FALSE			-- negacja logiczna slowa danych
  );
end receive_TB;

architecture behavioural of receive_TB is
  
  constant O_ZEGARA	:time := 1 sec/F_ZEGARA;		-- okres zegara systemowego
  constant O_BITU	:time := 1 sec/L_BODOW;			-- okres czasu trwania jednego bodu

  signal   R		:std_logic := '0';			-- symulowany sygnal resetujacacy
  signal   C		:std_logic := '1';			-- symulowany zegar taktujacy inicjowany na '1'
  signal   RX		:std_logic;				-- symulowane wejscie 'RX'
  signal   DATA_IN	:std_logic_vector(B_SLOWA-1 downto 0);	-- obserwowane wyjscie 'DATA_IN'
  signal   DATA_OUT	:std_logic_vector(DATA_IN'range);	-- obserwowane wyjscie 'DATA_OUT'
  signal   GOTOWE	:std_logic;				-- obserwowane wyjscie 'GOTOWE'
  signal   BLAD		:std_logic;				-- obserwowane wyjscie 'BLAD'
  signal   D		:std_logic_vector(DATA_IN'range);		-- symulowana dana transmitowana
  signal   TX		:std_logic;				-- symulowane wyjscie 'TX'
  
begin

 process is							-- proces bezwarunkowy
  begin								-- czesc wykonawcza procesu
    R <= '1'; wait for 100 ns;					-- ustawienie sygnalu 'res' na '1' i odczekanie 100 ns
    R <= '0'; wait;						-- ustawienie sygnalu 'res' na '0' i zatrzymanie
  end process;							-- zakonczenie procesu

  process is							-- proces bezwarunkowy
  begin								-- czesc wykonawcza procesu
    C <= not(C); wait for O_ZEGARA/2;				-- zanegowanie sygnalu 'clk' i odczekanie pol okresu zegara
  end process;							-- zakonczenie procesu
  
  process is							-- proces bezwarunkowy
    function neg(V :std_logic; N :boolean) return std_logic is	-- deklaracja funkcji wewnetrznej 'neg'
    begin							-- czesc wykonawcza funkcji wewnetrznej
      if (N=FALSE) then return (V); end if;			-- zwrot wartosc 'V' gdy 'N'=FALSE
      return (not(V));						-- zwrot zanegowanej wartosci 'V'
    end function;						-- zakonczenie funkcji wewnetrznej
  begin								-- czesc wykonawcza procesu
    RX <= neg('1',N_RX);					-- incjalizacja sygnalu 'RX' na wartosci spoczynkowa
    D  <= (others => '0');					-- wyzerowanie sygnalu 'D'
    wait for 200 ns;						-- odczekanie 200 ns
    loop							-- rozpoczecie petli nieskonczonej
      RX <= neg('0',N_RX);					-- ustawienie 'RX' na wartosc bitu START
      wait for O_BITU;						-- odczekanie jednego bodu
      for i in 0 to B_SLOWA-1 loop				-- petla po kolejnych bitach slowa danych 'D'
        RX <= neg(neg(D(i),N_SLOWO),N_RX);			-- ustawienie 'RX' na wartosc bitu 'D(i)'
        wait for O_BITU;					-- odczekanie jednego bodu
      end loop;							-- zakonczenie petli
--      if (B_PARZYSTOSCI = 1) then				-- badanie aktywowania bitu parzystosci
--        RX <= neg(neg(XOR_REDUCE(D),N_SLOWO),N_RX);		-- ustawienie 'RX' na wartosc bitu parzystosci	
--        wait for O_BITU;					-- odczekanie jednego bodu
--      end if;							-- zakonczenie instukcji warunkowej
      for i in 0 to B_STOPOW-1 loop				-- petla po liczbie bitow STOP
        RX <= neg('1',N_RX);					-- ustawienie 'RX' na wartosc bitu STOP
        wait for O_BITU;					-- odczekanie jednego bodu
      end loop;							-- zakonczenie petli
      D <= D + 5;						-- zwiekszenia wartosci 'D' o 7
      wait for 10*O_ZEGARA;					-- odczekanie 10-ciu okresow zegara
    end loop;							-- zakonczenie petli
  end process;							-- zakonczenie procesu
  
  receiver: entity work.receiver			-- instancja odbiornika szeregowego 'SERIAL_RX'
     port map(							-- mapowanie sygnalow do portow
      clk                    => C,				-- zegar taktujacy
		rst							=>R,
      rx                   => RX,				-- odebrany sygnal szeregowy
      data_out                => DATA_IN,			-- odebrane slowo danych
      GOTOWE               => GOTOWE,				-- flaga potwierdzenia odbioru
      BLAD                 => BLAD				-- flaga wykrycia bledu w odbiorze
    );
    
  modifier: entity work.modifier
    port map (
      data_in                   => DATA_IN,			-- modyfikowane wejscie
		GOTOWE							=>GOTOWE,
      data_out                  => DATA_OUT			-- wynik
    );
	 
  transmitter: entity work.transmitter
    port map (
      r				=> R,				-- sygnal resetujacy
      clk			=> C,				-- zegar taktujacy
      data_in			=> DATA_OUT,			-- wysylane slowo danych
      tx			=> TX				-- szeregowe wyjscie
    );

end behavioural;

