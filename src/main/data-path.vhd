library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real.all;
use ieee.numeric_std.all;

entity data_path is
    port(
        clk: in std_logic
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
    -- component | controller
    component controller is
        port(
            clk : in std_logic := '0';
            -- input signals
            opc : in std_logic_vector(2 downto 0);
            func: in std_logic_vector(1 downto 0);
            q, Reset: in std_logic;
            alu_zero: in std_logic;
            alu_borrow: in std_logic;
            -- output signals
            rst: out std_logic;
            we_mrf : out std_logic;
            we_bank: out std_logic;
            we_mem : out std_logic;
            sel_pc : out std_logic_vector(1 downto 0);
            sel_alu_lhs : out std_logic_vector(2 downto 0);
            sel_alu_rhs : out std_logic_vector(1 downto 0);
            alu_op : out std_logic;
            sel_pc_bgti : out std_logic;
            sel_rd_cmpi : out std_logic;
            sel_pc_beon : out std_logic;
            sel_rd_beon : out std_logic;
            sel_mem_addr: out std_logic;
            sel_bank_wr : out std_logic;
            sel_mrf_wd  : out std_logic_vector(2 downto 0);
            sel_mrf_wr  : out std_logic_vector(1 downto 0)
        );
    end component;
    -- component | multiplexer_2_to_1
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
    -- component | multiplexer_n_to_1
    component multiplexer_n_to_1 is
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
            address: in  std_logic_vector(7 downto 0);
            dataout: out std_logic_vector(15 downto 0)
        );
    end component;
    -- component register_file_3
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
    -- component | register_file_1
    component register_file_1 is
        generic(addr_size: natural);
        port(
            -- input
            clk, rst, we: in std_logic;
            r0: in std_logic_vector(addr_size-1 downto 0);
            wr: in std_logic_vector(addr_size-1 downto 0);
            wd: in std_logic_vector((2**addr_size)-1 downto 0);
            -- output
            out0: out std_logic_vector((2**addr_size)-1 downto 0)
        );
    end component;
    ----------------------
    constant n: natural := 16;
    -------- signals:
    ---- Controller:
    -- input signals
    signal opc : std_logic_vector(2 downto 0);
    signal func: std_logic_vector(1 downto 0);
    signal q, Reset: std_logic;
    signal alu_zero: std_logic;
    signal alu_borrow: std_logic;
    -- output signals
    signal rst: std_logic;
    signal we_mrf : std_logic;
    signal we_bank: std_logic;
    signal we_mem : std_logic;
    signal sel_pc : std_logic_vector(1 downto 0);
    signal sel_alu_lhs : std_logic_vector(2 downto 0);
    signal sel_alu_rhs : std_logic_vector(1 downto 0);
    signal alu_op : std_logic;
    signal sel_pc_bgti : std_logic;
    signal sel_rd_cmpi : std_logic;
    signal sel_pc_beon : std_logic;
    signal sel_rd_beon : std_logic;
    signal sel_mem_addr: std_logic;
    signal sel_bank_wr : std_logic;
    signal sel_mrf_wd  : std_logic_vector(2 downto 0);
    signal sel_mrf_wr  : std_logic_vector(1 downto 0);
    ---- pc:
    signal pc_out: std_logic_vector(n - 1 downto 0) := (others => '0');
    signal pc_in : std_logic_vector(n - 1 downto 0);
    ---- inst:
    signal inst  : std_logic_vector(n - 1 downto 0);
    ---- Bank RF
    signal mux_bank_wr_out: std_logic_vector(1 downto 0) := (others => '0');
    signal bank_out: std_logic_vector(n - 1 downto 0) := (others => '0');
    ---- MRF
    signal mux_mrf_wr_out: std_logic_vector(2 downto 0) := (others => '0');
    signal mux_mrf_wd_out: std_logic_vector(n-1 downto 0) := (others => '0');
    signal mrf_out: std_logic_vector(n - 1 downto 0) := (others => '0');
    signal mux_rd_cmpi_out: std_logic_vector(n-1 downto 0) := (others => '0');
begin
    -- Controller inputs
    opc  <= inst(8 downto 6);
    func <= inst(1 downto 0);
    q    <= inst(12);
    Reset<= '0';

    main_controller: controller port map(
        clk, opc, func, q, Reset, alu_zero, alu_borrow,
        -- output signals
        rst,we_mrf,we_bank,we_mem ,sel_pc,sel_alu_lhs,sel_alu_rhs,
        alu_op,sel_pc_bgti,sel_rd_cmpi,sel_pc_beon,sel_rd_beon,
        sel_mem_addr,sel_bank_wr,sel_mrf_wd,sel_mrf_wr
    );

    -- Program Counter
    pc: register_n_bit generic map(n) port map(
        pc_in, clk, pc_out, rst, '1'
    );

    ---- instruction_memory
    instruction_memory: rom
        port map (pc_out(7 downto 0), inst);
    ---- Bank RF
    -- mux_bank_wr
    mux_bank_wr: multiplexer_2_to_1 generic map(2)
        port map(
            inst(10 downto 9) & "11",
            sel_bank_wr,
            mux_bank_wr_out
        );
    -- bank_rf
    bank_rf: register_file_1 generic map(2)
        port map(
            clk, rst, we_bank,
            std_logic_vector(inst(10 downto 9)), mux_bank_wr_out,
            wd, -- wd todo
            -- output
            bank_out
        );
    ---- main RF
    -- mux_mrf_wr
    mux_mrf_wr: multiplexer_n_to_3 generic map(3, 3)
        port map (
            inst(15 downto 13) & inst(2 downto 0) & inst(11 downto 9),
            sel_mrf_wr,
            mux_mrf_wr_out
        );
    -- mux_rd_cmpi
    mux_rd_cmpi: multiplexer_2_to_1 generic map(16)
        port map(
            x"ffff" & x"0000",
            sel_rd_cmpi,
            mux_rd_cmpi_out
        );
    -- mux_mrf_wd
    --mux_mrf_wd: multiplexer_n_to_3 generic map(16, 5)
    --    port map (
    --        mux_rd_cmpi_out -- todo & inst(2 downto 0) & inst(11 downto 9),
    --        sel_mrf_wd,
    --        mux_mrf_wd_out
    --    );
    -- main_register_file
    main_register_file: register_file_3 generic map(3)
        port map(
            clk, rst, we_mrf,
            inst(15 downto 13),
            inst(5 downto 3),
            inst(2 downto 0),
            mux_mrf_wr_out,
            wd, -- wd todo
            -- output
            bank_out
        );

end architecture;
