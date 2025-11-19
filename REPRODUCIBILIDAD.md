# Guía de Reproducibilidad

**Proyecto:** Análisis Estadístico Descriptivo - Datos Meteorológicos IDEAM  
**Grupo:** 03  
**Fecha:** Noviembre 2024  

---

## Requisitos del Sistema

### Software Necesario

1. **R** (versión 4.0 o superior)
   - Descargar de: https://cran.r-project.org/
   - Versión recomendada: 4.3.x o superior

2. **RStudio** (opcional pero recomendado)
   - Descargar de: https://posit.co/download/rstudio-desktop/
   - Versión recomendada: 2023.x o superior

### Sistema Operativo
- Compatible con: Linux, Windows, macOS
- Probado en: Ubuntu 24.04 LTS

---

## Paquetes de R Requeridos

El proyecto requiere los siguientes paquetes de R:

| Paquete | Versión Mínima | Propósito |
|---------|----------------|-----------|
| `ggplot2` | 3.4.0 | Visualizaciones |
| `gridExtra` | 2.3 | Múltiples gráficos |
| `scales` | 1.2.0 | Escalas y formatos |
| `moments` | 0.14 | Asimetría y curtosis |
| `forecast` | 8.20 | Análisis temporal |

### Instalación Automática

El script principal (`R/analisis_principal.R`) instala automáticamente todos los paquetes necesarios si no están presentes.

### Instalación Manual

Si prefiere instalar los paquetes manualmente antes de ejecutar el análisis:

```r
# Instalar todos los paquetes necesarios
install.packages(c("ggplot2", "gridExtra", "scales", "moments", "forecast"),
                 dependencies = TRUE,
                 repos = "https://cloud.r-project.org/")
```

---

## Estructura de Archivos Necesaria

El proyecto requiere la siguiente estructura de directorios:

```
Trabajo-Final-Descriptiva/
├── Precipitacion/          # Datos de precipitación (CSV)
├── Temperatura/            # Datos de temperatura (CSV)
├── R/
│   ├── analisis_principal.R
│   └── funciones/
│       ├── carga_datos.R
│       ├── estadisticas_descriptivas.R
│       ├── visualizaciones.R
│       └── analisis_temporal.R
└── resultados/             # Se crea automáticamente
    ├── figuras/
    └── tablas/
```

---

## Pasos para Reproducir el Análisis

### Opción 1: Ejecución Completa (Recomendado)

1. **Clonar o descargar el proyecto completo**
   ```bash
   # Si está en un repositorio
   git clone [URL_DEL_REPOSITORIO]
   cd Trabajo-Final-Descriptiva
   ```

2. **Abrir R o RStudio**

3. **Establecer el directorio de trabajo**
   ```r
   setwd("/ruta/completa/a/Trabajo-Final-Descriptiva")
   ```

4. **Ejecutar el script principal**
   ```r
   source("R/analisis_principal.R")
   ```

5. **Esperar a que termine** (2-5 minutos)

### Opción 2: Desde Terminal/Consola

```bash
cd /ruta/completa/a/Trabajo-Final-Descriptiva
Rscript R/analisis_principal.R
```

### Opción 3: Desde RStudio (Interfaz Gráfica)

1. Abrir RStudio
2. File → Open File → Seleccionar `R/analisis_principal.R`
3. Presionar `Ctrl + Shift + Enter` (o `Cmd + Shift + Enter` en Mac)

---

## Verificación de Reproducibilidad

### Archivos que se Generarán

Después de ejecutar el análisis, se crearán automáticamente:

**Tablas (3 archivos CSV):**
```
resultados/tablas/
├── estadisticas_precipitacion_maxima.csv
├── estadisticas_precipitacion_total.csv
└── estadisticas_temperatura_minima.csv
```

