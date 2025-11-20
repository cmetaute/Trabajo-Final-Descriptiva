# ANÁLISIS ESTADÍSTICO DESCRIPTIVO Y EXPLORATORIO
# Datos Meteorológicos IDEAM - Estación 26055120
# Descripción: Script principal para análisis descriptivo de temperatura y
#              precipitación
# Grupo: 03
# Curso: Estadística Descriptiva y Análisis Exploratorio de Datos
# Fecha: Noviembre 2024

# Limpiar entorno
rm(list = ls())
gc()

# 1. CONFIGURACIÓN INICIAL
# Establecer directorio de trabajo
setwd("/home/cerrotico/unal/Trabajo-Final-Descriptiva")

# Configurar biblioteca local
lib_local <- "~/R/library"
if (!dir.exists(lib_local)) {
  dir.create(lib_local, recursive = TRUE)
}
.libPaths(c(lib_local, .libPaths()))

# Instalar y cargar paquetes necesarios
paquetes_necesarios <- c("ggplot2", "gridExtra", "scales", "moments", "forecast")

cat("Verificando paquetes necesarios...\n")
for (paquete in paquetes_necesarios) {
  if (!require(paquete, character.only = TRUE, quietly = TRUE, lib.loc = lib_local)) {
    cat(paste("Instalando", paquete, "...\n"))
    install.packages(paquete, dependencies = TRUE, 
                    repos = "https://cloud.r-project.org/", 
                    lib = lib_local)
    library(paquete, character.only = TRUE, lib.loc = lib_local)
  }
}

# Cargar funciones personalizadas
cat("Cargando funciones personalizadas...\n")
source("R/funciones/carga_datos.R")
source("R/funciones/estadisticas_descriptivas.R")
source("R/funciones/visualizaciones.R")
source("R/funciones/analisis_temporal.R")
cat("✓ Funciones cargadas correctamente\n\n")

# Crear directorios para resultados
dir.create("resultados/figuras", recursive = TRUE, showWarnings = FALSE)
dir.create("resultados/tablas", recursive = TRUE, showWarnings = FALSE)

cat("✓ Configuración completada\n\n")


# 2. CARGA DE DATOS
# Precipitación máxima diaria
precip_max_diaria <- cargar_csv_ideam(
  "Precipitacion/DataSetExport-PRECIPITACION.PT_10_MX_D@26055120-Maximum-mm-20251115143328.csv",
  "Precipitación Máxima Diaria"
)

# Precipitación total diaria
precip_total_diaria <- cargar_csv_ideam(
  "Precipitacion/DataSetExport-PRECIPITACION.PT_10_TT_D@26055120-Maximum-mm-20251115144237.csv",
  "Precipitación Total Diaria"
)

# --- TEMPERATURA ---
# Temperatura mínima media diaria
temp_min_diaria <- cargar_csv_ideam(
  "Temperatura/DataSetExport-TEMPERATURA.TAMN2_MEDIA_D@26055120-Maximum-degC-20251115143538.csv",
  "Temperatura Mínima Media Diaria"
)

# Temperatura máxima horaria (muestra - primeros 10000 registros por tamaño)
temp_max_horaria_completa <- cargar_csv_ideam(
  "Temperatura/DataSetExport-TEMPERATURA.TAMX2_AUT_60@26055120-Maximum-degC-20251115144718.csv",
  "Temperatura Máxima Horaria"
)

# Agregar variables temporales a todos los datasets
precip_max_diaria <- agregar_variables_temporales(precip_max_diaria)
precip_total_diaria <- agregar_variables_temporales(precip_total_diaria)
temp_min_diaria <- agregar_variables_temporales(temp_min_diaria)
temp_max_horaria_completa <- agregar_variables_temporales(temp_max_horaria_completa)

cat("\n✓ Todos los datos cargados y preparados\n\n")


# 3. LIMPIEZA DE DATOS

# Limpiar valores NA
precip_max_limpia <- limpiar_na(precip_max_diaria)
precip_total_limpia <- limpiar_na(precip_total_diaria)
temp_min_limpia <- limpiar_na(temp_min_diaria)
temp_max_limpia <- limpiar_na(temp_max_horaria_completa)

cat("✓ Limpieza completada\n\n")


