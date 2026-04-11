<h1>Arquivo com funções auxiliares para uso no ambiente R</h1>

<p>Olá, turma. Criei este arquivo com algumas funções úteis para auxiliar nas atividades diárias em R. Abaixo estão listadas as funções implementadas no arquivo <code>fun_aux.r</code>.</p>

<!-- -------------------------seção------------------------- -->

<h2>Funções implementadas no arquivo:</h2>

- gerar_dados()
- resEst()
- resEstSim()
- deteOut()
- remOut()
- remOutGrup()
- res_r2_syx()
- mult_lim()
- ks_teste()
- graf_apre()
- graf_limp()
- graf_txt()
- graf_resid()
- ger_equ_lin()

> [!NOTE]
> Para usar as funções, carregue o arquivo com:
>
> ```r
> source("https://raw.githubusercontent.com/jlvp000/bau-projetos/main/R/FuncoesAuxiliares/funcAux.r")
> ```

<!-- -------------------------seção------------------------- -->
<h2>gerar_dados()</h2>

**Descrição:** Gera um <code>data.frame</code> com <em>k</em> grupos, com número de observações, média e desvio-padrão sorteados a partir dos intervalos informados.

**Uso:** <code>gerar_dados(nGrp, intAmos, intMed, intDes)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>nGrp</code> | Número de grupos a serem gerados |
| <code>intAmos</code> | Vetor numérico de dois elementos com o intervalo do tamanho das amostras |
| <code>intMed</code> | Vetor numérico de dois elementos com o intervalo das médias dos grupos |
| <code>intDes</code> | Vetor numérico de dois elementos com o intervalo dos desvios-padrão dos grupos |

**Exemplo**

```r
dados <- gerar_dados(
  nGrp = 7,
  intAmos = c(30, 40),
  intMed  = c(200, 450),
  intDes  = c(10, 20)
)
```

<!-- -------------------------seção------------------------- -->
<h2>resEst()</h2>

**Descrição:** Calcula mediana, média, desvio padrão, mínimo, máximo, momentos centrais até a 4ª ordem e quantis/percentis específicos de um vetor numérico.

**Uso:** <code>resEst(vetor)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>vetor</code> | Vetor numérico com mais de um elemento |

**Exemplos**

```r
dados <- rnorm(1000, 30, 7)
resEst(dados)

arvores <- apply(trees, 2, resEst)
arvores
```

<!-- -------------------------seção------------------------- -->
<h2>resEstSim()</h2>

**Descrição:** Calcula estatísticas descritivas simples para cada coluna de um <code>data.frame</code>.

**Uso:** <code>resEstSim(data)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>data</code> | <code>data.frame</code> com pelo menos duas colunas e mais de uma linha |

**Exemplo**

```r
resEstSim(iris[, 1:4])
```

<!-- -------------------------seção------------------------- -->
<h2>deteOut()</h2>

**Descrição:** Identifica valores atípicos em um vetor numérico pelo critério do intervalo interquartílico.

**Uso:** <code>deteOut(vetor)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>vetor</code> | Vetor numérico com mais de um elemento |

**Exemplo**

```r
dados <- c(10, 11, 9, 10, 11, 50, 9, 10)
outliers <- deteOut(dados)
any(outliers)
```

<!-- -------------------------seção------------------------- -->
<h2>remOut()</h2>

**Descrição:** Remove os valores atípicos de um vetor numérico usando a função <code>deteOut()</code>.

**Uso:** <code>remOut(vetor)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>vetor</code> | Vetor numérico com mais de um elemento |

**Exemplo**

```r
dados <- c(10, 11, 9, 10, 11, 50, 9, 10)
dados_sem_outliers <- remOut(dados)
dados_sem_outliers
```

<!-- -------------------------seção------------------------- -->
<h2>remOutGrup()</h2>

**Descrição:** Remove valores atípicos de um conjunto de dados agrupado por um ou mais fatores, avaliando a variável resposta dentro de cada nível dos fatores.

**Uso:** <code>remOutGrup(dados, indices_fatores, indice_resposta)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>dados</code> | <code>data.frame</code> com os fatores e a variável resposta |
| <code>indices_fatores</code> | Índice(s) das colunas com fator(es) |
| <code>indice_resposta</code> | Índice da coluna com a variável resposta |

**Exemplo**

```r
dados <- data.frame(
  fator1 = sample(c("F1_A", "F1_B", "F1_C"), 100, replace = TRUE),
  fator2 = sample(c("F2_A", "F2_B"), 100, replace = TRUE),
  resposta = rnorm(100, mean = 10, sd = 2)
)

dados$resposta[sample(1:nrow(dados), 5)] <- rnorm(5, mean = 30, sd = 7)

dados_limpos <- remOutGrup(
  dados,
  indices_fatores = 1:2,
  indice_resposta = 3
)
```

<!-- -------------------------seção------------------------- -->
<h2>res_r2_syx()</h2>

**Descrição:** Calcula o erro padrão da estimativa (<em>Syx</em>), o erro padrão percentual, o coeficiente de determinação (<em>R²</em>), o <em>R²</em> ajustado e os resíduos.

**Uso:** <code>res_r2_syx(y_medido, y_predito, n_par)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>y_medido</code> | Vetor com os valores observados da variável resposta |
| <code>y_predito</code> | Vetor com os valores preditos pela modelagem |
| <code>n_par</code> | Número de parâmetros do modelo |

