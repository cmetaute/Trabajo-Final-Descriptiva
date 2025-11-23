# ==============================================================================
# ANÁLISIS ESTADÍSTICO DESCRIPTIVO Y EXPLORATORIO
# Datos Meteorológicos IDEAM - Análisis Multi-Estación
# ==============================================================================
# Descripción: Análisis descriptivo y exploratorio de precipitación y 
#              temperatura de 7 estaciones meteorológicas en Cali, Colombia
# Fuente: IDEAM (http://aquariuswebportal.ideam.gov.co)
# Grupo: 03
# Fecha: Noviembre 2024
# ==============================================================================

# Limpiar entorno
rm(list = ls())
gc()

cat("\n")
cat("╔══════════════════════════════════════════════════════════════╗\n")
cat("║  ANÁLISIS DESCRIPTIVO Y EXPLORATORIO MULTI-ESTACIÓN          ║\n")
cat("║  Datos Meteorológicos IDEAM - Cali, Colombia                 ║\n")
cat("╚══════════════════════════════════════════════════════════════╝\n")
cat("\n")

# ==============================================================================
# 1. CONFIGURACIÓN E INSTALACIÓN DE PAQUETES
# ==============================================================================

# Configurar biblioteca local
lib_local <- "~/R/library"
if (!dir.exists(lib_local)) {
  dir.create(lib_local, recursive = TRUE)
}
.libPaths(c(lib_local, .libPaths()))

# Paquetes necesarios
paquetes_necesarios <- c("ggplot2", "gridExtra", "scales", "moments", "dplyr", 
                         "tidyr", "lubridate")

cat("Verificando e instalando paquetes necesarios...\n")
for (paquete in paquetes_necesarios) {
  if (!require(paquete, character.only = TRUE, quietly = TRUE)) {
    cat(paste("Instalando", paquete, "...\n"))
    install.packages(paquete, dependencies = TRUE, 
                    repos = "https://cloud.r-project.org/", 
                    lib = lib_local)
    library(paquete, character.only = TRUE)
  }
}
cat("Todos los paquetes están listos\n\n")

# ==============================================================================
# 2. DEFINICIÓN DE ESTACIONES
# ==============================================================================

# Información de las estaciones meteorológicas
estaciones <- data.frame(
  codigo = c("26055120", "26075150", "26095320", "26055100", 
             "26075120", "26055110", "26085160"),
  nombre = c("UDV", "Aeropuerto Bonilla", "El Vínculo", "Farallones",
             "La Diana", "La Independencia", "Siloé"),
  nombre_corto = c("UDV", "Aeropuerto", "ElVinculo", "Farallones",
                   "LaDiana", "LaIndependencia", "Siloe"),
  stringsAsFactors = FALSE
)

cat("Estaciones a analizar:\n")
print(estaciones)
cat("\n")

# ==============================================================================
# 3. FUNCIÓN DE CARGA DE DATOS
# ==============================================================================

cargar_datos_estacion <- function(archivo, tipo_variable, nombre_estacion) {
  # Leer CSV con formato IDEAM
  datos <- read.csv2(archivo, 
                     skip = 1,  # Saltar línea de metadatos
                     header = TRUE,
                     sep = ";",
                     dec = ",",
                     stringsAsFactors = FALSE,
                     na.strings = c("NA", "NaN", ""))
  
  # Renombrar columnas
  colnames(datos) <- c("fecha_hora", "valor")
  
  # Convertir fecha
  datos$fecha_hora <- as.POSIXct(datos$fecha_hora, format = "%Y-%m-%d %H:%M:%S")
  
  # Convertir valor a numérico
  datos$valor <- as.numeric(datos$valor)
  
  # Eliminar NAs
  datos <- datos[!is.na(datos$valor), ]
  
  # Agregar variables temporales
  datos$fecha <- as.Date(datos$fecha_hora)
  datos$anio <- year(datos$fecha_hora)
  datos$mes <- month(datos$fecha_hora)
  datos$mes_nombre <- month.name[datos$mes]
  datos$dia_anio <- yday(datos$fecha_hora)
  datos$trimestre <- quarter(datos$fecha_hora)
  
  # Agregar información de estación
  datos$estacion <- nombre_estacion
  datos$tipo_variable <- tipo_variable
  
  return(datos)
}

