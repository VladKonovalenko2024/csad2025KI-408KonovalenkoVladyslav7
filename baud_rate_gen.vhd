library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_uart_tx is
end tb_uart_tx;

architecture Behavioral of tb_uart_tx is
    component baud_rate_gen
        Port ( clk : in STD_LOGIC; reset : in STD_LOGIC; baud_tick : out STD_LOGIC );
    end component;
    component uart_tx
        Port ( clk : in STD_LOGIC; reset : in STD_LOGIC; tx_start : in STD_LOGIC;
               data_in : in STD_LOGIC_VECTOR(7 downto 0); baud_tick : in STD_LOGIC;
               tx_done : out STD_LOGIC; txd : out STD_LOGIC );
    end component;
    
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';  
    signal tx_start : STD_LOGIC := '0';
    signal data_in : STD_LOGIC_VECTOR(7 downto 0) := "10101010";  
    signal baud_tick : STD_LOGIC;
    signal tx_done : STD_LOGIC;
    signal txd : STD_LOGIC;
    constant CLK_PERIOD : time := 20 ns;  
begin
    clk_process: process
    begin
        clk <= '0'; wait for CLK_PERIOD/2; 
        clk <= '1'; wait for CLK_PERIOD/2;  
    end process;
    
    uut_baud: baud_rate_gen port map (clk => clk, reset => reset, baud_tick => baud_tick);
    uut_tx: uart_tx port map (clk => clk, reset => reset, tx_start => tx_start,
                              data_in => data_in, baud_tick => baud_tick,
                              tx_done => tx_done, txd => txd);
    
    stim_proc: process
    begin
      
        wait for 100 ns;
        reset <= '0';
        
        wait for 100 ns;  
        tx_start <= '1';
        wait for 20 ns;   
        tx_start <= '0';
        
        wait for 1 ms;
        wait;
    end process;
end Behavioral;
