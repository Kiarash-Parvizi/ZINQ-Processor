library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity data_path is
    port(
        clk: in std_logic;
        rst: in std_logic;

        we_mrf: in std_logic;
        we_bank: in std_logic;
        we_mem: in std_logic;

        sel_pc: in std_logic_vector(1 downto 0);
        sel_pc_beon: in std_logic;
        sel_pc_bgti: in std_logic;

        sel_mrf_wr: in std_logic_vector(1 downto 0);
        sel_mrf_wd: in std_logic_vector(2 downto 0);
        sel_rd_cmpi: in std_logic;
        sel_rd_beon: in std_logic;

        sel_bank_wr: in std_logic;

        sel_alu_lhs: in std_logic_vector(2 downto 0);
        sel_alu_rhs: in std_logic_vector(1 downto 0);
        -- TODO: Convert to std_logic_vector
        alu_op: in std_logic;

        sel_mem_addr: in std_logic;

        opc: out std_logic_vector(2 downto 0);
        funct: out std_logic_vector(1 downto 0);
        q: out std_logic;
        alu_zero: out std_logic;
        alu_borrow: out std_logic
    );
end entity;

architecture structural of data_path is
    -- component | alu
    component alu is
        generic(N: integer);
        port(
            a : in std_logic_vector(N-1 downto 0);
            b : in std_logic_vector(N-1 downto 0);
            alu_op : in std_logic := '0';
            z : inout std_logic_vector(N-1 downto 0);
            alu_zero: out std_logic;
            alu_borrow: out std_logic
        );
    end component;
    -- component | sign_extend
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
    -- component | zero_extend
    component zero_extend is
        generic(
            constant src_len: natural;
            constant dest_len: natural
        );
        port(
            n: in std_logic_vector(src_len - 1 downto 0);
            result: out std_logic_vector(dest_len - 1 downto 0)
        );
    end component;
    -- component | concat
    component concat is
        generic(
            constant lhs_len: natural;
            constant rhs_len: natural
        );
        port(
            lhs: in std_logic_vector(lhs_len - 1 downto 0);
            rhs: in std_logic_vector(rhs_len - 1 downto 0);
            result: out std_logic_vector(lhs_len + rhs_len - 1 downto 0)
        );
    end component;
    -- component | pow_base_4
    component pow_base_4 is
        generic(
            constant n: natural;
            constant exponent_len: natural
        );
        port(
            exponent: in std_logic_vector(exponent_len - 1 downto 0);
            result: out std_logic_vector(n - 1 downto 0)
        );
    end component;
    -- component | shift_to_left
    component shift_to_left is
        generic(
            constant n: natural;
            constant shift_amount_len: natural
        );
        port(
            num: in std_logic_vector(n - 1 downto 0);
            shift_amount: in std_logic_vector(shift_amount_len - 1 downto 0);
            result: out std_logic_vector(n - 1 downto 0)
        );
    end component;
    -- component | shift_to_left_const
    component shift_to_left_const is
        generic(
            constant len: natural;
            constant shift_amount: natural := 1
        );
        port(
            num: in std_logic_vector(len - 1 downto 0);
            result: out std_logic_vector(len - 1 downto 0)
        );
    end component;
    -- component | register_n_bit
    component register_n_bit is
        generic(
            constant n: natural
        );
        port(
            data: in std_logic_vector(n - 1 downto 0);
            clock: in std_logic;
            result: out std_logic_vector(n - 1 downto 0);
            reset: in std_logic := '0';
            enable: in std_logic := '1'
        );
    end component;
    -- component | ram
    component ram is
        port (
            clock   : in  std_logic;
            we      : in  std_logic;
            address : in  std_logic_vector;
            datain  : in  std_logic_vector;
            dataout : out std_logic_vector
        );
    end component;
    -- component | rom
    component rom is
        port(
            address: in  std_logic_vector(15 downto 0);
            data_out: out std_logic_vector(15 downto 0)
        );
    end component;
    -- component register_file_3
    component register_file_3 is
        generic(
            constant addr_size: natural;
            constant n: natural
        );
        port(
            -- input
            clk, rst, we: in std_logic;
            r0: in std_logic_vector(addr_size-1 downto 0);
            r1: in std_logic_vector(addr_size-1 downto 0);
            r2: in std_logic_vector(addr_size-1 downto 0);
            wr: in std_logic_vector(addr_size-1 downto 0);
            wd: in std_logic_vector(n-1 downto 0);
            -- output
            out0: out std_logic_vector(n-1 downto 0);
            out1: out std_logic_vector(n-1 downto 0);
            out2: out std_logic_vector(n-1 downto 0)
        );
    end component;
    -- component | register_file_1
    component register_file_1 is
        generic(
            constant addr_size: natural;
            constant n: natural
        );
        port(
            -- input
            clk, rst, we: in std_logic;
            r0: in std_logic_vector(addr_size-1 downto 0);
            wr: in std_logic_vector(addr_size-1 downto 0);
            wd: in std_logic_vector(n-1 downto 0);
            -- output
            out0: out std_logic_vector(n-1 downto 0)
        );
    end component;

    component full_adder_n_bit is
        generic(
            constant n: natural
        );
        port(
            a, b: in std_logic_vector(n - 1 downto 0);
            cin: in std_logic := '0';

            sum: out std_logic_vector(n - 1 downto 0);
            cout: out std_logic
        );
    end component;

    component multiplexer_1_bit_selector is
        generic(n: natural);
        port(
            inp_0 : in std_logic_vector(n-1 downto 0);
            inp_1 : in std_logic_vector(n-1 downto 0);

            sel: in std_logic;
            dataout: out std_logic_vector(n-1 downto 0)
        );
    end component;

    component multiplexer_2_bit_selector is
        generic(n: natural);
        port(
            inp_0 : in std_logic_vector(n-1 downto 0);
            inp_1 : in std_logic_vector(n-1 downto 0);
            inp_2 : in std_logic_vector(n-1 downto 0);
            inp_3 : in std_logic_vector(n-1 downto 0);

            sel: in std_logic_vector(1 downto 0);
            dataout: out std_logic_vector(n-1 downto 0)
        );
    end component;

    component multiplexer_3_bit_selector is
        generic(n: natural);
        port(
            inp_0 : in std_logic_vector(n-1 downto 0);
            inp_1 : in std_logic_vector(n-1 downto 0);
            inp_2 : in std_logic_vector(n-1 downto 0);
            inp_3 : in std_logic_vector(n-1 downto 0);
            inp_4 : in std_logic_vector(n-1 downto 0);
            inp_5 : in std_logic_vector(n-1 downto 0);
            inp_6 : in std_logic_vector(n-1 downto 0);
            inp_7 : in std_logic_vector(n-1 downto 0);

            sel: in std_logic_vector(2 downto 0);
            dataout: out std_logic_vector(n-1 downto 0)
        );
    end component;
    ----------------------
    constant n: natural := 16;

    signal we_pc: std_logic;
    signal pc_in, pc_out: std_logic_vector(n - 1 downto 0);

    signal inst_addr: std_logic_vector(n - 1 downto 0);
    signal inst: std_logic_vector(n - 1 downto 0);

    signal mrf_reg_num_1, mrf_reg_num_2, mrf_reg_num_3, mrf_wr: std_logic_vector(3 - 1 downto 0);
    signal mrf_wd, mrf_out_1, mrf_out_2, mrf_out_3: std_logic_vector(n - 1 downto 0);

    signal bank_reg_num, bank_wr: std_logic_vector(2 - 1 downto 0);
    signal bank_wd, bank_out: std_logic_vector(n - 1 downto 0);

    signal alu_lhs, alu_rhs, alu_out: std_logic_vector(n - 1 downto 0);

    signal mem_addr, mem_data_in, mem_data_out: std_logic_vector(n - 1 downto 0);

    signal
        mux_pc_in_0, mux_pc_in_1, mux_pc_in_2, mux_pc_in_3, mux_pc_out,
        mux_pc_beon_in_0, mux_pc_beon_in_1, mux_pc_beon_out,
        mux_pc_bgti_in_0, mux_pc_bgti_in_1, mux_pc_bgti_out,
        mux_mrf_wd_in_0, mux_mrf_wd_in_1, mux_mrf_wd_in_2, mux_mrf_wd_in_3, mux_mrf_wd_in_4,
        mux_mrf_wd_out,
        mux_rd_cmpi_in_0, mux_rd_cmpi_in_1, mux_rd_cmpi_out,
        mux_rd_beon_in_0, mux_rd_beon_in_1, mux_rd_beon_out,
        mux_alu_lhs_in_0, mux_alu_lhs_in_1, mux_alu_lhs_in_2, mux_alu_lhs_in_3, mux_alu_lhs_in_4,
        mux_alu_lhs_in_5, mux_alu_lhs_out,
        mux_alu_rhs_in_0, mux_alu_rhs_in_1, mux_alu_rhs_in_2, mux_alu_rhs_in_3, mux_alu_rhs_out,
        mux_mem_addr_in_0, mux_mem_addr_in_1, mux_mem_addr_out:
            std_logic_vector(n - 1 downto 0);

    -- TODO: Remove This
    -- Initializing to uninitialized to immediately notice any bugs in the code
    signal mux_dummy_in_n_bit: std_logic_vector(n - 1 downto 0) := (others => 'U');
    signal mux_dummy_in_3_bit: std_logic_vector(3 - 1 downto 0) := (others => 'U');

    signal mux_mrf_wr_in_0, mux_mrf_wr_in_1, mux_mrf_wr_in_2, mux_mrf_wr_out:
        std_logic_vector(3 - 1 downto 0);

    signal mux_bank_wr_in_0, mux_bank_wr_in_1, mux_bank_wr_out:
        std_logic_vector(2 - 1 downto 0);

    signal
        adder_pc_plus_2_lhs, adder_pc_plus_2_rhs, adder_pc_plus_2_out,
        adder_beon_lhs, adder_beon_rhs, adder_beon_out,
        adder_stoi_value_lhs, adder_stoi_value_rhs, adder_stoi_value_out:
            std_logic_vector(n - 1 downto 0);

    signal se_cmpi_in: std_logic_vector(4 - 1 downto 0);
    signal se_ltor_in: std_logic_vector(11 - 1 downto 0);
    signal se_luis_in: std_logic_vector(7 - 1 downto 0);
    signal se_bgti_imml_in: std_logic_vector(4 - 1 downto 0);
    signal se_bgti_immh_in: std_logic_vector(5 - 1 downto 0);
    signal ze_stoi_in: std_logic_vector(4 - 1 downto 0);
    signal ze_jalv_in: std_logic_vector(9 - 1 downto 0);

    signal
        se_cmpi_out, se_ltor_out, se_luis_out, se_bgti_imml_out, se_bgti_immh_out,
        ze_stoi_out, ze_jalv_out:
            std_logic_vector(n - 1 downto 0);

    signal
        lshift_stoi_in, lshift_stoi_out,
        lshift_ltor_in, lshift_ltor_out,
        lshift_luis_in, lshift_luis_out,
        lshift_jalv_in, lshift_jalv_out,
        lshift_subs_in, lshift_subs_out,
        lshift_beon_q_eq_1_in, lshift_beon_q_eq_1_out,
        lshift_beon_q_ne_1_in, lshift_beon_q_ne_1_out:
            std_logic_vector(n - 1 downto 0);

    signal lshift_ltor_amount:
        std_logic_vector(n - 1 downto 0);
    signal lshift_luis_amount, lshift_subs_amount, lshift_beon_q_ne_1_amount:
        std_logic_vector(3 - 1 downto 0);

    signal pow_base_4_ltor_exponent, pow_base_4_beon_exponent:
        std_logic_vector(3 - 1 downto 0);

    signal pow_base_4_ltor_out, pow_base_4_beon_out:
        std_logic_vector(n - 1 downto 0);

    signal concat_ltor_lhs: std_logic_vector(7 - 1 downto 0);
    signal concat_luis_lhs: std_logic_vector(8 - 1 downto 0);
    signal concat_bgti_lhs: std_logic_vector(4 - 1 downto 0);
    signal concat_jalv_lhs: std_logic_vector(5 - 1 downto 0);
    signal concat_beon_lhs: std_logic_vector(8 - 1 downto 0);
    signal concat_ltor_rhs: std_logic_vector(4 - 1 downto 0);
    signal concat_luis_rhs: std_logic_vector(8 - 1 downto 0);
    signal concat_bgti_rhs: std_logic_vector(12 - 1 downto 0);
    signal concat_jalv_rhs: std_logic_vector(4 - 1 downto 0);
    signal concat_beon_rhs: std_logic_vector(8 - 1 downto 0);

    signal concat_ltor_out: std_logic_vector(11 - 1 downto 0);
    signal concat_jalv_out: std_logic_vector(9 - 1 downto 0);

    signal concat_luis_out, concat_bgti_out, concat_beon_out:
        std_logic_vector(n - 1 downto 0);

    signal
        z_type_rd, z_type_rs, z_type_rt,
        i_type_rd, i_type_shamt,
        q_type_rs, q_type_rd, q_type_rt, q_type_shamt:
            std_logic_vector(3 - 1 downto 0);

    signal z_type_imm: std_logic_vector(4 - 1 downto 0);
    signal i_type_imm: std_logic_vector(7 - 1 downto 0);
    signal n_type_immh: std_logic_vector(5 - 1 downto 0);
    signal n_type_addr: std_logic_vector(2 - 1 downto 0);
    signal n_type_imml: std_logic_vector(4 - 1 downto 0);
