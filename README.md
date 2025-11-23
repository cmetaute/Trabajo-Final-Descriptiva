# Análisis Estadístico Descriptivo y Exploratorio
## Datos Meteorológicos IDEAM - Cali, Colombia

**Grupo:** 03  
**Curso:** Estadística Descriptiva y Análisis Exploratorio de Datos  
**Fecha:** Noviembre 2024  

---

## Descripción del Proyecto

Este proyecto presenta un análisis estadístico descriptivo y exploratorio de datos meteorológicos de **7 estaciones** ubicadas en Cali, Colombia. Los datos fueron obtenidos del portal IDEAM (Instituto de Hidrología, Meteorología y Estudios Ambientales).

### Objetivos

1. Realizar análisis descriptivo univariado de precipitación y temperatura
2. Analizar patrones espacio-temporales entre múltiples estaciones
3. Identificar patrones estacionales e intertemporales
4. Comparar comportamiento climático entre diferentes ubicaciones
5. Detectar anomalías y tendencias en las series temporales

---

## Fuente de Datos

**Portal:** http://aquariuswebportal.ideam.gov.co  
**Región:** Cali, Valle del Cauca, Colombia  
**Período:** 2011-2024 (varía por estación)  
**Resolución temporal:**
- Precipitación: Diaria (máxima en 24h)
- Temperatura: Horaria

### Estaciones Meteorológicas

| Código | Nombre | Ubicación |
|--------|--------|-----------|
| 26055120 | UDV | Universidad del Valle |
| 26075150 | Aeropuerto Bonilla | Aeropuerto Alfonso Bonilla Aragón |
| 26095320 | El Vínculo | Sector El Vínculo |
| 26055100 | Farallones | Parque Nacional Farallones |
| 26075120 | La Diana | Sector La Diana |
| 26055110 | La Independencia | Sector La Independencia |
| 26085160 | Siloé | Comuna Siloé |

### Variables Analizadas

1. **Precipitación Máxima Diaria (mm)**
   - Código: PRECIPITACION.PT_10_MX_D
   - Unidad: Milímetros (mm)
   - Tipo: Máximo diario

2. **Temperatura Horaria (°C)**
   - Código: TEMPERATURA.TA2_AUT_60
   - Unidad: Grados Celsius (°C)
   - Tipo: Registro horario automático

---

## Estructura del Proyecto

```
Trabajo-Final-Descriptiva/
├── datos/
│   ├── precipitacion/          # 7 archivos CSV de precipitación
│   └── temperatura/            # 7 archivos CSV de temperatura
├── resultados/
│   ├── figuras/                # 10 gráficos PNG (300 DPI)
│   └── tablas/                 # 2 tablas CSV con estadísticas
├── analisis_descriptivo_multiestacion.R  # Script principal
├── README.md                   # Este archivo
├── REPRODUCIBILIDAD.md         # Guía de reproducibilidad
├── DEPENDENCIAS.txt            # Lista de paquetes requeridos
└── instalar_dependencias.R     # Script de instalación
```

---

## Requisitos

### Software

- **R** versión 4.0 o superior
- **RStudio** (opcional pero recomendado)

### Paquetes de R

```r
install.packages(c("ggplot2", "gridExtra", "scales", "moments", 
                   "dplyr", "tidyr", "lubridate"))
```

El script principal instala automáticamente los paquetes faltantes.

---

## Cómo Ejecutar el Análisis

### Opción 1: Ejecución Directa (Recomendado)

```r
# Abrir R o RStudio
setwd("/ruta/a/Trabajo-Final-Descriptiva")
source("analisis_descriptivo_multiestacion.R")
```

### Opción 2: Desde Terminal

```bash
cd /ruta/a/Trabajo-Final-Descriptiva
Rscript analisis_descriptivo_multiestacion.R
```

### Tiempo de Ejecución

- Estimado: 2-3 minutos
- Depende de: Velocidad del procesador y disponibilidad de paquetes

---

## Análisis Realizados

### 1. Estadísticas Descriptivas Univariadas

Para cada estación se calculan:

**Medidas de Tendencia Central:**
- Media
- Mediana

**Medidas de Dispersión:**
- Desviación estándar
- Rango
- Rango intercuartílico (IQR)
- Coeficiente de variación

