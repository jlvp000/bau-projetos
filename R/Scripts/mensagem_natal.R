


# ---------- Funções utilitárias ----------
circle_pts <- function(cx, cy, r, n = 120){
	t <- seq(0, 2*pi, length.out = n)
	list(x = cx + r * cos(t), y = cy + r * sin(t))
}

ellipse_pts <- function(cx, cy, a, b, angle = 0, n = 120){
	t <- seq(0, 2*pi, length.out = n)
	x <- a * cos(t); y <- b * sin(t)
	xr <- x * cos(angle) - y * sin(angle)
	yr <- x * sin(angle) + y * cos(angle)
	list(x = cx + xr, y = cy + yr)
}

semicircle_bottom <- function(cx, cy, r, n = 120){
	t <- seq(pi, 2*pi, length.out = n)
	list(x = cx + r * cos(t), y = cy + r * sin(t))
}


semicircle_top <- function(cx, cy, r, n = 120){
	t <- seq(0, pi, length.out = n)
	list(x = cx + r * cos(t), y = cy + r * sin(t))
}

# Quadratic Bézier curve (n points) between three control points P0,P1,P2
bezier_quad <- function(P0, P1, P2, n = 100) {
	t <- seq(0, 1, length.out = n)
	x <- (1 - t)^2 * P0[1] + 2 * (1 - t) * t * P1[1] + t^2 * P2[1]
	y <- (1 - t)^2 * P0[2] + 2 * (1 - t) * t * P1[2] + t^2 * P2[2]
	list(x = x, y = y)
}
 
# Rounded rectangle via corner arcs (cx,cy center)
rounded_rect <- function(xleft, ybottom, xright, ytop, r = 0.5, n_arc = 40) {
	# four corner centers
	tl <- circle_pts(xleft + r, ytop - r, r, n = n_arc)[c("x","y")]
	tr <- circle_pts(xright - r, ytop - r, r, n = n_arc)[c("x","y")]
	br <- circle_pts(xright - r, ybottom + r, r, n = n_arc)[c("x","y")]
	bl <- circle_pts(xleft + r, ybottom + r, r, n = n_arc)[c("x","y")]
	# select arcs for each corner (quarters)
	tl_idx <- seq( (n_arc*3/4)+1, n_arc )
	tr_idx <- seq( (n_arc/2)+1, (n_arc*3/4) )
	br_idx <- seq( (n_arc/4)+1, (n_arc/2) )
	bl_idx <- seq( 1, (n_arc/4) )
	x <- c(tl$x[tl_idx], tr$x[tr_idx], br$x[br_idx], bl$x[bl_idx])
	y <- c(tl$y[tl_idx], tr$y[tr_idx], br$y[br_idx], bl$y[bl_idx])
	list(x = x, y = y)
}

res <- 180
palette <- list(red = "#D8292A", dark_red = "#A71C1C", skin = "#F0C89F", white = "#FFFFFF", black = "#222222", gold = "gold", bg = "#FBFBFB")

# ---------- Início do desenho ----------
par(mar = c(0.5, 0.5, 0.5, 0.5))
plot(NA, NA, xlim = c(-10, 10), ylim = c(-14, 12), asp = 1, axes = FALSE, xlab = "", ylab = "", bg = palette$bg)


# ----------------- Corpo (elipse mais suave) -----------------
body <- ellipse_pts(0, -5.2, a = 5.6, b = 4.8, n = 240)
polygon(body$x, body$y, col = palette$red, border = NA)

# sombra lateral sutil (ellipse)
shadow <- ellipse_pts(1.8, -5.6, a = 2.8, b = 3.6, n = round(res*0.6))
polygon(shadow$x, shadow$y, col = palette$dark_red, border = NA)


# ----------------- Botões (círculos com sombra) -----------------
button_ys <- seq(-6.4, -3.0, length.out = )
for (i in seq_along(button_ys)){
	b <- circle_pts(0, button_ys[i], 0.28, n = res)
	polygon(b$x, b$y, col = "white", border = "#CFCFCF")
}


# ----------------- Cinto com borda arredondada -----------------
buckle_outer <- rounded_rect(-1.05, -5.6, 1.05, -4.9, r = 0.25, n_arc = res)
rect(-5.5, -5.7, 5.5, -4.7, col = palette$black, border = NA)	
polygon(buckle_outer$x, buckle_outer$y, col = palette$gold, border = "#8B6F1C", lwd = 1.1)


