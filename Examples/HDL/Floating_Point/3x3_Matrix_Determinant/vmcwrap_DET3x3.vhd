-- NOTE: This Wrapper file is autogenerated by Vitis Model Composer as part
--       of HDL BlackBox flow in order to handle port data types otherthan
--       std_logic and std_logic_vector.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--use IEEE.FLOAT_PKG.ALL;
use work.FLOAT_PKG.ALL;
use work.CFLOAT_PKG.ALL;

entity vmcwrap_DET3x3 is
   port(
	CLK		:in std_logic;
	CE		:in std_logic;

	I11		:in std_logic_vector (31 downto 0);
	I21		:in std_logic_vector (31 downto 0);
	I31		:in std_logic_vector (31 downto 0);
	I12		:in std_logic_vector (31 downto 0);
	I22		:in std_logic_vector (31 downto 0);
	I32		:in std_logic_vector (31 downto 0);
	I13		:in std_logic_vector (31 downto 0);
	I23		:in std_logic_vector (31 downto 0);
	I33		:in std_logic_vector (31 downto 0);
	VI		:in std_logic;

	O		:out std_logic_vector (31 downto 0);
	VO		:out std_logic
   );
end vmcwrap_DET3x3;

architecture wrapper of vmcwrap_DET3x3 is
   signal s_I11:float32;
   signal s_I21:float32;
   signal s_I31:float32;
   signal s_I12:float32;
   signal s_I22:float32;
   signal s_I32:float32;
   signal s_I13:float32;
   signal s_I23:float32;
   signal s_I33:float32;
   signal s_VI:boolean;
   signal s_O:float32;
   signal s_VO:boolean;
begin
   s_I11 <= to_float(I11,8,23);
   s_I21 <= to_float(I21,8,23);
   s_I31 <= to_float(I31,8,23);
   s_I12 <= to_float(I12,8,23);
   s_I22 <= to_float(I22,8,23);
   s_I32 <= to_float(I32,8,23);
   s_I13 <= to_float(I13,8,23);
   s_I23 <= to_float(I23,8,23);
   s_I33 <= to_float(I33,8,23);
   s_VI <= VI = '1';

u0: entity work.DET3x3 port map(
						CLK=>CLK,
						CE=>CE,
						I11=>s_I11,
						I21=>s_I21,
						I31=>s_I31,
						I12=>s_I12,
						I22=>s_I22,
						I32=>s_I32,
						I13=>s_I13,
						I23=>s_I23,
						I33=>s_I33,
						VI=>s_VI,
						O=>s_O,
						VO=>s_VO);
O <= to_slv(s_O);
VO <= '1' when s_VO else '0';
end wrapper;