#
## Funções auxiliares para uso no ambiente R
#

#-----------------------------------------------------------------------------------------
# Função para gerar um resumo estatístico descritivo

resEst <- function(vetor) {

	# --- Verifica se o vetor é numérico e contém pelo menos dois elementos ---
	if (!is.numeric(vetor) || length(vetor) < 2) 
		stop("Erro: O argumento de entrada deve ser um vetor numérico e conter mais de um elemento")
	# ---

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

	# --- Verifica se o vetor é numérico e contém pelo menos dois elementos ---
	if (!is.numeric(data) || length(data) < 2) 
		stop("Erro: O argumento de entrada deve ser um vetor numérico e conter mais de um elemento")
	# ---
	
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

	# --- Verifica se o vetor é numérico e contém pelo menos dois elementos
	if (!is.numeric(vetor) || length(vetor) < 2)
		stop("Erro: O argumento de entrada deve ser um vetor numérico e conter mais de um elemento")
	# ---

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
	
	# --- Verifica se o vetor é numérico e contém pelo menos dois elementos ---
	if (!is.numeric(vetor) || length(vetor) < 2)
		stop("Erro: O argumento de entrada deve ser um vetor numérico e conter mais de um elemento")
	# ---

	# Identifica outliers
	indicadores_outliers <- deteOut(vetor)
  
	# Retorna o vetor filtrado sem os outliers
	return(vetor[!indicadores_outliers])
}


#-----------------------------------------------------------------------------------------
# Função para remover outliers de um conjunto de dados agrupados por fatores

