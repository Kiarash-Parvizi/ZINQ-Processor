library ieee;
use ieee.std_logic_1164.all;

entity test_sign_extend is
end entity;

architecture structural of test_sign_extend is
    component sign_extend is
        generic(
            constant src_len: natural;
            constant dest_len: natural
        );
        port(
            n: in std_logic_vector(src_len - 1 downto 0);
            result: out std_logic_vector(dest_len - 1 downto 0)
        );
    end component;

    constant len_1: natural := 4;
    constant len_2: natural := 8;
    constant len_3: natural := 3;

    signal in_1_1, in_1_2: std_logic_vector(len_1 - 1 downto 0);
    signal out_2_1, out_2_2: std_logic_vector(len_2 - 1 downto 0);
    signal in_3, out_3: std_logic_vector(len_3 - 1 downto 0);

    signal dummy: bit;
begin
    in_1_1 <= b"0111";
    in_1_2 <= b"1100";
    in_3 <= b"101";

    greater_len_1: sign_extend generic map(len_1, len_2) port map(in_1_1, out_2_1);
    greater_len_2: sign_extend generic map(len_1, len_2) port map(in_1_2, out_2_2);
    equal_len: sign_extend generic map(len_3, len_3) port map(in_3, out_3);

    dummy <= '0' after 10 ns;
end architecture;
