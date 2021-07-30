library ieee;
use ieee.std_logic_1164.all;

entity test_add_sub_n_bit is
end entity;

architecture structural of test_add_sub_n_bit is
    component add_sub_n_bit is
    	generic(N: integer);
    	port(
    		a : in std_logic_vector(N-1 downto 0);
    		b : in std_logic_vector(N-1 downto 0);
            is_sub: in std_logic := '0';
    		z : out std_logic_vector(N-1 downto 0);
    		cout : out std_logic;
            borrow: out std_logic
    	);
    end component;
	-- helper vars
	constant N: integer := 4;
	signal a : std_logic_vector(N-1 downto 0);
	signal b : std_logic_vector(N-1 downto 0);
	signal z : std_logic_vector(N-1 downto 0);
	signal cout, borrow : std_logic;
    signal is_sub : std_logic := '1';
	--
begin
    uut0: add_sub_n_bit generic map(N)
        port map(a, b, is_sub, z, cout, borrow);
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
