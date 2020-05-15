--Lab 5:
--Write a VHDL/Verilog program and simulate the following modules:
--b) 4 bit register with enable (structural)
--Due: 7/17 08:00; lab report by 23:59 7/17
--------------------------------------------------------------------------------
--Author: Peter Dranishnikov    --Partner: NOT APPLICABLE
--"Veryhighhardwaredl"

library ieee;
use ieee.std_logic_1164.all;
entity d_ff is
    port(d, clk : in std_logic; q : out std_logic);
end entity d_ff;
architecture behavioral of d_ff is
begin
    d_flip_flop: process(clk) begin
        if(rising_edge(clk)) then
            q <= d;
        end if;
    end process;
end architecture behavioral;

library ieee;
use ieee.std_logic_1164.all;
entity and_gate is
    port(a, b : in std_logic; c : out std_logic);
end entity and_gate;
architecture behavioral of and_gate is
begin
    enable_line: c <= a and b;
end architecture behavioral;

library ieee;
use ieee.std_logic_1164.all;
entity enableable_4bit_register is
    port(clk, enable, d0, d1, d2, d3 : in std_logic; q0, q1, q2, q3 : out std_logic);
end entity enableable_4bit_register;

architecture structural of enableable_4bit_register is
    component d_ff is
        port(d, clk : in std_logic; q : out std_logic);
    end component d_ff;
    
    component and_gate is
        port(a, b : in std_logic; c : out std_logic);
    end component and_gate;
    signal m_clk : std_logic;
begin
    
    clk_enable: and_gate port map
        (
            a => clk,
            b => enable,
            c => m_clk
        );
    
    DR0: d_ff port map
        (
            d => d0,
            clk => m_clk,
            q => q0
        );
    
    DR1: d_ff port map
        (
            d => d1,
            clk => m_clk,
            q => q1
        );
    
    DR2: d_ff port map
        (
            d => d2,
            clk => m_clk,
            q => q2
        );
    
    DR3: d_ff port map
        (
            d => d3,
            clk => m_clk,
            q => q3
        );
end architecture structural;

--TESTBENCH--TESTBENCH--TESTBENCH--TESTBENCH--TESTBENCH--TESTBENCH--TESTBENCH--

library ieee;
use ieee.std_logic_1164.all;

entity t_enableable_4bit_register is
end entity t_enableable_4bit_register;

architecture structural of t_enableable_4bit_register is
    constant CLKCYCLE : time := 1 sec;
    signal t_clk : std_logic := '1';
    signal t_enable : std_logic := '0';
    signal t_d0, t_d1, t_d2, t_d3 : std_logic;
    signal t_q0, t_q1, t_q2, t_q3 : std_logic;
    
    component enableable_4bit_register is
        port(clk, enable, d0, d1, d2, d3 : in std_logic; q0, q1, q2, q3 : out std_logic);
    end component enableable_4bit_register;
begin
    UUT : enableable_4bit_register port map
    (
        clk => t_clk,
        enable => t_enable,
        d0 => t_d0,
        d1 => t_d1,
        d2 => t_d2,
        d3 => t_d3,
        q0 => t_q0,
        q1 => t_q1,
        q2 => t_q2,
        q3 => t_q3
    );
    
    CLK_GEN : process is
    begin
        wait for CLKCYCLE / 2;
        t_clk <= not t_clk;
    end process CLK_GEN;
    
    process begin
        wait for 900 ms;
        t_enable <= '1';
        t_d0 <= '0';
        t_d1 <= '1';
        t_d2 <= '0';
        t_d3 <= '0';
        wait for 1500 ms;
        t_enable <= '0';
        wait for 500 ms;
        t_d0 <= 'X';
        t_d1 <= 'X';
        t_d2 <= 'X';
        t_d3 <= 'X';
        wait;
    end process;
    
--    digit_0_gen : process is
--    begin
--        t_d0 <= '1';
--        wait for 5 sec;
--        t_d0 <= '0';
--        wait for 1 sec;
--    end process digit_0_gen;
--    
--    digit_1_gen : process is
--    begin
--        t_d1 <= '0';
--        wait for 532 ms;
--        t_d1 <= '1';
--        wait for 190 ms;
--    end process digit_1_gen;
--    
--    digit_2_gen : process is
--    begin
--        t_d2 <= '0';
--        wait for 105 ms;
--        t_d2 <= '1';
--        wait for 100 ms;
--        wait until t_d0 = '1' and t_d1 = '0';
--    end process digit_2_gen;
--    
--    digit_3_gen : process is
--    begin
--        t_d3 <= '0';
--        wait for 508 ms;
--        t_d3 <= '1';
--        wait for 250 ms;
--    end process digit_3_gen;
--    
--    process begin
--        report "Simulation start";
--        wait for 500 ms;
--        report "Register write enable";
--        t_enable <= '1';
--        wait for 5 sec;
--        report "Register read only";
--        t_enable <= '0';
--        wait for 5 sec;
--        report "Register write enable";
--        t_enable <= '1';
--        wait for 5 sec;
--        report "Register read only";
--        t_enable <= '0';
--        wait;
--    end process;
end architecture structural;
