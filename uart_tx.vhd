library ieee;
use ieee.std_logic_1164.all;

entity uart_tx is
    port (
        clk, reset : in  std_logic;
        tx_start   : in  std_logic;
        s_tick     : in  std_logic; -- From baud_gen
        din        : in  std_logic_vector(7 downto 0);
        tx_done    : out std_logic;
        tx         : out std_logic
    );
end uart_tx;

architecture arch of uart_tx is
    type state_type is (idle, start, data, stop);
    signal state_reg, state_next : state_type;
    signal s_reg, s_next : integer range 0 to 15 := 0; -- Tick counter
    signal n_reg, n_next : integer range 0 to 7 := 0;  -- Bit counter
    signal b_reg, b_next : std_logic_vector(7 downto 0);
    signal tx_reg, tx_next : std_logic;
begin
    process(clk, reset)
    begin
        if reset = '1' then
            state_reg <= idle;
            tx_reg <= '1';
        elsif rising_edge(clk) then
            state_reg <= state_next;
            s_reg <= s_next;
            n_reg <= n_next;
            b_reg <= b_next;
            tx_reg <= tx_next;
        end if;
    end process;

    process(state_reg, s_reg, n_reg, b_reg, s_tick, tx_start, din)
    begin
        state_next <= state_reg;
        s_next <= s_reg;
        n_next <= n_reg;
        b_next <= b_reg;
        tx_next <= tx_reg;
        tx_done <= '0';

        case state_reg is
            when idle =>
                tx_next <= '1';
                if tx_start = '1' then
                    state_next <= start;
                    s_next <= 0;
                    b_next <= din;
                end if;
            when start =>
                tx_next <= '0';
                if s_tick = '1' then
                    if s_reg = 15 then
                        state_next <= data;
                        s_next <= 0;
                        n_next <= 0;
                    else
                        s_next <= s_reg + 1;
                    end if;
                end if;
            when data =>
                tx_next <= b_reg(0);
                if s_tick = '1' then
                    if s_reg = 15 then
                        s_next <= 0;
                        b_next <= '0' & b_reg(7 downto 1);
                        if n_reg = 7 then state_next <= stop;
                        else n_next <= n_reg + 1; end if;
                    else s_next <= s_reg + 1;
                    end if;
                end if;
            when stop =>
                tx_next <= '1';
                if s_tick = '1' then
                    if s_reg = 15 then
                        state_next <= idle;
                        tx_done <= '1';
                    else s_next <= s_reg + 1;
                    end if;
                end if;
        end case;
    end process;
    tx <= tx_reg;
end arch;
