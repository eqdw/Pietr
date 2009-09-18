# INITIALIZE SHAPES

##Some constants##
@BLACK = Rgb.new(0,0,0)
@WHITE = Rgb.new(255,255,255)

##get bitmap##
@BITMAP = Bitmap.new(ARGV[0])

#should init to matrix if same size as @BITMAP, all 0
#init to -2 because 0 is a valid shape index, and -1 I can't remember why
#I'm not using it
@shape_mask = Array.new(@BITMAP.height){ |i| Array.new(@BITMAP.width){|j| -2 }}

@shapes = [] #stores all shapes indexed sequentially

index = 0 #to give each shape unique index
@shape_mask.size.times do |i|
  @shape_mask[0].size.times do |j|
    if @BITMAP.pt(i,j) == @WHITE
      @shape_mask[i][j] = "white"
    elsif @BITMAP.pt(i,j) == @BLACK
      @shape_mask[i][j] = "black"
    elsif @shape_mask[i][j] == -2
      enumerate_shape(i,j,index)
      index += 1
    end
  end
end

#END INITIALIZE SHAPES

#shapes are now initialized. We can start execution!


@stack = []
@cur = [0, 0]
@next = [0, 0]
@dp = "right"
@cc = "right"
##first time we run into trouble, toggle cc.
##second time, rotate dp
@toggle? = true

#terminate when 8 loops without doing anything
termcount = 0

until termcount == 8

  ##find current shape
  curshape = @shape_mask[@cur[0], @cur[1]]

  ##find codel where we're transitioning to next shape
  ##set this as current pixel
  @cur = @shapes[curshape].select(@dp, @cc)

  #find next pixel
  @next = next_point @cur

  #several cases are now possible

  #out of bounds
  if out_of_bounds? @next
    toggle
    termcount += 1
  elsif @shape_mask[@next[0]][@next[1]] == "black" 
    #same as out-of-bounds, but I keep it separate for ease of refactoring
    toggle
    termcount += 1
  elsif @shape_mask[@next[0]][@next[1]] == "white"
    #slide in direction of DP until find a non-white
    while @shape_mask[@next[0], @next[1]] == "white"
      @cur = @next
      @next = next_point @cur
    end
    #if it's black/edge, iterate main loop, it'll be taken care of
    #if it's another colour, we want to be *in* that colour, or else it
    #will try to execute an instruction
    @cur = @next unless out_of_bounds? @next || @shape_mask[@next[0]][@next[1]] == "black"
  else #move from colour to another colour

    #get the colours of cur and next
    nextshape = @shape_mask[@next[0]][@next[1]]

    curcolour = @shapes[curshape].colour
    nextcolour = @shapes[nextshape].colour

    




def toggle
  if @toggle?
    @cc = (@cc == "right") ? "left" : "right"
    @toggle? = false
  else
    @dp = case @dp
            when "right" then "down"
            when "down" then "left"
            when "left" then "up"
            when "up" then "right"
    end
    @toggle? = true
  end
end

def next_point(pt)
  case @dp
    when "right" then [pt[0]+1, pt[1]]
    when "left" then [pt[0]-1, pt[1]]
    when "up" then [pt[0], pt[1]-1]
    when "down" then [pt[0], pt[1]+1]
  end
end
        
def out_of_bounds?(pt)
  if pt[0] < 0 || pt[0] >= @BITMAP.height
    return false
  elsif pt[1] < 0 || pt[1] >= @BITMAP.width
    return false
  else
    return true
  end
end

  
#enumerates all pixels belonging to a shape that includes pixel (i,j)
def enumerate_shape(i,j,index)
  stack = [[i,j]]
  colour = @BITMAP.pt(i,j).copy
  pixcount = 0 #count number of pixels
  
  until stack.empty?
    pt = stack.pop
    pixcount += 1
    i = pt[0]
    j = pt[1]

    @shape_mask[i,j] = index #mark point as visited

    if(i > 0 && j >= 0 &&                    #in bounds
       @shape_mask[i-1,j] == -2 &&           #not yet visited
       @BITMAP.pt(i,j) == @BITMAP.pt(i-1, j) #same colour
      ) #visit pt(i-1, j)

      stack << [i-1, j]
    end

    if(i >= = && j > = &&                    #in bounds
       @shape_mask[i,j-1] == -2 &&           #not yet visited
       @BITMAP.pt(i,j) == @BITMAP.pt(i, j-1) #same colour
      )#visit pt(i, j-1)

      stack << [i,j-1]
    end

    if(i < @BITMAP.height - 1 && j < @BITMAP.width && #in bounds
       @shape_mask[i+1, j] == -2 &&                   #not yet visited
       @BITMAP.pt(i,j) == @BITMAP.pt(i+1, j)          #same colour
      )

      stack << [i+1, j]
    end

    if(i < @BITMAP.height && j < @BITMAP.width - 1 && #in bounds
       @shape_mask[i, j+1] == -2 &&                   #not yet visited
       @BITMAP.pt(i,j) == @BITMAP.pt(i, j+1)          #same colour
      )

      stack << [i, j+1]
    end
  end

  #now search the mask for the proper pts for the shape
  left_col = -1
  right_col = -1
  top_row = -1
  bottom_row = -1
  @shape_mask.size.times do |r|
    @shape_mask[0].size.times do |c|
      if @shape_mask[r][c] == index
        if left_col == -1
          left_col = c
        else
          right_col = c
        end

        if top_row == -1
          top_row = c
        else
          bottom_row = c
        end
      end
    end
  end

  # we now have rows and columns. Now it gets more interesting

  #find top points
  topright = [top_row, -1]
  topleft = [top_row, -1]
  @shape_mask[top_row].size.times do |k|
    if @shape_mask[top_row][k] == index
      if topleft[1] == -1
        topleft[1] = index
      else
        topright[1] = index
      end
    end
  end

  #find bottom points
  bottomright = [bottom_row, -1]
  bottomleft = [bottom_row, -1]
  @shape_mask[bottom_row].size.times do |k|
    if @shape_mask[bottom_row][k] == index
      if bottomleft[1] == -1
        bottomleft[1] = index
      else
        bottomright[1] = index
      end
    end
  end

  #find right points
  righttop = [-1, right_col]
  rightbottom = [-1, right_col]
  @shape_mask.size.times do |k|
    if @shape_mask[k][right_col] == index
      if righttop[0] == -1
        righttop[0] = index
      else
        rightbottom[0] = index
      end
    end
  end

  #find left points
  lefttop = [-1, left_col]
  leftbottom = [-1, left_col]
  @shape_mask.size.times do |k|
    if @shape_mask[k][left_col] == index
      if lefttop[0] == -1
        lefttop[0] = index
      else
        leftbottom[0] = index
      end
    end
  end

  params = [topright, topleft, bottomright, bottomleft, lefttop, leftbottom, righttop, rightbottom, colour, pixcount]

  @shapes << Shape.new(params)
end
