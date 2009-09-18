class Shape
  attr_reader :topright, :topleft, :bottomright, :bottomleft
  attr_reader :lefttop, :leftbottom, :righttop, :rightbottom
  attr_reader :colour, :size

  def select(dp, cc)
    if cc == "right"
      case dp
        when "up" then return @topright
        when "down" then return @bottomright
        when "right" then return @rightbottom
        when "left" then return @lefttop
      end
    elsif cc == "left"
      case dp
        when "up" then return @topleft
        when "down" then return @bottomleft
        when "right" then return @righttop
        when "left" then return @leftbottom
      end
    end
  end
  
  def initialize(params)
    @topright = params[0]
    @topleft = params[1]
    @bottomright = params[2]
    @bottomleft = params[3]
    @lefttop = params[4]
    @leftbottom = params[5]
    @righttop = params[6]
    @rightbottom = params[7]
    @colour = params[8]
    @size = params[9]
  end
end
