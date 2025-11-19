# ==============================================================================
# FUNCIONES PARA ESTADÍSTICAS DESCRIPTIVAS
# ==============================================================================
# Descripción: Cálculo de medidas de tendencia central, dispersión y forma
# Autor: Grupo 03
# Fecha: Noviembre 2024
# ==============================================================================

library(moments)  # Para asimetría y curtosis


#' Calcular estadísticas descriptivas completas
#'
#' Calcula medidas de tendencia central, dispersión, forma y posición
#'
#' @param datos Vector numérico o data frame con columna 'valor'
#' @param nombre Nombre de la variable (para el reporte)
#' @param unidad Unidad de medida (ej: "mm", "°C")
#' @return Lista con todas las estadísticas calculadas
#' @export
calcular_estadisticas <- function(datos, nombre = "Variable", unidad = "") {
  
  # Si es un data frame, extraer la columna 'valor'
  if (is.data.frame(datos)) {
    valores <- datos$valor
  } else {
    valores <- datos
  }
  
  # Eliminar NA
  valores_limpios <- valores[!is.na(valores)]
  
  if (length(valores_limpios) == 0) {
    warning("No hay valores válidos para calcular estadísticas")
    return(NULL)
  }
  
  # Calcular estadísticas
  estadisticas <- list(
    # Información básica
    n_total = length(valores),
    n_validos = length(valores_limpios),
    n_na = sum(is.na(valores)),
    porcentaje_na = round(sum(is.na(valores)) / length(valores) * 100, 2),
    
    # Medidas de tendencia central
    media = mean(valores_limpios),
    mediana = median(valores_limpios),
    moda = calcular_moda(valores_limpios),
    
    # Medidas de dispersión
    varianza = var(valores_limpios),
    desviacion_estandar = sd(valores_limpios),
    coef_variacion = sd(valores_limpios) / mean(valores_limpios) * 100,
    rango = max(valores_limpios) - min(valores_limpios),
    
    # Medidas de posición
    minimo = min(valores_limpios),
    q1 = quantile(valores_limpios, 0.25, na.rm = TRUE),
    q2 = quantile(valores_limpios, 0.50, na.rm = TRUE),
    q3 = quantile(valores_limpios, 0.75, na.rm = TRUE),
    maximo = max(valores_limpios),
    iqr = IQR(valores_limpios),
    
    # Percentiles adicionales
    p5 = quantile(valores_limpios, 0.05, na.rm = TRUE),
    p10 = quantile(valores_limpios, 0.10, na.rm = TRUE),
    p90 = quantile(valores_limpios, 0.90, na.rm = TRUE),
    p95 = quantile(valores_limpios, 0.95, na.rm = TRUE),
    
    # Medidas de forma
    asimetria = skewness(valores_limpios),
    curtosis = kurtosis(valores_limpios),
    
    # Error estándar
    error_estandar = sd(valores_limpios) / sqrt(length(valores_limpios))
  )
  
  # Redondear a 2 decimales
  estadisticas <- lapply(estadisticas, function(x) {
    if (is.numeric(x)) round(x, 2) else x
  })
  
  return(estadisticas)
}


#' Calcular la moda de un vector
#'
#' @param x Vector numérico
#' @return Valor de la moda (o NA si no hay moda única)
#' @export
calcular_moda <- function(x) {
  ux <- unique(x)
  tab <- tabulate(match(x, ux))
  moda <- ux[tab == max(tab)]
  
  if (length(moda) == length(ux)) {
    return(NA)  # No hay moda
  } else if (length(moda) > 1) {
    return(moda[1])  # Multimodal, devolver la primera
  } else {
    return(moda)
  }
}