**Medidas de Forma:**
- Asimetría (skewness)
- Curtosis (kurtosis)

**Medidas de Posición:**
- Mínimo
- Cuartil 1 (Q1)
- Cuartil 3 (Q3)
- Máximo

### 2. Análisis Espacio-Temporal

**Comparación entre Estaciones:**
- Distribuciones comparativas (boxplots)
- Correlaciones espaciales
- Variabilidad entre ubicaciones

**Evolución Temporal:**
- Series temporales por estación
- Tendencias a largo plazo
- Variabilidad interanual

### 3. Patrones Estacionales

**Análisis Mensual:**
- Promedios mensuales
- Variabilidad estacional
- Identificación de temporadas (lluviosa/seca)

**Análisis Trimestral:**
- Agrupación por trimestres
- Patrones intraanuales
- Ciclos estacionales

### 4. Análisis de Distribuciones

**Histogramas:**
- Forma de distribución
- Simetría/asimetría
- Identificación de valores atípicos

**Boxplots:**
- Comparación de dispersión
- Detección de outliers
- Rangos intercuartílicos

---

## Resultados Generados

### Tablas (CSV)

1. **estadisticas_precipitacion_por_estacion.csv**
   - Estadísticas descriptivas completas de precipitación
   - Una fila por estación
   - 12 columnas de métricas

2. **estadisticas_temperatura_por_estacion.csv**
   - Estadísticas descriptivas completas de temperatura
   - Una fila por estación
   - 12 columnas de métricas

### Figuras (PNG, 300 DPI)

1. **precip_boxplot_comparativo.png**
   - Comparación de distribuciones de precipitación entre estaciones
   - Ordenado por mediana

2. **temp_boxplot_comparativo.png**
   - Comparación de distribuciones de temperatura entre estaciones
   - Ordenado por mediana

3. **precip_series_temporales.png**
   - Evolución temporal de precipitación mensual
   - Panel con 7 estaciones

4. **temp_series_temporales.png**
   - Evolución temporal de temperatura diaria
   - Panel con 7 estaciones

5. **precip_patron_estacional.png**
   - Patrón mensual de precipitación
   - Barras agrupadas por estación

6. **temp_patron_estacional.png**
   - Patrón mensual de temperatura
   - Líneas por estación

7. **precip_analisis_trimestral.png**
   - Precipitación por trimestre
   - Comparación entre estaciones

8. **precip_histogramas.png**
   - Distribución de frecuencias
   - Panel con 7 estaciones

9. **precip_variabilidad_anual.png**
   - Precipitación total anual
   - Comparación interanual

10. **precip_correlacion_estaciones.png**
    - Matriz de correlación entre estaciones
    - Heatmap con coeficientes de Pearson

---

## Hallazgos Principales

### Precipitación

**Total de registros:** 16,319 observaciones diarias

**Características generales:**
- Distribución altamente sesgada (muchos días sin lluvia)
- Alta variabilidad espacial entre estaciones
- Patrón bimodal estacional (dos temporadas lluviosas)

**Patrón estacional:**
- Primera temporada lluviosa: Marzo-Mayo
- Segunda temporada lluviosa: Septiembre-Noviembre
- Temporadas secas: Junio-Agosto y Diciembre-Febrero

**Variabilidad espacial:**
- Estaciones de mayor elevación (Farallones) muestran mayor precipitación
- Estaciones urbanas (Siloé, UDV) tienen patrones similares
- Correlaciones altas entre estaciones cercanas

### Temperatura

**Total de registros:** 589,574 observaciones horarias

**Características generales:**
- Distribución aproximadamente normal
- Baja variabilidad estacional (clima tropical)
- Alta estabilidad temporal

**Patrón estacional:**
- Variación mensual mínima (< 2°C entre meses)
- No hay estaciones térmicas marcadas
- Típico de clima tropical ecuatorial

**Variabilidad espacial:**
- Diferencias significativas por elevación
- Estaciones de menor elevación más cálidas
- Gradiente altitudinal evidente

---

## Cumplimiento de Requisitos

