library ieee;
use ieee.std_logic_1164.all;

entity test_ram is
end entity;

architecture structural of test_ram is
    component ram is
        port (
            clock   : in  std_logic;
            we      : in  std_logic;
            address : in  std_logic_vector;
            datain  : in  std_logic_vector;
            dataout : out std_logic_vector
        );
    end component;
    --
    constant N: integer := 8;
    signal datain  : std_logic_vector(N-1 downto 0);
    signal dataout : std_logic_vector(N-1 downto 0);
    signal address: std_logic_vector(2 downto 0);
    signal clk : std_logic := '0';
    signal we  : std_logic;
begin
    test0: process is begin
        we <= '1';
        ---
        clk <= '0';
        address <= "101"; datain <= "10100101";
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        address <= "110"; datain <= "10111101";
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        we <= '0';
        wait for 10 ns;
        address <= "101";
        wait for 10 ns;
        address <= "110";
        wait for 10 ns;
        wait;
    end process;
    instance: ram port map(
        clk, we, address, datain, dataout
    );
end architecture;
