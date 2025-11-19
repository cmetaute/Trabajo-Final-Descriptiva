# Explicación de los Gráficos Generados

**Proyecto:** Análisis Estadístico Descriptivo - Datos Meteorológicos IDEAM  
**Estación:** 26055120  
**Grupo:** 03  

---

## Índice

1. [Gráficos de Precipitación](#gráficos-de-precipitación)
2. [Gráficos de Temperatura](#gráficos-de-temperatura)
3. [Análisis Bivariado](#análisis-bivariado)

---

## Gráficos de Precipitación

### 1. Serie Temporal - Precipitación Máxima Diaria
**Archivo:** `precip_max_serie_temporal.png`

**Qué muestra:**
- Evolución diaria de la precipitación máxima desde 2016 hasta 2024
- Cada punto representa el valor máximo de precipitación registrado en un día

**Cómo interpretarlo:**
- **Eje X:** Tiempo (años)
- **Eje Y:** Precipitación en milímetros (mm)
- **Picos altos:** Días con lluvias intensas (hasta 42 mm)
- **Línea base en 0:** La mayoría de días no llueve o llueve muy poco

**Hallazgos clave:**
- La precipitación es un fenómeno intermitente (no llueve todos los días)
- Hay eventos extremos esporádicos que superan los 30-40 mm
- No se observa un patrón estacional claro a simple vista
- Los años 2017-2018 y 2020 muestran más eventos de lluvia intensa

---

### 2. Histograma - Precipitación Máxima Diaria
**Archivo:** `precip_max_histograma.png`

**Qué muestra:**
- Distribución de frecuencias de los valores de precipitación
- Curva de densidad (línea roja oscura) que suaviza la distribución

**Cómo interpretarlo:**
- **Eje X:** Precipitación en mm
- **Eje Y:** Densidad (frecuencia relativa)
- **Línea roja discontinua:** Media (0.85 mm)
- **Línea azul discontinua:** Mediana (0.00 mm)

**Hallazgos clave:**
- Distribución extremadamente sesgada a la derecha (asimetría positiva)
- La mayoría de observaciones están concentradas en 0 mm
- La media (0.85) es mayor que la mediana (0) debido a valores extremos
- Esto es típico de datos de precipitación: muchos días sin lluvia y pocos días con lluvia intensa

**Interpretación estadística:**
- **Asimetría:** 6.85 (muy sesgada)
- **Curtosis:** 62.45 (distribución leptocúrtica - muy puntiaguda)
- No sigue una distribución normal

---

### 3. Boxplot - Precipitación Máxima Diaria
**Archivo:** `precip_max_boxplot.png`

**Qué muestra:**
- Resumen visual de los cinco números: mínimo, Q1, mediana, Q3, máximo
- Valores atípicos marcados en rojo

**Cómo interpretarlo:**
- **Caja (rectángulo):** Contiene el 50% central de los datos (Q1 a Q3)
- **Línea central:** Mediana (0 mm)
- **Bigotes:** Extienden hasta 1.5 veces el IQR
- **Puntos rojos:** Valores atípicos (días con lluvia significativa)

**Hallazgos clave:**
- La caja está completamente comprimida en 0 mm
- Esto indica que Q1, Q2 (mediana) y Q3 están todos en 0 o muy cerca
- Todos los puntos rojos son días con lluvia (considerados "atípicos" estadísticamente)
- El 75% de los días tiene precipitación de 0.1 mm o menos

---

### 4. Boxplot Mensual - Precipitación Máxima Diaria
**Archivo:** `precip_max_boxplot_mensual.png`

**Qué muestra:**
- Distribución de precipitación para cada mes del año
- Permite identificar patrones estacionales

**Cómo interpretarlo:**
- **Eje X:** Meses (Ene a Dic)
- **Eje Y:** Precipitación en mm
- **Cada caja:** Distribución de precipitación para ese mes
- **Puntos rojos:** Eventos extremos en cada mes

**Hallazgos clave:**
- Abril y Mayo muestran mayor variabilidad (cajas más altas)
- Todos los meses tienen eventos extremos (puntos rojos)
- Las medianas de todos los meses están cerca de 0
- No hay una diferencia estacional muy marcada en las medianas

---

### 5. Patrón Mensual - Precipitación Máxima Diaria (Barras)
**Archivo:** `precip_max_patron_mensual.png`

**Qué muestra:**
- Promedio de precipitación por mes con barras de error
- Visualización más clara de la estacionalidad

**Cómo interpretarlo:**
- **Barras azules:** Media de precipitación para cada mes
- **Líneas rojas:** ± 1 desviación estándar (mide la variabilidad)
- **Números sobre barras:** Valor exacto de la media

**Hallazgos clave:**
- **Abril:** Mes más lluvioso (1.7 mm promedio)
- **Mayo:** Segundo mes más lluvioso (1.4 mm promedio)
- **Enero, Julio, Agosto:** Meses más secos (0.2-0.6 mm)
- Las barras de error grandes indican alta variabilidad
- Patrón bimodal: dos temporadas lluviosas (abril-mayo y septiembre)

**Interpretación climática:**
- Corresponde al régimen de lluvias típico de Colombia
- Primera temporada de lluvias: marzo-mayo
- Segunda temporada de lluvias: septiembre-noviembre

---

### 6. Patrón Trimestral - Precipitación Máxima Diaria
**Archivo:** `precip_max_patron_trimestral.png`

**Qué muestra:**
- Promedio de precipitación agrupado por trimestres
- Simplifica el análisis estacional

**Cómo interpretarlo:**
- **Trimestre 1:** Enero-Marzo
- **Trimestre 2:** Abril-Junio (más lluvioso)
- **Trimestre 3:** Julio-Septiembre
- **Trimestre 4:** Octubre-Diciembre

**Hallazgos clave:**
- Trimestre 2 tiene el mayor promedio (1.3 mm)
- Los otros trimestres son similares entre sí (0.6-0.7 mm)
- Confirma que abril-junio es la temporada más lluviosa

---

### 7. Análisis de Tendencia - Precipitación Máxima Diaria
**Archivo:** `precip_max_tendencia.png`

**Qué muestra:**
- Regresión lineal para detectar tendencias temporales
- Línea roja: tendencia ajustada
- Puntos azules: datos observados

**Cómo interpretarlo:**
- **Pendiente:** 0.0000 (prácticamente cero)
- **R²:** 0.027 (2.7% de varianza explicada - muy bajo)
- **p-valor:** 0.0000 (estadísticamente significativo)

**Hallazgos clave:**
- La línea de tendencia es casi horizontal
- No hay cambio significativo en la precipitación a lo largo del tiempo
- Aunque el p-valor es significativo, el efecto práctico es nulo
- La precipitación se mantiene estable en el período analizado

**Nota importante:**
- Un p-valor bajo no siempre significa un efecto importante
- Aquí, la significancia estadística se debe al gran tamaño de muestra
- La pendiente cercana a 0 indica que no hay tendencia práctica

---

### 8. Evolución Anual - Precipitación Máxima Diaria
**Archivo:** `precip_max_evolucion_anual.png`

**Qué muestra:**
- Promedio anual de precipitación con banda de confianza
- Línea azul: media anual
- Banda azul claro: ± 1 desviación estándar

**Cómo interpretarlo:**
- **Eje X:** Años
- **Eje Y:** Precipitación promedio (mm)
- **Banda ancha:** Alta variabilidad dentro de cada año

**Hallazgos clave:**
- 2017 fue el año más lluvioso (promedio ~2 mm)
- 2023 fue el año más seco (promedio ~0 mm)
- Tendencia general decreciente de 2017 a 2023
- Repunte en 2024
- La banda ancha indica que hay mucha variabilidad día a día

---

## Gráficos de Temperatura

### 9. Serie Temporal - Temperatura Mínima Media Diaria
**Archivo:** `temp_min_serie_temporal.png`

**Qué muestra:**
- Evolución diaria de la temperatura mínima desde 2006 hasta 2024
- Período más largo que precipitación (18 años de datos)

**Cómo interpretarlo:**
- **Eje X:** Tiempo (años)
- **Eje Y:** Temperatura en grados Celsius (°C)
- **Oscilaciones:** Variación diaria natural

**Hallazgos clave:**
- Rango de temperatura: 18-25°C
- Temperatura relativamente estable a lo largo de los años
- Pico notable en 2020 (temperaturas más altas, hasta 25°C)
- Variabilidad diaria es normal (oscilaciones de corto plazo)
- No se observan cambios bruscos o discontinuidades

**Interpretación climática:**
- Clima tropical estable
- El pico de 2020 podría estar relacionado con fenómenos como El Niño

---

### 10. Histograma - Temperatura Mínima Media Diaria
**Archivo:** `temp_min_histograma.png`

**Qué muestra:**
- Distribución de frecuencias de la temperatura
- Curva de densidad (línea roja oscura)

**Cómo interpretarlo:**
- **Eje X:** Temperatura en °C
- **Eje Y:** Densidad
- **Línea roja discontinua:** Media (21.64°C)
- **Línea azul discontinua:** Mediana (21.66°C)

**Hallazgos clave:**
- Distribución aproximadamente normal (forma de campana)
- Media y mediana casi idénticas (21.64 vs 21.66°C)
- Esto indica simetría en la distribución
- La mayoría de valores se concentran entre 21-22°C
- Pocos valores extremos en ambos lados

**Interpretación estadística:**
- **Asimetría:** -0.05 (prácticamente simétrica)
- **Curtosis:** 3.64 (cercana a 3, distribución mesocúrtica)
- Sigue aproximadamente una distribución normal
- Esto es típico de datos de temperatura

---

### 11. Boxplot - Temperatura Mínima Media Diaria
**Archivo:** `temp_min_boxplot.png`

**Qué muestra:**
- Resumen de cinco números para temperatura
- Valores atípicos marcados en rojo

**Cómo interpretarlo:**
- **Caja:** Contiene el 50% central de los datos
- **Línea central:** Mediana (21.66°C)
- **Bigotes:** Rango de valores normales
- **Puntos rojos:** Días con temperaturas atípicas

**Hallazgos clave:**
- Caja bien definida entre 21.16°C (Q1) y 22.09°C (Q3)
- IQR = 0.93°C (rango intercuartílico pequeño)
- Valores atípicos tanto por arriba (días muy calientes) como por abajo (días fríos)
- Distribución compacta indica estabilidad térmica
- Rango total: 18.4°C a 25.03°C

---

### 12. Boxplot Mensual - Temperatura Mínima Media Diaria
**Archivo:** `temp_min_boxplot_mensual.png`

**Qué muestra:**
- Distribución de temperatura para cada mes
- Permite identificar variación estacional

**Cómo interpretarlo:**
- **Eje X:** Meses (Ene a Dic)
- **Eje Y:** Temperatura en °C
- **Cada caja:** Distribución para ese mes

**Hallazgos clave:**
- Todas las cajas son muy similares entre sí
- Medianas prácticamente iguales en todos los meses (21-22°C)
- Variación estacional mínima (< 1°C entre meses)
- Algunos valores atípicos en varios meses
- Esto es característico de clima tropical ecuatorial

**Interpretación climática:**
- No hay estaciones térmicas marcadas
- Temperatura constante todo el año
- Típico de zonas cercanas al ecuador

---

### 13. Patrón Mensual - Temperatura Mínima Media Diaria (Barras)
**Archivo:** `temp_min_patron_mensual.png`

**Qué muestra:**
- Promedio mensual de temperatura con desviación estándar
- Visualización más clara de la variación mensual

**Cómo interpretarlo:**
- **Barras azules:** Temperatura media por mes
- **Líneas rojas:** ± 1 desviación estándar
- **Números sobre barras:** Valor exacto de la media

**Hallazgos clave:**
- Todos los meses tienen temperaturas entre 21.3°C y 21.9°C
- Variación mensual de solo 0.6°C
- Enero y Junio: ligeramente más cálidos (21.9°C)
- Octubre: ligeramente más frío (21.3°C)
- Desviación estándar pequeña en todos los meses (alta consistencia)

**Conclusión:**
- Temperatura extremadamente estable a lo largo del año
- No hay temporadas frías o calientes definidas

---

### 14. Análisis de Tendencia - Temperatura Mínima Media Diaria
**Archivo:** `temp_min_tendencia.png`

**Qué muestra:**
- Regresión lineal para detectar tendencias de calentamiento/enfriamiento
- Línea roja: tendencia ajustada
- Puntos azules: datos observados

**Cómo interpretarlo:**
- **Pendiente:** 0.0000 (positiva pero muy pequeña)
- **R²:** 0.082 (8.2% de varianza explicada)
- **p-valor:** 0.0000 (estadísticamente significativo)

**Hallazgos clave:**
- Hay una tendencia de calentamiento estadísticamente significativa
- La pendiente es muy pequeña (calentamiento gradual)
- La temperatura aumenta aproximadamente 0.5°C en todo el período (2006-2024)
- El ajuste es bajo (R² = 0.082) debido a la alta variabilidad diaria
- Tendencia consistente con el calentamiento global

**Interpretación:**
- Aunque el calentamiento es lento, es estadísticamente detectable
- En 18 años, la temperatura ha aumentado medio grado
- Esto equivale a ~0.03°C por año

---

### 15. Evolución Anual - Temperatura Mínima Media Diaria
**Archivo:** `temp_min_evolucion_anual.png`

**Qué muestra:**
- Promedio anual de temperatura con banda de confianza
- Línea azul: media anual
- Banda azul claro: ± 1 desviación estándar

**Cómo interpretarlo:**
- **Eje X:** Años
- **Eje Y:** Temperatura promedio (°C)
- **Banda:** Variabilidad dentro de cada año

**Hallazgos clave:**
- Temperatura relativamente estable de 2006 a 2019 (~21.3-21.7°C)
- **2020:** Año anómalo con temperatura mucho más alta (23.74°C)
- Después de 2020, la temperatura vuelve a valores normales
- La banda de confianza es más estrecha que en precipitación (menor variabilidad)

**Interpretación del pico de 2020:**
- Posible evento de El Niño
- Anomalía climática temporal
- Requeriría investigación adicional para confirmar la causa

---

## Análisis Bivariado

### 16. Relación entre Temperatura Mínima y Precipitación Máxima
**Archivo:** `correlacion_temp_precip.png`

**Qué muestra:**
- Gráfico de dispersión comparando temperatura vs precipitación
- Línea roja: regresión lineal
- Banda gris: intervalo de confianza

**Cómo interpretarlo:**
- **Eje X:** Temperatura mínima media (°C)
- **Eje Y:** Precipitación máxima (mm)
- **Cada punto:** Un día con ambas mediciones
- **Correlación de Pearson:** -0.1020

**Hallazgos clave:**
- Correlación negativa muy débil (-0.1020)
- A mayor temperatura, ligeramente menor precipitación
- La relación es casi inexistente (cercana a 0)
- La nube de puntos está muy dispersa
- La línea de regresión es casi horizontal

**Interpretación:**
- Temperatura y precipitación son prácticamente independientes
- No se puede predecir la precipitación a partir de la temperatura
- Esto es normal en climas tropicales donde otros factores (humedad, vientos) son más importantes
- La correlación débil sugiere que ambas variables responden a diferentes mecanismos climáticos

**Nota estadística:**
- Correlación < 0.3 se considera débil
- R² sería aproximadamente 0.01 (1% de varianza compartida)
- No hay relación práctica entre las variables

---

## Resumen de Interpretaciones

### Precipitación
- **Naturaleza:** Intermitente, con muchos días sin lluvia
- **Distribución:** Altamente sesgada (no normal)
- **Estacionalidad:** Abril-Mayo es la temporada más lluviosa
- **Tendencia temporal:** Estable, sin cambios significativos
- **Variabilidad:** Alta, con eventos extremos esporádicos

### Temperatura
- **Naturaleza:** Estable y constante
- **Distribución:** Aproximadamente normal
- **Estacionalidad:** Prácticamente inexistente (variación < 1°C)
- **Tendencia temporal:** Calentamiento gradual (~0.03°C/año)
- **Variabilidad:** Baja, con alta consistencia
- **Anomalía:** Año 2020 con temperaturas inusualmente altas

### Relación entre Variables
- **Correlación:** Muy débil (-0.10)
- **Conclusión:** Las variables son prácticamente independientes
- **Implicación:** No se puede usar una para predecir la otra

---

## Uso de los Gráficos en el Informe

### Recomendaciones

1. **Para análisis descriptivo univariado:**
   - Usar histogramas y boxplots
   - Citar estadísticas específicas (media, mediana, desviación estándar)

2. **Para análisis temporal:**
   - Usar series temporales y gráficos de tendencia
   - Mencionar el p-valor y R² de las regresiones

3. **Para análisis estacional:**
   - Usar boxplots mensuales y gráficos de barras
   - Identificar meses extremos

4. **Para análisis bivariado:**
   - Usar gráfico de dispersión
   - Reportar correlación de Pearson

### Calidad de los Gráficos

Todos los gráficos tienen:
- Resolución de 300 DPI (calidad publicación)
- Títulos descriptivos
- Ejes etiquetados con unidades
- Leyendas claras
- Colores apropiados

**Están listos para incluir directamente en el informe final.**

---

## Preguntas Frecuentes

**¿Por qué la precipitación tiene tantos valores en 0?**
- Es normal. La lluvia no ocurre todos los días. En muchas regiones, la mayoría de días son secos.

**¿Por qué la temperatura es tan estable?**
- La estación está en una zona tropical cercana al ecuador, donde la temperatura varía poco durante el año.

**¿Es normal que la correlación sea tan baja?**
- Sí. En climas tropicales, temperatura y precipitación no están fuertemente relacionadas.

**¿Qué pasó en 2020 con la temperatura?**
- Fue un año anómalo, posiblemente relacionado con fenómenos climáticos como El Niño.

**¿Los valores atípicos son errores?**
- No necesariamente. Pueden ser eventos climáticos reales extremos. Solo se consideran "atípicos" estadísticamente.

---

**Documento preparado para:** Trabajo Final de Estadística Descriptiva  
**Grupo:** 03  
**Fecha:** Noviembre 2024