# ----------------- Rosto -----------------
face <- circle_pts(0, 2.6, 3.0, n = 180)
polygon(face$x, face$y, col = palette$skin, border = NA)
lines(face$x, face$y, col = "#D1A27D", lwd = 1)


# ----------------- Olhos -----------------
eye_l <- circle_pts(-0.95, 3.05, 0.22, n = 80)
polygon(eye_l$x, eye_l$y, col = palette$black, border = NA)
eye_r <- circle_pts(0.95, 3.05, 0.22, n = 80)
polygon(eye_r$x, eye_r$y, col = palette$black, border = NA)

# pequeno brilho
sparkle <- circle_pts(-0.75, 3.2, 0.06, n = 40)
polygon(sparkle$x, sparkle$y, col = palette$white, border = NA)
sparkle2 <- circle_pts(1.15, 3.2, 0.06, n = 40)
polygon(sparkle2$x, sparkle2$y, col = palette$white, border = NA)


# ----------------- barba -----------------

# base da barba (meia elipse inferior)
beard_base <- ellipse_pts(cx = 0, cy = 1.05, a  = 2.25, b  = 1.65, n  = res)
polygon(beard_base$x, beard_base$y, col = palette$white, border = "#E0E0E0")

# recorte superior da barba (para encaixar no rosto)
beard_cut <- ellipse_pts(cx = 0, cy = 1.85, a  = 2.05, b  = 1.05, n  = res)
polygon(beard_cut$x, beard_cut$y, col = palette$skin, border = NA)

# sombras faciais leves (para profundidade)
sh_l <- ellipse_pts(-1.9, 2.2, a = 0.6, b = 0.9, angle = -0.3, n = 60)
polygon(sh_l$x, sh_l$y, col = adjustcolor("#D1A27D", alpha.f = 0.4), border = NA)
sh_r <- ellipse_pts(1.9, 2.2, a = 0.6, b = 0.9, angle = 0.3, n = 60)
polygon(sh_r$x, sh_r$y, col = adjustcolor("#D1A27D", alpha.f = 0.4), border = NA)

# laterais da barba (volume)
beard_l <- ellipse_pts(-1.75, 1.15, a = 0.65, b = 1.25, angle = 0.15, n = 120)
beard_r <- ellipse_pts( 1.75, 1.15, a = 0.65, b = 1.25, angle = -0.15, n = 120)
polygon(beard_l$x, beard_l$y, col = palette$white, border = NA)
polygon(beard_r$x, beard_r$y, col = palette$white, border = NA)


# ----------------- bigode-----------------
m1 <- ellipse_pts(-0.85, 1.9, a = 0.85, b = 0.45, n = res)
polygon(m1$x, m1$y, col = palette$white, border = "#E8E8E8")
m2 <- ellipse_pts(0.85, 1.9, a = 0.85, b = 0.45, n = res)
polygon(m2$x, m2$y, col = palette$white, border = "#E8E8E8")


# ----------------- Nariz -----------------
nose <- circle_pts(0, 2.45, 0.42, n = 100)
polygon(nose$x, nose$y, col = "#E67E22", border = NA)
lines(nose$x, nose$y, col = "#C96418", lwd = 0.8)


# ----------------- Detalhes do corpo -----------------

# mangas
sleeve_l <- ellipse_pts(-4.2, -2.8, a = 1.6, b = 1.4, angle = -0.35, n = res)
sleeve_r <- ellipse_pts(4.2, -2.8, a = 1.6, b = 1.4, angle = 0.35, n = res)
polygon(sleeve_l$x, sleeve_l$y, col = palette$red, border = NA)
polygon(sleeve_r$x, sleeve_r$y, col = palette$red, border = NA)

# mãos (círculos de pele)
hand_l <- circle_pts(-4.3, -2.4, 0.6, n = res)
hand_r <- circle_pts(4.3, -2.4, 0.6, n = res)
polygon(hand_l$x, hand_l$y, col = palette$skin, border = "#D1A27D")
polygon(hand_r$x, hand_r$y, col = palette$skin, border = "#D1A27D")


# ----------------- Gorro -----------------


# parte vermelha do gorro (semicírculo superior)
hat_top <- semicircle_top(cx = 0, cy = 4, r  = 3.15, n  = res)
polygon(hat_top$x, hat_top$y, col = palette$red, border = NA)

