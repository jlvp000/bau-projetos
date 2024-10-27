<h1>Arquivo com funções para auxiliar em trabalhos</h1>

<p>Olá, turma. Criei esse arquivo com algumas funções que acredito que serão uma mão na roda para auxiliar nos trabalhos diários em R. Confira as funções implementadas:</p>

<!-- -------------------------seção------------------------- -->

<h2>Funções implementadas no arquivo:</h2>

+ resEst()
+ ‎resEstSim()
+ deteOut()
+ remOut()
+ remOutGrup()
+ ks_teste()
+ gApre()
+ ‎res_r2_syx()

> [!NOTE]
> Para conseguir usar as funções, baixe o arquivo com o seguinte código:
> 
> ```source("https://raw.githubusercontent.com/jlvp000/bau-projetos/main/R/funcAux.r")```

<!-- -------------------------seção------------------------- -->
<h2>resEst()</h2>

**Descrição:** Calcula a mediana, média, desvio padrão, valor mínimo e máximo, momentos centrais até 4ª ordem, quantis e percentis específicos de um  vetor. 

**Uso:** resEst(vetor)

| Argumentos | Descrição |
| :--- | :--- |
| vetor | um vetor numérico |

**Exemplos**

```
## Exemplo 1:
varA <- 2
varB <- c("casa", "biscoito", "geladeira")
resEst(varA)
resEst(varB)

## Exemplo 2: 
dados <- rnorm(1000, 30, 7)
resEst(dados)
resumo <- resEst(dados)
format(resumo, scientific=FALSE) #formatando o resumo estatístico para evitar a notação científica

# Exemplo 3:
arvores <- apply(trees, 2, resEst)
arvores

## Exemplo 4:
vetor <- airquality[, 1]
resEst(vetor)
vetor <- vetor[!is.na(vetor)] # Remove NAs do vetor
resEst(vetor)
```

<!-- -------------------------seção------------------------- -->
<h2>‎‎resEstSim()</h2>

**Descrição:** Calcula a mediana, média, desvio padrão, valor mínimo e máximo das colunas de um data.frame.

**Uso:** resEstSim(data.frame)

| Argumentos | Descrição |
| :--- | :--- |
| data.frame | data.frame numérico |

**Exemplos**

```
resEstSim(iris[, 1:4])
```

<!-- -------------------------seção------------------------- -->
<h2>deteOut()</h2>

**Descrição:** Detecta outliers em um vetor numérico usando o método dos quantis.

**Uso:** deteOut(vetor)

| Argumentos | Descrição |
| :--- | :--- |
| vetor | um vetor número |

**Exemplos**

```
# Conjunto de dados numéricos com outliers
dados <- c(10, 11, 9, 10, 11, 50, 9, 10)

# Identificação de outliers
outliers <- deteOut(dados)

# Se houver ao menos um outlier, retorna TRUE
any(outliers)
```

<!-- -------------------------seção------------------------- -->
<h2>remOut()</h2>

**Descrição:** Remove outliers de um vetor numérico usando a função `deteOut()`.

**Uso:** remOut(vetor)

| Argumentos | Descrição |
| :--- | :--- |
| vetor | um vetor número |

**Exemplos**

```
dados <- c(10, 11, 9, 10, 11, 50, 9, 10)

# Remoção dos outliers
dados_sem_outliers <- remOut(dados)

# Exibir o conjunto de dados original e o filtrado
dados
dados_sem_outliers
```

<!-- -------------------------seção------------------------- -->
<h2>remOutGrup()</h2>

**Descrição:** Remove outliers de um conjunto de dados agrupados por fatores usando a função `deteOut()`.

**Uso:** remOutGrup(dados, indices_fatores, indice_resposta)

| Argumentos | Descrição |
| :--- | :--- |
| dados | Dados de entrada com o(s) fator(es) e variável resposta. Argumento deve ser do tipo `data.freme` |
| indices_fatores | Índice(s) da(s) coluna(s) com fator(es) |
| indice_resposta | Índice da coluna com variável resposta |

**Exemplos**

