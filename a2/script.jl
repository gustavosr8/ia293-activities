using Bijections
using LinearAlgebra
using Mods

dict = Bijection{Int,String}()
dict[1] = "a"
dict[2] = "b"
dict[3] = "c"
dict[4] = "d"
dict[5] = "e"
dict[6] = "f"
dict[7] = "g"
dict[8] = "h"
dict[9] = "i"
dict[10] = "j"
dict[11] = "k"
dict[12] = "l"
dict[13] = "m"
dict[14] = "n"
dict[15] = "o"
dict[16] = "p"
dict[17] = "q"
dict[18] = "r"
dict[19] = "s"
dict[20] = "t"
dict[21] = "u"
dict[22] = "v"
dict[23] = "w"
dict[24] = "x"
dict[25] = "y"
dict[26] = "z"
dict[27] = " "
dict[28] = "."
dict[29] = "*"

function mult_inv(a, N)
  for i = 1:N
    if (i*a%N == 1)
      return i
    end
  end
  return nothing
end

function str2val(str)
  vect = collect.(lowercase(str))
  values = zeros(0)

  for i in vect
    try
      append!(values, dict(string(i))-1)
    catch e
      print("Undefined char detected: ")
      println(i)
      return nothing
    end
  end
  return values
end

function val2str(values)
  str = ""

  for i in values
    try
      str*=dict[i+1] # * operator concatenates to string
    catch e
      print("Undefined value detected: ")
      println(i)
      return nothing
    end
  end
  return str
end

function codex(str, A)
  m, n = size(A)
  if m != n
    error("cannot find modular inverse of non-square matrix")
  end

  if (length(str) % n != 0)
    str = str * "*"^(n - (length(str) % n))
  end

  vect = str2val(str)

  i = 1
  vect_encoded = zeros(0)
  while true
    v = reshape(vect[i: i+n-1], 1, :)
    encoded = transpose(A * transpose(v)) .% 29
    append!(vect_encoded, encoded)
    i += n
    i <= length(str) || break
  end

  return val2str(vect_encoded)
end

function mod_inv(A, N)
  # Convert A to Mod and invert it
  return inv(convert(Array{Mod{N}}, A))
end