### Selección y Descarga
- [x] Fuente clara y reproducible (IDEAM)
- [x] Justificación de variables (precipitación y temperatura)
- [x] Región definida (Cali, Colombia)
- [x] Período temporal documentado
- [x] Más de 1000 registros (605,893 registros totales)

### Descripción de Datos
- [x] Resolución temporal especificada
- [x] Variables disponibles documentadas
- [x] Información de estaciones completa
- [x] Formato de datos descrito

### Estadísticos Descriptivos
- [x] Medidas de tendencia central (media, mediana)
- [x] Medidas de dispersión (desviación estándar, IQR)
- [x] Análisis por escalas temporales (anual, mensual, trimestral)
- [x] Tablas resumen generadas

### Visualizaciones
- [x] Gráficos profesionales con títulos descriptivos
- [x] Ejes etiquetados con unidades
- [x] Leyendas claras
- [x] Paleta de colores adecuada
- [x] Resolución 300 DPI

### Análisis Exploratorio
- [x] Patrones temporales identificados
- [x] Análisis estacional completo
- [x] Patrones intertemporales (trimestres)
- [x] Comparación espacial entre estaciones
- [x] Correlaciones calculadas

### Reproducibilidad
- [x] Código R funcional y documentado
- [x] Instalación automática de dependencias
- [x] Estructura organizada
- [x] Comentarios explicativos
- [x] Guías de reproducibilidad

---

## Notas Importantes

### Diferencias con Análisis Anterior

Este análisis se diferencia del trabajo previo en:

1. **Múltiples estaciones:** Análisis comparativo de 7 estaciones (antes 1)
2. **Enfoque descriptivo puro:** Sin modelos de regresión lineal
3. **Análisis espacial:** Comparación entre ubicaciones
4. **Visualizaciones mejoradas:** Gráficos más ilustrativos y comparativos
5. **Mayor énfasis en patrones:** Estacionales e intertemporales

### Consideraciones del Profesor

Según feedback recibido:
- **NO se hacen modelos:** Solo análisis descriptivo
- **Enfoque en series temporales:** Análisis detallado de patrones
- **Visualizaciones ilustrativas:** Gráficos que comuniquen claramente
- **Análisis comparativo:** Entre múltiples estaciones

---

## Reproducibilidad

### Verificación de Resultados

Después de ejecutar el script, verificar:

```r
# Verificar tablas generadas
list.files("resultados/tablas/")
# Debe mostrar 2 archivos CSV

# Verificar figuras generadas
list.files("resultados/figuras/")
# Debe mostrar 10 archivos PNG

# Ver estadísticas
read.csv("resultados/tablas/estadisticas_precipitacion_por_estacion.csv")
```

### Información de Sesión

Para documentar las versiones exactas usadas:

```r
sessionInfo()
```

Ver `REPRODUCIBILIDAD.md` para guía completa.

---

## Archivos para Entrega

Según requisitos del proyecto:

1. **Código R:** `analisis_descriptivo_multiestacion.R` ✓
2. **Datos:** Carpeta `datos/` con 14 archivos CSV ✓
3. **Informe PDF:** (Preparado por compañera de grupo)
4. **Póster:** (Ya completado según profesor)

**Nota:** Los datos ocupan < 2 MB, no requiere Google Drive.

---

## Contacto y Soporte

Para problemas de reproducibilidad:

1. Verificar versión de R (>= 4.0)
2. Verificar que todos los archivos CSV estén en `datos/`
3. Consultar `REPRODUCIBILIDAD.md`
4. Ejecutar `source("instalar_dependencias.R")`

---

## Referencias

- **IDEAM:** Instituto de Hidrología, Meteorología y Estudios Ambientales de Colombia
- **Portal:** http://aquariuswebportal.ideam.gov.co
- **Región:** Cali, Valle del Cauca
- **Documentación R:** https://www.r-project.org/
- **ggplot2:** https://ggplot2.tidyverse.org/
- **dplyr:** https://dplyr.tidyverse.org/

---

## Licencia de Datos

Los datos son de dominio público, proporcionados por IDEAM para uso académico y científico.

---

**Última actualización:** Noviembre 2024  
**Grupo:** 03  
**Total de registros:** 605,893 (16,319 precipitación + 589,574 temperatura)  
**Total de estaciones:** 7  
**Período de análisis:** 2011-2024
