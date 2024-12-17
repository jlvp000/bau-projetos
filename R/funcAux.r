#
## Funções auxiliares para uso no ambiente R
#

#-----------------------------------------------------------------------------------------
# Função para gerar um resumo estatístico descritivo
resEst <- function(vetor){
	# Verifica se o vetor é numérico e contém pelo menos dois elementos
	if (!is.numeric(vetor) || length(vetor) < 2) {
		stop("O argumento de entrada deve ser um vetor numérico e conter mais de um elemento")
	}

	tamanho <- length(vetor)
	mediana <- median(vetor)
	media <- mean(vetor)
	desvioPadrao <- sd(vetor)
	minimo <- min(vetor)
	maximo <- max(vetor)

	# Momentos centrais de primeira a quarta ordem
	momento1 <- sum(vetor - media) / tamanho
	momento2 <- sum((vetor - media)^2) / tamanho
	momento3 <- sum((vetor - media)^3) / tamanho
	momento4 <- sum((vetor - media)^4) / tamanho

	# Percentis específicos
	percentis <- c(0.01, 0.05, 0.10, 0.25, 0.75, 0.90, 0.95, 0.99)
	quantis <- quantile(vetor, probs = percentis)

	# Criação de um data frame com os resultados
	resumo <- data.frame(
		Estimador = c("n", "mediana", "media", "desvioPadrao", "minimo", "maximo",
			"P1", "P5", "P10", "Q1", "Q3", "P90", "P95", "P99", "m1", "m2", "m3", "m4"),
		Estatistica = c(tamanho, mediana, media, desvioPadrao, minimo, maximo,
			quantis[1], quantis[2], quantis[3], quantis[4], quantis[5], quantis[6], quantis[7], quantis[8],
			momento1, momento2, momento3, momento4)
	)

	# Retorna o data frame com o resumo estatístico
	return(resumo)
}

#-----------------------------------------------------------------------------------------
## Função para estatísticas descritivas simples de um data.frame
resEstSim <- function(data) {
	est <- data.frame(
		minimo = apply(data, 2, min, na.rm = TRUE),
		mediana = apply(data, 2, median, na.rm = TRUE),
		maximo = apply(data, 2, max, na.rm = TRUE),
		media = apply(data, 2, mean, na.rm = TRUE),
		desvio_padrao = apply(data, 2, sd, na.rm = TRUE)
	)
	return(round(est, 4))
}

#-----------------------------------------------------------------------------------------
# Função para identificar valores atípicos (outliers) em um vetor
deteOut <- function(vetor) {
	# Verifica se o vetor é numérico e contém pelo menos dois elementos
	if (!is.numeric(vetor) || length(vetor) < 2) {
		stop("O argumento de entrada deve ser um vetor numérico e conter mais de um elemento")
	}

	# Calcula o primeiro e o terceiro quartis
	primeiro_quartil <- quantile(vetor, probs = 0.25)
	terceiro_quartil <- quantile(vetor, probs = 0.75)
  
	# Calcula a amplitude interquartílica (IQR)
	iqr <- terceiro_quartil - primeiro_quartil

	# Define os limites inferior e superior para identificação de outliers
	limite_inferior <- primeiro_quartil - (1.5 * iqr)
	limite_superior <- terceiro_quartil + (1.5 * iqr)

	# Retorna um vetor lógico indicando quais dados são outliers
	# Verdadeiro para outliers, Falso para dados dentro do intervalo normal
	return(vetor < limite_inferior | vetor > limite_superior)
}

#-----------------------------------------------------------------------------------------
# Função para remover outliers de um vetor
remOut <- function(vetor) {
	# Verifica se o vetor é numérico e contém pelo menos dois elementos
	if (!is.numeric(vetor) || length(vetor) < 2) {
		stop("O argumento de entrada deve ser um vetor numérico e conter mais de um elemento")
	}

	# Identifica outliers
	indicadores_outliers <- deteOut(vetor)
  
	# Retorna o vetor filtrado sem os outliers
	return(vetor[!indicadores_outliers])
}

