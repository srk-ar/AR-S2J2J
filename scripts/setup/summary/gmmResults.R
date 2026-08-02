# nolint start
GMMSummary <- local({
  sys.source(
    file.path(root, "scripts", "setup", "summary", "gmpe.R"),
    envir = environment()
  )
  list(
    reference = GMPE.ref,
    attenuation = GMPE.atten,
    spectrum = GMPE.spectrum
  )
})
# nolint end
