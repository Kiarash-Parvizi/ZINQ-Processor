library ieee;
use ieee.std_logic_1164.all;

entity add_sub_n_bit is
    generic(N: integer);
    port(
        a : in std_logic_vector(N-1 downto 0);
        b : in std_logic_vector(N-1 downto 0);
        is_sub: in std_logic := '0';
        z : out std_logic_vector(N-1 downto 0);
        cout : out std_logic;
        borrow: out std_logic
    );
end entity;

architecture structural of add_sub_n_bit is
    signal carry: std_logic_vector(N downto 0) := (others => '0');
    signal bm: std_logic_vector(N-1 downto 0);
    signal axb: std_logic_vector(N-1 downto 0);
    signal z_sign: std_logic;
begin
    z_sign <= carry(N-1) xor axb(N-1);
    carry(0) <= is_sub;
    cout <= carry(N);
    borrow <= (not a(N-1) and z_sign and not b(N-1)) or
              (a(N-1) and z_sign and b(N-1)) or
              (a(N-1) and not b(N-1));

    -- generator func:
    g0: for i in N downto 1 generate
            bm(i-1)  <= b(i-1) xor carry(0);
            axb(i-1) <= a(i-1) xor bm(i-1);
            z(i-1) <= carry(i-1) xor axb(i-1);
            carry(i) <= (a(i-1) and bm(i-1)) or
                        (axb(i-1) and carry(i-1));
    end generate g0;
end architecture;
