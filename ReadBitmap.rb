#translates an array of signed bytes into it's value
def twos_comp(arr)
  if arr[-1].to_s(2)[0] == '1' #if negative
    arr.map!{|i| ~i}
    arr[0] += 1
  end
  val = 0
  arr.each_index { |i| val += arr[i] * (256**i) }

  val
end


#read in an integer of size n from stream instr
#assumes stream is LITTLE-endian
def read_int(n, instr, unsigned = TRUE)
  arr = Array.new(n){|i| instr.readchar}
  if unsigned
    val = 0
    arr.each_index{|i| val += (arr[i] * (256**i))}
    val
  else
    twos_comp(arr)
  end
end
  

def read_bitmap( filename )
 
