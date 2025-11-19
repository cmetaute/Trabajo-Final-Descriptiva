# ==============================================================================
# FUNCIONES PARA ANÁLISIS TEMPORAL
# ==============================================================================
# Descripción: Análisis de tendencias, estacionalidad y patrones temporales
# Autor: Grupo 03
# Fecha: Noviembre 2024
# ==============================================================================

library(ggplot2)
library(forecast)


#' Análisis de tendencia usando regresión lineal
#'
#' @param datos Data frame con columnas 'fecha' y 'valor'
#' @param nombre Nombre de la variable
#' @return Lista con modelo, estadísticas y gráfico
#' @export
analisis_tendencia <- function(datos, nombre = "Variable") {
  
  # Eliminar NA
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  # Crear variable numérica de tiempo
  datos_limpios$tiempo <- as.numeric(datos_limpios$fecha)
  
  # Ajustar modelo de regresión lineal
  modelo <- lm(valor ~ tiempo, data = datos_limpios)
  
  # Extraer estadísticas
  coef <- summary(modelo)$coefficients
  r_cuadrado <- summary(modelo)$r.squared
  pendiente <- coef[2, 1]
  p_valor <- coef[2, 4]
  
  # Determinar significancia
  significativo <- p_valor < 0.05
  
  # Crear gráfico
  datos_limpios$prediccion <- predict(modelo)
  
  p <- ggplot(datos_limpios, aes(x = fecha, y = valor)) +
    geom_point(alpha = 0.3, color = "steelblue", size = 1) +
    geom_line(aes(y = prediccion), color = "red", linewidth = 1.2) +
    labs(
      title = paste("Análisis de Tendencia -", nombre),
      subtitle = sprintf(
        "Pendiente: %.4f | R²: %.3f | p-valor: %.4f %s",
        pendiente, r_cuadrado, p_valor,
        ifelse(significativo, "(Significativo)", "(No significativo)")
      ),
      x = "Fecha",
      y = nombre
    ) +
    tema_personalizado()
  
  # Resultados
  resultado <- list(
    modelo = modelo,
    pendiente = pendiente,
    r_cuadrado = r_cuadrado,
    p_valor = p_valor,
    significativo = significativo,
    grafico = p
  )
  
  # Imprimir resumen
  cat("\n╔══════════════════════════════════════════════════════════════╗\n")
  cat("  ANÁLISIS DE TENDENCIA:", nombre, "\n")
  cat("╚══════════════════════════════════════════════════════════════╝\n\n")
  cat(sprintf("  Pendiente:           %.6f\n", pendiente))
  cat(sprintf("  R² (ajuste):         %.4f\n", r_cuadrado))
  cat(sprintf("  p-valor:             %.6f\n", p_valor))
  cat(sprintf("  Significativo (α=0.05): %s\n", ifelse(significativo, "SÍ", "NO")))
  
  if (pendiente > 0) {
    cat("\n  → Tendencia CRECIENTE\n")
  } else if (pendiente < 0) {
    cat("\n  → Tendencia DECRECIENTE\n")
  } else {
    cat("\n  → Sin tendencia clara\n")
  }
  cat("\n")
  
  return(resultado)
}


