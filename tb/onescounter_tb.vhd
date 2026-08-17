-------------------------------------------------------
--! @brief OneCounter testbench
-------------------------------------------------------
library ieee;
use ieee.numeric_bit.rising_edge;
use ieee.numeric_bit.falling_edge;
use ieee.numeric_bit.to_unsigned;
use ieee.numeric_bit.to_integer;
use ieee.numeric_bit.unsigned;

entity onescounter_tb is
end entity;

architecture arch of onescounter_tb is
  function conta(i:integer; s:integer) return integer is
    variable c: integer:=0;
    variable bv: bit_vector(s-1 downto 0);
  begin
    bv:=bit_vector(to_unsigned(i,s));
    for ii in 0 to s-1 loop
      if bv(ii)='1' then
        c:=c+1;
      end if;
    end loop;
    return c;
  end conta;

  component onescounter is
  port (
    clock   : in  bit;
    reset   : in  bit;
    start   : in  bit;
    inport  : in  bit_vector(14 downto 0);
    outport : out bit_vector(3 downto 0);
    done    : out bit
  );
  end component;

  constant size: integer := 15;
  constant ckp : time := 10 ns;

  signal clk, rst, sim: bit := '0';
  signal stt, don: bit;
  signal inp : bit_vector(14 downto 0);
  signal otp : bit_vector(3 downto 0);

begin
  clk <= (sim and (not clk)) after ckp/2;

  dut: onescounter
    port map(
        clock   => clk,
        reset   => rst,
        start   => stt,
        inport  => inp,
        outport => otp,
        done    => don
    );

  st: process is
  begin
    sim <= '1';
    assert false report "BOT" severity note;
    --! reset
    rst<='1';
    stt <= '0';
    wait until rising_edge(clk);
    wait until falling_edge(clk);
    rst<='0';
    wait until falling_edge(clk);

    for i in 0 to (2**size)-1 loop
      -- report "Teste: "&integer'image(i);

      wait until falling_edge(clk);
      inp <= bit_vector(to_unsigned(i,size));
      stt <= '1'; -- pulso de start
      wait until falling_edge(clk);
      stt <= '0';

      -- assert don='0'
        -- report "Teste: "&integer'image(i)&". Done antes do estado final! Impossivel continuar."
        -- severity failure;
      -- while don='0' loop
        -- wait until falling_edge(clk);
      -- end loop;

      -- wait until falling_edge(clk); --final da contagem
      wait until don='1'; --final da contagem
      assert conta(i,size)=to_integer(unsigned(otp))
        report "Teste: "&integer'image(i)&" falhou! Resposta:"&integer'image(to_integer(unsigned(otp)))
        severity failure; -- para simulacao em caso de erro
        -- severity error;

      -- assert conta(i,size)/=to_integer(unsigned(otp))
        -- report "Teste: "&integer'image(i)&" passou."
        -- severity note;

      wait until falling_edge(clk);
    end loop;

   assert false report "testes ok" severity note;
   assert false report "EOT" severity note;
   sim <='0';
   wait;
 end process;
end architecture;