# 4. ANÁLISIS DESCRIPTIVO UNIVARIADO - PRECIPITACIÓN

# --- Precipitación Máxima Diaria ---
cat("\n" , strrep("=", 60), "\n")
cat("PRECIPITACIÓN MÁXIMA DIARIA\n")
cat(strrep("=", 60), "\n")

# Calcular estadísticas
stats_precip_max <- calcular_estadisticas(precip_max_limpia, 
                                          "Precipitación Máxima Diaria", 
                                          "mm")
imprimir_estadisticas(stats_precip_max, "Precipitación Máxima Diaria", "mm")

# Guardar tabla de estadísticas
tabla_precip_max <- tabla_estadisticas(stats_precip_max)
write.csv(tabla_precip_max, 
          "resultados/tablas/estadisticas_precipitacion_maxima.csv", 
          row.names = FALSE)

# Visualizaciones
cat("\nGenerando visualizaciones...\n")

# Serie temporal
g1 <- grafico_serie_temporal(precip_max_limpia,
                             "Serie Temporal - Precipitación Máxima Diaria",
                             "Período 2016-2024",
                             "Precipitación (mm)",
                             "steelblue")
ggsave("resultados/figuras/precip_max_serie_temporal.png", g1, 
       width = 12, height = 6, dpi = 300)

# Histograma
g2 <- grafico_histograma(precip_max_limpia,
                        "Distribución - Precipitación Máxima Diaria",
                        "Precipitación (mm)",
                        bins = 50,
                        "steelblue")
ggsave("resultados/figuras/precip_max_histograma.png", g2, 
       width = 10, height = 6, dpi = 300)

# Boxplot
g3 <- grafico_boxplot(precip_max_limpia,
                     "Boxplot - Precipitación Máxima Diaria",
                     "Precipitación (mm)",
                     "steelblue")
ggsave("resultados/figuras/precip_max_boxplot.png", g3, 
       width = 8, height = 6, dpi = 300)

cat("✓ Visualizaciones guardadas en resultados/figuras/\n")


# --- Precipitación Total Diaria ---
cat("\n", strrep("=", 60), "\n")
cat("PRECIPITACIÓN TOTAL DIARIA\n")
cat(strrep("=", 60), "\n")

stats_precip_total <- calcular_estadisticas(precip_total_limpia,
                                           "Precipitación Total Diaria",
                                           "mm")
imprimir_estadisticas(stats_precip_total, "Precipitación Total Diaria", "mm")

tabla_precip_total <- tabla_estadisticas(stats_precip_total)
write.csv(tabla_precip_total,
          "resultados/tablas/estadisticas_precipitacion_total.csv",
          row.names = FALSE)


# 5. ANÁLISIS DESCRIPTIVO UNIVARIADO - TEMPERATURA

# --- Temperatura Mínima Diaria ---
cat("\n", strrep("=", 60), "\n")
cat("TEMPERATURA MÍNIMA MEDIA DIARIA\n")
cat(strrep("=", 60), "\n")

stats_temp_min <- calcular_estadisticas(temp_min_limpia,
                                       "Temperatura Mínima Media Diaria",
                                       "°C")
imprimir_estadisticas(stats_temp_min, "Temperatura Mínima Media Diaria", "°C")

tabla_temp_min <- tabla_estadisticas(stats_temp_min)
write.csv(tabla_temp_min,
          "resultados/tablas/estadisticas_temperatura_minima.csv",
          row.names = FALSE)

# Visualizaciones
cat("\nGenerando visualizaciones...\n")

g4 <- grafico_serie_temporal(temp_min_limpia,
                            "Serie Temporal - Temperatura Mínima Media Diaria",
                            "Período 2006-2024",
                            "Temperatura (°C)",
                            "coral")
ggsave("resultados/figuras/temp_min_serie_temporal.png", g4,
       width = 12, height = 6, dpi = 300)

g5 <- grafico_histograma(temp_min_limpia,
                        "Distribución - Temperatura Mínima Media Diaria",
                        "Temperatura (°C)",
                        bins = 40,
                        "coral")
ggsave("resultados/figuras/temp_min_histograma.png", g5,
       width = 10, height = 6, dpi = 300)