```
# Criar um conjunto de dados simulado
dados <- data.frame(
	fator1 = sample(c("F1_A", "F1_B", "F1_C"), 100, replace = TRUE),
	fator2 = sample(c("F2_A", "F2_B"), 100, replace = TRUE),
	resposta = rnorm(100, mean = 10, sd = 2)
)

# Adicionando outliers em posições aleatórias
dados$resposta[sample(1:nrow(dados), 5)] <- rnorm(5, mean = 30, sd = 7)

# Remover outliers
dados_limpos <- remOutGrup(
	dados,
	indices_fatores = 1:2,	# Índices das colunas dos fatores
	indice_resposta = 3	# Índice da coluna de resposta
)

# Visualizando dados
par(mfrow = c(2, 2), mar=c(2, 2, 2.5, 1))
boxplot(resposta ~ fator1, data=dados, main="Com outlier")
boxplot(resposta ~ fator1, data=dados_limpos, main="Sem outlier")
boxplot(resposta ~ fator2, data=dados)
boxplot(resposta ~ fator2, data=dados_limpos)
```

<!-- -------------------------seção------------------------- -->
<h2>ks_teste()</h2>

**Descrição:** Imprime os resultados do teste KS, incluindo a estatística D e o p-valor, bem como o valor da assimetria de Bowley.

**Uso:** ks_teste(vetor)

| Argumentos | Descrição |
| :--- | :--- |
| vetor | um vetor número |

**Exemplos**

```
# Aplicando a função ao conjunto de dados trees
ks_teste(trees$Girth)
```

<!-- -------------------------seção------------------------- -->
<h2>‎gApre()</h2>

**Descrição:** Realiza a plotagem de um histograma para um vetor de uma variável, juntamente com uma curva normal teórica, teste KS e assimetria de Bowley.

**Uso:** gApre(xlim, ylim, xlab, posicao1, posicao2)

| Argumentos | Descrição |
| :--- | :--- |
|VarE | Uma variável numérica para a qual o histograma será gerado |
|xlim |	Um vetor de dois elementos que define os limites inferior e superior do eixo x do gráfico |
|ylim |	Um valor numérico que define o limite superior do eixo y do gráfico |
|xlab | Um rótulo de texto para o eixo x do gráfico |
|posicao1 | A posição para inserir a legenda da curva normal teórica |
|posicao2 | A posição para inserir a legenda do resultado do teste de normalidade |

**Exemplos**

```
# ver limites dos eixos
hist(trees$Girth, prob=TRUE)

gApre(
	# VarE: Seleciona a coluna 'Girth' do conjunto de dados 'trees'.
	trees$Girth, 
	# xlim: Define os limites do eixo x para o intervalo de 5 a 25.
	xlim=c(5, 25), 
	# ylim: Define o limite superior do eixo y para 0.25.
	ylim=0.25, 
	# xlab: Define o rótulo do eixo x como "Girth Trees".
	xlab="Girth Trees", 
	# posicao1: Define a posição da legenda da curva normal teórica para o lado direito.
	posicao1="right", 
	# posicao2: Define a posição da legenda do resultado do teste de normalidade para o canto superior direito.
	posicao2="topright"
)
```

<!-- -------------------------seção------------------------- -->
<h2>‎res_r2_syx()</h2>

**Descrição:** Calcula o coeficiente de determinação (R²), erro padrão do modelo (Syx) e resíduos.

**Uso:** ‎res_r2_syx(y_medido, y_predito)

| Argumentos | Descrição |
| :--- | :--- |
| y_medido | Valores reais ou observados da variável resposta |
| y_predito | Valores previstos ou estimados pela modelagem ou método de previsão |


**Exemplos**

```
mod <- lm(trees$Height ~ trees$Girth)

estMod <- res_r2_syx(trees$Height, predict(mod))

# Coeficiente de determinação - R²
estMod$R2

# Erro padrão
estMod$Syx

# gráfico de resíduos
plot(predict(mod), estMod$residuos)
```

<!-- -------------------------seção------------------------- -->