begin
    -- # Components
    -- Program Counter
    pc: register_n_bit generic map(n) port map(
        pc_in,
        clk,
        pc_out,
        rst,
        we_pc
    );

    instruction_memory: rom port map(
        inst_addr,
        inst
    );

    mrf: register_file_3 generic map(3, n) port map(
        clk,
        rst,
        we_mrf,
        mrf_reg_num_1,
        mrf_reg_num_2,
        mrf_reg_num_3,
        mrf_wr,
        mrf_wd,
        mrf_out_1,
        mrf_out_2,
        mrf_out_3
    );

    bank: register_file_1 generic map(2, n) port map(
        clk,
        rst,
        we_bank,
        bank_reg_num,
        bank_wr,
        bank_wd,
        bank_out
    );

    alu_instance: alu generic map(n) port map(
        alu_lhs,
        alu_rhs,
        alu_op,
        alu_out,
        alu_zero,
        alu_borrow
    );

    memory_unit: ram port map(
        clk,
        we_mem,
        mem_addr,
        mem_data_in,
        mem_data_out
    );

    mux_pc: multiplexer_2_bit_selector generic map(n) port map(
        mux_pc_in_0,
        mux_pc_in_1,
        mux_pc_in_2,
        mux_pc_in_3,
        sel_pc,
        mux_pc_out
    );

    mux_pc_beon: multiplexer_1_bit_selector generic map(n) port map(
        mux_pc_beon_in_0,
        mux_pc_beon_in_1,
        sel_pc_beon,
        mux_pc_beon_out
    );

    mux_pc_bgti: multiplexer_1_bit_selector generic map(n) port map(
        mux_pc_bgti_in_0,
        mux_pc_bgti_in_1,
        sel_pc_bgti,
        mux_pc_bgti_out
    );

    mux_mrf_wr: multiplexer_2_bit_selector generic map(3) port map(
        mux_mrf_wr_in_0,
        mux_mrf_wr_in_1,
        mux_mrf_wr_in_2,
        mux_dummy_in_3_bit,
        sel_mrf_wr,
        mux_mrf_wr_out
    );

    mux_mrf_wd: multiplexer_3_bit_selector generic map(n) port map(
        mux_mrf_wd_in_0,
        mux_mrf_wd_in_1,
        mux_mrf_wd_in_2,
        mux_mrf_wd_in_3,
        mux_mrf_wd_in_4,
        mux_dummy_in_n_bit,
        mux_dummy_in_n_bit,
        mux_dummy_in_n_bit,
        sel_mrf_wd,
        mux_mrf_wd_out
    );

    mux_rd_cmpi: multiplexer_1_bit_selector generic map(n) port map(
        mux_rd_cmpi_in_0,
        mux_rd_cmpi_in_1,
        sel_rd_cmpi,
        mux_rd_cmpi_out
    );

    mux_rd_beon: multiplexer_1_bit_selector generic map(n) port map(
        mux_rd_beon_in_0,
        mux_rd_beon_in_1,
        sel_rd_beon,
        mux_rd_beon_out
    );

    mux_bank_wr: multiplexer_1_bit_selector generic map(2) port map(
        mux_bank_wr_in_0,
        mux_bank_wr_in_1,
        sel_bank_wr,
        mux_bank_wr_out
    );

    mux_alu_lhs: multiplexer_3_bit_selector generic map(n) port map(
        mux_alu_lhs_in_0,
        mux_alu_lhs_in_1,
        mux_alu_lhs_in_2,
        mux_alu_lhs_in_3,
        mux_alu_lhs_in_4,
        mux_alu_lhs_in_5,
        mux_dummy_in_n_bit,
        mux_dummy_in_n_bit,
        sel_alu_lhs,
        mux_alu_lhs_out
    );

    mux_alu_rhs: multiplexer_2_bit_selector generic map(n) port map(
        mux_alu_rhs_in_0,
        mux_alu_rhs_in_1,
        mux_alu_rhs_in_2,
        mux_alu_rhs_in_3,
        sel_alu_rhs,
        mux_alu_rhs_out
    );

    mux_mem_addr: multiplexer_1_bit_selector generic map(n) port map(
        mux_mem_addr_in_0,
        mux_mem_addr_in_1,
        sel_mem_addr,
        mux_mem_addr_out
    );

    adder_pc_plus_2: full_adder_n_bit generic map(n) port map(
        adder_pc_plus_2_lhs,
        adder_pc_plus_2_rhs,
        '0',
        adder_pc_plus_2_out,
        open
    );

    adder_beon: full_adder_n_bit generic map(n) port map(
        adder_beon_lhs,
        adder_beon_rhs,
        '0',
        adder_beon_out,
        open
    );

    adder_stoi_value: full_adder_n_bit generic map(n) port map(
        adder_stoi_value_lhs,
        adder_stoi_value_rhs,
        '0',
        adder_stoi_value_out,
        open
    );

    -- SE: Sign Extend
    -- ZE: Zero Extend
    se_cmpi: sign_extend generic map(4, n) port map(
        se_cmpi_in, se_cmpi_out
    );

    se_ltor: sign_extend generic map(11, n) port map(
        se_ltor_in, se_ltor_out
    );

    se_luis: sign_extend generic map(7, n) port map(
        se_luis_in, se_luis_out
    );

    se_bgti_imml: sign_extend generic map(4, n) port map(
        se_bgti_imml_in, se_bgti_imml_out
    );

    se_bgti_immh: sign_extend generic map(5, n) port map(
        se_bgti_immh_in, se_bgti_immh_out
    );

    ze_stoi: zero_extend generic map(4, n) port map(
        ze_stoi_in, ze_stoi_out
    );

    ze_jalv: zero_extend generic map(9, n) port map(
        ze_jalv_in, ze_jalv_out
    );

    -- LShift: Left Shift
    lshift_stoi: shift_to_left_const generic map(n, 4) port map(
        lshift_stoi_in, lshift_stoi_out
    );

    lshift_ltor: shift_to_left generic map(n, n) port map(
        lshift_ltor_in, lshift_ltor_amount, lshift_ltor_out
    );

    lshift_luis: shift_to_left generic map(n, 3) port map(
        lshift_luis_in, lshift_luis_amount, lshift_luis_out
    );

    lshift_jalv: shift_to_left_const generic map(n, 1) port map(
        lshift_jalv_in, lshift_jalv_out
    );

    lshift_subs: shift_to_left generic map(n, 3) port map(
        lshift_subs_in, lshift_subs_amount, lshift_subs_out
    );

    -- eq: Equals
    -- ne: Not Equals
    lshift_beon_q_eq_1: shift_to_left_const generic map(n, 6) port map(
        lshift_beon_q_eq_1_in, lshift_beon_q_eq_1_out
    );

    lshift_beon_q_ne_1: shift_to_left generic map(n, 3) port map(
        lshift_beon_q_ne_1_in, lshift_beon_q_ne_1_amount, lshift_beon_q_ne_1_out
    );

    pow_base_4_ltor: pow_base_4 generic map(n, 3) port map(
        pow_base_4_ltor_exponent, pow_base_4_ltor_out
    );

    pow_base_4_beon: pow_base_4 generic map(n, 3) port map(
        pow_base_4_beon_exponent, pow_base_4_beon_out
    );

    concat_ltor: concat generic map(7, 4) port map(
        concat_ltor_lhs, concat_ltor_rhs, concat_ltor_out
    );

    concat_luis: concat generic map(8, 8) port map(
        concat_luis_lhs, concat_luis_rhs, concat_luis_out
    );

    concat_bgti: concat generic map(4, 12) port map(
        concat_bgti_lhs, concat_bgti_rhs, concat_bgti_out
    );

    concat_jalv: concat generic map(5, 4) port map(
        concat_jalv_lhs, concat_jalv_rhs, concat_jalv_out
    );

    concat_beon: concat generic map(8, 8) port map(
        concat_beon_lhs, concat_beon_rhs, concat_beon_out
    );

    -- # Connections
    -- Connnections are grouped in the order of definitions of components above, and only their
    -- inputs are connected. The reason is, outputs will be connected somewhere else, by some other
    -- component's input. This way, it is more compact and more maintainable to do so.

    -- Controller inputs
    opc <= inst(8 downto 6);
    funct <= inst(1 downto 0);
    q <= inst(12);

    -- Instruction slices
    z_type_rd <= inst(15 downto 13);
    z_type_imm <= inst(12 downto 9);
    z_type_rs <= inst(5 downto 3);
    z_type_rt <= inst(2 downto 0);
    i_type_imm <= inst(15 downto 9);
    i_type_shamt <= inst(5 downto 3);
    i_type_rd <= inst(2 downto 0);
    n_type_immh <= inst(15 downto 11);
    n_type_addr <= inst(10 downto 9);
    n_type_imml <= inst(5 downto 2);
    q_type_rs <= inst(15 downto 13);
    q_type_rd <= inst(11 downto 9);
    q_type_rt <= inst(5 downto 3);
    q_type_shamt <= inst(2 downto 0);

    pc_in <= mux_pc_out;
    we_pc <= '1';

    inst_addr <= pc_out;

    -- Same as: q_type_rs
    mrf_reg_num_1 <= z_type_rd;
    -- Same as: q_type_rt
    mrf_reg_num_2 <= z_type_rs;
    mrf_reg_num_3 <= z_type_rt;
    mrf_wr <= mux_mrf_wr_out;
    mrf_wd <= mux_mrf_wd_out;

    bank_reg_num <= n_type_addr;
    bank_wr <= mux_bank_wr_out;
    bank_wd <= adder_pc_plus_2_out;

    alu_lhs <= mux_alu_lhs_out;
    alu_rhs <= mux_alu_rhs_out;

    mem_addr <= mux_mem_addr_out;
    mem_data_in <= adder_stoi_value_out;

    mux_pc_in_0 <= adder_pc_plus_2_out;
    mux_pc_in_1 <= mux_pc_beon_out;
    mux_pc_in_2 <= alu_out;
    mux_pc_in_3 <= mux_pc_bgti_out;

    mux_pc_beon_in_0 <= lshift_beon_q_ne_1_out;
    mux_pc_beon_in_1 <= adder_beon_out;

    mux_pc_bgti_in_0 <= adder_pc_plus_2_out;
    mux_pc_bgti_in_1 <= concat_bgti_out;

    mux_mrf_wr_in_0 <= z_type_rd;
    mux_mrf_wr_in_1 <= i_type_rd;
    mux_mrf_wr_in_2 <= q_type_rd;

    mux_mrf_wd_in_0 <= mux_rd_cmpi_out;
    mux_mrf_wd_in_1 <= lshift_ltor_out;
    mux_mrf_wd_in_2 <= concat_luis_out;
    mux_mrf_wd_in_3 <= lshift_subs_out;
    mux_mrf_wd_in_4 <= mux_rd_beon_out;

    mux_rd_cmpi_in_0 <= x"0000";
    mux_rd_cmpi_in_1 <= x"FFFF";

    -- TODO: Create a not c-omponent
    mux_rd_beon_in_0 <= not mrf_out_1;
    mux_rd_beon_in_1 <= concat_beon_out;

    mux_bank_wr_in_0 <= inst(10 downto 9);
    mux_bank_wr_in_1 <= b"11";

    mux_alu_lhs_in_0 <= se_bgti_imml_out;
    mux_alu_lhs_in_1 <= se_cmpi_out;
    mux_alu_lhs_in_2 <= lshift_beon_q_eq_1_out;
    mux_alu_lhs_in_3 <= mrf_out_1;
    mux_alu_lhs_in_4 <= mrf_out_3;
    mux_alu_lhs_in_5 <= adder_pc_plus_2_out;

    mux_alu_rhs_in_0 <= mrf_out_2;
    mux_alu_rhs_in_1 <= se_bgti_immh_out;
    mux_alu_rhs_in_2 <= pow_base_4_beon_out;
    mux_alu_rhs_in_3 <= lshift_jalv_out;

    mux_mem_addr_in_0 <= alu_out;
    mux_mem_addr_in_1 <= se_ltor_out;

    adder_pc_plus_2_lhs <= pc_out;
    adder_pc_plus_2_rhs <= x"0002";

    adder_beon_lhs <= pc_out;
    adder_beon_rhs <= alu_out;

    adder_stoi_value_lhs <= ze_stoi_out;
    adder_stoi_value_rhs <= lshift_stoi_out;

    se_cmpi_in <= z_type_imm;

    se_ltor_in <= concat_ltor_out;

    se_luis_in <= i_type_imm;

    se_bgti_imml_in <= n_type_imml;
    se_bgti_immh_in <= n_type_immh;

    ze_stoi_in <= z_type_imm;

    ze_jalv_in <= concat_jalv_out;

    lshift_stoi_in <= mrf_out_1;

    lshift_ltor_in <= mem_data_out;
    lshift_ltor_amount <= pow_base_4_ltor_out;

    lshift_luis_in <= se_ltor_out;
    lshift_luis_amount <= i_type_shamt;

    lshift_jalv_in <= ze_jalv_out;

    lshift_subs_in <= alu_out;
    lshift_subs_amount <= q_type_shamt;

    lshift_beon_q_eq_1_in <= mrf_out_1;

    lshift_beon_q_ne_1_in <= pc_out;
    lshift_beon_q_ne_1_amount <= q_type_shamt;

    pow_base_4_ltor_exponent <= i_type_shamt;

    pow_base_4_beon_exponent <= q_type_shamt;

    concat_ltor_lhs <= i_type_imm;
    concat_ltor_rhs <= x"0";

    concat_luis_lhs <= lshift_luis_out(15 downto 8);
    concat_luis_rhs <= x"00";

    concat_bgti_lhs <= pc_out(15 downto 12);
    concat_bgti_rhs <= bank_out(11 downto 0);

    concat_jalv_lhs <= n_type_immh;
    concat_jalv_rhs <= n_type_imml;

    concat_beon_lhs <= mrf_out_1(15 downto 8);
    concat_beon_rhs <= mrf_out_2(7 downto 0);
end architecture;
