library ieee;
use ieee.std_logic_1164.all;

entity test_sign_extend is
end entity;

architecture structural of test_sign_extend is
    component sign_extend is
        generic(
            src_bit_count: natural;
            dest_bit_count: natural
        );
        port(
            n: in std_logic_vector(src_bit_count - 1 downto 0);
            result: out std_logic_vector(dest_bit_count - 1 downto 0)
        );
    end component;

    -- bc: bit count
    constant bc_1: natural := 4;
    constant bc_2: natural := 8;
    constant bc_3: natural := 3;

    signal in_1_1, in_1_2: std_logic_vector(bc_1 - 1 downto 0);
    signal out_2_1, out_2_2: std_logic_vector(bc_2 - 1 downto 0);
    signal in_3, out_3: std_logic_vector(bc_3 - 1 downto 0);

    signal dummy: bit;
begin
    in_1_1 <= b"0111";
    in_1_2 <= b"1100";
    in_3 <= b"101";

    greater_bit_count_1: sign_extend generic map(bc_1, bc_2) port map(in_1_1, out_2_1);
    greater_bit_count_2: sign_extend generic map(bc_1, bc_2) port map(in_1_2, out_2_2);
    equal_bit_count: sign_extend generic map(bc_3, bc_3) port map(in_3, out_3);

    dummy <= '0' after 10 ns;
end architecture;
