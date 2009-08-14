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
    return HUES[x.map{|g|(g-m).zero? ? 0 : 1}.join]
  end

  def darkness
    if @rgb.contains(0xFF) && @rgb.contains(0xC0)
      0
    elsif(@rgb.contains(0xFF))
      1
    else
      2
    end
  end

  def -(other)
    { hue => (other.hue - self.hue), darkness => (other.darkness - self.darkness)} 
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
    @rgb[0] = r
    @rgb[1] = g
    @rgb[2] = b
  end
end
