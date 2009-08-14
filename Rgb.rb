class Rgb


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
  end
end