#' Análisis de estacionalidad mensual
#'
#' @param datos Data frame con columnas 'fecha' y 'valor'
#' @param nombre Nombre de la variable
#' @param unidad Unidad de medida
#' @return Lista con estadísticas y gráficos
#' @export
analisis_estacionalidad_mensual <- function(datos, nombre = "Variable", unidad = "") {
  
  # Asegurar variables temporales
  if (!"mes" %in% colnames(datos)) {
    datos <- agregar_variables_temporales(datos)
  }
  
  # Eliminar NA
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  # Calcular estadísticas por mes
  stats_mes <- aggregate(
    valor ~ mes,
    data = datos_limpios,
    FUN = function(x) {
      c(
        media = mean(x),
        mediana = median(x),
        sd = sd(x),
        min = min(x),
        max = max(x),
        n = length(x)
      )
    }
  )
  
  stats_mes <- do.call(data.frame, stats_mes)
  
  # Nombres de meses
  nombres_meses <- c("Ene", "Feb", "Mar", "Abr", "May", "Jun",
                     "Jul", "Ago", "Sep", "Oct", "Nov", "Dic")
  stats_mes$mes_nombre <- nombres_meses[stats_mes$mes]
  
  # Gráfico de promedios mensuales
  g1 <- ggplot(stats_mes, aes(x = factor(mes), y = valor.media)) +
    geom_bar(stat = "identity", fill = "steelblue", alpha = 0.8) +
    geom_errorbar(aes(ymin = valor.media - valor.sd, 
                      ymax = valor.media + valor.sd),
                  width = 0.2, color = "red") +
    geom_text(aes(label = sprintf("%.1f", valor.media)), 
              vjust = -0.5, size = 3) +
    scale_x_discrete(labels = nombres_meses) +
    labs(
      title = paste("Patrón Mensual -", nombre),
      subtitle = "Barras: Media | Líneas rojas: ± 1 Desv. Est.",
      x = "Mes",
      y = paste(nombre, "(", unidad, ")")
    ) +
    tema_personalizado()
  
  # Boxplot por mes
  g2 <- ggplot(datos_limpios, aes(x = factor(mes), y = valor)) +
    geom_boxplot(fill = "lightblue", alpha = 0.7, outlier.color = "red") +
    scale_x_discrete(labels = nombres_meses) +
    labs(
      title = paste("Distribución Mensual -", nombre),
      x = "Mes",
      y = paste(nombre, "(", unidad, ")")
    ) +
    tema_personalizado()
  
  # Imprimir tabla
  cat("\n╔══════════════════════════════════════════════════════════════╗\n")
  cat("  ANÁLISIS DE ESTACIONALIDAD MENSUAL:", nombre, "\n")
  cat("╚══════════════════════════════════════════════════════════════╝\n\n")
  
  cat(sprintf("%-5s %-8s %-8s %-8s %-8s %-8s\n", 
              "Mes", "Media", "Mediana", "Desv.Est", "Mín", "Máx"))
  cat(strrep("-", 60), "\n")
  
  for (i in 1:12) {
    cat(sprintf("%-5s %8.2f %8.2f %8.2f %8.2f %8.2f\n",
                nombres_meses[i],
                stats_mes$valor.media[i],
                stats_mes$valor.mediana[i],
                stats_mes$valor.sd[i],
                stats_mes$valor.min[i],
                stats_mes$valor.max[i]))
  }
  cat("\n")
  
  # Identificar meses extremos
  mes_max <- stats_mes$mes[which.max(stats_mes$valor.media)]
  mes_min <- stats_mes$mes[which.min(stats_mes$valor.media)]
  
  cat("Mes con mayor promedio:", nombres_meses[mes_max], 
      sprintf("(%.2f %s)\n", max(stats_mes$valor.media), unidad))
  cat("Mes con menor promedio:", nombres_meses[mes_min], 
      sprintf("(%.2f %s)\n", min(stats_mes$valor.media), unidad))
  cat("\n")
  
  return(list(
    estadisticas = stats_mes,
    grafico_barras = g1,
    grafico_boxplot = g2,
    mes_maximo = mes_max,
    mes_minimo = mes_min
  ))
}


#' Análisis de estacionalidad anual
#'
#' @param datos Data frame con columnas 'fecha' y 'valor'
#' @param nombre Nombre de la variable
#' @param unidad Unidad de medida
#' @return Lista con estadísticas y gráfico
#' @export
analisis_estacionalidad_anual <- function(datos, nombre = "Variable", unidad = "") {
  
  # Asegurar variables temporales
  if (!"anio" %in% colnames(datos)) {
    datos <- agregar_variables_temporales(datos)
  }
  
  # Eliminar NA
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  # Calcular estadísticas por año
  stats_anio <- aggregate(
    valor ~ anio,
    data = datos_limpios,
    FUN = function(x) {
      c(
        media = mean(x),
        mediana = median(x),
        sd = sd(x),
        min = min(x),
        max = max(x),
        n = length(x)
      )
    }
  )
  
  stats_anio <- do.call(data.frame, stats_anio)
  
  # Gráfico de evolución anual
  g <- ggplot(stats_anio, aes(x = anio, y = valor.media)) +
    geom_line(color = "steelblue", linewidth = 1.2) +
    geom_point(color = "steelblue", size = 3) +
    geom_ribbon(aes(ymin = valor.media - valor.sd, 
                    ymax = valor.media + valor.sd),
                alpha = 0.2, fill = "steelblue") +
    labs(
      title = paste("Evolución Anual -", nombre),
      subtitle = "Línea: Media | Banda: ± 1 Desv. Est.",
      x = "Año",
      y = paste(nombre, "(", unidad, ")")
    ) +
    scale_x_continuous(breaks = stats_anio$anio) +
    tema_personalizado() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Imprimir tabla
  cat("\n╔══════════════════════════════════════════════════════════════╗\n")
  cat("  ANÁLISIS DE VARIACIÓN ANUAL:", nombre, "\n")
  cat("╚══════════════════════════════════════════════════════════════╝\n\n")
  
  cat(sprintf("%-6s %-10s %-10s %-10s %-10s\n", 
              "Año", "Media", "Desv.Est", "Mín", "Máx"))
  cat(strrep("-", 50), "\n")
  
  for (i in 1:nrow(stats_anio)) {
    cat(sprintf("%-6d %10.2f %10.2f %10.2f %10.2f\n",
                stats_anio$anio[i],
                stats_anio$valor.media[i],
                stats_anio$valor.sd[i],
                stats_anio$valor.min[i],
                stats_anio$valor.max[i]))
  }
  cat("\n")
  
  return(list(
    estadisticas = stats_anio,
    grafico = g
  ))
}


