library ieee;
use ieee.std_logic_1164.all;

-- There is a bug in GHDL, the tool used to test the program, which prevents us from using a type
-- defining unconstrained arrays of unconstrained std_logic_vectors, introduced in VHDL 2008. This
-- bug becomes more tedious when it comes to two-dimensional arrays, as it is completely blocking.
-- One-dimensional support in GHDL should be in a good shape already, but not much stable.
--
-- So, instead of using VHDL 2008 features and set GHDL to use it as the standard, we'll stick to
-- the latest stable implemented standard (i.e. VHDL 2002). As a result of so, we have to define
-- everything related to std_logic_vector with zero dimensions (except the dimensions of the type
-- itself), and exercise it programmatically and logically. Just like how arrays work in C: if a is
-- a 3-by-4 array, both a[2][3] and a[11] refer to the same thing. We use this logic in the code, at
-- least in multiplexers, however it makes things just more complex. Identifiers tried to be
-- extended by the 'concat' suffix to make this more explicit.
--
-- The convension for determining the inputs is, although using reverse indices as usual (i.e. using
-- downto), the first n bits (i.e. MSBs) is for the input number 0, the second n bits for 1, and so
-- on. For example, b"0011" supposing the inputs are 2-bit each, means that, if the selector is '0',
-- then the multiplexer will return b"00". 

entity multiplexer_2_to_1 is
    generic(
        constant inout_len: natural
    );
    port(
        inputs_concat: in std_logic_vector(2 * inout_len - 1 downto 0);
        selector: in std_logic;
        result: out std_logic_vector(inout_len - 1 downto 0)
    );
end entity;

architecture structural of multiplexer_2_to_1 is
begin
    l_calculate_result:
    for i in inout_len - 1 downto 0 generate
        result(i) <=
            (inputs_concat(inout_len + i) and not selector) or
            (inputs_concat(i) and selector);
    end generate;
end architecture;