# ==============================================================================
# 4. CARGAR TODOS LOS DATOS
# ==============================================================================

cat("Cargando datos de precipitación...\n")
datos_precip_list <- list()
for (i in 1:nrow(estaciones)) {
  archivo <- paste0("datos/precipitacion/", 
                   estaciones$nombre_corto[i],
                   "_DataSetExport-PRECIPITACION.PT_10_MX_D@",
                   estaciones$codigo[i],
                   "-Maximum-mm-20251120*.csv")
  archivo <- Sys.glob(archivo)[1]
  
  if (file.exists(archivo)) {
    cat(paste("  -", estaciones$nombre[i], "\n"))
    datos_precip_list[[i]] <- cargar_datos_estacion(
      archivo, "Precipitación", estaciones$nombre[i]
    )
  }
}
datos_precip <- do.call(rbind, datos_precip_list)

cat("\nCargando datos de temperatura...\n")
datos_temp_list <- list()
for (i in 1:nrow(estaciones)) {
  archivo <- paste0("datos/temperatura/", 
                   estaciones$nombre_corto[i],
                   "_DataSetExport-TEMPERATURA.TA2_AUT_60@",
                   estaciones$codigo[i],
                   "-Maximum-degC-20251120*.csv")
  archivo <- Sys.glob(archivo)[1]
  
  if (file.exists(archivo)) {
    cat(paste("  -", estaciones$nombre[i], "\n"))
    datos_temp_list[[i]] <- cargar_datos_estacion(
      archivo, "Temperatura", estaciones$nombre[i]
    )
  }
}
datos_temp <- do.call(rbind, datos_temp_list)

cat("\n")
cat("Resumen de datos cargados:\n")
cat(paste("  - Precipitación:", nrow(datos_precip), "registros\n"))
cat(paste("  - Temperatura:", nrow(datos_temp), "registros\n"))
cat(paste("  - TOTAL:", nrow(datos_precip) + nrow(datos_temp), "registros\n\n"))

# ==============================================================================
# 5. CREAR DIRECTORIOS DE SALIDA
# ==============================================================================

dir.create("resultados", showWarnings = FALSE)
dir.create("resultados/figuras", recursive = TRUE, showWarnings = FALSE)
dir.create("resultados/tablas", recursive = TRUE, showWarnings = FALSE)

# ==============================================================================
# 6. ESTADÍSTICAS DESCRIPTIVAS POR ESTACIÓN
# ==============================================================================

calcular_estadisticas <- function(datos, variable_nombre) {
  stats <- datos %>%
    group_by(estacion) %>%
    summarise(
      N = n(),
      Media = round(mean(valor, na.rm = TRUE), 2),
      Mediana = round(median(valor, na.rm = TRUE), 2),
      Desv_Std = round(sd(valor, na.rm = TRUE), 2),
      Min = round(min(valor, na.rm = TRUE), 2),
      Max = round(max(valor, na.rm = TRUE), 2),
      Q1 = round(quantile(valor, 0.25, na.rm = TRUE), 2),
      Q3 = round(quantile(valor, 0.75, na.rm = TRUE), 2),
      IQR = round(IQR(valor, na.rm = TRUE), 2),
      CV_pct = round(sd(valor, na.rm = TRUE) / mean(valor, na.rm = TRUE) * 100, 2),
      Asimetria = round(skewness(valor, na.rm = TRUE), 2),
      Curtosis = round(kurtosis(valor, na.rm = TRUE), 2)
    )
  
  return(stats)
}

cat("Calculando estadísticas descriptivas por estación...\n")
stats_precip <- calcular_estadisticas(datos_precip, "Precipitación")
stats_temp <- calcular_estadisticas(datos_temp, "Temperatura")

