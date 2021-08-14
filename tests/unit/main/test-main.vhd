library ieee;
use ieee.std_logic_1164.all;

entity test_main is
end entity;

architecture structural of test_main is
    component controller is
        port(
            clk: in std_logic := '0';
            rst: in std_logic;
            -- input signals
            opc : in std_logic_vector(2 downto 0);
            func: in std_logic_vector(1 downto 0);
            q: in std_logic;
            alu_zero: in std_logic;
            alu_borrow: in std_logic;
            -- output signals
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

    component data_path is
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
            alu_op: in std_logic;

            sel_mem_addr: in std_logic;

            opc: out std_logic_vector(2 downto 0);
            funct: out std_logic_vector(1 downto 0);
            q: out std_logic;
            alu_zero: out std_logic;
            alu_borrow: out std_logic
        );
    end component;

    component clock_generator is
        generic(
            -- How many cycles to generate
            constant cycle_iterations: integer := 0;
            -- The period of half a cycle
            constant half_cycle_period: time := 10 ns
        );
        port(
            clock: out std_logic := '0'
        );
    end component;

    signal clk: std_logic;
    signal rst: std_logic;

    signal we_mrf: std_logic;
    signal we_bank: std_logic;
    signal we_mem: std_logic;

    signal sel_pc: std_logic_vector(1 downto 0);
    signal sel_pc_beon: std_logic;
    signal sel_pc_bgti: std_logic;

    signal sel_mrf_wr: std_logic_vector(1 downto 0);
    signal sel_mrf_wd: std_logic_vector(2 downto 0);
    signal sel_rd_cmpi: std_logic;
    signal sel_rd_beon: std_logic;

    signal sel_bank_wr: std_logic;

    signal sel_alu_lhs: std_logic_vector(2 downto 0);
    signal sel_alu_rhs: std_logic_vector(1 downto 0);
    signal alu_op: std_logic;

    signal sel_mem_addr: std_logic;

    signal opc: std_logic_vector(2 downto 0);
    signal funct: std_logic_vector(1 downto 0);
    signal q: std_logic;
    signal alu_zero: std_logic;
    signal alu_borrow: std_logic;
begin
    clock_generator_instance: clock_generator generic map(100) port map(clk);

    controller_instance: controller port map(
        clk,
        rst,
        opc,
        funct,
        q,
        alu_zero,
        alu_borrow,
        we_mrf,
        we_bank,
        we_mem,
        sel_pc,
        sel_alu_lhs,
        sel_alu_rhs,
        alu_op,
        sel_pc_bgti,
        sel_rd_cmpi,
        sel_pc_beon,
        sel_rd_beon,
        sel_mem_addr,
        sel_bank_wr,
        sel_mrf_wd,
        sel_mrf_wr
    );

    data_path_instance: data_path port map(
        clk,
        rst,
        we_mrf,
        we_bank,
        we_mem,
        sel_pc,
        sel_pc_beon,
        sel_pc_bgti,
        sel_mrf_wr,
        sel_mrf_wd,
        sel_rd_cmpi,
        sel_rd_beon,
        sel_bank_wr,
        sel_alu_lhs,
        sel_alu_rhs,
        alu_op,
        sel_mem_addr,
        opc,
        funct,
        q,
        alu_zero,
        alu_borrow
    );

    rst <= '0',
        '0' after 11 ns;
end architecture;
