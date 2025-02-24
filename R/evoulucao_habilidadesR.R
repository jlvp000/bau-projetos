
# Definição do vetor de valores para o eixo X
x <- seq(0.2, 20, length.out = 100)

# Definição das curvas que representam diferentes tipos de conhecimento
y1 <- (1 - exp(-0.25 * x)) * 1.5  # Curva de crescimento exponencial (Programação)
y2 <- (x - 4) * 1/7               # Função linear deslocada (Estatística)

# Abre uma nova janela gráfica com dimensões específicas
windows(7, 4)

# Configuração dos parâmetros gráficos
op <- par(mar=c(2.5, 2.5, 1, 1), mgp=c(1, 0, 0))

# Criação do gráfico vazio com limites ajustados e sem eixos desenhados
plot(1:20, 1:20, type="n",
	xlim=c(0, 20), ylim=c(0, 2),
	xlab="Conhecimento", ylab="Habilidade em R", main="",
	xaxs="i", yaxs="i", xaxt="n", yaxt="n",
	font.lab=2, cex.lab=1.2, bty="n")

# Adição de setas para indicar os eixos principais
arrows(x0=0.1, y0=0.01, x1=20, y1=0.01, length=0.1, angle=20, lwd=2)  # Eixo X
arrows(x0=0.1, y0=0.01, x1=0.1, y1=2, length=0.1, angle=20, lwd=2)   # Eixo Y

# Adição das curvas ao gráfico
lines(x, y1, lwd=2, lty=2, col="red")       # Linha tracejada vermelha (Programação)
lines(x, y2, lwd=2, lty=4, col="darkblue")  # Linha pontilhada azul escura (Estatística)

# Adição da legenda no canto superior esquerdo
legend("topleft", inset=c(0.05, 0.01),
	title="Tipo de conhecimento:", title.font=2,
	legend=c("Programação", "Estatística"),
	lwd=2, lty=c(2, 4), col=c("red", "darkblue"), bty="n")

# Restaura os parâmetros gráficos originais
par(op)