# Guardar tablas
write.csv(stats_precip, "resultados/tablas/estadisticas_precipitacion_por_estacion.csv", 
          row.names = FALSE)
write.csv(stats_temp, "resultados/tablas/estadisticas_temperatura_por_estacion.csv", 
          row.names = FALSE)

cat("  ✓ Tablas guardadas\n\n")

# ==============================================================================
# 7. VISUALIZACIONES COMPARATIVAS
# ==============================================================================

# Tema personalizado
tema_personalizado <- theme_minimal() +
  theme(
    plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
    plot.subtitle = element_text(hjust = 0.5, size = 10),
    axis.title = element_text(size = 11),
    axis.text = element_text(size = 9),
    legend.position = "bottom",
    legend.title = element_text(size = 10),
    panel.grid.minor = element_blank()
  )

cat("Generando visualizaciones comparativas...\n\n")

# ------------------------------------------------------------------------------
# 7.1 Comparación de Distribuciones - Precipitación
# ------------------------------------------------------------------------------

cat("  - Boxplot comparativo de precipitación\n")
p1 <- ggplot(datos_precip, aes(x = reorder(estacion, valor, FUN = median), 
                                y = valor, fill = estacion)) +
  geom_boxplot(outlier.size = 0.5, outlier.alpha = 0.3) +
  coord_flip() +
  labs(title = "Distribución de Precipitación Máxima Diaria por Estación",
       subtitle = "Comparación entre 7 estaciones meteorológicas - Cali",
       x = "Estación",
       y = "Precipitación (mm)") +
  tema_personalizado +
  theme(legend.position = "none") +
  scale_fill_brewer(palette = "Set2")

ggsave("resultados/figuras/precip_boxplot_comparativo.png", p1, 
       width = 10, height = 6, dpi = 300)

# ------------------------------------------------------------------------------
# 7.2 Comparación de Distribuciones - Temperatura
# ------------------------------------------------------------------------------

cat("  - Boxplot comparativo de temperatura\n")
p2 <- ggplot(datos_temp, aes(x = reorder(estacion, valor, FUN = median), 
                              y = valor, fill = estacion)) +
  geom_boxplot(outlier.size = 0.5, outlier.alpha = 0.3) +
  coord_flip() +
  labs(title = "Distribución de Temperatura por Estación",
       subtitle = "Comparación entre 7 estaciones meteorológicas - Cali",
       x = "Estación",
       y = "Temperatura (°C)") +
  tema_personalizado +
  theme(legend.position = "none") +
  scale_fill_brewer(palette = "Set3")

ggsave("resultados/figuras/temp_boxplot_comparativo.png", p2, 
       width = 10, height = 6, dpi = 300)

# ------------------------------------------------------------------------------
# 7.3 Series Temporales Comparativas - Precipitación
# ------------------------------------------------------------------------------

cat("  - Series temporales de precipitación\n")

# Agregar por mes para visualización más clara
precip_mensual <- datos_precip %>%
  group_by(estacion, anio, mes) %>%
  summarise(precip_media = mean(valor, na.rm = TRUE),
            fecha = as.Date(paste(anio[1], mes[1], "15", sep = "-")),
            .groups = "drop")

p3 <- ggplot(precip_mensual, aes(x = fecha, y = precip_media, color = estacion)) +
  geom_line(linewidth = 0.7) +
  facet_wrap(~estacion, ncol = 2, scales = "free_y") +
  labs(title = "Evolución Temporal de Precipitación por Estación",
       subtitle = "Promedio mensual de precipitación máxima diaria",
       x = "Fecha",
       y = "Precipitación media (mm)") +
  tema_personalizado +
  theme(legend.position = "none") +
  scale_color_brewer(palette = "Dark2")

ggsave("resultados/figuras/precip_series_temporales.png", p3, 
       width = 12, height = 10, dpi = 300)

