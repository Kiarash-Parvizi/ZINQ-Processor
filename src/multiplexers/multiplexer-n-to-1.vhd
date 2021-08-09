library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;

entity multiplexer_n_to_1 is
    generic(
        constant inout_len: natural;
        constant inputs_count: natural
    );
    port(
        inputs_concat: in std_logic_vector(inputs_count * inout_len - 1 downto 0);
        -- If the multiplexer is n-bit, and n = 2^m, this long expression is m
        selector: in std_logic_vector(natural(ceil(log2(real(inputs_count)))) - 1 downto 0);
        result: out std_logic_vector(inout_len - 1 downto 0)
    );
end entity;

-- General description about what the implementation does.
--
-- Split the current multiplexer into a set of layers 2x1 multiplexers, available in multiple
-- layers. Each layer reduces one selection, and merges two inputs into one output. Thus, if the
-- multiplexer has n inputs (supposing n is a power of 2), it has exactly log2(n) layers in it.
-- Also, we have exactly n - 1 multiplexers in all layers.
--
-- It may seem obvious, but the multiplexers count in each layer differ, and each layer has two
-- times more multiplexers than the previous one. Also, starting from the biggest layer (i.e. the
-- closest to the inputs), the selector bit is less significant than the smaller ones.
--
-- This is how we index things: We index the layers and multiplexers from the biggest one (i.e.
-- with most number of 2x1 multiplexers). It does not make much sense to know how multiplexers are
-- indexed within a layer, but suppose the index starts from the upmost multiplexer downwards.
--
-- Note that, as our multiplexer accepts n if it is not a power of 2, so we round that up to the
-- first number meeting the condition. Saying so, some inputs remain uninitialized, and if the
-- selector chooses one these inputs, either intensionally or by accident, the results will be
-- useless.
architecture structural of multiplexer_n_to_1 is
    component multiplexer_2_to_1 is
        generic(
            constant inout_len: natural
        );
        port(
            inputs_concat: in std_logic_vector(2 * inout_len - 1 downto 0);
            selector: in std_logic;
            result: out std_logic_vector(inout_len - 1 downto 0)
        );
    end component;

    constant selector_len: natural := natural(ceil(log2(real(inputs_count))));
    constant n: natural := 2 ** selector_len;

    -- To handle layer interconnections, we must define some connections (i.e. singals).
    --
    -- First, inputs of each layer is the outputs of the previous one.
    --
    -- For an n to 1 multiplexer, in the current implementation, considering all distinct
    -- connections (including the ones from the outside, i.e. inputs and outputs of the component),
    -- we must have exactly 2n - 1 of these connections.
    --
    -- We index each connection based on the multiplexer it is the input of. If you suppose a
    -- multiplexer with index k, then its first input connection (i.e. being selected when the
    -- selector is '0') is 2k, and the second one is 2k + 1. In other words, if a connection is
    -- the output of a multiplexer with index k, then its index is k + n. Keep in mind, indexes
    -- start from zero.
    --
    -- Each connection has a specific length, aka inout_len, so we must take it into consideration.
    --
    -- For keeping consistensy with the inputs, the connections with less index has a lefter-most
    -- position. For instance, the left-most bits (with the count of inout_len) constructs the
    -- connection number 0. Also, to avoid complexity of the code, we use forward keys instead
    -- (i.e. using to instead of downto).
    signal connections: std_logic_vector(0 to (2*n - 1) * (inout_len) - 1);
begin
    -- Initialize the inputs of the layer number 0
    connections(0 to inputs_count * inout_len - 1) <= inputs_concat;

    -- Layer number is needed for selecting selector bit
    l_iterate_layers:
    for layer_num in 0 to selector_len - 1 generate
        -- How calculated? Have a good time. :)
        constant mux_min_index: natural := n - (2 ** (selector_len - layer_num));
        constant mux_max_index: natural := n - (2 ** (selector_len - 1 - layer_num) + 1);
    begin
        l_generate_2x1_multiplexers:
        for mux_num in mux_min_index to mux_max_index generate
            mux_2x1: multiplexer_2_to_1 generic map(inout_len) port map(
                -- Remember 2k and 2k + 1? Just add an inout_len into it!
                connections(2 * mux_num * inout_len to (2 * mux_num + 2) * inout_len - 1),
                selector(layer_num),
                -- Remember k + n?
                connections((mux_num + n) * inout_len to (mux_num + n + 1) * inout_len - 1)
            );
        end generate;
    end generate;

    result <= connections((2*n - 2) * inout_len to (2*n - 1) * inout_len - 1);
end architecture;
