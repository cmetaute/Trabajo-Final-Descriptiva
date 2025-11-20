# Análisis Estadístico Descriptivo - Datos Meteorológicos IDEAM

**Grupo:** 03  
**Curso:** Estadística Descriptiva y Análisis Exploratorio de Datos  
**Estación:** 26055120 (IDEAM)  
**Variables:** Temperatura y Precipitación  
**Período:** 2006-2024  

---

## Descripción del Proyecto

Este proyecto realiza un análisis estadístico descriptivo y exploratorio completo de datos meteorológicos de Colombia, obtenidos del portal IDEAM (Instituto de Hidrología, Meteorología y Estudios Ambientales).

### Fuente de Datos
- **URL:** http://aquariuswebportal.ideam.gov.co/Data/DataSet/Interval/Latest
- **Estación:** 26055120
- **Total de registros:** >10,000 observaciones

### Variables Analizadas
1. **Precipitación Máxima Diaria** (mm) - 2016 a 2024
2. **Precipitación Total Diaria** (mm) - 2016 a 2024
3. **Temperatura Mínima Media Diaria** (°C) - 2006 a 2024
4. **Temperatura Máxima Horaria** (°C) - 2006 a 2024

---

## Estructura del Proyecto

```
Trabajo-Final-Descriptiva/
│
├── README.md                          # Este archivo
├── CONTEXTO_DATOS.md                  # Documentación detallada de los datos
│
├── Precipitacion/                     # Datos de precipitación (CSV)
│   ├── DataSetExport-PRECIPITACION.PT_10_MX_D@...csv
│   ├── DataSetExport-PRECIPITACION.PT_10_TT_D@...csv
│   └── ...
│
├── Temperatura/                       # Datos de temperatura (CSV)
│   ├── DataSetExport-TEMPERATURA.TAMN2_MEDIA_D@...csv
│   ├── DataSetExport-TEMPERATURA.TAMX2_AUT_60@...csv
│   └── ...
│
├── R/                                 # Scripts de R
│   ├── analisis_principal.R          # SCRIPT PRINCIPAL
│   │
│   └── funciones/                    # Funciones modulares
│       ├── carga_datos.R             # Carga y limpieza de datos
│       ├── estadisticas_descriptivas.R  # Cálculo de estadísticas
│       ├── visualizaciones.R         # Gráficos y visualizaciones
│       └── analisis_temporal.R       # Análisis de tendencias y patrones
│
└── resultados/                       # Resultados generados
    ├── figuras/                      # Gráficos (PNG, 300 DPI)
    └── tablas/                       # Tablas de estadísticas (CSV)
```

---

## Cómo Ejecutar el Análisis

### Requisitos Previos

1. **R** (versión 4.0 o superior)
2. **RStudio** (recomendado)
3. Paquetes de R (se instalan automáticamente):
   - `ggplot2`
   - `gridExtra`
   - `scales`
   - `moments`
   - `forecast`

**Nota:** Para instalar manualmente las dependencias, ejecutar:
```r
source("instalar_dependencias.R")
```

Ver `DEPENDENCIAS.txt` y `REPRODUCIBILIDAD.md` para más detalles.

### Ejecución

#### Opción 1: Desde RStudio (Recomendado)

1. Abrir RStudio
2. Abrir el archivo `R/analisis_principal.R`
3. Ejecutar todo el script: `Ctrl + Shift + Enter` (o `Cmd + Shift + Enter` en Mac)

#### Opción 2: Desde Terminal/Consola

```bash
cd /home/cerrotico/unal/Trabajo-Final-Descriptiva
Rscript R/analisis_principal.R
```

#### Opción 3: Desde Consola de R

```r
setwd("/home/cerrotico/unal/Trabajo-Final-Descriptiva")
source("R/analisis_principal.R")
```

### Tiempo de Ejecución

- **Estimado:** 2-5 minutos (dependiendo del hardware)
- El script mostrará progreso en consola

---

## Análisis Realizados

### 1. **Análisis Descriptivo Univariado**

Para cada variable se calcula:

#### Medidas de Tendencia Central
- Media
- Mediana
- Moda

#### Medidas de Dispersión
- Varianza
- Desviación estándar
- Coeficiente de variación
- Rango
- Rango intercuartílico (IQR)