**Exemplo**

```r
mod <- lm(trees$Height ~ trees$Girth)
estMod <- res_r2_syx(trees$Height, predict(mod), n_par = 2)

estMod$R2
estMod$Syx
plot(predict(mod), estMod$residuos)
```

<!-- -------------------------seção------------------------- -->
<h2>mult_lim()</h2>

**Descrição:** Retorna limites inferior e superior ajustados por múltiplos de 2, 3, 5 e 10 para um vetor numérico.

**Uso:** <code>mult_lim(vetor, mult = c(2, 3, 5, 10))</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>vetor</code> | Vetor numérico |
| <code>mult</code> | Múltiplos usados para ajustar os limites |

**Exemplo**

```r
mult_lim(trees$Girth)
```

<!-- -------------------------seção------------------------- -->
<h2>ks_teste()</h2>

**Descrição:** Executa o teste de Kolmogorov-Smirnov contra a distribuição normal e calcula a assimetria de Bowley.

**Uso:** <code>ks_teste(VarE, show = FALSE)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>VarE</code> | Vetor numérico com mais de um elemento |
| <code>show</code> | Se <code>TRUE</code>, imprime os resultados no console |

**Exemplo**

```r
ks_teste(trees$Girth, show = TRUE)
```

<!-- -------------------------seção------------------------- -->
<h2>graf_apre()</h2>

**Descrição:** Gera um histograma com curva normal teórica e apresenta, na legenda, os resultados do teste de normalidade e da assimetria de Bowley.

**Uso:** <code>graf_apre(dados, limite_x, limite_y, rotulo_x, pos_legenda1, pos_legenda2)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>dados</code> | Variável numérica a ser analisada |
| <code>limite_x</code> | Vetor numérico de dois elementos com os limites do eixo x |
| <code>limite_y</code> | Valor numérico positivo para o limite superior do eixo y |
| <code>rotulo_x</code> | Rótulo do eixo x |
| <code>pos_legenda1</code> | Posição da legenda da curva normal teórica |
| <code>pos_legenda2</code> | Posição da legenda com os resultados do teste |

**Exemplo**

```r
graf_apre(
  dados = trees$Girth,
  limite_x = c(5, 25),
  limite_y = 0.25,
  rotulo_x = "Girth Trees",
  pos_legenda1 = "right",
  pos_legenda2 = "topright"
)
```

<!-- -------------------------seção------------------------- -->
<h2>graf_limp()</h2>

**Descrição:** Gera uma área de gráfico limpa, sem eixos, títulos ou moldura.

**Uso:** <code>graf_limp()</code>

**Exemplo**

```r
graf_limp()
```

<!-- -------------------------seção------------------------- -->
<h2>graf_txt()</h2>

**Descrição:** Exibe um texto em um gráfico limpo, em uma posição pré-definida.

**Uso:** <code>graf_txt(texto, posicao = "center", ...)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>texto</code> | Texto a ser exibido |
| <code>posicao</code> | Posição da legenda no gráfico |
| <code>...</code> | Argumentos adicionais repassados à função <code>legend()</code> |

**Exemplo**

```r
graf_txt("Texto de exemplo", posicao = "center", cex = 1.4)
```

<!-- -------------------------seção------------------------- -->
<h2>graf_resid()</h2>

**Descrição:** Produz um gráfico de resíduos em função dos valores preditos, com linha horizontal em zero e opção de legenda.

**Uso:** <code>graf_resid(y_pred, residuos, x.lim, y.lim, x.lim.mult, y.lim.mult, x.lab, y.lab, texto, pos.texto)</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>y_pred</code> | Valores preditos |
| <code>residuos</code> | Resíduos do modelo |
| <code>x.lim</code> | Limites do eixo x |
| <code>x.lim.mult</code> | Múltiplo para ajuste automático do eixo x |
| <code>y.lim</code> | Limites do eixo y |
| <code>y.lim.mult</code> | Múltiplo para ajuste automático do eixo y |
| <code>x.lab</code> | Rótulo do eixo x |
| <code>y.lab</code> | Rótulo do eixo y |
| <code>texto</code> | Texto adicional para a legenda |
| <code>pos.texto</code> | Posição da legenda |

**Exemplo**

```r
mod <- lm(Height ~ Girth, data = trees)
pred <- predict(mod)
res <- trees$Height - pred

graf_resid(
  y_pred = pred,
  residuos = res,
  x.lim.mult = 5,
  y.lim.mult = 2,
  x.lab = expression(bold(hat(y))),
  y.lab = expression(bold(epsilon)),
  texto = "Resíduos do modelo",
  pos.texto = "topright"
)
```

<!-- -------------------------seção------------------------- -->
<h2>ger_equ_lin()</h2>

**Descrição:** Monta a equação linear de um modelo ajustado do tipo <code>lm</code> ou <code>glm</code>.

**Uso:** <code>ger_equ_lin(modelo, variaveis = NULL, resposta = "Y")</code>

| Argumentos | Descrição |
| :--- | :--- |
| <code>modelo</code> | Objeto ajustado do tipo <code>lm</code> ou <code>glm</code> |
| <code>variaveis</code> | Nomes das variáveis explicativas, se desejar substituir os nomes do modelo |
| <code>resposta</code> | Nome da variável resposta na equação |

**Exemplo**

```r
mod <- lm(Height ~ Girth, data = trees)
ger_equ_lin(mod, resposta = "Height")
```