#' Imprimir tabla de estadísticas descriptivas
#'
#' @param estadisticas Lista con estadísticas (resultado de calcular_estadisticas)
#' @param nombre Nombre de la variable
#' @param unidad Unidad de medida
#' @export
imprimir_estadisticas <- function(estadisticas, nombre = "Variable", unidad = "") {
  
  cat("\n╔══════════════════════════════════════════════════════════════╗\n")
  cat("  ESTADÍSTICAS DESCRIPTIVAS:", nombre, "\n")
  cat("╚══════════════════════════════════════════════════════════════╝\n\n")
  
  cat("INFORMACIÓN GENERAL\n")
  cat("───────────────────────────────────────────────────────────────\n")
  cat(sprintf("  %-30s %10d\n", "Total de observaciones:", estadisticas$n_total))
  cat(sprintf("  %-30s %10d\n", "Valores válidos:", estadisticas$n_validos))
  cat(sprintf("  %-30s %10d (%.1f%%)\n", "Valores faltantes:", 
              estadisticas$n_na, estadisticas$porcentaje_na))
  
  cat("\nMEDIDAS DE TENDENCIA CENTRAL\n")
  cat("───────────────────────────────────────────────────────────────\n")
  cat(sprintf("  %-30s %10.2f %s\n", "Media:", estadisticas$media, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Mediana:", estadisticas$mediana, unidad))
  if (!is.na(estadisticas$moda)) {
    cat(sprintf("  %-30s %10.2f %s\n", "Moda:", estadisticas$moda, unidad))
  }
  
  cat("\nMEDIDAS DE DISPERSIÓN\n")
  cat("───────────────────────────────────────────────────────────────\n")
  cat(sprintf("  %-30s %10.2f %s²\n", "Varianza:", estadisticas$varianza, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Desviación estándar:", estadisticas$desviacion_estandar, unidad))
  cat(sprintf("  %-30s %10.2f%%\n", "Coeficiente de variación:", estadisticas$coef_variacion))
  cat(sprintf("  %-30s %10.2f %s\n", "Rango:", estadisticas$rango, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Rango intercuartílico (IQR):", estadisticas$iqr, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Error estándar:", estadisticas$error_estandar, unidad))
  
  cat("\nMEDIDAS DE POSICIÓN\n")
  cat("───────────────────────────────────────────────────────────────\n")
  cat(sprintf("  %-30s %10.2f %s\n", "Mínimo:", estadisticas$minimo, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Percentil 5:", estadisticas$p5, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Percentil 10:", estadisticas$p10, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Q1 (Percentil 25):", estadisticas$q1, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Q2 (Mediana, Percentil 50):", estadisticas$q2, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Q3 (Percentil 75):", estadisticas$q3, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Percentil 90:", estadisticas$p90, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Percentil 95:", estadisticas$p95, unidad))
  cat(sprintf("  %-30s %10.2f %s\n", "Máximo:", estadisticas$maximo, unidad))
  
  cat("\nMEDIDAS DE FORMA\n")
  cat("───────────────────────────────────────────────────────────────\n")
  cat(sprintf("  %-30s %10.2f\n", "Asimetría (Skewness):", estadisticas$asimetria))
  
  # Interpretación de asimetría
  if (estadisticas$asimetria < -0.5) {
    cat("    → Distribución asimétrica negativa (cola izquierda)\n")
  } else if (estadisticas$asimetria > 0.5) {
    cat("    → Distribución asimétrica positiva (cola derecha)\n")
  } else {
    cat("    → Distribución aproximadamente simétrica\n")
  }
  
  cat(sprintf("  %-30s %10.2f\n", "Curtosis (Kurtosis):", estadisticas$curtosis))
  
  # Interpretación de curtosis
  if (estadisticas$curtosis > 3) {
    cat("    → Distribución leptocúrtica (más puntiaguda)\n")
  } else if (estadisticas$curtosis < 3) {
    cat("    → Distribución platicúrtica (más aplanada)\n")
  } else {
    cat("    → Distribución mesocúrtica (normal)\n")
  }
  
  cat("\n")
}


#' Crear tabla de estadísticas para exportar
#'
#' @param estadisticas Lista con estadísticas
#' @return Data frame con las estadísticas en formato tabla
#' @export
tabla_estadisticas <- function(estadisticas) {
  
  df <- data.frame(
    Estadistica = c(
      "N Total", "N Válidos", "N Faltantes", "% Faltantes",
      "Media", "Mediana", "Moda",
      "Desviación Estándar", "Varianza", "Coef. Variación (%)",
      "Mínimo", "Q1", "Q2", "Q3", "Máximo",
      "Rango", "IQR",
      "Asimetría", "Curtosis"
    ),
    Valor = c(
      estadisticas$n_total,
      estadisticas$n_validos,
      estadisticas$n_na,
      estadisticas$porcentaje_na,
      estadisticas$media,
      estadisticas$mediana,
      ifelse(is.na(estadisticas$moda), NA, estadisticas$moda),
      estadisticas$desviacion_estandar,
      estadisticas$varianza,
      estadisticas$coef_variacion,
      estadisticas$minimo,
      estadisticas$q1,
      estadisticas$q2,
      estadisticas$q3,
      estadisticas$maximo,
      estadisticas$rango,
      estadisticas$iqr,
      estadisticas$asimetria,
      estadisticas$curtosis
    )
  )
  
  return(df)
}


#' Estadísticas por grupos temporales
#'
#' Calcula estadísticas agrupadas por año, mes, etc.
#'
#' @param datos Data frame con columnas 'fecha' y 'valor'
#' @param agrupar_por Variable temporal para agrupar ("anio", "mes", "trimestre", etc.)
#' @return Data frame con estadísticas por grupo
#' @export
estadisticas_por_periodo <- function(datos, agrupar_por = "anio") {
  
  # Asegurar que existan las variables temporales
  if (!agrupar_por %in% colnames(datos)) {
    datos <- agregar_variables_temporales(datos)
  }
  
  # Agrupar y calcular estadísticas
  resultado <- aggregate(
    valor ~ get(agrupar_por),
    data = datos,
    FUN = function(x) {
      c(
        n = length(x),
        media = mean(x, na.rm = TRUE),
        mediana = median(x, na.rm = TRUE),
        sd = sd(x, na.rm = TRUE),
        min = min(x, na.rm = TRUE),
        max = max(x, na.rm = TRUE)
      )
    }
  )
  
  # Convertir a data frame
  resultado <- do.call(data.frame, resultado)
  colnames(resultado)[1] <- agrupar_por
  
  return(resultado)
}
