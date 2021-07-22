library ieee;
use ieee.std_logic_1164.all;
use work.types.std_logic_vector_2d_array;

entity multiplexer_n_to_1 is
    generic(
        constant inout_len: natural;
        constant inputs_count: natural;
        constant selector_len: natural := natural(ceil(log2(real(inputs_count))))
    );
    port(
        inputs: in std_logic_vector_array(inputs_count - 1 downto 0)(inout_len - 1 downto 0);
        selector: in std_logic_vector(selector_len - 1 downto 0);
        result: out std_logic_vector(inout_len - 1 downto 0)
    );
end entity;

architecture structural of multiplexer_n_to_1 is
    component multiplexer_2_to_1 is
        generic(
            constant inout_len: natural
        );
        port(
            inputs: in std_logic_vector_array(2 - 1 downto 0)(inout_len - 1 downto 0);
            selector: in std_logic;
            result: out std_logic_vector(inout_len - 1 downto 0)
        );
    end component;

    -- n must be a power of 2
    constant n: natural := 2 ** selector_len;

    -- The inputs to give to each layer of multiplexers (refer to the comment below).
    --
    -- To prevent overcomplicating things, we define the maximum inputs needed for all layers,
    -- which belongs to first layer (i.e. that equals to n), for all other layers as well. As a
    -- result, some inputs defined here might remain unused (i.e. uninitialized). The ones that are
    -- used in the implementation is the first-most ones.
    --
    -- Also, as the inputs of the current layer are the outputs of the previous one, for n = 8 for
    -- example, we have to consider 4 layers instead of 3; as the last output is the output of the
    -- entity and must be stored.
    signal layer_inputs: std_logic_vector_2d_array
        (selector_len + 1 - 1 downto 0, n - 1 downto 0)(inout_len - 1 downto 0);
begin
    -- After this loop, some inputs for the first layer should remain unintialized, as we suppose
    -- there is no need to them; because, otherwise the inputs count must differ.
    l_initialize_first_layer_inputs:
    for input_num in inputs_count - 1 downto 0 generate
        layer_inputs(0, input_num) <= inputs(input_num);
    end generate;

    -- Split the multiplexer into multiple layers consisting of some 2x1 multiplexers, and then
    -- merge them until making the final result. Obviously, each layer has twice multiplexers as
    -- the previous one.
    l_iterate_layers:
    for layer_num in 0 to selector_len - 1 generate
        constant mux_count: natural := 2 ** ((selector_len - 1) - layer_num);
    begin
        l_generate_current_layer:
        for mux_num in 0 to mux_count - 1 generate
            mux_2x1: multiplexer_2_to_1 generic map(inout_len) port map(
                (layer_inputs(layer_num, 2 * mux_num), layer_inputs(layer_num, 2 * mux_num + 1)),
                selector(layer_num),
                layer_inputs(layer_num + 1, mux_num)
            );
        end generate;
    end generate;

    result <= layer_inputs(selector_len, 0);
end architecture;
