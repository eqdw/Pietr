class Bitmap


  attr_reader :quality, :width, :height, :invert_data
  attr_reader :horizontal_resolution, :vertical_resolution


  def row(n)
    nil
    @bmp[n] if n < @height
  end

  def col(n)
    if n < @width
      rtn = []
      @bmp.each{|i| rtn << i[n]}
      rtn
    else
      nil
    end
  end

  def pt(r, c)
    nil
    @bmp[r][c] if r < @height && c < @width
  end

  def initialize(filename=nil)
    if filename == nil
      @image_size = 0
      @quality = 0
      @width = 0
      @height = 0
      @horizontal_resolution = 0
      @vertical_resolution = 0
      @bmp = nil
    else
      @bmp = [[]] #needs to be declared
      File.open(filename, 'r') do |f|
        readcount = 0

        begin
          num1 = f.readchar
          num2 = f.readchar
          readcount += 2
          raise "Invalid Version" unless (num1 == 0x42 && num2 == 0x4D)
          
          size = read_int(4, f) #read in size of file
  puts "DIAGNOSTIC MESSAGE: Size is #{size}\n"
          readcount += 4

          read_int(4, f) #skip application-specific field
          readcount += 4
  puts "DIAGNOSTIC MESSAGE: Application-specific field skipped\n\n"

          data_offset = read_int(4, f) # location of bitmap data
  puts "DIAGNOSTIC MESSAGE: Data Offset is #{data_offset}\n"
          readcount += 4

          remaining_header = read_int(4, f) #remaining bytes in header
  puts "DIAGNOSTIC MESSAGE: Remaining Header Bytes are #{remaining_header}\n"
          remaining_header -= 4
          readcount += 4

          @width = read_int(4, f, FALSE) #width of bitmap
  puts "DIAGNOSTIC MESSAGE: Width is #{@width}\n\n"
          remaining_header -= 4
          readcount += 4

          @height = read_int(4, f, FALSE) #height of bitmap
  puts "DIAGNOSTIC MESSAGE: Height is #{@height}"
          remaining_header -= 4
          readcount += 4
#          raise "Height must be negative" if @height >= 0
          if @height < 0
            @invert_data = TRUE
            @height = -@height
          end
          
          @bmp = Array.new(@height){|i| Array.new(@width){|j| nil}}
          
          
          
          planes = read_int(2, f)
  puts "DIAGNOSTIC MESSAGE: Number of planes is #{planes}"
          remaining_header -= 2
          readcount += 2
          raise "Invalid Value for num of colour planes; MUST be 1" unless planes == 1

          @quality = read_int(2, f)
  puts "DIAGNOSTIC MESSAGE: Bits per pixel is #{@quality}"
          remaining_header -= 2
          readcount += 2

          compression = read_int(4, f)
  puts "DIAGNOSTIC MESSAGE: Compression is #{compression}"
          remaining_header -= 4
          readcount += 4
          raise "Invalid Compression Setting" unless compression == 0

          data_bytes = read_int(4, f)
  puts "DIAGNOSTIC MESSAGE: Total Data Bytes: #{data_bytes}"
          remaining_header -= 4
          readcount += 4

          @horizontal_resolution = read_int(4, f, FALSE)
  puts "DIAGNOSTIC MESSAGE: Horizontal Resolution: #{@horizontal_resolution}
  px/meter"
          remaining_header -= 4
          readcount += 4

          @vertical_resolution = read_int(4, f, FALSE)
  puts "DIAGNOSTIC MESSAGE: Vertical Resolution: #{@vertical_resolution}
  px/meter"
          remaining_header -= 4
          readcount += 4

          num_colours = read_int(4, f)
  puts "DIAGNOSTIC MESSAGE: Num colours in pallette: #{num_colours}"
          remaining_header -= 4
          readcount += 4
          raise "Invalid pallette setting" unless num_colours == 0

          imp_colours = read_int(4, f)
  puts "DIAGNOSTIC MESSAGE: Important colours: #{imp_colours}"       
          remaining_header -= 4
          readcount += 4
          raise "Invalid setting" unless imp_colours == 0

          raise "Header error" unless remaining_header == 0

          #####BITMAP DATA STARTS HERE#####

          @height.times do |i|
            row_counter = 0
            
            @width.times do |j|
              b = f.readchar
              g = f.readchar
              r = f.readchar

              readcount += 3
              row_counter += 3

              #BMP data is stored bottom-left to top-right
              @bmp[@height - i - 1][j] = Rgb.new(r, g, b)
            end

            #skip over padding bytes (each row of BMP padded to 32-bit boundary
            until( (row_counter % 4) == 0)
              f.readchar
              row_counter += 1
              readcount += 1
            end
          end


          #####END BITMAP DATA#####

          #####MORE ERROR CORRECTION#####
          raise "Read Error" unless readcount == size

          rescue Exception => e
          puts "Error reading bitmap: #{e}"
            
            @image_size = 0
            @quality = 0
            @width = 0
            @height = 0
            @horizontal_resolution = 0
            @vertical_resolution = 0
            @bmp = [[]]
        end
      end
    end
  end


private

  #flips each bit in a string representing a bitvector
  def ones_comp(str)

    arr = str.split('')
    arr.map! do |i|
      if i == '1'
        '0'
      else
        '1'
      end
    end

    arr.join
  end

  
  #evals an array of bytes representing a signed int, into its value
  def twos_comp(arr)

    arr.map!{|i| i.to_s(2)}

    neg = arr[-1][0].chr == '1'
    
    if neg # if negative
      arr.map!{ |i| ones_comp(i) }
    end
      
      
    val = 0
    arr.each_index{|i| val += (arr[i].to_i(2) * (256**i))}
    val += 1 if neg
    val = -val if neg
    val
  end

  #reads in an integer of size n from stream instr
  #assumes little-endian (LSB first)
  def read_int(n, instr, unsigned=TRUE)
    arr = Array.new(n){|i| instr.readchar}
    puts arr
    if unsigned
      val = 0
      arr.each_index{|i| val += (arr[i] * (256**i))}
      val
    else
      twos_comp(arr)
    end
  end
end