#' Detectar anomalías usando desviación estándar
#'
#' @param datos Data frame con columna 'valor'
#' @param n_sd Número de desviaciones estándar para considerar anomalía
#' @return Data frame con columna adicional 'es_anomalia'
#' @export
detectar_anomalias <- function(datos, n_sd = 3) {
  
  media <- mean(datos$valor, na.rm = TRUE)
  sd <- sd(datos$valor, na.rm = TRUE)
  
  limite_superior <- media + n_sd * sd
  limite_inferior <- media - n_sd * sd
  
  datos$es_anomalia <- datos$valor > limite_superior | datos$valor < limite_inferior
  
  n_anomalias <- sum(datos$es_anomalia, na.rm = TRUE)
  
  cat("\n--- Detección de Anomalías ---\n")
  cat(sprintf("Media: %.2f\n", media))
  cat(sprintf("Desviación estándar: %.2f\n", sd))
  cat(sprintf("Límite inferior (μ - %dσ): %.2f\n", n_sd, limite_inferior))
  cat(sprintf("Límite superior (μ + %dσ): %.2f\n", n_sd, limite_superior))
  cat(sprintf("Anomalías detectadas: %d (%.2f%%)\n", 
              n_anomalias, n_anomalias/nrow(datos)*100))
  cat("\n")
  
  return(datos)
}


#' Análisis de ciclos intraanuales (trimestres, semestres)
#'
#' @param datos Data frame con columnas 'fecha' y 'valor'
#' @param periodo Tipo de período ("trimestre" o "semestre")
#' @param nombre Nombre de la variable
#' @return Lista con estadísticas y gráfico
#' @export
analisis_ciclos_intraanuales <- function(datos, periodo = "trimestre", 
                                        nombre = "Variable") {
  
  # Asegurar variables temporales
  if (!periodo %in% colnames(datos)) {
    datos <- agregar_variables_temporales(datos)
  }
  
  # Eliminar NA
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  # Calcular estadísticas por período
  formula <- as.formula(paste("valor ~", periodo))
  stats_periodo <- aggregate(formula, data = datos_limpios, 
                            FUN = function(x) {
                              c(media = mean(x), sd = sd(x), n = length(x))
                            })
  
  stats_periodo <- do.call(data.frame, stats_periodo)
  
  # Gráfico
  g <- ggplot(stats_periodo, aes(x = factor(get(periodo)), y = valor.media)) +
    geom_bar(stat = "identity", fill = "coral", alpha = 0.8) +
    geom_errorbar(aes(ymin = valor.media - valor.sd, 
                      ymax = valor.media + valor.sd),
                  width = 0.2, color = "darkred") +
    geom_text(aes(label = sprintf("%.1f", valor.media)), 
              vjust = -0.5, size = 4) +
    labs(
      title = paste("Patrón", tools::toTitleCase(periodo), "-", nombre),
      x = tools::toTitleCase(periodo),
      y = paste("Media de", nombre)
    ) +
    tema_personalizado()
  
  return(list(
    estadisticas = stats_periodo,
    grafico = g
  ))
}
