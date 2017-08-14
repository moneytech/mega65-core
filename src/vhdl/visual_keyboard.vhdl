library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.debugtools.all;

entity visual_keyboard is
  port (
    pixel_x_640 : in integer;
    ycounter_in : in unsigned(11 downto 0);
    pixelclock : in std_logic;
    visual_keyboard_enable : in std_logic;
    key1 : in unsigned(7 downto 0);
    key2 : in unsigned(7 downto 0);
    key3 : in unsigned(7 downto 0);
    vgared_in : in  unsigned (7 downto 0);
    vgagreen_in : in  unsigned (7 downto 0);
    vgablue_in : in  unsigned (7 downto 0);
    vgared_out : out  unsigned (7 downto 0);
    vgagreen_out : out  unsigned (7 downto 0);
    vgablue_out : out  unsigned (7 downto 0)
    );
end visual_keyboard;

architecture behavioural of visual_keyboard is

  signal vk_pixel : unsigned(1 downto 0) := "00";

  signal memaddr : integer range 0 to 4095 := 0;
  signal rdata : unsigned(7 downto 0);
    
begin

  km0: entity work.oskmem
    port map (
      clk => pixelclock,
      address => memaddr,
      we => '0',
      data_i => (others => '1'),
      data_o => rdata
      );
  
  process (pixelclock)
    variable p640 : unsigned(13 downto 0);
  begin
    if rising_edge(pixelclock) then
      -- Draw checker pattern to debug pixel_x_640 generation
      p640 := to_unsigned(pixel_x_640,14);
      if p640(0)='0' then
        vk_pixel(1) <= ycounter_in(0);
      else
        vk_pixel(1) <= ycounter_in(0) xor '1';
      end if;
      if visual_keyboard_enable='1' then
        vgared_out <= vk_pixel&vgared_in(7 downto 2);
        vgagreen_out <= vk_pixel&vgagreen_in(7 downto 2);
        vgablue_out <= vk_pixel&vgablue_in(7 downto 2);
      else
        vgared_out <= vgared_in;
        vgagreen_out <= vgagreen_in;
        vgablue_out <= vgablue_in;
      end if;
    end if;
  end process;
  
end behavioural;
