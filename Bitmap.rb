class Bitmap


  attr_reader :size, :image_size, :quality, :width, :height
  attr_reader :horizontal_resolution, :vertical_resolution
  

  def row(n)
    @bmp[n]
  end

  def col(n)
    rtn = []
    @bmp.each{|i| rtn << i[n]}
    rtn
  end

  def pt(r, c)
    @bmp[r][c]
  end

  def initialize(filename=NULL)
    if filename == NULL
      @size = 0
      @bmp = [[]]
    else
      File.open(filename, 'r') do |f|
        readcount = 0

        begin
          num1 = f.readchar
          num2 = f.readchar
          readcount += 2
          raise "Invalid Version" unless (num1 == 0x42 && num2 == 0x4D)
          
          @size = read_int(4, f) #read in size of file
  #puts "DIAGNOSTIC MESSAGE: Size is #{@size}"
          readcount += 4

          f.read_int(4) #skip application-specific field
          readcount += 4

          data_offset = read_int(4, f) # location of bitmap data
  #puts "DIAGNOSTIC MESSAGE: Data Offset is #{data_offset}"
          readcount += 4

          remaining_header = read_int(4, f) #remaining bytes in header
  #puts "DIAGNOSTIC MESSAGE: Remaining Header Bytes are #{remaining_header}"
          remaining_header -= 4
          readcount += 4

          @width = read_int(4, f, FALSE) #width of bitmap
  #puts "DIAGNOSTIC MESSAGE: Width is #{@width}"
          remaining_header -= =4
          readcount += 4

          @height = read_int(4, f, FALSE) #height of bitmap
  #puts "DIAGNOSTIC MESSAGE: Height is #{@height}"
          remaining_header -= 4
          readcount += 4
          raise "Height must be positive" unless @height >= 0
          
          @bmp = Array.new(@height){|i| Array.new(@width){|j| NULL}}
          
          
          
          planes = read_int(2, f)
  #puts "DIAGNOSTIC MESSAGE: Number of planes is #{planes}"
          remaining_header -= 2
          readcount += 2
          raise "Invalid Value for num of colour planes; MUST be 1" unless planes == 1

          @quality = read_int(2, f)
  #puts "DIAGNOSTIC MESSAGE: Bits per pixel is #{@quality}"
          remaining_header -= 2
          readcount += 2

          compression = read_int(4, f)
  #puts "DIAGNOSTIC MESSAGE: Compression is #{compression}"
          remaining_header -= 4
          readcount += 4
          raise "Invalid Compression Setting" unless compression == 0

          data_bytes = read_int(4, f)
  #puts "DIAGNOSTIC MESSAGE: Total Data Bytes: #{data_bytes}"
          remaining_header -= 4
          readcount += 4

          @horizontal_resolution = read_int(4, f, FALSE)
  #puts "DIAGNOSTIC MESSAGE: Horizontal Resolution: #{@horizontal_resolution}
  #px/meter"
          remaining_header -= 4
          readcount += 4

          @vertical_resolution = read_int(4, f, FALSE)
  #puts "DIAGNOSTIC MESSAGE: Vertical Resolution: #{@vertical_resolution}
  #px/meter"
          remaining_header -= 4
          readcount += 4

          num_colours = read_int(4, f)
  #puts "DIAGNOSTIC MESSAGE: Num colours in pallette: #{num_colours}"
          remaining_header -= 4
          readcount += 4
          raise "Invalid pallette setting" unless num_colours == 0

          imp_colours = read_int(4, f)
  #puts "DIAGNOSTIC MESSAGE: Important colours: #{imp_colours}"       
          remaining_header -= 4
          readcount += 4
          raise "Invalid setting" unless imp_colours == 0

          raise "Header error" unless remaining_header == 0

          #####BITMAP DATA STARTS HERE#####


          
          
          

          
        end

        

      end


    end

  end



  private
  #evals an array of bytes representing a signed int, into its value
  def twos_comp(arr)
    if arr[-1].to_s(2)[0] == '1' # if negative
      arr.map!{|i| ~i}
      arr[0] += 1
    end
    val = 0
    arr.each_index{|i| val += (arr[i] * (256**i))}
    val
  end

  #reads in an integer of size n from stream instr
  #assumes little-endian (LSB first)
  def read_int(n, instr, unsigned=TRUE)
    arr = Array.new(n){|i| instr.readchar}
    if unsigned
      val = 0
      arr.each_index{|i| val += (arr[i] * (256**i))}
      val
    else
      twos_comp(arr)
    end
  end

  
end
