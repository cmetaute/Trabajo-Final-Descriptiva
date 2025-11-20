# EJEMPLOS DE USO - Funciones Personalizadas
# Descripción: Ejemplos prácticos de cómo usar las funciones del proyecto
# Grupo: 03


# Establecer directorio de trabajo
setwd("/home/cerrotico/unal/Trabajo-Final-Descriptiva")

# Cargar funciones
source("R/funciones/carga_datos.R")
source("R/funciones/estadisticas_descriptivas.R")
source("R/funciones/visualizaciones.R")
source("R/funciones/analisis_temporal.R")

# Cargar paquetes necesarios
library(ggplot2)
library(gridExtra)
library(moments)

# EJEMPLO 1: Cargar y explorar un dataset
# Cargar datos de precipitación
datos_precip <- cargar_csv_ideam(
  "Precipitacion/DataSetExport-PRECIPITACION.PT_10_MX_D@26055120-Maximum-mm-20251115143328.csv",
  "Precipitación Máxima Diaria"
)

# Ver primeras filas
head(datos_precip)

# Resumen rápido
resumen_dataset(datos_precip, "Precipitación Máxima Diaria")


# EJEMPLO 2: Agregar variables temporales
# Agregar variables de tiempo
datos_precip <- agregar_variables_temporales(datos_precip)

# Ver nuevas columnas
colnames(datos_precip)

# Ver algunos datos
head(datos_precip[, c("fecha", "valor", "anio", "mes", "trimestre")])


# EJEMPLO 3: Limpiar datos
# Limpiar valores NA
datos_limpios <- limpiar_na(datos_precip, verbose = TRUE)

# Detectar valores atípicos
datos_con_atipicos <- detectar_atipicos(datos_limpios, factor_iqr = 1.5)

# Ver cuántos atípicos hay
table(datos_con_atipicos$es_atipico)


# EJEMPLO 4: Calcular estadísticas descriptivas
# Calcular todas las estadísticas
estadisticas <- calcular_estadisticas(datos_limpios, 
                                     "Precipitación Máxima Diaria", 
                                     "mm")

# Imprimir en formato bonito
imprimir_estadisticas(estadisticas, "Precipitación Máxima Diaria", "mm")

# Crear tabla exportable
tabla <- tabla_estadisticas(estadisticas)
print(tabla)

# Guardar tabla
# write.csv(tabla, "mi_tabla_estadisticas.csv", row.names = FALSE)


# EJEMPLO 5: Crear visualizaciones básicas
# Serie temporal
g1 <- grafico_serie_temporal(
  datos_limpios,
  titulo = "Serie Temporal - Precipitación",
  subtitulo = "Estación 26055120",
  eje_y = "Precipitación (mm)",
  color = "steelblue"
)
print(g1)
# ggsave("mi_serie_temporal.png", g1, width = 12, height = 6, dpi = 300)

# Histograma
g2 <- grafico_histograma(
  datos_limpios,
  titulo = "Distribución de Precipitación",
  eje_x = "Precipitación (mm)",
  bins = 40,
  color = "steelblue"
)
print(g2)

# Boxplot
g3 <- grafico_boxplot(
  datos_limpios,
  titulo = "Boxplot - Precipitación",
  eje_y = "Precipitación (mm)",
  color = "steelblue"
)
print(g3)


# EJEMPLO 6: Boxplots por grupos
# Boxplot por mes
g4 <- grafico_boxplot_grupos(
  datos_limpios,
  variable_grupo = "mes",
  titulo = "Precipitación por Mes",
  eje_x = "Mes",
  eje_y = "Precipitación (mm)",
  color = "lightblue"
)
print(g4)

# Boxplot por año
g5 <- grafico_boxplot_grupos(
  datos_limpios,
  variable_grupo = "anio",
  titulo = "Precipitación por Año",
  eje_x = "Año",
  eje_y = "Precipitación (mm)",
  color = "coral"
)
print(g5)


# EJEMPLO 7: Análisis de tendencia
# Analizar tendencia
resultado_tendencia <- analisis_tendencia(datos_limpios, 
                                         "Precipitación Máxima Diaria")

# Ver el gráfico
print(resultado_tendencia$grafico)

# Acceder a los resultados
cat("\nPendiente:", resultado_tendencia$pendiente, "\n")
cat("R²:", resultado_tendencia$r_cuadrado, "\n")
cat("p-valor:", resultado_tendencia$p_valor, "\n")
cat("¿Es significativo?:", resultado_tendencia$significativo, "\n")


