library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    Port (
        clk       : in  STD_LOGIC;              
        reset     : in  STD_LOGIC;            
        rxd       : in  STD_LOGIC;              
        baud_tick : in  STD_LOGIC;             
        data_out  : out STD_LOGIC_VECTOR(7 downto 0);)
        data_valid: out STD_LOGIC            
    );
end uart_rx;

architecture Behavioral of uart_rx is
    type state_type is (IDLE, START, DATA, STOP);  
    signal state : state_type := IDLE;             
    signal bit_counter : integer range 0 to 7 := 0;  
    signal data_reg : STD_LOGIC_VECTOR(7 downto 0);  
    signal sample_counter : integer range 0 to 15 := 0; 
    constant MID_SAMPLE : integer := 7;  
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state <= IDLE;
            data_valid <= '0';
            bit_counter <= 0;
            sample_counter <= 0;
            data_reg <= (others => '0');
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            if baud_tick = '1' then
                case state is
                    when IDLE =>
                        data_valid <= '0';
                        if rxd = '0' then
                            state <= START;
                            sample_counter <= 0;
                        end if;
                    when START =>
                        if sample_counter = MID_SAMPLE then
                            if rxd = '0' then
                                state <= DATA;
                                sample_counter <= 0;
                            else
                                state <= IDLE;
                            end if;
                        else
                            sample_counter <= sample_counter + 1;
                        end if;
                    when DATA =>
                        if sample_counter = MID_SAMPLE then
                            data_reg(bit_counter) <= rxd;
                            if bit_counter = 7 then
                                state <= STOP;
                                bit_counter <= 0;
                            else
                                bit_counter <= bit_counter + 1;
                            end if;
                            sample_counter <= 0;
                        else
                            sample_counter <= sample_counter + 1;
                        end if;
                    when STOP =>
                        if sample_counter = MID_SAMPLE then
                            if rxd = '1' then
                                data_out <= data_reg;
                                data_valid <= '1';
                                state <= IDLE;
                            else
                                state <= IDLE;
                            end if;
                        else
                            sample_counter <= sample_counter + 1;
                        end if;
                end case;
            end if;
        end if;
    end process;
end Behavioral;