remOutGrup <- function(dados, indices_fatores, indice_resposta) {
	
	# --- Verificações de entrada ---
	if (!is.data.frame(dados)) 
		stop("Erro: 'dados' deve ser um objeto do tipo 'data.frame'")

	if (!is.numeric(indices_fatores) || !is.numeric(indice_resposta))
		stop("Erro: 'indices_fatores' e 'indice_resposta' devem ser numéricos")

	if (any(indices_fatores > ncol(dados)) || indice_resposta > ncol(dados))
		stop("Erro: Índices de colunas são inválidos")
	# ---

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


#-----------------------------------------------------------------------------------------
# Função para gerar um data.frame com k grups a partir de intervalos fornecidos de n, média e desvio

gerar_dados <- function(nGrp, intAmos, intMed, intDes) {

	# --- Verificando se os argumentos são válidos ---
	if(!is.numeric(nGrp) || length(nGrp) != 1)
		stop("Erro: 'nGrp' deve ser numérico e de tamanho 1")

	if(!is.numeric(intAmos) || length(intAmos) != 2)
		stop("Erro: 'intAmos' deve ser numérico e de tamanho 2")

	if(!is.numeric(intMed) || length(intMed) != 2)
		stop("Erro: 'intMed' deve ser numérico e de tamanho 2")

	if(!is.numeric(intDes) || length(intDes) != 2)
		stop("Erro: 'intDes' deve ser numérico e de tamanho 2")
	# ---

	# Gerando dados para cada grupo
	amN <- sample(intAmos[1]:intAmos[2], nGrp, replace = TRUE)
	med <- runif(nGrp, intMed[1], intMed[2])
	des <- runif(nGrp, intDes[1], intDes[2])

	# Criando os dados finais
	Grupo <- rep(paste("grupo", 1:nGrp), amN)
	Valor <- unlist(mapply(rnorm, amN, med, des))

	return(data.frame(Grupo, Valor))
}


#------------------------------------------------------------------------
## Função para teste de Kolmogorov-Smirnov e assimetria de Bowley

# Somente estatísticas
ks_teste <- function(VarE, show = FALSE){

	# --- Verificações de entrada
	if (!is.numeric(VarE) || length(VarE) < 2)
		stop("Erro: O argumento de entrada deve ser um vetor numérico e conter mais de um elemento")
	# ---
	
	# Teste de Kolmogorov-Smirnov
	VarE_jittered <- jitter(VarE)
	teste_KS <- ks.test(VarE_jittered, "pnorm", mean(VarE), sd(VarE))
	
	# Assimetria de Bowley
	quan <- quantile(VarE)
	AsB <- (quan[[4]] + quan[[2]] - (2 * quan[[3]])) / (quan[[4]] - quan[[2]])

	if(show == TRUE){
		cat("K-S test\n")
		cat("D = ", round(teste_KS$statistic, 4), "\n")
		cat("p-valor = " , round(teste_KS$p.value, 4), "\n")
		cat("Bowley's Skewness:\n")
		cat("AsB = ", round(AsB, 4), "\n")
	}

	return(c(estatistic_ks = teste_KS$statistic, p_value = teste_KS$p.value, AsB = AsB))
}

# Para apresentação em gráficos
ks_teste_g <- function(VarE) {

	# --- Verificações de entrada
	if (!is.numeric(VarE) || length(VarE) < 2)
		stop("Erro: O argumento de entrada deve ser um vetor numérico e conter mais de um elemento")
	# ---

	# Teste de Kolmogorov-Smirnov 
	VarE_jittered <- jitter(VarE)
	teste_KS <- ks.test(VarE_jittered, "pnorm", mean(VarE), sd(VarE))
	
	# Assimetria de Bowley
	quan <- quantile(VarE)
	AsB <- (quan[[4]] + quan[[2]] - (2 * quan[[3]])) / (quan[[4]] - quan[[2]])

	return(
		c(
			expression(bold("K-S test:")),
			paste0("D = ", round(teste_KS$statistic, 4)),
			paste0("p-valor = " , round(teste_KS$p.value, 4)),
			expression(bold("Bowley's Skewness:")),
			paste0("AsB = ", round(AsB, 4))
		)
	)
}


#-------------------------------------------------------------------------
## Função para encontrar múltiplos (2, 3, 5, 10) para limites em gráficos

mult_lim <- function(vetor, mult = c(2, 3, 5, 10)){

	# --- Verificações de entrada ---
	if(missing(vetor))
		stop("Erro: vetor ausente")

	if(!is.numeric(vetor))
		stop("Erro: vetor deve ser numérico")
	# ---

	menor <- min(vetor, na.rm = TRUE)
	maior <- max(vetor, na.rm = TRUE)

	resultado <- lapply(mult, function(m){
		c(floor(menor / m) * m, ceiling(maior / m) * m)
	})

	names(resultado) <- paste0("m", mult)

	return(resultado)
}


#----------------------------------------------------------------------
## Função para gráfico de apresentação (histograma + métricas) de variáveis/resíduos

gApre <- function(dados, limite_x, limite_y, rotulo_x, pos_legenda1, pos_legenda2){

	# --- Verificações de entrada ---
	if(missing(dados))
		stop("Erro: forneça 'dados'")
	
	if(!is.numeric(dados) || length(dados) < 2)
		stop("Erro: 'dados' deve ser numérico e conter pelo menos 2 observações")
	
	if(missing(limite_x))
		stop("Erro: forneça 'limite_x'")
	
	if(!is.numeric(limite_x) || length(limite_x) != 2)
		stop("Erro: 'limite_x' deve ser um vetor numérico de tamanho 2")
	
	if(limite_x[1] >= limite_x[2])
		stop("Erro: 'limite_x[1]' deve ser menor que 'limite_x[2]'")
	
	if(missing(limite_y))
		stop("Erro: 'limite_y' não foi informado.")
	
	if(!is.numeric(limite_y) || length(limite_y) != 1)
		stop("Erro: 'limite_y' deve ser um valor numérico único")
	
	if(limite_y <= 0)
		stop("Erro: 'limite_y' deve ser positivo")
	
	if(missing(rotulo_x))
		stop("Erro: 'rotulo_x' não foi informado")
	
	if(!is.character(rotulo_x) || length(rotulo_x) != 1)
		stop("Erro: 'rotulo_x' deve ser um texto (string)")
	# ---

	# posições das legendas
	if(missing(pos_legenda1) || missing(pos_legenda2))
		stop("Erro: posições das legendas não foram informadas")
	
	# (aceita tanto texto quanto coordenadas numéricas)
	validar_posicao <- function(pos){
		if(is.character(pos)) return(TRUE)
		if(is.numeric(pos) && length(pos) == 2) return(TRUE)
		stop("Erro: posição de legenda deve ser texto (ex: 'topright') ou coordenadas numéricas c(x, y)")
	}
	
	validar_posicao(pos_legenda1)
	validar_posicao(pos_legenda2)

	# --- Estatísticas básicas ---
	n_obs       <- length(dados)
	valor_min   <- min(dados)
	valor_max   <- max(dados)
	media       <- mean(dados)
	desvio_pad  <- sd(dados)

	# --- Definição das classes do histograma ---
	n_classes   <- ceiling(2 * (n_obs^(1/3)))
	largura_cls <- (valor_max - valor_min) / n_classes
	
	if(largura_cls <= 0)
		stop("Erro: não foi possível calcular classes do histograma (dados constantes?)")
	
	breaks_hist <- seq(valor_min, valor_max, largura_cls)

	# --- Plot ---
	windows(7, 4)
	op <- par(mar = c(3, 3.2, 1, 1))
	
	hist(dados, prob = TRUE,
		xlim = limite_x, ylim = c(0, limite_y), breaks = breaks_hist, right = FALSE,
		xaxp = c(limite_x[1], limite_x[2], 5), yaxp = c(0, limite_y, 6),
		xlab = rotulo_x, ylab = "", main = "",
		mgp = c(1.5, 0.7, 0), border = 0, col = "lightgrey",
		font.lab = 2, font.axis = 2,
		las = 1, cex.axis = 1,
		xaxs = "i", yaxs = "i", bty = "n"
	)

	# --- Curva normal teórica ---
	curve(dnorm(x, mean = media, sd = desvio_pad), from = valor_min, to = valor_max, lty = 4, lwd = 2, add = TRUE)

	# --- Legendas ---
	legend(pos_legenda1, "Distribuição Normal Teórica", lty = 4, lwd = 2, cex = 1.2, bty = "n")

	legend(pos_legenda2, ks_teste_g(dados), cex = 1.2, bty = "n")

	par(op)
}


#----------------------------------------------------------------------
## Função para cálculo de resíduos e R² e Syx

res_r2_syx <- function(y_medido, y_predito, n_par) {

	# --- Verificações de entrada ---
	if(missing(y_medido) || missing(y_predito) || missing(n_par))
		stop("Erro: forneça 'y_medido', 'y_predito' e 'n_par'")

	if (length(y_medido) != length(y_predito))
		stop("Erro: Tamanhos de 'y_medido' e 'y_predito' são diferentes.")

	if (!is.numeric(n_par) || length(n_par) != 1 || n_par >= length(y_medido))
		stop("Erro: 'n_par' deve ser um número único e menor que o número de observações.")
	# ---

	n <- length(y_medido)
	med <- mean(y_medido)

	residuos <- y_medido - y_predito

	SQres <- sum(residuos^2)
	SQexp <- sum((y_predito - med)^2)
	SQtot <- SQexp + SQres

	Syx <- sqrt(SQres / (n - n_par))
	Syx_perc <- Syx / med * 100

	R2 <- SQexp / SQtot
	R2_aj <- 1 - ( (1 - R2) * ( (n - 1) / (n - n_par) ) )

	return(list(
		Syx = Syx,
		Syx_perc = Syx_perc,
		R2 = R2,
		R2_aj = R2_aj,
		residuos = residuos
	))
}


#----------------------------------------------------------------------
## Função para apresentar um gráfico de resíduos

graf_resid <- function(y_pred, residuos, x.lim, y.lim, x.lim.mult, y.lim.mult, x.lab, y.lab, texto, pos.texto){

	# --- Verificações de entrada ---
	if(missing(y_pred) || missing(residuos))
		stop("Erro: forneça 'y_pred' e 'residuos'")

	if(length(y_pred) != length(residuos))
		stop("Erro: 'y_pred' e 'residuos' devem ter o mesmo tamanho")

	if(!is.numeric(y_pred) || !is.numeric(residuos))
		stop("Erro: 'y_pred' e 'residuos' devem ser numéricos")

	if(!missing(x.lim) && !missing(x.lim.mult))
		stop("Erro: usar somente 'x.lim' ou 'x.lim.mult' para limite em x")

	if(!missing(y.lim) && !missing(y.lim.mult))
		stop("Erro: usar somente 'y.lim' ou 'y.lim.mult' para limite em y")

	if(!missing(x.lim.mult)){
		if(!(x.lim.mult %in% c(2, 3, 5, 10)) || length(x.lim.mult) > 1)
			stop("Erro: 'x.lim.mult' deve ser um desses: c(2, 3, 5, 10)")
	}

	if(!missing(y.lim.mult)){
		if(!(y.lim.mult %in% c(2, 3, 5, 10)) || length(y.lim.mult) > 1)
			stop("Erro: 'y.lim.mult' deve ser um desses: c(2, 3, 5, 10)")
	}

	# Limites eixo x
	if(!missing(x.lim)){
		if(!is.numeric(x.lim) || length(x.lim) != 2)
			stop("Erro: 'x.lim' deve ser um vetor numérico de tamanho 2")

		if(x.lim[1] >= x.lim[2])
			stop("Erro: 'x.lim[1]' deve ser menor que 'x.lim[2]'")

		va <- range(y_pred, na.rm = TRUE)
		if(x.lim[1] > va[1] || x.lim[2] < va[2])
			stop("Erro: 'x.lim' deve cobrir todo o intervalo de 'y_pred'")
	} else if(!missing(x.lim.mult)){
		x.lim <- mult_lim(y_pred)[[paste0("m", x.lim.mult)]]
	} else {
		x.lim <- range(y_pred, na.rm = TRUE)
	}

	# Limites eixo y
	if(!missing(y.lim)){
		if(!is.numeric(y.lim) || length(y.lim) != 2)
			stop("Erro: 'y.lim' deve ser um vetor numérico de tamanho 2")

		if(y.lim[1] >= y.lim[2])
			stop("Erro: 'y.lim[1]' deve ser menor que 'y.lim[2]'")

		va <- range(residuos, na.rm = TRUE)
		if(x.lim[1] > va[1] || x.lim[2] < va[2])
			stop("Erro: 'y.lim' deve cobrir todo o intervalo de 'residuos'")
	} else if(!missing(y.lim.mult)){
		y.lim <- mult_lim(residuos)[[paste0("m", y.lim.mult)]]
	} else {
		y.lim <- range(residuos, na.rm = TRUE)
	}

	if(missing(x.lab))
		x.lab <- expression(bold(hat(y)))

	if(missing(y.lab))
		y.lab <- expression(bold(epsilon))

	if(!(is.expression(x.lab) || (is.character(x.lab) && length(x.lab) == 1)))
		stop("Erro: 'x.lab' deve ser expression ou caractere unitário")

	if(!(is.expression(y.lab) || (is.character(y.lab) && length(y.lab) == 1)))
		stop("Erro: 'y.lab' deve ser expression ou caractere unitário")

	if(!missing(texto)){
		if(missing(pos.texto)) stop("Erro: forneça 'pos.texto'")

		if(!missing(pos.texto)){
			if(!(pos.texto %in% c("bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right", "center")))
				stop("Erro: 'pos.texto' deve ser um dentre “bottomright”, “bottom”, “bottomleft”, “left”, “topleft”, “top”, “topright”, “right”, “center”")
		}
	}
	# ---

	# --- Plot ---
	op <- par(mar = c(5, 5, 1, 1), mgp = c(3, 0.8, 0), las = 1)
	plot(1:10, type = "n", xlim = x.lim, ylim = y.lim, xlab = x.lab, ylab = y.lab,
		 cex = 0.9, cex.axis = 1.6, cex.lab = 1.8, font.lab = 2, font.axis = 2)
	abline(h = 0, lty = 2, lwd = 2, col = "red")
	points(y_pred, residuos, pch = 16)

	if(!missing(texto)){
		legend(pos.texto, legend = texto, bty = "n")
	}

	par(op)

}


#-------------------------------------------------------------------------
# Função para apresentar um gráfico limpo

graf_limp <- function(){
	op <- par(mar = c(0, 0, 0, 0))
	on.exit(par(op))
	plot(1:10, 11:20, type = "n", xlab = "", ylab = "", xaxt = "n", yaxt = "n", bty = "n")
}


#-------------------------------------------------------------------------
# Função para apresentar um gráfico limpo com um texto

graf_txt <- function(texto, posicao = "center", ...){

	# --- Verificações de entrada ---
	if(missing(texto) || is.null(texto) || any(is.na(texto)) || any(texto == "")) stop("Erro: forneça 'texto' válido")

	pos_vald <- c("bottomright", "bottom", "bottomleft", "left", "topleft", "top", "topright", "right", "center")

	if(!(posicao %in% pos_vald)) stop(paste("Erro: 'posicao' deve ser um entre:", paste(pos_vald, collapse = ", ")))

	# --- Plot ---
	graf_limp()
	legend(posicao, legend = texto, bty = "n", ...)
}


#-------------------------------------------------------------------------


