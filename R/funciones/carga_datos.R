# FUNCIONES PARA CARGA Y LIMPIEZA DE DATOS METEOROLÓGICOS IDEAM
# Descripción: Funciones para cargar archivos CSV del IDEAM y preprocesarlos
# Autor: Grupo 03
# Fecha: Noviembre 2024

#' Cargar archivo CSV del IDEAM
#'
#' Lee un archivo CSV del portal IDEAM con el formato específico:
#' - Separador: punto y coma (;)
#' - Decimal: coma (,)
#' - Primera línea: metadatos (se omite)
#' 
#' @param ruta_archivo Ruta al archivo CSV
#' @param nombre_variable Nombre descriptivo para la variable (opcional)
#' @return Data frame con columnas: fecha, valor
#' @export
cargar_csv_ideam <- function(ruta_archivo, nombre_variable = NULL) {
  
  # Validar que el archivo existe
  if (!file.exists(ruta_archivo)) {
    stop(paste("El archivo no existe:", ruta_archivo))
  }
  
  # Leer el archivo CSV con el formato del IDEAM
  datos <- read.csv2(
    file = ruta_archivo,
    sep = ";",
    dec = ",",
    skip = 1,  # Saltar la primera línea de metadatos
    header = TRUE,
    stringsAsFactors = FALSE,
    encoding = "UTF-8"
  )
  
  # Renombrar columnas a nombres estándar
  colnames(datos) <- c("fecha", "valor")
  
  # Convertir fecha a formato POSIXct
  datos$fecha <- as.POSIXct(datos$fecha, format = "%Y-%m-%d %H:%M:%S", tz = "America/Bogota")
  
  # Convertir valor a numérico (maneja NaN y valores inválidos)
  datos$valor <- as.numeric(datos$valor)
  
  # Redondear a 2 decimales
  datos$valor <- round(datos$valor, 2)
  
  # Agregar columna con el nombre de la variable si se proporciona
  if (!is.null(nombre_variable)) {
    datos$variable <- nombre_variable
  }
  
  # Información del dataset cargado
  cat("Dataset cargado:", ifelse(!is.null(nombre_variable), nombre_variable, basename(ruta_archivo)), "\n")
  cat("Archivo:", basename(ruta_archivo), "\n")
  cat("Período:", format(min(datos$fecha, na.rm = TRUE), "%Y-%m-%d"), "a", 
      format(max(datos$fecha, na.rm = TRUE), "%Y-%m-%d"), "\n")
  cat("Total de registros:", nrow(datos), "\n")
  cat("Valores válidos:", sum(!is.na(datos$valor)), "\n")
  cat("Valores faltantes (NA):", sum(is.na(datos$valor)), 
      sprintf("(%.1f%%)", sum(is.na(datos$valor))/nrow(datos)*100), "\n")

  
  return(datos)
}


#' Limpiar datos eliminando valores faltantes
#'
#' @param datos Data frame con los datos
#' @param verbose Mostrar información del proceso (TRUE/FALSE)
#' @return Data frame sin valores NA
#' @export
limpiar_na <- function(datos, verbose = TRUE) {
  
  n_original <- nrow(datos)
  n_na <- sum(is.na(datos$valor))
  
  # Eliminar filas con NA en la columna valor
  datos_limpios <- datos[!is.na(datos$valor), ]
  
  n_final <- nrow(datos_limpios)
  
  if (verbose) {
    cat("\n--- Limpieza de datos ---\n")
    cat("Registros originales:", n_original, "\n")
    cat("Registros eliminados:", n_na, sprintf("(%.1f%%)", n_na/n_original*100), "\n")
    cat("Registros finales:", n_final, "\n\n")
  }
  
  return(datos_limpios)
}