#-----------------------------------------------------------------------------------------
# Função para remover outliers de um conjunto de dados agrupados por fatores
remOutGrup <- function(dados, indices_fatores, indice_resposta) {
	# Verificar se o argumento 'dados' é um dataframe
	if (!is.data.frame(dados)) {
		stop("O argumento 'dados' deve ser um objeto do tipo 'data.frame'")
	}
	# Verificar se os índices são numéricos
	if (!is.numeric(indices_fatores) || !is.numeric(indice_resposta)) {
		stop("Os argumentos 'indices_fatores' e 'indice_resposta' devem ser numéricos")
	}
	# Verificar se os índices de colunas são válidos
	if (any(indices_fatores > ncol(dados)) || indice_resposta > ncol(dados)) {
		stop("Índices de colunas são inválidos")
	}

	# Inicializar matriz para contar outliers por nível dos fatores
	contagem_outliers <- matrix(ncol = length(indices_fatores), nrow = nrow(dados), data = 0)

	# Iterar sobre cada coluna de fator
	for (indice_fator in indices_fatores) {
		# Identificar os níveis do fator
		niveis_fator <- levels(as.factor(dados[[indice_fator]]))

		# Para cada nível, identificar e contar outliers na coluna de resposta
		for (nivel in niveis_fator) {
			# Filtrar dados para o nível atual do fator
			dados_atual <- dados[dados[[indice_fator]] == nivel, ]
			# Identificar valores outliers na coluna de resposta
			valores_outliers <- deteOut(dados_atual[[indice_resposta]])
			# Contar outliers e atribuir na matriz
			contagem_outliers[dados[[indice_fator]] == nivel, which(indices_fatores == indice_fator)] <- valores_outliers
		}
	}

	# Calcular o total de outliers por linha
	soma_outliers <- apply(contagem_outliers, 1, sum)

	# Filtrar e retornar o dataframe sem os outliers
	dados_sem_outliers <- dados[soma_outliers == 0, ]

	return(dados_sem_outliers)
}

#------------------------------------------------------------------------
## Função para teste de Kolmogorov-Smirnov e assimetria de Bowley
ks_teste <- function(VarE) {

	# Teste de Kolmogorov-Smirnov
	VarE_jittered <- jitter(VarE)
	teste_KS <- ks.test(VarE_jittered, "pnorm", mean(VarE), sd(VarE))
	
	# Assimetria de Bowley
	quan <- quantile(VarE)
	AsB <- (quan[[4]] + quan[[2]] - (2 * quan[[3]])) / (quan[[4]] - quan[[2]])

	cat("K-S test\n")
	cat("D = ", round(teste_KS$statistic, 4), "\n")
	cat("p-valor = " , round(teste_KS$p.value, 4), "\n")
	cat("Bowley's Skewness:\n")
	cat("AsB = ", round(AsB, 4), "\n")
}

ks_teste_g <- function(VarE) {

	# Teste de Kolmogorov-Smirnov 
	VarE_jittered <- jitter(VarE)
	teste_KS <- ks.test(VarE_jittered, "pnorm", mean(VarE), sd(VarE))
	
	# Assimetria de Bowley
	quan <- quantile(VarE)
	AsB <- (quan[[4]] + quan[[2]] - (2 * quan[[3]])) / (quan[[4]] - quan[[2]])

	return(
		c(
			expression(bold("teste K-S:")),
			paste0("D = ", round(teste_KS$statistic, 4)),
			paste0("p-valor = " , round(teste_KS$p.value, 4)),
			expression(bold("Assimetria de Bowley:")),
			paste0("AsB = ", round(AsB, 4))
		)
	)
}

#-------------------------------------------------------------------------
## Função do Gráfico de apresentação
gApre <- function(VarE, xlim, ylim, xlab, posicao1, posicao2){

	 n  <- length(VarE)
	inf <- min(VarE)
	sup <- max(VarE)
	med <- mean(VarE)
	des <- sd(VarE)

	    k <- ceiling((2*(n^(1/3))))
	   h1 <- (sup-inf)/k
	legH1 <- seq(inf, sup, h1)

	windows(7, 4)
	par(mar=c(3, 3.2, 1, 1))
	hist(VarE, prob=T, xlim=xlim, ylim=c(0, ylim), breaks=legH1, right=F, xaxp=c(xlim[1], xlim[2], 5), yaxp=c(0, ylim, 6), main="",
		xlab=xlab, ylab="", mgp=c(1.5, 0.7, 0), border=0, col="lightgrey", font.lab=2, font.axis=2,
		las=1, cex.axis=1, xaxs="i", yaxs="i", bty="n")
	#curva normal teorica
	plot(function(x) dnorm(x, med, des), from=inf, to=sup, col="red", lty=4, lwd=2, add=TRUE)
	#legendas
	legend(posicao1, "normal teórica", col="red", lty=4, lwd=2, cex=1.2, bty="n")
	legend(posicao2, ks_teste_g(VarE), cex=1.2, bty="n")
}

#----------------------------------------------------------------------
## Função para cálculo de resíduos e R² e Syx
res_r2_syx <- function(y_medido, y_predito) {
	if (length(y_medido) != length(y_predito)) {
		stop("Erro: Tamanho de y_medido e y_predito são diferentes!")
	}

	residuos <- y_medido - y_predito
	SST <- sum((y_medido - mean(y_medido))^2)
	SSR <- sum(residuos^2)
	R2 <- 1 - (SSR / SST)
	Syx <- sqrt(SSR / (length(y_medido)-2))
  
	return(list(R2 = R2, Syx = Syx, residuos = residuos))
}

#-------------------------------------------------------------------------
