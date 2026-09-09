#set page(paper: "a4")
#set text(lang:"pt", region:"br")

#show link: underline

= Questão 1
Para checarmos se um ponto encontra-se dentro de um polígono convexo, podemos
basear-nos no algorítimo de Shimrat e checar se o ponto está do mesmo lado de
todos os segmentos. Para isso, podemos usar o produto escalar do vetor formado
entre o ponto e a normal do segmento a ser testado. Como o produto é
proporcional ao cosseno do angulo formado entre o segmento e o ponto, se o
calcularmos com a normal do vértice, um resultado positivo significar estar a
direita e um resultado negativo significa estar a esquerda.

*Baseado em:*
- #link("https://stackoverflow.com/questions/1119627/how-to-test-if-a-point-is-inside-of-a-convex-polygon-in-2d-integer-coordinates")
- #link("https://math.stackexchange.com/questions/274712/calculate-on-which-side-of-a-straight-line-is-a-given-point-located")

= Questão 2
O método descrito foi implementado e testado com 2 figuras, cuja área pode ser
facilmente calculada:

#table(
  columns: 5,
  inset: 10pt,
  align: horizon,
  table.header(
    [*Vértices*], [*Área teórica*], [*100 pontos*], [*1000 pontos*], [*10000 pontos*]
  ),
  `[[0.1,0.1],[0.1,0.7],[0.4,0.7],[0.4,0.1]]`,$ 0.18 $, $ 0.2 $, $0.189$, $0.1794$,
  `[[0.2,0.3],[0.4,0.7],[0.6,0.3]]`,$ 0.08 $, $ 0.08 $, $0.08$, $0.0737$
)

O resultado visual pode ser observado abaixo:


#table(
  columns: 3,
  align: horizon,
  table.header(
    [*100 pontos*], [*1000 pontos*], [*10000 pontos*]
  ),
  image("q2-f1-100.pdf"), image("q2-f1-1000.pdf"), image("q2-f1-10000.pdf"),
  image("q2-f2-100.pdf"), image("q2-f2-1000.pdf"), image("q2-f2-10000.pdf")
)

= Questão 3
Como forma de testar um polígono mais complexo, foram escolhidos os pontos
aleatórios `[[0.2,0.3],[0.4,0.7],[0.6,0.6],[0.7,0.4],[0.6,0.3],[0.4,0.1]]` e,
utilizando o algorítimo desenvolvido, foi calculado o valor de $0.1629$ para a
área, gerando a seguinte figura:

#figure(image("q3-10000.pdf"))

Para tal, foi também calculada a área utilizado a biblioteca
_PolygonAlgorithms_, que implementa a fórmula de _Shoe-lace_ no método
_area_polygon_. Dessa forma, a área estimada foi de $0.165$.

= Questão 4
Com o algorítimo implementado, é esperado que pontos vizinhos formem uma aresta,
para o qual calcularemos o vetor normal que será por fim utilizado para decidir
se o ponto está ou não no polígono. No caso de termos pontos desordenados, seria
necessário um passo anterior de ordena-los.

= Questão 5
No caso de um polígono não convexo, não temos mais a garantia de que o produto
escalar do ponto com o vetor normal à aresta ditem se o ponto está ou não no
polígono, uma vez que o normal apontaria para o lado oposto do esperado.
