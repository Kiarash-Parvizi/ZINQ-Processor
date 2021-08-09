library ieee;
use ieee.std_logic_1164.all;

entity test_register_file_3 is
end entity;

architecture structural of test_register_file_3 is
    component register_file_3 is
        generic(addr_size: natural);
        port(
            -- input
            clk, rst, we: in std_logic;
            r0: in std_logic_vector(addr_size-1 downto 0);
            r1: in std_logic_vector(addr_size-1 downto 0);
            r2: in std_logic_vector(addr_size-1 downto 0);
            wr: in std_logic_vector(addr_size-1 downto 0);
            wd: in std_logic_vector((2**addr_size)-1 downto 0);
            -- output
            out0: out std_logic_vector((2**addr_size)-1 downto 0);
            out1: out std_logic_vector((2**addr_size)-1 downto 0);
            out2: out std_logic_vector((2**addr_size)-1 downto 0)
        );
    end component;
    ---- constants
    constant addr_size: natural := 3;
    ---- signals:
    -- input
    signal clk, rst, we: std_logic;
    signal r0: std_logic_vector(addr_size-1 downto 0);
    signal r1: std_logic_vector(addr_size-1 downto 0);
    signal r2: std_logic_vector(addr_size-1 downto 0);
    signal wr: std_logic_vector(addr_size-1 downto 0);
    signal wd: std_logic_vector((2**addr_size)-1 downto 0);
    -- output
    signal out0: std_logic_vector((2**addr_size)-1 downto 0);
    signal out1: std_logic_vector((2**addr_size)-1 downto 0);
    signal out2: std_logic_vector((2**addr_size)-1 downto 0);
begin
    instance: register_file_3
        generic map(addr_size)
        port map(
            clk, rst, we,
            r0  ,
            r1  ,
            r2  ,
            wr  ,
            wd  ,
            out0,
            out1,
            out2
        );
    process is begin
        rst <= '0';
        we  <= '0';
        r0 <= "000";
        r1 <= "001";
        r2 <= "010";
        wr <= "000";
        --
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        --
        clk <= '0';
        we <= '1';
        wd <= x"cd";
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        --
        clk <= '0';
        wr <= "001";
        wd <= x"0d";
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        --
        clk <= '0';
        wr <= "010";
        wd <= x"ee";
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        rst <= '1';
        wait for 10 ns;
        --
        wait;
    end process;
end architecture;
