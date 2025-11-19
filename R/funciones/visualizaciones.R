# ==============================================================================
# FUNCIONES PARA VISUALIZACIONES
# ==============================================================================
# Descripción: Gráficos para análisis descriptivo y exploratorio
# Autor: Grupo 03
# Fecha: Noviembre 2024
# ==============================================================================

library(ggplot2)
library(gridExtra)
library(scales)


#' Configuración de tema para gráficos
#'
#' @return Tema de ggplot2 personalizado
#' @export
tema_personalizado <- function() {
  theme_minimal() +
    theme(
      plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
      plot.subtitle = element_text(size = 11, hjust = 0.5, color = "gray30"),
      axis.title = element_text(size = 11, face = "bold"),
      axis.text = element_text(size = 10),
      legend.title = element_text(size = 10, face = "bold"),
      legend.text = element_text(size = 9),
      panel.grid.major = element_line(color = "gray90"),
      panel.grid.minor = element_line(color = "gray95"),
      plot.margin = margin(10, 10, 10, 10)
    )
}


#' Gráfico de serie temporal
#'
#' @param datos Data frame con columnas 'fecha' y 'valor'
#' @param titulo Título del gráfico
#' @param subtitulo Subtítulo del gráfico
#' @param eje_y Etiqueta del eje Y
#' @param color Color de la línea
#' @return Objeto ggplot
#' @export
grafico_serie_temporal <- function(datos, titulo, subtitulo = NULL, 
                                   eje_y = "Valor", color = "steelblue") {
  
  # Eliminar NA
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  p <- ggplot(datos_limpios, aes(x = fecha, y = valor)) +
    geom_line(color = color, linewidth = 0.6, alpha = 0.8) +
    labs(
      title = titulo,
      subtitle = subtitulo,
      x = "Fecha",
      y = eje_y
    ) +
    scale_x_datetime(date_breaks = "1 year", date_labels = "%Y") +
    tema_personalizado()
  
  return(p)
}


#' Gráfico de serie temporal con media móvil
#'
#' @param datos Data frame con columnas 'fecha' y 'valor'
#' @param titulo Título del gráfico
#' @param eje_y Etiqueta del eje Y
#' @param ventana Tamaño de la ventana para media móvil
#' @param color Color de la línea original
#' @param color_media Color de la media móvil
#' @return Objeto ggplot
#' @export
grafico_serie_con_tendencia <- function(datos, titulo, eje_y = "Valor", 
                                        ventana = 30, color = "gray60", 
                                        color_media = "red") {
  
  # Eliminar NA
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  # Calcular media móvil
  datos_limpios$media_movil <- stats::filter(datos_limpios$valor, 
                                              rep(1/ventana, ventana), 
                                              sides = 2)
  
  p <- ggplot(datos_limpios, aes(x = fecha)) +
    geom_line(aes(y = valor), color = color, linewidth = 0.4, alpha = 0.5) +
    geom_line(aes(y = media_movil), color = color_media, linewidth = 1.2) +
    labs(
      title = titulo,
      subtitle = paste("Media móvil de", ventana, "períodos"),
      x = "Fecha",
      y = eje_y
    ) +
    scale_x_datetime(date_breaks = "1 year", date_labels = "%Y") +
    tema_personalizado()
  
  return(p)
}


#' Histograma con curva de densidad
#'
#' @param datos Data frame con columna 'valor'
#' @param titulo Título del gráfico
#' @param eje_x Etiqueta del eje X
#' @param bins Número de bins para el histograma
#' @param color Color de las barras
#' @return Objeto ggplot
#' @export
grafico_histograma <- function(datos, titulo, eje_x = "Valor", 
                               bins = 30, color = "steelblue") {
  
  # Eliminar NA
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  # Calcular estadísticas para agregar al gráfico
  media <- mean(datos_limpios$valor)
  mediana <- median(datos_limpios$valor)
  
  p <- ggplot(datos_limpios, aes(x = valor)) +
    geom_histogram(aes(y = after_stat(density)), bins = bins, 
                   fill = color, color = "white", alpha = 0.7) +
    geom_density(color = "darkred", linewidth = 1.2) +
    geom_vline(aes(xintercept = media, color = "Media"), 
               linetype = "dashed", linewidth = 1) +
    geom_vline(aes(xintercept = mediana, color = "Mediana"), 
               linetype = "dashed", linewidth = 1) +
    scale_color_manual(
      name = "Estadísticas",
      values = c("Media" = "red", "Mediana" = "blue")
    ) +
    labs(
      title = titulo,
      subtitle = sprintf("Media: %.2f | Mediana: %.2f", media, mediana),
      x = eje_x,
      y = "Densidad"
    ) +
    tema_personalizado()
  
  return(p)
}


#' Boxplot
#'
#' @param datos Data frame con columna 'valor'
#' @param titulo Título del gráfico
#' @param eje_y Etiqueta del eje Y
#' @param color Color del boxplot
#' @return Objeto ggplot
#' @export
grafico_boxplot <- function(datos, titulo, eje_y = "Valor", color = "steelblue") {
  
  # Eliminar NA
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  p <- ggplot(datos_limpios, aes(y = valor)) +
    geom_boxplot(fill = color, alpha = 0.7, outlier.color = "red", 
                 outlier.shape = 16, outlier.size = 2) +
    labs(
      title = titulo,
      y = eje_y
    ) +
    tema_personalizado() +
    theme(axis.text.x = element_blank(),
          axis.ticks.x = element_blank())
  
  return(p)
}