#### Medidas de Posición
- Mínimo, Máximo
- Cuartiles (Q1, Q2, Q3)
- Percentiles (5, 10, 90, 95)

#### Medidas de Forma
- Asimetría (Skewness)
- Curtosis (Kurtosis)

### 2. **Visualizaciones Descriptivas**

- **Series temporales:** Evolución de las variables en el tiempo
- **Histogramas:** Distribución de frecuencias con curva de densidad
- **Boxplots:** Identificación de valores atípicos y dispersión
- **Boxplots por mes:** Variación estacional

### 3. **Análisis de Patrones Temporales**

#### Tendencias
- Regresión lineal para detectar tendencias a largo plazo
- Prueba de significancia estadística
- Visualización con línea de tendencia

#### Estacionalidad Mensual
- Promedios y desviaciones por mes
- Identificación de meses con valores extremos
- Gráficos de barras y boxplots mensuales

#### Variación Anual
- Evolución de promedios anuales
- Bandas de confianza (± 1 desviación estándar)

#### Ciclos Intraanuales
- Análisis por trimestres
- Análisis por semestres

### 4. **Análisis Bivariado**

- **Correlación:** Entre temperatura y precipitación
- **Gráfico de dispersión:** Con línea de regresión
- **Interpretación:** Fuerza y dirección de la relación

### 5. **Detección de Anomalías**

- Identificación de valores atípicos usando método de desviación estándar (3σ)
- Cuantificación de anomalías

---

## Resultados Generados

### Tablas (CSV)
Ubicación: `resultados/tablas/`

- `estadisticas_precipitacion_maxima.csv`
- `estadisticas_precipitacion_total.csv`
- `estadisticas_temperatura_minima.csv`

### Figuras (PNG, 300 DPI)
Ubicación: `resultados/figuras/`

**Precipitación:**
- `precip_max_serie_temporal.png`
- `precip_max_histograma.png`
- `precip_max_boxplot.png`
- `precip_max_tendencia.png`
- `precip_max_patron_mensual.png`
- `precip_max_boxplot_mensual.png`
- `precip_max_evolucion_anual.png`
- `precip_max_patron_trimestral.png`

**Temperatura:**
- `temp_min_serie_temporal.png`
- `temp_min_histograma.png`
- `temp_min_boxplot.png`
- `temp_min_tendencia.png`
- `temp_min_patron_mensual.png`
- `temp_min_boxplot_mensual.png`
- `temp_min_evolucion_anual.png`

**Análisis Bivariado:**
- `correlacion_temp_precip.png`

**Total:** ~20 gráficos de alta calidad

---

## Funciones Personalizadas

El proyecto incluye funciones modulares bien documentadas:

### `carga_datos.R`
- `cargar_csv_ideam()`: Carga archivos CSV del IDEAM
- `limpiar_na()`: Elimina valores faltantes
- `agregar_variables_temporales()`: Crea variables de año, mes, día, etc.
- `detectar_atipicos()`: Detecta valores atípicos usando IQR
- `resumen_dataset()`: Muestra resumen rápido de un dataset

### `estadisticas_descriptivas.R`
- `calcular_estadisticas()`: Calcula todas las estadísticas descriptivas
- `imprimir_estadisticas()`: Muestra estadísticas formateadas
- `tabla_estadisticas()`: Crea tabla exportable
- `estadisticas_por_periodo()`: Estadísticas agrupadas por período

### `visualizaciones.R`
- `grafico_serie_temporal()`: Serie temporal básica
- `grafico_serie_con_tendencia()`: Serie con media móvil
- `grafico_histograma()`: Histograma con densidad
- `grafico_boxplot()`: Boxplot individual
- `grafico_boxplot_grupos()`: Boxplot por grupos
- `grafico_promedios_periodo()`: Promedios por período
- `grafico_dispersion()`: Gráfico de dispersión bivariado
- `panel_exploratorio()`: Panel completo de gráficos

### `analisis_temporal.R`
- `analisis_tendencia()`: Regresión lineal para tendencias
- `analisis_estacionalidad_mensual()`: Patrones mensuales
- `analisis_estacionalidad_anual()`: Variación anual
- `detectar_anomalias()`: Detección de anomalías
- `analisis_ciclos_intraanuales()`: Ciclos trimestrales/semestrales

