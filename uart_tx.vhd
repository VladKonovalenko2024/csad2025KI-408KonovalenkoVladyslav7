library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
    Port (
        clk       : in  STD_LOGIC;              
        reset     : in  STD_LOGIC;             
        tx_start  : in  STD_LOGIC;              
        data_in   : in  STD_LOGIC_VECTOR(7 downto 0);
        baud_tick : in  STD_LOGIC;             
        tx_done   : out STD_LOGIC;              
        txd       : out STD_LOGIC              
    );
end uart_tx;

architecture Behavioral of uart_tx is
    type state_type is (IDLE, START, DATA, STOP);  
    signal state : state_type := IDLE;             
    signal bit_counter : integer range 0 to 7 := 0;  
    signal data_reg : STD_LOGIC_VECTOR(7 downto 0);  
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            txd <= '1';           
            tx_done <= '0';
            bit_counter <= 0;
            data_reg <= (others => '0');
        elsif rising_edge(clk) then
            if baud_tick = '1' then
                case state is
                    when IDLE =>
                        txd <= '1';
                        tx_done <= '0';
                        if tx_start = '1' then
                            data_reg <= data_in;  
                            state <= START;
                        end if;
                    when START =>
                        txd <= '0';          
                        state <= DATA;
                    when DATA =>
                        txd <= data_reg(bit_counter);  
                        if bit_counter = 7 then
                            bit_counter <= 0;
                            state <= STOP;
                        else
                            bit_counter <= bit_counter + 1;
                        end if;
                    when STOP =>
                        txd <= '1';          
                        tx_done <= '1';
                        state <= IDLE;
                end case;
            end if;
        end if;
    end process;
end Behavioral;
