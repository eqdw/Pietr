
@BITMAP = Bitmap.new(ARGV[0])

#should init to matrix if same size as @BITMAP, all 0
@shape_mask = Array.new(@BITMAP.height){ |i| Array.new(@BITMAP.width){|j| -2 }}

@shapes = [] #stores all shapes indexed sequentially

index = 0 #to give each shape unique index
@shape_mask.size.times do |i|
  @shape_mask[0].size.times do |j|
    if @shape_mask(i,j) == -2
      enumerate_shape(i,j,index)
      index += 1
    end
  end
end






#enumerates all pixels belonging to a shape that includes pixel (i,j)
def enumerate_shape(i,j,index)
  stack = [[i,j]]
  colour = @BITMAP.pt(i,j).copy

  until stack.empty?
    pt = stack.pop
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

  params = [topright, topleft, bottomright, bottomleft, lefttop, leftbottom, righttop, rightbottom, colour]

  @shapes << Shape.new(params)
end
