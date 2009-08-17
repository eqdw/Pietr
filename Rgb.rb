class Rgb

  attr_reader :piet


  COLOURS = {
    "light red" => [0xff, 0xc0, 0xc0],
    "red" => [0xff, 0x00, 0x00],
    "dark red" => [0xc0, 0x00, 0x00],
    "light yellow" => [0xff, 0xff, 0xc0],
    "yellow" => [0xff, 0xff, 0x00],
    "dark yellow" => [0xc0, 0xc0, 0x00],
    "light green" => [0xc0, 0xff, 0xc0],
    "green" => [0x00, 0xff, 0x00],
    "dark green" => [0x00, 0xc0, 0x00],
    "light cyan" => [0xc0, 0xff, 0xff],
    "cyan" => [0x00, 0xff, 0xff],
    "dark cyan" => [0x00, 0xc0, 0xc0],
    "light blue" => [0xc0, 0xc0, 0xff],
    "blue" => [0x00, 0x00, 0xff],
    "dark blue" => [0x00, 0x00, 0xc0],
    "light magenta" => [0xff, 0xc0, 0xff],
    "magenta" => [0xff, 0x00, 0xff],
    "dark magenta" => [0xc0, 0x00, 0xc0]
  }
  
  #Thanks, Burke Libbey!
  HUES = {
    "100" => 0,
    "110" => 1,
    "010" => 2,
    "011" => 3,
    "001" => 4,
    "101" => 5
  }

  #only defined on the Piet standard 18 colours
  #again, Thanks to Burke Libbey
  def hue
    m = @rgb.min
    return HUES[@rgb.map{|g|(g-m).zero? ? 0 : 1}.join]
  end

  def darkness
    if @rgb.include?(0xFF) && @rgb.include?(0xC0)
      0
    elsif(@rgb.include?(0xFF))
      1
    else
      2
    end
  end

  def -(other)
    { "hue" => ((other.hue - self.hue) % 6), "darkness" => ((other.darkness - self.darkness) % 3)} 
  end
  
  def red
    @rgb[0]
  end

  def green
    @rgb[1]
  end

  def blue
    @rgb[2]
  end

  def initialize(r, g, b)
    @rgb = []
    @rgb[0] = r
    @rgb[1] = g
    @rgb[2] = b

    @piet = COLOURS.has_value? @rgb
  end
end
