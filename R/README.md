<h1>Arquivo com funções para auxiliar em trabalhos</h1>

<p>Olá, turma. Criei esse arquivo com algumas funções que acredito que serão uma mão na roda para auxiliar nos trabalhos diários em R. Confira as funções implementadas:</p>

<!-- -------------------------seção------------------------- -->

<h2>Funções implementadas no arquivo:</h2>

+ resEst()
+ deteOut()
+ remOut()

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
outliers <- deteOut(dados_normais)

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
print(dados)
print(dados_sem_outliers)
# Original:  10 11  9 10 11 50  9 10
# Sem outliers: 10 11  9 10 11  9 10
```

<!-- -------------------------seção------------------------- -->
