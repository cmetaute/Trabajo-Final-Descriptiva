# Guía Rápida de Inicio

## Para Empezar Inmediatamente

### Opción 1: Ejecutar Todo el Análisis (Recomendado)

```r
# Abrir RStudio y ejecutar:
setwd("/home/cerrotico/unal/Trabajo-Final-Descriptiva")
source("R/analisis_principal.R")
```

**Resultado:** 
- ~20 gráficos en `resultados/figuras/`
- 3 tablas CSV en `resultados/tablas/`
- Análisis completo en consola
- Tiempo: 2-5 minutos

---

### Opción 2: Explorar con Ejemplos

```r
# Para ver ejemplos de uso de cada función:
setwd("/home/cerrotico/unal/Trabajo-Final-Descriptiva")
source("R/EJEMPLOS_USO.R")
```

---

## Análisis Rápido de un Dataset

```r
# 1. Cargar funciones
source("R/funciones/carga_datos.R")
source("R/funciones/estadisticas_descriptivas.R")
source("R/funciones/visualizaciones.R")

# 2. Cargar datos
datos <- cargar_csv_ideam("ruta/al/archivo.csv", "Nombre Variable")

# 3. Limpiar
datos <- limpiar_na(datos)
datos <- agregar_variables_temporales(datos)

# 4. Estadísticas
stats <- calcular_estadisticas(datos, "Mi Variable", "unidad")
imprimir_estadisticas(stats, "Mi Variable", "unidad")

# 5. Gráficos
grafico_serie_temporal(datos, "Título", eje_y = "Eje Y")
grafico_histograma(datos, "Título", eje_x = "Eje X")
grafico_boxplot(datos, "Título", eje_y = "Eje Y")
```

---

## Verificar que Todo Funciona

### Desde Terminal

```bash
cd /home/cerrotico/unal/Trabajo-Final-Descriptiva
Rscript -e "source('R/analisis_principal.R')"
```

### Desde R

```r
# Verificar paquetes
paquetes <- c("ggplot2", "gridExtra", "scales", "moments", "forecast")
sapply(paquetes, require, character.only = TRUE)

# Si falta alguno:
install.packages(c("ggplot2", "gridExtra", "scales", "moments", "forecast"))
```

---

## Archivos Importantes

| Archivo | Descripción |
|---------|-------------|
| `R/analisis_principal.R` | **EJECUTAR ESTE** - Análisis completo |
| `R/EJEMPLOS_USO.R` | Ejemplos de cada función |
| `README.md` | Documentación completa |
| `CONTEXTO_DATOS.md` | Explicación de los datos |
| `R/funciones/*.R` | Funciones modulares |

---

## Personalizar Gráficos

```r
# Cambiar colores
grafico_serie_temporal(datos, "Título", color = "red")

# Cambiar tamaño
ggsave("mi_grafico.png", grafico, width = 14, height = 8, dpi = 300)

# Cambiar bins del histograma
grafico_histograma(datos, "Título", bins = 50)
```

---

## Problemas Comunes

### "No se encuentra el archivo"
```r
getwd()  # Ver dónde estás
setwd("/home/cerrotico/unal/Trabajo-Final-Descriptiva")  # Ir al directorio correcto
```

### "Paquete no encontrado"
```r
install.packages("nombre_paquete")
```

### "Memoria insuficiente"
```r
rm(list = ls())  # Limpiar
gc()  # Liberar memoria
```

---

## Resultados del Análisis

Después de ejecutar `analisis_principal.R`:

### Consola mostrará:
- Estadísticas descriptivas completas
- Análisis de tendencias
- Patrones mensuales y anuales
- Correlaciones
- Detección de anomalías

### Archivos generados:
- `resultados/figuras/` - ~20 gráficos PNG (300 DPI)
- `resultados/tablas/` - 3 tablas CSV

---

## Siguiente Paso

Una vez ejecutado el análisis:

1. **Revisar gráficos:** Abrir `resultados/figuras/`
2. **Revisar tablas:** Abrir `resultados/tablas/`
3. **Interpretar resultados:** Ver consola de R
4. **Personalizar:** Modificar `analisis_principal.R` según necesidades

---

## Tips

- **Para el informe:** Usa los gráficos de `resultados/figuras/` (300 DPI)
- **Para tablas:** Importa los CSV de `resultados/tablas/` a Word/Excel
- **Para modificar:** Edita `analisis_principal.R` y vuelve a ejecutar
- **Para ayuda:** Lee `README.md` completo

---

## Checklist Rápido

- [ ] RStudio instalado
- [ ] Paquetes instalados (se hace automático)
- [ ] Directorio correcto (`setwd(...)`)
- [ ] Ejecutar `source("R/analisis_principal.R")`
- [ ] Revisar `resultados/figuras/`
- [ ] Revisar `resultados/tablas/`
- [ ] Listo para el informe

---

**¿Dudas?** Lee el `README.md` completo o revisa `CONTEXTO_DATOS.md`