---

## Notas Importantes

### Formato de los Datos IDEAM

Los archivos CSV del IDEAM tienen características especiales:

- **Separador:** Punto y coma (`;`)
- **Decimal:** Coma (`,`)
- **Primera línea:** Metadatos (se omite)
- **Valores faltantes:** `NaN`
- **Zona horaria:** UTC-05:00 (Colombia)

Las funciones de carga manejan automáticamente estos formatos.

### Manejo de Valores Faltantes

- **Precipitación:** Pocos valores faltantes (~1-2%)
- **Temperatura:** Muchos períodos sin datos (~30-50%)
- **Estrategia:** Eliminación de NA (análisis con datos completos)

### Calidad de los Gráficos

Todos los gráficos se generan en:
- **Formato:** PNG
- **Resolución:** 300 DPI (calidad publicación)
- **Tamaño:** 10-14 pulgadas de ancho

---

## Cumplimiento de Objetivos del Trabajo

| Objetivo | Estado | Ubicación |
|----------|--------|-----------|
| Selección y descarga de datos | Completado | `Precipitacion/`, `Temperatura/` |
| Descripción de los datos | Completado | `CONTEXTO_DATOS.md` |
| Estadísticos descriptivos univariantes | Completado | `analisis_principal.R` (secciones 4-5) |
| Visualizaciones descriptivas | Completado | `resultados/figuras/` |
| Patrones temporales | Completado | `analisis_principal.R` (secciones 6-7) |
| Análisis bivariado | Completado | `analisis_principal.R` (sección 8) |
| Detección de anomalías | Completado | `analisis_principal.R` (sección 9) |
| Código reproducible | Completado | Todo el proyecto |

---

## Uso del Código

### Para Reproducir el Análisis Completo

```r
source("R/analisis_principal.R")
```

### Para Usar Funciones Individuales

```r
# Cargar funciones
source("R/funciones/carga_datos.R")
source("R/funciones/estadisticas_descriptivas.R")
source("R/funciones/visualizaciones.R")
source("R/funciones/analisis_temporal.R")

# Ejemplo: Cargar un dataset
datos <- cargar_csv_ideam("ruta/al/archivo.csv", "Nombre Variable")

# Ejemplo: Calcular estadísticas
stats <- calcular_estadisticas(datos, "Mi Variable", "unidad")
imprimir_estadisticas(stats, "Mi Variable", "unidad")

# Ejemplo: Crear gráfico
grafico <- grafico_serie_temporal(datos, "Título", eje_y = "Eje Y")
ggsave("mi_grafico.png", grafico, width = 12, height = 6, dpi = 300)
```

---

## Solución de Problemas

### Error: "No se puede encontrar el archivo"

Verificar que el directorio de trabajo sea correcto:

```r
getwd()  # Ver directorio actual
setwd("/home/cerrotico/unal/Trabajo-Final-Descriptiva")  # Establecer correcto
```

### Error: "Paquete no encontrado"

Instalar manualmente:

```r
install.packages(c("ggplot2", "gridExtra", "scales", "moments", "forecast"))
```

### Error: "Memoria insuficiente"

El dataset de temperatura horaria es muy grande. El script ya maneja esto, pero si hay problemas:

```r
# Limpiar memoria
rm(list = ls())
gc()
```

---

## Referencias

- **IDEAM:** Instituto de Hidrología, Meteorología y Estudios Ambientales de Colombia
- **Portal de datos:** http://aquariuswebportal.ideam.gov.co
- **Documentación R:** https://www.r-project.org/
- **ggplot2:** https://ggplot2.tidyverse.org/

---

## Checklist de Entrega

- [x] Código R funcional y documentado
- [x] Funciones modulares en archivos separados
- [x] Análisis descriptivo univariado completo
- [x] Análisis de patrones temporales
- [x] Análisis bivariado (correlaciones)
- [x] Visualizaciones de alta calidad
- [x] Tablas de estadísticas exportadas
- [x] Documentación completa (README + CONTEXTO_DATOS)
- [x] Código reproducible 100%
- [x] Propuesta de póster 
- [x] Conclusiones finales 

---

**Última actualización:** Noviembre 2024  
**Grupo:** 03