# EJEMPLO 8: Análisis de estacionalidad mensual

# Analizar patrón mensual
resultado_mensual <- analisis_estacionalidad_mensual(
  datos_limpios,
  nombre = "Precipitación Máxima Diaria",
  unidad = "mm"
)

# Ver gráficos
print(resultado_mensual$grafico_barras)
print(resultado_mensual$grafico_boxplot)

# Ver estadísticas
print(resultado_mensual$estadisticas)

# Mes con mayor precipitación
cat("\nMes con mayor precipitación:", resultado_mensual$mes_maximo, "\n")
cat("Mes con menor precipitación:", resultado_mensual$mes_minimo, "\n")


# EJEMPLO 9: Análisis de variación anual
cat("\n=== EJEMPLO 9: Variación anual ===\n\n")

# Analizar evolución anual
resultado_anual <- analisis_estacionalidad_anual(
  datos_limpios,
  nombre = "Precipitación Máxima Diaria",
  unidad = "mm"
)

# Ver gráfico
print(resultado_anual$grafico)

# Ver estadísticas por año
print(resultado_anual$estadisticas)


# EJEMPLO 10: Análisis de ciclos intraanuales
# Análisis por trimestres
resultado_trimestral <- analisis_ciclos_intraanuales(
  datos_limpios,
  periodo = "trimestre",
  nombre = "Precipitación Máxima Diaria"
)
print(resultado_trimestral$grafico)

# Análisis por semestres
resultado_semestral <- analisis_ciclos_intraanuales(
  datos_limpios,
  periodo = "semestre",
  nombre = "Precipitación Máxima Diaria"
)
print(resultado_semestral$grafico)


# EJEMPLO 11: Estadísticas por período
# Estadísticas por año
stats_por_anio <- estadisticas_por_periodo(datos_limpios, agrupar_por = "anio")
print(stats_por_anio)

# Estadísticas por mes
stats_por_mes <- estadisticas_por_periodo(datos_limpios, agrupar_por = "mes")
print(stats_por_mes)


# EJEMPLO 12: Gráfico de promedios por período
# Promedios mensuales (barras)
g6 <- grafico_promedios_periodo(
  datos_limpios,
  periodo = "mes",
  titulo = "Precipitación Promedio por Mes",
  eje_y = "Precipitación Promedio (mm)",
  tipo = "barras",
  color = "steelblue"
)
print(g6)

# Promedios anuales (línea)
g7 <- grafico_promedios_periodo(
  datos_limpios,
  periodo = "anio",
  titulo = "Precipitación Promedio por Año",
  eje_y = "Precipitación Promedio (mm)",
  tipo = "linea",
  color = "coral"
)
print(g7)


# EJEMPLO 13: Detectar anomalías

# Detectar anomalías (3 desviaciones estándar)
datos_con_anomalias <- detectar_anomalias(datos_limpios, n_sd = 3)

# Ver anomalías detectadas
anomalias <- datos_con_anomalias[datos_con_anomalias$es_anomalia == TRUE, ]
print(head(anomalias))

# Gráfico con anomalías marcadas
g8 <- ggplot(datos_con_anomalias, aes(x = fecha, y = valor)) +
  geom_line(color = "gray60", linewidth = 0.5) +
  geom_point(data = anomalias, aes(x = fecha, y = valor), 
             color = "red", size = 3, alpha = 0.7) +
  labs(
    title = "Serie Temporal con Anomalías Detectadas",
    subtitle = paste("Anomalías:", nrow(anomalias)),
    x = "Fecha",
    y = "Precipitación (mm)"
  ) +
  tema_personalizado()
print(g8)


# EJEMPLO 14: Análisis bivariado (correlación)

# Cargar segundo dataset (temperatura)
datos_temp <- cargar_csv_ideam(
  "Temperatura/DataSetExport-TEMPERATURA.TAMN2_MEDIA_D@26055120-Maximum-degC-20251115143538.csv",
  "Temperatura Mínima"
)
datos_temp <- limpiar_na(datos_temp, verbose = FALSE)

# Gráfico de dispersión
g9 <- grafico_dispersion(
  datos_precip,
  datos_temp,
  nombre1 = "Precipitación (mm)",
  nombre2 = "Temperatura (°C)",
  titulo = "Relación Precipitación vs Temperatura"
)
print(g9)


# EJEMPLO 15: Panel exploratorio completo
# Crear panel con múltiples gráficos
panel_exploratorio(
  datos_limpios,
  nombre = "Precipitación Máxima Diaria",
  unidad = "mm",
  color = "steelblue"
)
