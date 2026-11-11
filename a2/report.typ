#set page(paper: "a4")
#set text(lang:"pt", region:"br")

#show link: underline

= Questão 1

== (a)
Como exemplo de números que não têm inverso multiplicativo em módulo 26,
podemos citar qualquer número par, uma vez que nunca haverá resto um na
operação de módulo com outro número par (26, no caso). O número 13 também não
possui, uma vez que é divisor de 26. Com exceção desses valores, podemos tomar
sempre um múltiplo inteiro de número primo como tendo inverso multiplicativo em
módulo 26.
A inexistência de inverso multiplicativo tornaria mais impossível o cálculo de uma
inversa da matriz de codificação, impossibilitando assim a decodificação da
mensagem.

== (b)
Em uma operação do tipo produto com o elemento nulo, independente do outro
elemento, o resultado será sempre o próprio produto nulo. Por essa razão, ele
não admite inverso multiplicativo, uma vez que seria necessário que o produto
resultasse na identidade multiplicativa. Apesar disso, não há problemas em
associar caracteres ao número zero, uma vez que isso não implica em nada na
inversibilidade da matriz de codificação, que por sua vez é quem precisa ter
inverso multiplicativo.

== (c)
Se possível, é interessante escolher números primos para a base da aritmética
modular, uma vez que não possuem divisores positivos além de 1 e deles próprios,
o que facilitaria muito a obtenção de inversos multiplicativos.
No caso do alfabeto de 26 caracteres, podemos associar as letras aos dígitos de
1 a 26 em ordem alfabética, e usar os demais dígitos para caracteres especiais,
como espaço (27), ponto (28) e um caractere vazio (29). Dessa forma, teríamos 29
símbolos ao todo, sendo esse um número primo para a aritmética modular.
Note que o número 0 não foi escolhido uma vez que, na linguagem de programação
aqui utilizada (_Julia_), os vetores são indexados em 1.

= Questão 2
== (a)

O inverso multiplicativo de um número $a$ em base $N$ pode ser facilmente obtido
percorrendo os valores de $1$ à $a$ e procurando aquele cuja multiplicação em
base N resulta em 1.

```julia
function mult_inv(a, N)
  for i = 1:N
    if (i*a%N == 1)
      return i
    end
  end
  return nothing
end
```

== (b)

Para a codificação de caracteres, foi criado um dicionário do tipo _Bijection_
seguindo o padrão descrito anteriormente, e as seguintes funções foram criadas
para codificação e decodificação das mensagens:

```julia
function str2val(str)
  vect = collect.(lowercase(str))
  values = zeros(0)

  for i in vect
    try
      append!(values, dict(string(i)))
    catch e
      print("Undefined char detected: ")
      println(i)
      return nothing
    end
  end
  return values
end
```
 
```julia
function val2str(values)
  str = ""

  for i in values
    try
      str*=dict[i] # * operator concatenates to string
    catch e
      print("Undefined value detected: ")
      println(i)
      return nothing
    end
  end
  return str
end

```

== (c)

Dada uma frase a ser codificada `str`, uma matriz quadrada `A` e as funções
auxiliares definidas anteriormente, a implementação da Cifra de Hill segue:

```julia
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
```

Vale notar que, caso o tamanho da frase a ser codificada não seja múltiplo da
dimensão da matriz, a frase é preenchida com o caractere `*` a fim de que a
codificação possa ser realizada.


= Questão 3
Usando a biblioteca `Mods.jl`, a inversão pode ser facilmente realizada na forma:

```julia
function mod_inv(A, N)
  return inv(convert(Array{Mod{N}}, A))
end
```

= Questão 4
Usando as funções desenvolvidas anteriormente e as matrizes dadas, temos:

```julia
julia> mod_inv([7 9; 4 15], 29)
2×2 Matrix{Mod{29}}:
  Mod{29}(4)  Mod{29}(15)
 Mod{29}(26)  Mod{29}(27)

julia> codex("oi meu nome eh gustavo.", [7 9; 4 15])
"zcaxf jjdebaefeumcrsmegg"

julia> codex("zcaxf jjdebaefeumcrsmegg", [4 15; 26 27])
"oi meu nome eh gustavo.*"

julia> codex("a cifra de hill eh muito legal", [7 9; 4 15])
"cn*moocn*ongkxv*efaxj .zuiytmu"

julia> codex("cn*moocn*ongkxv*efaxj .zuiytmu", [4 15; 26 27])
"a cifra de hill eh muito legal"

julia> codex("programar em julia eh divertido. parece matlab com python.", [7 9; 4 15])
" zhbdk tfxuwchhn.dptwmgqj*afztw .kixrrba tajjp sde.kuebgpw"

julia> codex(" zhbdk tfxuwchhn.dptwmgqj*afztw .kixrrba tajjp sde.kuebgpw", [4 15; 26 27])
"programar em julia eh divertido. parece matlab com python."

julia> mod_inv([3 12 1; 1 3 10; 5 5 1], 29)
3×3 Matrix{Mod{29}}:
 Mod{29}(20)  Mod{29}(11)  Mod{29}(15)
 Mod{29}(10)  Mod{29}(28)   Mod{29}(0)
 Mod{29}(24)   Mod{29}(8)  Mod{29}(13)

julia> codex("oi meu nome eh gustavo.", [3 12 1; 1 3 10; 5 5 1])
"tiurvnqcgxxtgyxpodu ar.b"

julia> codex("tiurvnqcgxxtgyxpodu ar.b", [20 11 15; 10 28 0; 24 8 13])
"oi meu nome eh gustavo.*"

julia> codex("a cifra de hill eh muito legal", [3 12 1; 1 3 10; 5 5 1])
"ylqotyzvrmhmwgtrvmkbhfcelmpaam"

julia> codex("ylqotyzvrmhmwgtrvmkbhfcelmpaam", [20 11 15; 10 28 0; 24 8 13])
"a cifra de hill eh muito legal"

julia> codex("programar em julia eh divertido. parece matlab com python.", [3 12 1; 1 3 10; 5 5 1])
"cdat**yitwnrdvvngirvmg*ima lpwph*elflvfteqpxf.mvjuleql*fckon"

julia> codex("cdat**yitwnrdvvngirvmg*ima lpwph*elflvfteqpxf.mvjuleql*fckon", [20 11 15; 10 28 0; 24 8 13])
"programar em julia eh divertido. parece matlab com python.**"

```

= Questão 5
Dado que a cifra de Hill é uma transformação linear, podemos montar um sistema
que busca uma matriz quadrada capaz de atingir a codificação realizada.