#' Agregar variables temporales útiles para análisis
#'
#' Agrega columnas con año, mes, día, hora, día del año, etc.
#'
#' @param datos Data frame con columna 'fecha'
#' @return Data frame con columnas temporales adicionales
#' @export
agregar_variables_temporales <- function(datos) {
  
  datos$anio <- as.numeric(format(datos$fecha, "%Y"))
  datos$mes <- as.numeric(format(datos$fecha, "%m"))
  datos$dia <- as.numeric(format(datos$fecha, "%d"))
  datos$hora <- as.numeric(format(datos$fecha, "%H"))
  datos$dia_anio <- as.numeric(format(datos$fecha, "%j"))
  datos$mes_nombre <- format(datos$fecha, "%B")
  datos$trimestre <- ceiling(datos$mes / 3)
  datos$semestre <- ceiling(datos$mes / 6)
  
  # Estación del año (hemisferio norte - Colombia)
  datos$estacion <- cut(datos$mes, 
                        breaks = c(0, 2, 5, 8, 11, 12),
                        labels = c("Verano", "Primavera", "Verano", "Otoño", "Invierno"),
                        include.lowest = TRUE)
  
  return(datos)
}


#' Detectar y marcar valores atípicos usando el método IQR
#'
#' @param datos Data frame con columna 'valor'
#' @param factor_iqr Factor multiplicador del IQR (por defecto 1.5)
#' @return Data frame con columna adicional 'es_atipico' (TRUE/FALSE)
#' @export
detectar_atipicos <- function(datos, factor_iqr = 1.5) {
  
  Q1 <- quantile(datos$valor, 0.25, na.rm = TRUE)
  Q3 <- quantile(datos$valor, 0.75, na.rm = TRUE)
  IQR <- Q3 - Q1
  
  limite_inferior <- Q1 - factor_iqr * IQR
  limite_superior <- Q3 + factor_iqr * IQR
  
  datos$es_atipico <- datos$valor < limite_inferior | datos$valor > limite_superior
  
  n_atipicos <- sum(datos$es_atipico, na.rm = TRUE)
  
  cat("\n--- Detección de valores atípicos ---\n")
  cat("Límite inferior:", round(limite_inferior, 2), "\n")
  cat("Límite superior:", round(limite_superior, 2), "\n")
  cat("Valores atípicos detectados:", n_atipicos, 
      sprintf("(%.2f%%)", n_atipicos/nrow(datos)*100), "\n\n")
  
  return(datos)
}


#' Resumen rápido de un dataset
#'
#' @param datos Data frame con columna 'valor'
#' @param nombre Nombre del dataset
#' @export
resumen_dataset <- function(datos, nombre = "Dataset") {
  
  cat("  RESUMEN:", nombre, "\n")

  
  cat("Estructura:\n")
  cat("  - Dimensiones:", nrow(datos), "filas x", ncol(datos), "columnas\n")
  cat("  - Período:", format(min(datos$fecha, na.rm = TRUE), "%Y-%m-%d"), "a", 
      format(max(datos$fecha, na.rm = TRUE), "%Y-%m-%d"), "\n")
  cat("  - Duración:", round(difftime(max(datos$fecha, na.rm = TRUE), 
                                       min(datos$fecha, na.rm = TRUE), 
                                       units = "days"), 0), "días\n\n")
  
  cat("Valores:\n")
  cat("  - Mínimo:", min(datos$valor, na.rm = TRUE), "\n")
  cat("  - Máximo:", max(datos$valor, na.rm = TRUE), "\n")
  cat("  - Media:", round(mean(datos$valor, na.rm = TRUE), 2), "\n")
  cat("  - Mediana:", round(median(datos$valor, na.rm = TRUE), 2), "\n")
  cat("  - Desv. Est.:", round(sd(datos$valor, na.rm = TRUE), 2), "\n")
  cat("  - NA:", sum(is.na(datos$valor)), 
      sprintf("(%.1f%%)", sum(is.na(datos$valor))/nrow(datos)*100), "\n\n")
}
