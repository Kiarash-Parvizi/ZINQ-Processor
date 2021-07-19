library ieee;
use ieee.std_logic_1164.all;

entity test_concat is
end entity;

architecture structural of test_concat is
    component concat is
        generic(
            lhs_len: natural;
            rhs_len: natural
        );
        port(
            lhs: in std_logic_vector(lhs_len - 1 downto 0);
            rhs: in std_logic_vector(rhs_len - 1 downto 0);
            result: out std_logic_vector(lhs_len + rhs_len - 1 downto 0)
        );
    end component;

    constant len_1: natural := 3;
    constant len_2: natural := 4;

    signal val_1: std_logic_vector(len_1 - 1 downto 0);
    signal val_2: std_logic_vector(len_2 - 1 downto 0);
    signal result_1_1: std_logic_vector(len_1 + len_1 - 1 downto 0);
    signal result_1_2: std_logic_vector(len_1 + len_2 - 1 downto 0);
    signal result_2_1: std_logic_vector(len_1 + len_2 - 1 downto 0);

    signal dummy: bit;
begin
    val_1 <= b"100";
    val_2 <= b"1101";

    instance_1_1: concat generic map(len_1, len_1) port map(val_1, val_1, result_1_1);
    instance_1_2: concat generic map(len_1, len_2) port map(val_1, val_2, result_1_2);
    instance_2_1: concat generic map(len_2, len_1) port map(val_2, val_1, result_2_1);

    dummy <= '0' after 10 ns;
end architecture;