**Figuras (16 archivos PNG, 300 DPI):**
```
resultados/figuras/
├── correlacion_temp_precip.png
├── precip_max_boxplot.png
├── precip_max_boxplot_mensual.png
├── precip_max_evolucion_anual.png
├── precip_max_histograma.png
├── precip_max_patron_mensual.png
├── precip_max_patron_trimestral.png
├── precip_max_serie_temporal.png
├── precip_max_tendencia.png
├── temp_min_boxplot.png
├── temp_min_boxplot_mensual.png
├── temp_min_evolucion_anual.png
├── temp_min_histograma.png
├── temp_min_patron_mensual.png
├── temp_min_serie_temporal.png
└── temp_min_tendencia.png
```

### Verificar que Todo Funcionó

```r
# Verificar que se crearon las tablas
list.files("resultados/tablas/")

# Verificar que se crearon los gráficos
list.files("resultados/figuras/")

# Debe mostrar 3 archivos CSV y 16 archivos PNG respectivamente
```

---

## Resultados Esperados

### Estadísticas Principales

**Precipitación Máxima Diaria:**
- Media: 0.85 mm
- Mediana: 0.00 mm
- Desviación estándar: 3.30 mm
- Rango: 0 - 42.5 mm

**Temperatura Mínima Media Diaria:**
- Media: 21.64 °C
- Mediana: 21.66 °C
- Desviación estándar: 0.72 °C
- Rango: 18.4 - 25.03 °C

**Correlación Temperatura-Precipitación:**
- Correlación de Pearson: -0.1020 (débil negativa)

### Tiempo de Ejecución

- **Estimado:** 2-5 minutos
- **Depende de:** Velocidad del procesador y disponibilidad de paquetes

---

## Solución de Problemas Comunes

### Error: "No se puede encontrar el archivo"

**Causa:** Directorio de trabajo incorrecto

**Solución:**
```r
# Verificar directorio actual
getwd()

# Cambiar al directorio correcto
setwd("/ruta/completa/a/Trabajo-Final-Descriptiva")
```

### Error: "No se puede instalar el paquete"

**Causa:** Permisos insuficientes o problemas de red

**Solución 1 - Usar biblioteca local:**
```r
# Crear directorio local
dir.create("~/R/library", recursive = TRUE)

# Instalar en biblioteca local
install.packages("nombre_paquete", lib = "~/R/library")

# Cargar desde biblioteca local
library(nombre_paquete, lib.loc = "~/R/library")
```

**Solución 2 - Instalar con sudo (Linux):**
```bash
sudo R
> install.packages(c("ggplot2", "gridExtra", "scales", "moments", "forecast"))
```

### Error: "Memoria insuficiente"

**Causa:** Dataset de temperatura muy grande

**Solución:**
```r
# Limpiar memoria antes de ejecutar
rm(list = ls())
gc()

# Luego ejecutar el análisis
source("R/analisis_principal.R")
```

### Advertencias sobre versiones de paquetes

**Causa:** Versiones antiguas de R o paquetes

**Solución:**
```r
# Actualizar todos los paquetes
update.packages(ask = FALSE)

# O actualizar R a la última versión
```

---

## Información de Sesión

Para documentar exactamente qué versiones se usaron:

```r
# Ejecutar después del análisis
sessionInfo()
```

Esto mostrará:
- Versión de R
- Sistema operativo
- Versiones de todos los paquetes cargados
- Configuración regional

### Ejemplo de Salida

```
R version 4.3.3 (2024-02-29)
Platform: x86_64-pc-linux-gnu (64-bit)
Running under: Ubuntu 24.04 LTS

Matrix products: default
BLAS:   /usr/lib/x86_64-linux-gnu/blas/libblas.so.3.11.0 
LAPACK: /usr/lib/x86_64-linux-gnu/lapack/liblapack.so.3.11.0

locale:
 [1] LC_CTYPE=en_US.UTF-8       LC_NUMERIC=C              
 [3] LC_TIME=en_US.UTF-8        LC_COLLATE=en_US.UTF-8    

attached base packages:
[1] stats     graphics  grDevices utils     datasets  methods   base     

other attached packages:
[1] forecast_8.21.1  moments_0.14.1   scales_1.3.0     
[4] gridExtra_2.3    ggplot2_3.5.0   
```

