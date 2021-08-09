library ieee;
use ieee.std_logic_1164.all;

entity controller is
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
end entity;

-- all based on about/exe_state_calc.jpg
architecture structural of controller is
    signal a : std_logic;
    signal b : std_logic;
    signal c : std_logic;
    signal F1: std_logic;
    signal F2: std_logic;
    -- flip-flop
    signal reset_state: std_logic := '1';
    -- table
    -- opc based
    signal notRst : std_logic;
    signal O_000: std_logic;
    signal O_001: std_logic;
    signal O_01d: std_logic;
    signal O_0d0: std_logic;
    signal O_100: std_logic;
    signal O_10d: std_logic;
    signal O_110: std_logic;
    signal O_111: std_logic;
    signal O_11d: std_logic;
    signal O_1d0: std_logic;
    signal O_1d1: std_logic;
    signal O_d11: std_logic;
    signal N_1d1: std_logic;
    -- opc & func based
    signal O_111_F_1d: std_logic;
    signal O_111_F_d1: std_logic;
    signal O_1d1_F_1d: std_logic;
    signal O_1d1_F_d1: std_logic;
    -- custom
    --signal sel_pc_v0 : std_logic := not(O_110 or (O_111 and (F1 or F2)));
begin
    -- bind table
    a  <= opc(2);
    b  <= opc(1);
    c  <= opc(0);
    F1 <= func(1);
    F2 <= func(0);
    -- flip-flop
    -- table
    -- opc based
    notRst <= not (Reset or reset_state);
    O_000 <= (not a and not b and not c);
    O_001 <= (not a and not b and c);
    O_01d <= (not a and b);
    O_0d0 <= (not a and not c);
    O_100 <= (a and not b and not c);
    O_10d <= (a and not b);
    O_110 <= (a and b and not c);
    O_111 <= (a and b and c);
    O_11d <= (a and b);
    O_1d0 <= (a and not c);
    O_1d1 <= (a and c);
    O_d11 <= (b and c);
    N_1d1 <= not O_1d1;
    -- opc & func based
    O_111_F_1d <= O_111 and F1;
    O_111_F_d1 <= O_111 and F2;
    O_1d1_F_1d <= O_1d1 and F1;
    O_1d1_F_d1 <= O_1d1 and F2;
    -- custom
    ------------------------
    ------------------------
    rst <= Reset;
    -- we
    we_mrf  <= notRst and ((not a) or O_1d0);
    we_bank <= notRst and O_1d1;
    we_mem  <= notRst and O_000;
    -- sel_pc
    sel_pc(1) <= O_111_F_1d or O_111_F_d1;
    sel_pc(0) <= O_110 or O_111_F_d1;
    -- sel_alu_lhs
    sel_alu_lhs(2) <= (O_000) or (O_1d1_F_1d); -- 4 5
    sel_alu_lhs(1) <= (N_1d1 and b) or (N_1d1 and O_10d); -- 2 3
    sel_alu_lhs(0) <= 
        (N_1d1 and c) or (N_1d1 and O_10d) or (O_1d1_F_1d); -- 1 3 5
    -- sel_alu_rhs
    sel_alu_rhs(1) <= (N_1d1 and b) or (O_1d1_F_1d); -- pre 2 5
    sel_alu_rhs(0) <= (O_1d1 and (F1 or F2)); -- pre 0 5
    -- alu_op
    alu_op <= O_001 or O_100 or O_111_F_d1;
    -- sel_pc_bgti
    sel_pc_bgti <= alu_borrow;
    -- sel_rd_cmpi
    sel_rd_cmpi <= alu_zero;
    -- beon
    sel_pc_beon <= q;
    sel_rd_beon <= q;
    -- sel_mem_addr
    sel_mem_addr <= b;
    -- sel_bank_wr
    sel_bank_wr <= F2 and alu_borrow;
    -- sel_mrf_wd
    sel_mrf_wd(2) <= O_11d;
    sel_mrf_wd(1) <= O_d11 or O_10d; -- 2 3
    sel_mrf_wd(0) <= O_0d0 or O_10d; -- 1 3
    -- sel_mrf_wr
    sel_mrf_wr(1) <= a;
    sel_mrf_wr(0) <= O_01d;
    -------------------
    -- flip flop
    process(clk) begin
        if(clk'event and clk='1') then
            reset_state <= Reset;
        end if;
    end process;
end architecture;