g6 <- grafico_boxplot(temp_min_limpia,
                     "Boxplot - Temperatura Mínima Media Diaria",
                     "Temperatura (°C)",
                     "coral")
ggsave("resultados/figuras/temp_min_boxplot.png", g6,
       width = 8, height = 6, dpi = 300)

cat("✓ Visualizaciones guardadas\n")


# 6. ANÁLISIS DE PATRONES TEMPORALES - PRECIPITACIÓN

# Análisis de tendencia
cat("\n>>> ANÁLISIS DE TENDENCIA <<<\n")
tendencia_precip <- analisis_tendencia(precip_max_limpia, 
                                      "Precipitación Máxima Diaria")
ggsave("resultados/figuras/precip_max_tendencia.png", tendencia_precip$grafico,
       width = 12, height = 6, dpi = 300)

# Análisis de estacionalidad mensual
cat("\n>>> ANÁLISIS DE ESTACIONALIDAD MENSUAL <<<\n")
estacional_precip <- analisis_estacionalidad_mensual(precip_max_limpia,
                                                     "Precipitación Máxima Diaria",
                                                     "mm")
ggsave("resultados/figuras/precip_max_patron_mensual.png", 
       estacional_precip$grafico_barras,
       width = 12, height = 6, dpi = 300)

ggsave("resultados/figuras/precip_max_boxplot_mensual.png",
       estacional_precip$grafico_boxplot,
       width = 12, height = 6, dpi = 300)

# Análisis de variación anual
cat("\n>>> ANÁLISIS DE VARIACIÓN ANUAL <<<\n")
anual_precip <- analisis_estacionalidad_anual(precip_max_limpia,
                                              "Precipitación Máxima Diaria",
                                              "mm")
ggsave("resultados/figuras/precip_max_evolucion_anual.png",
       anual_precip$grafico,
       width = 12, height = 6, dpi = 300)

# Análisis de ciclos intraanuales
cat("\n>>> ANÁLISIS DE CICLOS TRIMESTRALES <<<\n")
trimestral_precip <- analisis_ciclos_intraanuales(precip_max_limpia,
                                                  "trimestre",
                                                  "Precipitación Máxima Diaria")
ggsave("resultados/figuras/precip_max_patron_trimestral.png",
       trimestral_precip$grafico,
       width = 10, height = 6, dpi = 300)


# 7. ANÁLISIS DE PATRONES TEMPORALES - TEMPERATURA

# Análisis de tendencia
cat("\n>>> ANÁLISIS DE TENDENCIA <<<\n")
tendencia_temp <- analisis_tendencia(temp_min_limpia,
                                    "Temperatura Mínima Media Diaria")
ggsave("resultados/figuras/temp_min_tendencia.png", tendencia_temp$grafico,
       width = 12, height = 6, dpi = 300)

# Análisis de estacionalidad mensual
cat("\n>>> ANÁLISIS DE ESTACIONALIDAD MENSUAL <<<\n")
estacional_temp <- analisis_estacionalidad_mensual(temp_min_limpia,
                                                   "Temperatura Mínima Media Diaria",
                                                   "°C")
ggsave("resultados/figuras/temp_min_patron_mensual.png",
       estacional_temp$grafico_barras,
       width = 12, height = 6, dpi = 300)

ggsave("resultados/figuras/temp_min_boxplot_mensual.png",
       estacional_temp$grafico_boxplot,
       width = 12, height = 6, dpi = 300)

# Análisis de variación anual
cat("\n>>> ANÁLISIS DE VARIACIÓN ANUAL <<<\n")
anual_temp <- analisis_estacionalidad_anual(temp_min_limpia,
                                           "Temperatura Mínima Media Diaria",
                                           "°C")
ggsave("resultados/figuras/temp_min_evolucion_anual.png",
       anual_temp$grafico,
       width = 12, height = 6, dpi = 300)

# 8. ANÁLISIS BIVARIADO - RELACIÓN TEMPERATURA-PRECIPITACIÓN


# Preparar datos para análisis bivariado (mismas fechas)
# Agregar temperatura a datos diarios
temp_min_diaria_agg <- aggregate(valor ~ as.Date(fecha), 
                                 data = temp_min_limpia,
                                 FUN = mean)
colnames(temp_min_diaria_agg) <- c("fecha", "temperatura")