# sombra lateral do gorro
hat_shadow <- semicircle_top(cx = 0.6, cy = 4, r  = 2.5, n  = res)
polygon(hat_shadow$x, hat_shadow$y, col = palette$dark_red, border = NA)

# faixa branca do gorro
hat_band <- rounded_rect(
	xleft  = -4, xright =  4,
	ybottom= 3.8, ytop =  4.6,
	r = 0.55, n_arc = res)
polygon(hat_band$x, hat_band$y, col = palette$white, border = "#E0E0E0")

# pompom
pom <- circle_pts(0, 8.0, 0.85, n = 140)
polygon(pom$x, pom$y, col = palette$white, border = "#DDDDDD")


# ----------------- Árvore de Natal -----------------

# posição base da árvore
tx <- -7.8
ty <- -6.5

# tronco
rect(tx - 0.35, ty - 2.0, tx + 0.35, ty - 0.6, col = "#8B5A2B", border = NA)

# copa (três camadas triangulares)
tri1_x <- c(tx - 2.2, tx, tx + 2.2)
tri1_y <- c(ty - 0.6, ty + 2.0, ty - 0.6)

tri2_x <- c(tx - 1.8, tx, tx + 1.8)
tri2_y <- c(ty + 0.6, ty + 3.8, ty + 0.6)

tri3_x <- c(tx - 1.4, tx, tx + 1.4)
tri3_y <- c(ty + 1.8, ty + 5.2, ty + 1.8)

polygon(tri1_x, tri1_y, col = "#1E6B3A", border = NA)
polygon(tri2_x, tri2_y, col = "#238B45", border = NA)
polygon(tri3_x, tri3_y, col = "#2CA25F", border = NA)

# sombra lateral da copa
shade <- ellipse_pts(tx + 0.7, ty + 1.5, a = 0.6, b = 2.2, angle = -0.2, n = 120)
polygon(shade$x, shade$y, col = adjustcolor("black", alpha.f = 0.12), border = NA)

# estrela no topo
star <- function(cx, cy, r1 = 0.45, r2 = 0.2, n = 5){
	angles <- seq(0, 2*pi, length.out = 2*n + 1)
	r <- rep(c(r1, r2), n)
	r <- c(r, r1)
	list(
		x = cx + r * sin(angles),
		y = cy + r * cos(angles)
	)
}
st <- star(tx, ty + 5.9)
polygon(st$x, st$y, col = palette$gold, border = "#8B6F1C")

# bolas decorativas
balls <- data.frame(
	x = c(tx - 0.8, tx + 0.9, tx - 0.4, tx + 0.5, tx - 1.2, tx - 0.5),
	y = c(ty + 1.2, ty + 2.3, ty + 3.4, ty + 1.8, ty + 0.8, ty + 0.7),
	col = c("#D8292A", "#FFD700", "#FFFFFF", "#C0392B", "#FFD700", "#FFFFFF")
)

for(i in seq_len(nrow(balls))){
	b <- circle_pts(balls$x[i], balls$y[i], 0.18, n = 60)
	polygon(b$x, b$y, col = balls$col[i], border = NA)
}


# ----------------- Presentes -----------------

# base próxima ao tronco
px <- -7.2
py <- -9.0

# presente 1
rect(px - 1.6, py, px - 0.6, py + 1.1, col = "#D8292A", border = NA)
rect(px - 1.15, py, px - 1.05, py + 1.1, col = palette$gold, border = NA)
rect(px - 1.6, py + 0.45, px - 0.6, py + 0.6, col = palette$gold, border = NA)

# presente 2
rect(px - 0.4, py - 0.1, px + 0.6, py + 0.8, col = "#2E86C1", border = NA)
rect(px + 0.05, py - 0.1, px + 0.15, py + 0.8, col = palette$white, border = NA)
rect(px - 0.4, py + 0.3, px + 0.6, py + 0.4, col = palette$white, border = NA)

# presente 3 (menor)
rect(px + 0.75, py, px + 1.35, py + 0.6, col = "#27AE60", border = NA)
rect(px + 1.03, py, px + 1.07, py + 0.6, col = palette$gold, border = NA)


# ----------------- Texto final -----------------
text(0, -13.2, "Feliz Natal, R Users!", cex = 1.0, font = 2)


