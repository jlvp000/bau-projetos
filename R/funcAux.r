
#
## Funções auxiliares para uso no ambiente R
#

#-----------------------------------------------------------------------------------------
# Função para gerar um resumo estatístico descritivo no ambiente R

resumoEstatistico <- function(vetor, na.rm = FALSE){
	# Verifica se o vetor de entrada é numérico após remover NAs se na.rm for TRUE
	if (!is.numeric(vetor) || (na.rm && any(is.na(vetor)))) {
		vetor <- vetor[!is.na(vetor)] # Remove NAs do vetor
	}
	if (!is.numeric(vetor) || length(vetor) < 2) {
		stop("O vetor de entrada deve ser numérico e conter mais de um elementos após remover NAs")
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
# Função para identificar valores atípicos (outliers) em um vetor

deteOut <- function(vetor) {
	# Verifica se o vetor é numérico e contém pelo menos dois elementos
	if (!is.numeric(vetor) || length(vetor) < 2) {
		stop("O vetor de entrada deve ser numérico e conter mais de um elemento")
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
	# Verifica se o vetor de entrada é numérico e maior que 1
	if (!is.numeric(vetor) || length(vetor) < 2) {
		stop("O vetor de entrada deve ser numérico e conter mais de um elementos")
	}

	# Identifica outliers
	indicadores_outliers <- deteOut(vetor)
  
	# Retorna o vetor filtrado sem os outliers
	return(vetor[!indicadores_outliers])
}

#-----------------------------------------------------------------------------------------
