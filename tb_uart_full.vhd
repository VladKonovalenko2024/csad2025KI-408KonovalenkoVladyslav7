library IEEE;
use IEEE.STD_LOGIC_1164.ALL;  
use IEEE.NUMERIC_STD.ALL;     

entity tb_uart_tx is
end tb_uart_tx;  

architecture Behavioral of tb_uart_tx is
    component baud_rate_gen
        Port (
            clk      : in  STD_LOGIC;  -- Input clock signal (50 MHz)
            reset    : in  STD_LOGIC;  -- Asynchronous reset signal
            baud_tick: out STD_LOGIC   -- Output tick signal for 9600 baud rate
        );
    end component;

    component uart_tx
        Port (
            clk       : in  STD_LOGIC;              -- Input clock signal (50 MHz)
            reset     : in  STD_LOGIC;              -- Asynchronous reset signal
            tx_start  : in  STD_LOGIC;              -- Start transmission signal
            data_in   : in  STD_LOGIC_VECTOR(7 downto 0); -- 8-bit input data
            baud_tick : in  STD_LOGIC;              -- Baud rate tick for synchronization
            tx_done   : out STD_LOGIC;              -- Transmission complete flag
            txd       : out STD_LOGIC               -- Serial output data line
        );
    end component;
    
    signal clk : STD_LOGIC := '0';         -- Clock signal, initially low
    signal reset : STD_LOGIC := '1';       -- Reset signal, initially active high
    signal tx_start : STD_LOGIC := '0';    -- Signal to start transmission
    signal data_in : STD_LOGIC_VECTOR(7 downto 0) := "10101010";  -- Test data (binary)
    signal baud_tick : STD_LOGIC;          -- Baud rate tick from generator
    signal tx_done : STD_LOGIC;            -- Flag for transmission completion
    signal txd : STD_LOGIC;                -- Serial output from transmitter
    constant CLK_PERIOD : time := 20 ns;   -- Clock period for 50 MHz (20 ns)

begin
    clk_process: process
    begin
        clk <= '0'; wait for CLK_PERIOD/2;  -- Low for 10 ns
        clk <= '1'; wait for CLK_PERIOD/2;  -- High for 10 ns
    end process;  

    uut_baud: baud_rate_gen port map (
        clk => clk,      -- Connect to clock signal
        reset => reset,  -- Connect to reset signal
        baud_tick => baud_tick  -- Connect to baud rate tick output
    );

    uut_tx: uart_tx port map (
        clk => clk,       -- Connect to clock signal
        reset => reset,   -- Connect to reset signal
        tx_start => tx_start,  -- Connect to start transmission signal
        data_in => data_in,    -- Connect to test data input
        baud_tick => baud_tick,-- Connect to baud rate tick
        tx_done => tx_done,    -- Connect to transmission done flag
        txd => txd            -- Connect to serial output
    );
    
    stim_proc: process
    begin
        -- Apply reset for 100 ns
        wait for 100 ns;
        reset <= '0';  -- Deactivate reset after 100 ns
        
        -- Start transmission after 100 ns (total 200 ns)
        wait for 100 ns;  
        tx_start <= '1';  -- Activate transmission start
        wait for 20 ns;   -- Hold for 20 ns (200–220 ns)
        tx_start <= '0';  -- Deactivate start signal
        
        -- Wait for transmission to complete (~1 ms for 10 bits at 9600 baud)
        wait for 1 ms;
        wait;  
    end process;
end Behavioral;
