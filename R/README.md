<h1>Arquivo com funções para auxiliar em trabalhos</h1>

<p>Olá, turma. Criei esse arquivo com algumas funções que acredito que serão uma mão na roda para auxiliar nos trabalhos diários em R. Confira As funções implementadas:</p>

<h2>Funções implementadas no arquivo:</h2>

[resumoEstatistico()](https://github.com/jlvp000/bau-projetos/edit/main/R/README.md#resumoestatistico)

> [!NOTE]
> Para conseguir usar as funções, baixo o arquivo com o seguinte código:
> 
> ```source("https://raw.githubusercontent.com/jlvp000/bau-projetos/main/R/funcAux.r")```

<h2>resumoEstatistico()</h2>

**Descrição**
<p>A função calcula a mediana, média, desvio padrão, valor mínimo e máximo, momentos centrais até 4ª ordem, quantis e percentis específicos de um  vetor.</p>

**Uso**

  resumoEstatistico(vetor)
  
  '# Padrão:'
  
  resumoEstatistico(vetor, na.rm = FALSE)

**Argumentos**

  X:
  
  um vetor numérico
    
  na.rm = TRUE:
  
  uma booleano, indicando se os valores NA devem ser removidos antes que o cálculo prossiga.

**Exemplos**

```
## Exemplo 1:
varA <- 2
varB <- c("casa", "biscoito", "geladeira")
resumoEstatistico(varA)
resumoEstatistico(varB)

## Exemplo 2: 
dados <- rnorm(1000, 30, 7)
resumoEstatistico(dados)
resumo <- resumoEstatistico(dados)
format(resumo, scientific=FALSE) #formatando o resumo estatístico para evitar a notação científica

# Exemplo 3:
arvores <- apply(trees, 2, resumoEstatistico)
arvores

## Exemplo 4:
resumoEstatistico(airquality[, 1])
```