---

## Datos de Entrada

### Archivos CSV Requeridos

El análisis requiere los siguientes archivos de datos:

**Precipitación:**
1. `Precipitacion/DataSetExport-PRECIPITACION.PT_10_MX_D@26055120-Maximum-mm-20251115143328.csv`
2. `Precipitacion/DataSetExport-PRECIPITACION.PT_10_TT_D@26055120-Maximum-mm-20251115144237.csv`

**Temperatura:**
1. `Temperatura/DataSetExport-TEMPERATURA.TAMN2_MEDIA_D@26055120-Maximum-degC-20251115143538.csv`
2. `Temperatura/DataSetExport-TEMPERATURA.TAMX2_AUT_60@26055120-Maximum-degC-20251115144718.csv`

### Formato de los Datos

- **Separador:** Punto y coma (`;`)
- **Decimal:** Coma (`,`)
- **Codificación:** UTF-8
- **Primera línea:** Metadatos (se omite automáticamente)
- **Columnas:** Fecha y Valor

---

## Modificaciones Permitidas

### Cambiar Rutas de Archivos

Si los archivos CSV están en otra ubicación, modificar en `R/analisis_principal.R`:

```r
# Líneas 69-86 aproximadamente
precip_max_diaria <- cargar_csv_ideam(
  "NUEVA_RUTA/archivo.csv",
  "Precipitación Máxima Diaria"
)
```

### Cambiar Directorio de Salida

Para guardar resultados en otra ubicación:

```r
# Línea 60-62 aproximadamente
dir.create("NUEVA_RUTA/figuras", recursive = TRUE, showWarnings = FALSE)
dir.create("NUEVA_RUTA/tablas", recursive = TRUE, showWarnings = FALSE)
```

### Modificar Gráficos

Los parámetros de visualización se pueden ajustar en `R/funciones/visualizaciones.R`:
- Colores
- Tamaños
- Resolución (DPI)
- Dimensiones

---

## Compatibilidad

### Versiones de R Probadas

- R 4.3.3 (Ubuntu 24.04) - Funciona correctamente
- R 4.2.x - Compatible
- R 4.1.x - Compatible
- R 4.0.x - Compatible (versión mínima)

### Sistemas Operativos Probados

- Linux (Ubuntu 24.04 LTS) - Funciona correctamente
- Windows 10/11 - Compatible
- macOS - Compatible

---

## Contacto y Soporte

Si encuentra problemas al reproducir el análisis:

1. Verificar que todos los archivos CSV estén presentes
2. Verificar que el directorio de trabajo sea correcto
3. Verificar que R esté actualizado (versión 4.0+)
4. Consultar la sección "Solución de Problemas Comunes"

---

## Licencia de los Datos

**Fuente:** IDEAM (Instituto de Hidrología, Meteorología y Estudios Ambientales de Colombia)  
**Portal:** http://aquariuswebportal.ideam.gov.co  
**Estación:** 26055120  
**Período:** 2006-2024  

Los datos son de dominio público y están disponibles para uso académico y científico.

---

## Checklist de Reproducibilidad

Antes de compartir el proyecto, verificar:

- [ ] Todos los archivos CSV están incluidos
- [ ] Todos los scripts R están presentes
- [ ] La estructura de directorios es correcta
- [ ] El README.md está actualizado
- [ ] Los resultados se pueden regenerar ejecutando el script principal
- [ ] La documentación está completa
- [ ] Se incluye este archivo de reproducibilidad

---

**Última actualización:** Noviembre 2024  
**Grupo:** 03  
**Curso:** Estadística Descriptiva y Análisis Exploratorio de Datos
