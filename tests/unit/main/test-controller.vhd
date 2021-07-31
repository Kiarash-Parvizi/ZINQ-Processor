library ieee;
use ieee.std_logic_1164.all;

entity test_controller is
end entity;

architecture structural of test_controller is
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
    signal clk : std_logic := '0';
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
    signal sel_mrf_wr  : std_logic_vector(1 downto 0)
begin
    instance: controller port map(
    opc,
    func
    q, Reset,
    alu_zero
    alu_borrow,
    -- output signals
    rst,
    we_mrf,
    we_bank,
    we_mem ,
    sel_pc ,
    sel_alu_lhs,
    sel_alu_rhs,
    alu_op,
    sel_pc_bgti,
    sel_rd_cmpi,
    sel_pc_beon,
    sel_rd_beon,
    sel_mem_addr,
    sel_bank_wr ,
    sel_mrf_wd  ,
    sel_mrf_wr  
    );
    process is begin
        -- TODO
        wait for 10 ns;
        wait;
    end process;
end architecture;
