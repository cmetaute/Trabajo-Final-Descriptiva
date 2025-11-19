# ==============================================================================
# SCRIPT DE INSTALACIÓN DE DEPENDENCIAS
# ==============================================================================
# Descripción: Instala todos los paquetes necesarios para el análisis
# Uso: source("instalar_dependencias.R")
# Grupo: 03
# ==============================================================================

cat("\n")
cat("╔══════════════════════════════════════════════════════════════╗\n")
cat("║  INSTALACIÓN DE DEPENDENCIAS                                 ║\n")
cat("║  Análisis Estadístico Descriptivo - IDEAM                    ║\n")
cat("╚══════════════════════════════════════════════════════════════╝\n")
cat("\n")

# ==============================================================================
# CONFIGURACIÓN
# ==============================================================================

# Repositorio CRAN
repo <- "https://cloud.r-project.org/"

# Lista de paquetes requeridos con versiones mínimas
paquetes_requeridos <- data.frame(
  paquete = c("ggplot2", "gridExtra", "scales", "moments", "forecast"),
  version_minima = c("3.4.0", "2.3", "1.2.0", "0.14", "8.20"),
  proposito = c(
    "Visualizaciones de datos",
    "Organización de múltiples gráficos",
    "Escalas y formatos para gráficos",
    "Cálculo de asimetría y curtosis",
    "Análisis de series temporales"
  ),
  stringsAsFactors = FALSE
)

# ==============================================================================
# VERIFICACIÓN DE R
# ==============================================================================

cat("Verificando versión de R...\n")
r_version <- getRversion()
cat(sprintf("  Versión de R instalada: %s\n", r_version))

if (r_version < "4.0.0") {
  cat("\n")
  cat("⚠️  ADVERTENCIA: Se recomienda R versión 4.0.0 o superior\n")
  cat("   Tu versión:", as.character(r_version), "\n")
  cat("   Descargar de: https://cran.r-project.org/\n")
  cat("\n")
  
  respuesta <- readline(prompt = "¿Deseas continuar de todos modos? (s/n): ")
  if (tolower(respuesta) != "s") {
    stop("Instalación cancelada por el usuario")
  }
} else {
  cat("  ✓ Versión de R es compatible\n\n")
}

# ==============================================================================
# VERIFICACIÓN DE PAQUETES INSTALADOS
# ==============================================================================

cat("Verificando paquetes instalados...\n\n")

paquetes_instalar <- character(0)
paquetes_actualizar <- character(0)

for (i in 1:nrow(paquetes_requeridos)) {
  paquete <- paquetes_requeridos$paquete[i]
  version_min <- paquetes_requeridos$version_minima[i]
  
  if (!require(paquete, character.only = TRUE, quietly = TRUE)) {
    # Paquete no instalado
    cat(sprintf("  ✗ %s - NO INSTALADO\n", paquete))
    paquetes_instalar <- c(paquetes_instalar, paquete)
  } else {
    # Paquete instalado, verificar versión
    version_actual <- as.character(packageVersion(paquete))
    cat(sprintf("  ✓ %s - Instalado (versión %s)\n", paquete, version_actual))
    
    if (package_version(version_actual) < package_version(version_min)) {
      cat(sprintf("    ⚠️  Se recomienda versión %s o superior\n", version_min))
      paquetes_actualizar <- c(paquetes_actualizar, paquete)
    }
  }
}

cat("\n")

# ==============================================================================
# INSTALACIÓN DE PAQUETES FALTANTES
# ==============================================================================

