library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test_rom is
end entity;

architecture structural of test_rom is
    component rom is
        port(
            address: in  std_logic_vector(7 downto 0);
            dataout: out std_logic_vector(15 downto 0)
        );
    end component;
    --
    signal addr: std_logic_vector(7 downto 0);
    signal data: std_logic_vector(15 downto 0);
begin
    rom_inst: rom port map(addr, data);
    process is begin
        addr <= (others => '0');
        wait for 10 ns;
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait for 10 ns;
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait for 10 ns;
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait for 10 ns;
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait for 10 ns;
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait for 10 ns;
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait for 10 ns;
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait for 10 ns;
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait for 10 ns;
        addr <= std_logic_vector(unsigned(addr) + 1);
        wait;
    end process;
end architecture;