# ------------------------------------------------------------------------------
# 7.4 Series Temporales Comparativas - Temperatura
# ------------------------------------------------------------------------------

cat("  - Series temporales de temperatura\n")

# Agregar por día para temperatura
temp_diaria <- datos_temp %>%
  group_by(estacion, fecha) %>%
  summarise(temp_media = mean(valor, na.rm = TRUE),
            .groups = "drop")

p4 <- ggplot(temp_diaria, aes(x = fecha, y = temp_media, color = estacion)) +
  geom_line(linewidth = 0.5, alpha = 0.7) +
  facet_wrap(~estacion, ncol = 2, scales = "free_y") +
  labs(title = "Evolución Temporal de Temperatura por Estación",
       subtitle = "Promedio diario de temperatura",
       x = "Fecha",
       y = "Temperatura media (°C)") +
  tema_personalizado +
  theme(legend.position = "none") +
  scale_color_brewer(palette = "Set1")

ggsave("resultados/figuras/temp_series_temporales.png", p4, 
       width = 12, height = 10, dpi = 300)

# ------------------------------------------------------------------------------
# 7.5 Patrones Estacionales - Precipitación
# ------------------------------------------------------------------------------

cat("  - Patrones estacionales de precipitación\n")

precip_por_mes <- datos_precip %>%
  group_by(estacion, mes, mes_nombre) %>%
  summarise(precip_media = mean(valor, na.rm = TRUE),
            precip_sd = sd(valor, na.rm = TRUE),
            .groups = "drop")

precip_por_mes$mes_nombre <- factor(precip_por_mes$mes_nombre, 
                                    levels = month.name)

p5 <- ggplot(precip_por_mes, aes(x = mes_nombre, y = precip_media, 
                                  fill = estacion, group = estacion)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Patrón Estacional de Precipitación por Estación",
       subtitle = "Promedio mensual de precipitación máxima diaria",
       x = "Mes",
       y = "Precipitación media (mm)",
       fill = "Estación") +
  tema_personalizado +
  scale_fill_brewer(palette = "Set2") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("resultados/figuras/precip_patron_estacional.png", p5, 
       width = 12, height = 6, dpi = 300)

# ------------------------------------------------------------------------------
# 7.6 Patrones Estacionales - Temperatura
# ------------------------------------------------------------------------------

cat("  - Patrones estacionales de temperatura\n")

temp_por_mes <- datos_temp %>%
  group_by(estacion, mes, mes_nombre) %>%
  summarise(temp_media = mean(valor, na.rm = TRUE),
            temp_sd = sd(valor, na.rm = TRUE),
            .groups = "drop")

temp_por_mes$mes_nombre <- factor(temp_por_mes$mes_nombre, 
                                  levels = month.name)

