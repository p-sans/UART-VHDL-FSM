library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- Add this library to use the 'finish' command properly
use std.env.all; 

entity uart_tb is
end uart_tb;

architecture sim of uart_tb is
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal tx_start : std_logic := '0';
    signal tick     : std_logic;
    signal tx_done  : std_logic;
    signal rx_done  : std_logic;
    signal serial   : std_logic;
    signal data_in  : std_logic_vector(7 downto 0) := "10100101"; 
    signal data_out : std_logic_vector(7 downto 0);
begin
    -- Clock: 50MHz
    clk <= not clk after 10 ns; 

    -- Port Mapping (Using Named Association for safety)
    B_GEN: entity work.baud_gen 
        port map(clk => clk, reset => reset, tick => tick);

    TX_MOD: entity work.uart_tx 
        port map(clk => clk, reset => reset, tx_start => tx_start, 
                 s_tick => tick, din => data_in, tx_done => tx_done, tx => serial);

    RX_MOD: entity work.uart_rx 
        port map(clk => clk, reset => reset, rx => serial, 
                 s_tick => tick, rx_done => rx_done, dout => data_out);

    process
    begin
        -- Initial Reset
        reset <= '1'; 
        wait for 40 ns; 
        reset <= '0';
        
        -- Start Transmission
        wait for 20 ns;
        tx_start <= '1'; 
        wait for 20 ns; 
        tx_start <= '0';
        
        -- Wait for Completion
        wait until rx_done = '1';
        wait for 100 ns;
        
        -- Verify Result
        assert (data_in = data_out) report "DATA MATCHED!" severity note;
        
        report "Simulation Finished Successfully!";
        finish; -- This now works because of 'use std.env.all'
    end process;
end sim;
