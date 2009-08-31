class Shape
  attr_reader :topright, :topleft, :bottomright, :bottomleft
  attr_reader :lefttop, :leftbottom, :righttop, :rightbottom
  attr_reader :colour

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
  end
end
