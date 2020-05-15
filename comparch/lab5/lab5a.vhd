--Lab 5:
--Write a VHDL/Verilog program and simulate the following modules:
--a) Full adder (behavioral)
--b) 4 bit register with enable (structural) ***SEE OTHER SECTION***--
--Due: 7/17 08:00; lab report by 23:59 7/17
--------------------------------------------------------------------------------
--Author: Peter Dranishnikov    --Partner: NOT APPLICABLE
--"Veryhighhardwaredl"

library ieee;
use ieee.std_logic_1164.all;

entity fulladder is
    port(a, b, cin : in STD_LOGIC; s, cout : out STD_LOGIC);
end entity fulladder;

architecture behavioral of fulladder is
begin
    s <= a xor b xor cin;
    cout <= (a and b) or (a and cin) or (b and cin);
end architecture behavioral;

--TESTBENCH--TESTBENCH--TESTBENCH--TESTBENCH--TESTBENCH--TESTBENCH--TESTBENCH--

library ieee;
use ieee.std_logic_1164.all;

entity t_fulladder is
end entity t_fulladder;

architecture behavioral of t_fulladder is
    signal t_a : std_logic := '0';
    signal t_b : std_logic := '0';
    signal t_cin : std_logic := '0';
    signal t_s : std_logic;
    signal t_cout : std_logic;
    component fulladder is
        port(a, b, cin : in STD_LOGIC; s, cout : out STD_LOGIC);
    end component fulladder;
begin
    UUT : fulladder port map
    (
        a => t_a,
        b => t_b,
        cin => t_cin,
        s => t_s,
        cout => t_cout
    );
    
    process begin
        wait for 1 sec;
        t_a <= '0';
        t_b <= '1';
        t_cin <= '1';
        wait;
    end process;
--    process begin
--        report "Simulation start!";
--        
--        t_a <= '0';
--        t_b <= '0';
--        t_cin <= '0';
--        
--        wait for 1 sec;
--        report "Inputs: A " & std_logic'image(t_a) & " B " & std_logic'image(t_b) & " Carryin " & std_logic'image(t_cin);
--        report "Outputs: Sum: " & std_logic'image(t_s) & " Carryout " & std_logic'image(t_cout);
--        
--        t_a <= '0';
--        t_b <= '0';
--        t_cin <= '1';
--        
--        wait for 1 sec;
--        report "Inputs: A " & std_logic'image(t_a) & " B " & std_logic'image(t_b) & " Carryin " & std_logic'image(t_cin);
--        report "Outputs: Sum: " & std_logic'image(t_s) & " Carryout " & std_logic'image(t_cout);
--        
--        t_a <= '0';
--        t_b <= '1';
--        t_cin <= '0';
--        
--        wait for 1 sec;
--        report "Inputs: A " & std_logic'image(t_a) & " B " & std_logic'image(t_b) & " Carryin " & std_logic'image(t_cin);
--        report "Outputs: Sum: " & std_logic'image(t_s) & " Carryout " & std_logic'image(t_cout);
--        
--        t_a <= '0';
--        t_b <= '1';
--        t_cin <= '1';
--        
--        wait for 1 sec;
--        report "Inputs: A " & std_logic'image(t_a) & " B " & std_logic'image(t_b) & " Carryin " & std_logic'image(t_cin);
--        report "Outputs: Sum: " & std_logic'image(t_s) & " Carryout " & std_logic'image(t_cout);
--        
--        t_a <= '1';
--        t_b <= '0';
--        t_cin <= '0';
--        
--        wait for 1 sec;
--        report "Inputs: A " & std_logic'image(t_a) & " B " & std_logic'image(t_b) & " Carryin " & std_logic'image(t_cin);
--        report "Outputs: Sum: " & std_logic'image(t_s) & " Carryout " & std_logic'image(t_cout);
--        
--        t_a <= '1';
--        t_b <= '0';
--        t_cin <= '1';
--        
--        wait for 1 sec;
--        report "Inputs: A " & std_logic'image(t_a) & " B " & std_logic'image(t_b) & " Carryin " & std_logic'image(t_cin);
--        report "Outputs: Sum: " & std_logic'image(t_s) & " Carryout " & std_logic'image(t_cout);
--        t_a <= '1';
--        t_b <= '1';
--        t_cin <= '0';
--        
--        wait for 1 sec;
--        report "Inputs: A " & std_logic'image(t_a) & " B " & std_logic'image(t_b) & " Carryin " & std_logic'image(t_cin);
--        report "Outputs: Sum: " & std_logic'image(t_s) & " Carryout " & std_logic'image(t_cout);
--        t_a <= '1';
--        t_b <= '1';
--        t_cin <= '1';
--        
--        
--        wait for 1 sec;
--        report "Inputs: A " & std_logic'image(t_a) & " B " & std_logic'image(t_b) & " Carryin " & std_logic'image(t_cin);
--        report "Outputs: Sum: " & std_logic'image(t_s) & " Carryout " & std_logic'image(t_cout);
--        report "Simulation complete";
--        wait;
--    end process;
end architecture behavioral;
