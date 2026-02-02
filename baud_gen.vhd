library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity baud_gen is
    port (
        clk      : in  std_logic;
        reset    : in  std_logic; -- Added this port
        tick     : out std_logic
    );
end baud_gen;

architecture arch of baud_gen is
    -- For 9600 baud with 50MHz clock: 50MHz / (9600 * 16) = 326
    signal count : unsigned(9 downto 0) := (others => '0');
begin
    process(clk, reset)
    begin
        if reset = '1' then
            count <= (others => '0');
            tick  <= '0';
        elsif rising_edge(clk) then
            if count = 325 then
                count <= (others => '0');
                tick  <= '1';
            else
                count <= count + 1;
                tick  <= '0';
            end if;
        end if;
    end process;
end arch;