p6 <- ggplot(temp_por_mes, aes(x = mes_nombre, y = temp_media, 
                                color = estacion, group = estacion)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(title = "Patrón Estacional de Temperatura por Estación",
       subtitle = "Promedio mensual de temperatura",
       x = "Mes",
       y = "Temperatura media (°C)",
       color = "Estación") +
  tema_personalizado +
  scale_color_brewer(palette = "Set1") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("resultados/figuras/temp_patron_estacional.png", p6, 
       width = 12, height = 6, dpi = 300)

# ------------------------------------------------------------------------------
# 7.7 Análisis Intertemporal - Trimestres
# ------------------------------------------------------------------------------

cat("  - Análisis por trimestres\n")

precip_trimestral <- datos_precip %>%
  group_by(estacion, trimestre) %>%
  summarise(precip_media = mean(valor, na.rm = TRUE),
            .groups = "drop")

precip_trimestral$trimestre_label <- paste("T", precip_trimestral$trimestre, sep = "")

p7 <- ggplot(precip_trimestral, aes(x = trimestre_label, y = precip_media, 
                                     fill = estacion)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Precipitación por Trimestre y Estación",
       subtitle = "Análisis intertemporal trimestral",
       x = "Trimestre",
       y = "Precipitación media (mm)",
       fill = "Estación") +
  tema_personalizado +
  scale_fill_brewer(palette = "Set2")

ggsave("resultados/figuras/precip_analisis_trimestral.png", p7, 
       width = 10, height = 6, dpi = 300)

# ------------------------------------------------------------------------------
# 7.8 Histogramas Comparativos
# ------------------------------------------------------------------------------

cat("  - Histogramas comparativos\n")

p8 <- ggplot(datos_precip, aes(x = valor, fill = estacion)) +
  geom_histogram(bins = 50, alpha = 0.7) +
  facet_wrap(~estacion, ncol = 2, scales = "free") +
  labs(title = "Distribución de Frecuencias de Precipitación por Estación",
       subtitle = "Histogramas comparativos",
       x = "Precipitación (mm)",
       y = "Frecuencia") +
  tema_personalizado +
  theme(legend.position = "none") +
  scale_fill_brewer(palette = "Set2")

ggsave("resultados/figuras/precip_histogramas.png", p8, 
       width = 12, height = 10, dpi = 300)

# ------------------------------------------------------------------------------
# 7.9 Variabilidad Interanual
# ------------------------------------------------------------------------------

cat("  - Variabilidad interanual\n")

precip_anual <- datos_precip %>%
  group_by(estacion, anio) %>%
  summarise(precip_total = sum(valor, na.rm = TRUE),
            .groups = "drop")

p9 <- ggplot(precip_anual, aes(x = as.factor(anio), y = precip_total, 
                                fill = estacion)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Precipitación Total Anual por Estación",
       subtitle = "Variabilidad interanual",
       x = "Año",
       y = "Precipitación total (mm)",
       fill = "Estación") +
  tema_personalizado +
  scale_fill_brewer(palette = "Set2") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("resultados/figuras/precip_variabilidad_anual.png", p9, 
       width = 12, height = 6, dpi = 300)

# ------------------------------------------------------------------------------
# 7.10 Correlación entre Estaciones - Precipitación
# ------------------------------------------------------------------------------

cat("  - Matriz de correlación entre estaciones\n")

# Crear matriz de datos anchos
precip_wide <- datos_precip %>%
  select(fecha, estacion, valor) %>%
  pivot_wider(names_from = estacion, values_from = valor, 
              values_fn = mean)

# Calcular correlaciones
cor_matrix <- cor(precip_wide[, -1], use = "pairwise.complete.obs")

# Convertir a formato largo para ggplot
cor_long <- as.data.frame(as.table(cor_matrix))
colnames(cor_long) <- c("Estacion1", "Estacion2", "Correlacion")

p10 <- ggplot(cor_long, aes(x = Estacion1, y = Estacion2, fill = Correlacion)) +
  geom_tile(color = "white") +
  geom_text(aes(label = round(Correlacion, 2)), size = 3) +
  scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                       midpoint = 0, limits = c(-1, 1)) +
  labs(title = "Matriz de Correlación de Precipitación entre Estaciones",
       subtitle = "Correlación de Pearson",
       x = "", y = "") +
  tema_personalizado +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggsave("resultados/figuras/precip_correlacion_estaciones.png", p10, 
       width = 10, height = 8, dpi = 300)

cat("\n")
cat("╔══════════════════════════════════════════════════════════════╗\n")
cat("║  ANÁLISIS COMPLETADO EXITOSAMENTE                            ║\n")
cat("╚══════════════════════════════════════════════════════════════╝\n")
cat("\n")
cat("Resultados guardados en:\n")
cat("  - resultados/figuras/ (10 gráficos PNG)\n")
cat("  - resultados/tablas/ (2 tablas CSV)\n")
cat("\n")
cat("Total de registros analizados:\n")
cat(paste("  - Precipitación:", nrow(datos_precip), "registros\n"))
cat(paste("  - Temperatura:", nrow(datos_temp), "registros\n"))
cat(paste("  - TOTAL:", nrow(datos_precip) + nrow(datos_temp), "registros\n"))
cat("\n")