#' Boxplot por grupos (mes, año, etc.)
#'
#' @param datos Data frame con columnas 'valor' y variable de agrupación
#' @param variable_grupo Nombre de la columna para agrupar
#' @param titulo Título del gráfico
#' @param eje_x Etiqueta del eje X
#' @param eje_y Etiqueta del eje Y
#' @param color Color de los boxplots
#' @return Objeto ggplot
#' @export
grafico_boxplot_grupos <- function(datos, variable_grupo, titulo, 
                                   eje_x = "Grupo", eje_y = "Valor", 
                                   color = "steelblue") {
  
  # Eliminar NA
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  p <- ggplot(datos_limpios, aes(x = factor(get(variable_grupo)), y = valor)) +
    geom_boxplot(fill = color, alpha = 0.7, outlier.color = "red", 
                 outlier.size = 1) +
    labs(
      title = titulo,
      x = eje_x,
      y = eje_y
    ) +
    tema_personalizado()
  
  return(p)
}


#' Gráfico de promedios por período
#'
#' @param datos Data frame con columnas 'fecha' y 'valor'
#' @param periodo Período de agregación ("mes", "anio", "trimestre")
#' @param titulo Título del gráfico
#' @param eje_y Etiqueta del eje Y
#' @param tipo Tipo de gráfico ("barras" o "linea")
#' @param color Color del gráfico
#' @return Objeto ggplot
#' @export
grafico_promedios_periodo <- function(datos, periodo = "mes", titulo, 
                                      eje_y = "Promedio", tipo = "barras", 
                                      color = "steelblue") {
  
  # Asegurar variables temporales
  if (!periodo %in% colnames(datos)) {
    datos <- agregar_variables_temporales(datos)
  }
  
  # Calcular promedios
  datos_agrupados <- aggregate(valor ~ get(periodo), data = datos, 
                               FUN = mean, na.rm = TRUE)
  colnames(datos_agrupados) <- c(periodo, "promedio")
  
  if (tipo == "barras") {
    p <- ggplot(datos_agrupados, aes(x = factor(get(periodo)), y = promedio)) +
      geom_bar(stat = "identity", fill = color, alpha = 0.8) +
      geom_text(aes(label = sprintf("%.1f", promedio)), 
                vjust = -0.5, size = 3.5)
  } else {
    p <- ggplot(datos_agrupados, aes(x = get(periodo), y = promedio)) +
      geom_line(color = color, linewidth = 1.2) +
      geom_point(color = color, size = 3)
  }
  
  p <- p +
    labs(
      title = titulo,
      x = tools::toTitleCase(periodo),
      y = eje_y
    ) +
    tema_personalizado()
  
  return(p)
}


#' Gráfico de dispersión entre dos variables
#'
#' @param datos1 Data frame con primera variable
#' @param datos2 Data frame con segunda variable
#' @param nombre1 Nombre de la primera variable
#' @param nombre2 Nombre de la segunda variable
#' @param titulo Título del gráfico
#' @return Objeto ggplot
#' @export
grafico_dispersion <- function(datos1, datos2, nombre1, nombre2, titulo) {
  
  # Combinar datos por fecha
  datos_combinados <- merge(
    datos1[, c("fecha", "valor")],
    datos2[, c("fecha", "valor")],
    by = "fecha",
    suffixes = c("_1", "_2")
  )
  
  # Eliminar NA
  datos_combinados <- datos_combinados[complete.cases(datos_combinados), ]
  
  # Calcular correlación
  correlacion <- cor(datos_combinados$valor_1, datos_combinados$valor_2)
  
  p <- ggplot(datos_combinados, aes(x = valor_1, y = valor_2)) +
    geom_point(alpha = 0.5, color = "steelblue", size = 2) +
    geom_smooth(method = "lm", color = "red", se = TRUE, linewidth = 1) +
    labs(
      title = titulo,
      subtitle = sprintf("Correlación de Pearson: %.3f", correlacion),
      x = nombre1,
      y = nombre2
    ) +
    tema_personalizado()
  
  return(p)
}


#' Panel de visualizaciones completo
#'
#' Crea un panel con múltiples gráficos para análisis exploratorio
#'
#' @param datos Data frame con columnas 'fecha' y 'valor'
#' @param nombre Nombre de la variable
#' @param unidad Unidad de medida
#' @param color Color principal
#' @return Grid de gráficos
#' @export
panel_exploratorio <- function(datos, nombre, unidad, color = "steelblue") {
  
  # Crear gráficos individuales
  g1 <- grafico_serie_temporal(datos, 
                                paste("Serie Temporal -", nombre),
                                eje_y = paste(nombre, "(", unidad, ")"),
                                color = color)
  
  g2 <- grafico_histograma(datos,
                           paste("Distribución -", nombre),
                           eje_x = paste(nombre, "(", unidad, ")"),
                           color = color)
  
  g3 <- grafico_boxplot(datos,
                        paste("Boxplot -", nombre),
                        eje_y = paste(nombre, "(", unidad, ")"),
                        color = color)
  
  # Asegurar variables temporales
  if (!"mes" %in% colnames(datos)) {
    datos <- agregar_variables_temporales(datos)
  }
  
  g4 <- grafico_boxplot_grupos(datos, "mes",
                               paste("Variación Mensual -", nombre),
                               eje_x = "Mes",
                               eje_y = paste(nombre, "(", unidad, ")"),
                               color = color)
  
  # Combinar en grid
  grid.arrange(g1, g2, g3, g4, ncol = 2)
}
