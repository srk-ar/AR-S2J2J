suppressMessages(library(gmsp))
dt <- 0.005; t <- seq(0, 10, by = dt); f0 <- 2.0; w0 <- 2*pi*f0
env <- pmin(1, t/1) * pmin(1, (10 - t)/1)
v <- env * sin(w0 * t)
a <- c(0, diff(v))/dt
d <- cumsum(v) * dt
sdof <- gmsp:::.sdofMax
OUT <- NULL
for (Tn in c(0.1, 0.25, 0.5, 1.0)) {
  SDc  <- sdof(a, dt = dt, xi = 0.05, Tn = Tn, ID = "SD")   # oscilador excitado por a
  PSAc <- sdof(a, dt = dt, xi = 0.05, Tn = Tn, ID = "PSA")  # = SDc * K (clasico)
  PSVc <- (2*pi/Tn) * SDc                                    # pseudo-velocidad clasica
  PSVg <- sdof(v, dt = dt, xi = 0.05, Tn = Tn, ID = "PSV")  # gmsp: excitado por v
  SDg  <- sdof(d, dt = dt, xi = 0.05, Tn = Tn, ID = "SD")   # gmsp: excitado por d
  OUT <- rbind(OUT, data.frame(Tn = Tn, PSV.classic = PSVc, PSV.gmsp = PSVg,
                               ratio.PSV = PSVg/PSVc, SD.classic = SDc, SD.gmsp = SDg,
                               ratio.SD = SDg/SDc, PSA.check = PSAc/((2*pi/Tn)^2*SDc)))
}
print(OUT, digits = 4)

# RESULTADO (2026-07-18, gmsp instalado, señal v = env*sin(2*pi*2*t), dt=0.005):
#     Tn PSV.classic PSV.gmsp ratio.PSV SD.classic   SD.gmsp ratio.SD PSA.check
#   0.10      0.2102  0.01657   0.07882   0.003346 2.099e-05 0.006272         1
#   0.25      0.6709  0.05460   0.08138   0.026696 1.679e-04 0.006290         1
#   0.50      9.9442  0.79143   0.07959   0.791338 5.022e-03 0.006347         1
#   1.00      0.6824  0.05501   0.08062   0.108601 7.957e-04 0.007327         1
# VEREDICTO: PSA de gmsp = clasica (K*max|y1| con oscilador excitado por a).
# PSV y SD de gmsp = respuestas de osciladores excitados por v y d
# (TSL2PS.R:180 PAIRS AT->PSA, VT->PSV, DT->SD) — NO son las
# pseudo-ordenadas clasicas omega*SD y SD; difieren por factores
# dependientes del contenido de la senal (aqui ~1/(4*pi) y su cuadrado
# porque f0=2 Hz). DECISION DEL USUARIO pendiente: convencion a
# documentar en el reporte, o bug de gmsp a corregir (afectaria PSL/PSW
# de productos y escenarios en sus columnas PSV/SD; PSA no cambia).
