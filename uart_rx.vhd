library ieee;
use ieee.std_logic_1164.all;

entity uart_rx is
    port (
        clk, reset : in  std_logic;
        rx         : in  std_logic;
        s_tick     : in  std_logic;
        rx_done    : out std_logic;
        dout       : out std_logic_vector(7 downto 0)
    );
end uart_rx;

architecture arch of uart_rx is
    type state_type is (idle, start, data, stop);
    signal state_reg, state_next : state_type;
    signal s_reg, s_next : integer range 0 to 15 := 0;
    signal n_reg, n_next : integer range 0 to 7 := 0;
    signal b_reg, b_next : std_logic_vector(7 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state_reg <= idle;
        elsif rising_edge(clk) then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
        end if;
    end process;

    process(state_reg, s_reg, n_reg, b_reg, s_tick, rx)
    begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        rx_done <= '0';

        case state_reg is
            when idle =>
                if rx = '0' then
                    state_next <= start;
                    s_next <= 0;
                end if;
            when start =>
                if s_tick = '1' then
                    if s_reg = 7 then -- Middle of start bit
                        state_next <= data;
                        s_next <= 0;
                        n_next <= 0;
                    else s_next <= s_reg + 1;
                    end if;
                end if;
            when data =>
                if s_tick = '1' then
                    if s_reg = 15 then
                        s_next <= 0;
                        b_next <= rx & b_reg(7 downto 1);
                        if n_reg = 7 then state_next <= stop;
                        else n_next <= n_reg + 1; end if;
                    else s_next <= s_reg + 1;
                    end if;
                end if;
            when stop =>
                if s_tick = '1' then
                    if s_reg = 15 then
                        state_next <= idle;
                        rx_done <= '1';
                    else s_next <= s_reg + 1;
                    end if;
                end if;
        end case;
    end process;
    dout <= b_reg;
end arch;
