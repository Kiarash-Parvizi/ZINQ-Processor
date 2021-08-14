library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.or_reduce;

entity alu is
    generic(N: integer);
    port(
        a : in std_logic_vector(N-1 downto 0);
        b : in std_logic_vector(N-1 downto 0);
        alu_op : in std_logic := '0';
        z : inout std_logic_vector(N-1 downto 0);
        alu_zero: out std_logic;
        alu_borrow: out std_logic
    );
end entity;

architecture structural of alu is
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
    signal cout: std_logic;
begin
    add_sub: add_sub_n_bit generic map(N)
        port map(a, b, alu_op, z, cout, alu_borrow);
    alu_zero <= not or_reduce(z);

end architecture;