precip_max_diaria_agg <- aggregate(valor ~ as.Date(fecha),
                                   data = precip_max_limpia,
                                   FUN = max)
colnames(precip_max_diaria_agg) <- c("fecha", "precipitacion")

# Combinar datasets
datos_combinados <- merge(temp_min_diaria_agg, precip_max_diaria_agg, 
                         by = "fecha", all = FALSE)

cat("Datos combinados:", nrow(datos_combinados), "observaciones\n\n")

# Calcular correlación
correlacion <- cor(datos_combinados$temperatura, 
                  datos_combinados$precipitacion,
                  use = "complete.obs")

cat(sprintf("  Correlación de Pearson: %.4f\n\n", correlacion))

if (abs(correlacion) < 0.3) {
  cat("  → Correlación DÉBIL\n")
} else if (abs(correlacion) < 0.7) {
  cat("  → Correlación MODERADA\n")
} else {
  cat("  → Correlación FUERTE\n")
}

if (correlacion > 0) {
  cat("  → Relación POSITIVA (a mayor temperatura, mayor precipitación)\n\n")
} else {
  cat("  → Relación NEGATIVA (a mayor temperatura, menor precipitación)\n\n")
}

# Gráfico de dispersión
g_dispersion <- ggplot(datos_combinados, 
                      aes(x = temperatura, y = precipitacion)) +
  geom_point(alpha = 0.4, color = "steelblue", size = 2) +
  geom_smooth(method = "lm", color = "red", se = TRUE, linewidth = 1.2) +
  labs(
    title = "Relación entre Temperatura Mínima y Precipitación Máxima",
    subtitle = sprintf("Correlación de Pearson: %.4f", correlacion),
    x = "Temperatura Mínima Media (°C)",
    y = "Precipitación Máxima (mm)"
  ) +
  tema_personalizado()

ggsave("resultados/figuras/correlacion_temp_precip.png", g_dispersion,
       width = 10, height = 7, dpi = 300)

# 9. DETECCIÓN DE ANOMALÍAS

cat("\n>>> PRECIPITACIÓN <<<\n")
precip_con_anomalias <- detectar_anomalias(precip_max_limpia, n_sd = 3)

cat("\n>>> TEMPERATURA <<<\n")
temp_con_anomalias <- detectar_anomalias(temp_min_limpia, n_sd = 3)


# 10. RESUMEN FINAL

cat("✓ Análisis completado exitosamente\n\n")

cat("ARCHIVOS GENERADOS:\n")
cat("───────────────────────────────────────────────────────────────\n")
cat("Tablas de estadísticas:\n")
cat("  • resultados/tablas/estadisticas_precipitacion_maxima.csv\n")
cat("  • resultados/tablas/estadisticas_precipitacion_total.csv\n")
cat("  • resultados/tablas/estadisticas_temperatura_minima.csv\n\n")

cat("Figuras generadas:\n")
cat("  • Series temporales (3)\n")
cat("  • Histogramas (3)\n")
cat("  • Boxplots (5)\n")
cat("  • Análisis de tendencias (2)\n")
cat("  • Patrones mensuales (4)\n")
cat("  • Evolución anual (2)\n")
cat("  • Correlación bivariada (1)\n")
cat("  • Total: ~20 gráficos en resultados/figuras/\n\n")

cat("HALLAZGOS PRINCIPALES:\n")
cat("───────────────────────────────────────────────────────────────\n")
cat(sprintf("• Precipitación máxima promedio: %.2f mm\n", 
            stats_precip_max$media))
cat(sprintf("• Temperatura mínima promedio: %.2f °C\n", 
            stats_temp_min$media))
cat(sprintf("• Correlación temperatura-precipitación: %.4f\n", 
            correlacion))
cat(sprintf("• Tendencia precipitación: %s (p=%.4f)\n",
            ifelse(tendencia_precip$significativo, "Significativa", "No significativa"),
            tendencia_precip$p_valor))
cat(sprintf("• Tendencia temperatura: %s (p=%.4f)\n",
            ifelse(tendencia_temp$significativo, "Significativa", "No significativa"),
            tendencia_temp$p_valor))

cat("\n")
cat("  ANÁLISIS FINALIZADO\n")

