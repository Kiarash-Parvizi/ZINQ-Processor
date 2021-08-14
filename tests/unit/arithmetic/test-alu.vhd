library ieee;
use ieee.std_logic_1164.all;

entity test_alu is
end entity;

architecture structural of test_alu is
    component alu is
        generic(N: integer);
        port(
            a : in std_logic_vector(N-1 downto 0);
            b : in std_logic_vector(N-1 downto 0);
            alu_op : in std_logic := '0';
            z : inout std_logic_vector(N-1 downto 0);
            alu_zero: out std_logic;
            alu_borrow: out std_logic
        );
    end component;
    constant N: integer := 4;

    signal a, b, z: std_logic_vector(N-1 downto 0);
    signal alu_op, alu_zero, alu_borrow: std_logic;
begin
    alu_op <= '1';
    --
    instance: alu generic map (N) port map(
        a, b, alu_op, z, alu_zero, alu_borrow
    );
    test0: process is begin
        a <= "1101"; b <= "0101";
        wait for 10 ns;
        a <= "1111"; b <= "1101";
        wait for 10 ns;
        a <= "1101"; b <= "1111";
        wait for 10 ns;
        a <= "0101"; b <= "0101";
        wait for 10 ns;
        a <= "0101"; b <= "0111";
        wait for 10 ns;
        a <= "0111"; b <= "0101";
        wait for 10 ns;
        a <= "0110"; b <= "0110";
        wait for 10 ns;
        a <= "0101"; b <= "1111";
        wait for 10 ns;
        a <= "0111"; b <= "1110";
        wait for 10 ns;
        wait;
    end process;
end architecture;
