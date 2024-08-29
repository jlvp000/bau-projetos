#-----------------------------------------------------------------------------------------
# Função para criar gráficos de apresentação de uma variável estatística

# Parâmetros:
# - vetor_dados: vetor de dados numéricos para análise
# - nome_grafico: título do gráfico
# - nome_variavel: nome da variável para o eixo x
# - unidade_medida: unidade de medida da variável

Graf_Apres <- function(vetor_dados, nome_grafico, nome_variavel, unidade_medida){
	# Validação dos argumentos de entrada
	if(!is.numeric(vetor_dados) || length(vetor_dados) < 1){
		return("vetor de entrada inválido")
	}
	if(!is.character(nome_grafico) || !is.character(nome_variavel) || !is.character(unidade_medida)){
		return("argumento de entrada inválido")
	}

	# Cálculos estatísticos básicos
	tamanho_vetor <- length(vetor_dados)
	valor_minimo <- min(vetor_dados)
	valor_maximo <- max(vetor_dados)
	valor_medio <- mean(vetor_dados)
	desvio_padrao <- sd(vetor_dados)

	# Determinação do número de bins para o histograma
	numero_bins <- ceiling((2 * (tamanho_vetor^(1/3))))
	largura_bin <- (valor_maximo - valor_minimo) / numero_bins
	limites_bins <- seq(valor_minimo, valor_maximo, by = largura_bin)

	# Determinação dos limites do eixo x
	limites_eixo_x <- calcMelLim(limites_bins, tipo = "d")

	# Determinação dos limites do eixo y para o histograma
	densidade_dados <- density(vetor_dados)
	limite_superior_y <- calClass(round(max(densidade_dados$y), 3), seq(0.005, 1, 0.005))

	# Inicialização da janela gráfica
	windows(7, 7)
	layout(matrix(1:2, nrow = 2, byrow = TRUE), heights = c(0.2, 0.8))

	# Configuração dos parâmetros gráficos e criação do boxplot
	par(mar = c(0, 3, 3, 1))
	boxplot(vetor_dados, ylim = limites_eixo_x, horizontal = TRUE,
		col = "lightgrey", main = "", xaxt = "n", frame = FALSE)
	title(nome_grafico, line = 1.5, adj = 0)
	mtext("Gráficos de apresentação", line = 0.4, adj = 0)

	# Configuração dos parâmetros gráficos e criação do histograma
	par(mar = c(3, 3, 0, 1))
	hist(vetor_dados, prob = TRUE, xlim = limites_eixo_x, ylim = c(0, limite_superior_y),
		breaks = limites_bins, right = FALSE,
		xaxp = c(limites_eixo_x[1], limites_eixo_x[2], 5),
		yaxp = c(0, limite_superior_y, 6), main = "",
		xlab = paste0(nome_variavel, " [", unidade_medida, "]"), ylab = "fr",
		mgp = c(1.5, 0.7, 0), border = 0, col = "lightgrey",
		cex.axis = 1, xaxs = "i", yaxs = "i", bty = "n"
	)

	# Adição da curva normal teórica ao histograma
	plot(function(x) dnorm(x, valor_medio, desvio_padrao), from = valor_minimo, to = valor_maximo, col = "red", lty = 4, add = TRUE)

	# Inclusão da legenda
	legend("topright", "normal teórica", col = "red", lty = 4, cex = 0.8, bty = "n")
}

#-----------------------------------------------------------------------------------------
# Função auxiliar para calcular melhor limites para os eixos

calcMelLim <- function(vetor, tipo){
	# Validação dos argumentos de entrada
	if(!is.numeric(vetor)){
		return("vetor de entrada inválido")
	}

	# Determinação do limite inferior ou superior ou ambos, dependendo do tipo
	if(tipo == "s"){
		if(length(vetor) == 1){
			return(arredondar_para_cinco(ceiling(vetor), superior = TRUE))
		} else {
			return("comprimento inválido: use tipo = d")
		}
	} else if(tipo == "i"){
		if(length(vetor) == 1){
			return(arredondar_para_cinco(ceiling(vetor), superior = FALSE))
		} else {
		return("comprimento inválido: use tipo = d")
		}
	} else if(tipo == "d"){
		if(length(vetor) > 1){
			return(c(arredondar_para_cinco(ceiling(min(vetor)), superior = FALSE),
				arredondar_para_cinco(ceiling(max(vetor)), superior = TRUE))
			)
		} else {
			return("comprimento inválido: use tipo = list(s, i)")
		}
	} else {
		return("parâmetro tipo inválido: use tipo = list(s, i, d)")
	}
}

#-----------------------------------------------------------------------------------------
# Função auxiliar para arredondar um número para o próximo múltiplo de 5

arredondar_para_cinco <- function(numero, superior){
	repeat{
		if(superior){
			numero <- numero + 1
		} else {
			numero <- numero - 1
		}
		resto <- numero %% 5
		if(resto == 0){
			break()
		}
	}
	return(numero)
}

#-----------------------------------------------------------------------------------------
# Função auxiliar para encontrar a próxima classe numérica maior que um valor dado

calClass <- function(valor, sequencia_classes){
	for(valor_classe in sequencia_classes){
		if(valor_classe > valor){
			return(valor_classe)
		}
	}
	return(NA)
}

#-----------------------------------------------------------------------------------------