if (length(paquetes_instalar) > 0) {
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("PAQUETES A INSTALAR:\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  
  for (paquete in paquetes_instalar) {
    idx <- which(paquetes_requeridos$paquete == paquete)
    cat(sprintf("  • %s\n", paquete))
    cat(sprintf("    Propósito: %s\n", paquetes_requeridos$proposito[idx]))
    cat(sprintf("    Versión mínima: %s\n\n", paquetes_requeridos$version_minima[idx]))
  }
  
  cat("Instalando paquetes...\n\n")
  
  for (paquete in paquetes_instalar) {
    cat(sprintf("Instalando %s...\n", paquete))
    
    tryCatch({
      install.packages(paquete, 
                      repos = repo, 
                      dependencies = TRUE,
                      quiet = FALSE)
      cat(sprintf("  ✓ %s instalado correctamente\n\n", paquete))
    }, error = function(e) {
      cat(sprintf("  ✗ Error al instalar %s\n", paquete))
      cat(sprintf("    Error: %s\n\n", e$message))
    })
  }
} else {
  cat("✓ Todos los paquetes requeridos están instalados\n\n")
}

# ==============================================================================
# ACTUALIZACIÓN DE PAQUETES (OPCIONAL)
# ==============================================================================

if (length(paquetes_actualizar) > 0) {
  cat("═══════════════════════════════════════════════════════════════\n")
  cat("PAQUETES CON VERSIONES ANTIGUAS:\n")
  cat("═══════════════════════════════════════════════════════════════\n\n")
  
  for (paquete in paquetes_actualizar) {
    version_actual <- as.character(packageVersion(paquete))
    idx <- which(paquetes_requeridos$paquete == paquete)
    version_min <- paquetes_requeridos$version_minima[idx]
    cat(sprintf("  • %s (actual: %s, recomendada: %s+)\n", 
                paquete, version_actual, version_min))
  }
  
  cat("\n")
  respuesta <- readline(prompt = "¿Deseas actualizar estos paquetes? (s/n): ")
  
  if (tolower(respuesta) == "s") {
    cat("\nActualizando paquetes...\n\n")
    
    for (paquete in paquetes_actualizar) {
      cat(sprintf("Actualizando %s...\n", paquete))
      
      tryCatch({
        install.packages(paquete, 
                        repos = repo, 
                        dependencies = TRUE,
                        quiet = FALSE)
        cat(sprintf("  ✓ %s actualizado correctamente\n\n", paquete))
      }, error = function(e) {
        cat(sprintf("  ✗ Error al actualizar %s\n", paquete))
        cat(sprintf("    Error: %s\n\n", e$message))
      })
    }
  }
}

# ==============================================================================
# VERIFICACIÓN FINAL
# ==============================================================================

cat("\n")
cat("═══════════════════════════════════════════════════════════════\n")
cat("VERIFICACIÓN FINAL\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

todos_ok <- TRUE

for (i in 1:nrow(paquetes_requeridos)) {
  paquete <- paquetes_requeridos$paquete[i]
  
  if (require(paquete, character.only = TRUE, quietly = TRUE)) {
    version <- as.character(packageVersion(paquete))
    cat(sprintf("  ✓ %s (versión %s)\n", paquete, version))
  } else {
    cat(sprintf("  ✗ %s - ERROR: No se pudo cargar\n", paquete))
    todos_ok <- FALSE
  }
}

cat("\n")

if (todos_ok) {
  cat("╔══════════════════════════════════════════════════════════════╗\n")
  cat("║  ✓ INSTALACIÓN COMPLETADA EXITOSAMENTE                       ║\n")
  cat("╚══════════════════════════════════════════════════════════════╝\n")
  cat("\n")
  cat("Todos los paquetes necesarios están instalados y funcionando.\n")
  cat("Puedes ejecutar el análisis con:\n")
  cat("  source('R/analisis_principal.R')\n\n")
} else {
  cat("╔══════════════════════════════════════════════════════════════╗\n")
  cat("║  ✗ INSTALACIÓN INCOMPLETA                                    ║\n")
  cat("╚══════════════════════════════════════════════════════════════╝\n")
  cat("\n")
  cat("Algunos paquetes no se pudieron instalar.\n")
  cat("Por favor, revisa los errores anteriores.\n\n")
  cat("Soluciones posibles:\n")
  cat("  1. Verificar conexión a internet\n")
  cat("  2. Ejecutar R con permisos de administrador\n")
  cat("  3. Instalar manualmente: install.packages('nombre_paquete')\n\n")
}

# ==============================================================================
# INFORMACIÓN DE SESIÓN
# ==============================================================================

cat("═══════════════════════════════════════════════════════════════\n")
cat("INFORMACIÓN DE SESIÓN\n")
cat("═══════════════════════════════════════════════════════════════\n\n")

print(sessionInfo())

cat("\n")
cat("Para guardar esta información en un archivo:\n")
cat("  sink('session_info.txt')\n")
cat("  sessionInfo()\n")
cat("  sink()\n\n")
