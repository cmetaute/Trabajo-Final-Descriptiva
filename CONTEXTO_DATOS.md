# Contexto de los Datos - Trabajo Final Estadística Descriptiva

## Fuente de los Datos

**IDEAM** - Instituto de Hidrología, Meteorología y Estudios Ambientales de Colombia
- Portal: http://aquariuswebportal.ideam.gov.co/Data/DataSet/Interval/Latest
- Es la entidad oficial de Colombia encargada del monitoreo del clima, hidrología y medio ambiente

## Estación Meteorológica

**Código de Estación: 26055120**
- Esta es una estación meteorológica automática del IDEAM
- Registra datos continuos de temperatura y precipitación
- Ubicación: Colombia (necesitarías buscar la ubicación exacta en el catálogo del IDEAM)

## Datasets que Tienes

### PRECIPITACIÓN (5 archivos)

#### 1. `PT_10_MX_D` - Precipitación Máxima Diaria (10 minutos)
- **Período**: 2016-2024
- **Frecuencia**: Diaria (registros cada día a las 07:00 UTC-5)
- **Unidad**: milímetros (mm)
- **Significado**: Máxima precipitación registrada en intervalos de 10 minutos durante cada día

#### 2. `PT_10_MX_M` - Precipitación Máxima Mensual (10 minutos)
- **Frecuencia**: Mensual
- **Unidad**: milímetros (mm)
- **Significado**: Máxima precipitación en 10 minutos de cada mes

#### 3. `PT_10_TT_D` - Precipitación Total Diaria (10 minutos)
- **Frecuencia**: Diaria
- **Unidad**: milímetros (mm)
- **Significado**: Total acumulado de precipitación cada día

#### 4. `PT_10_TT_M` - Precipitación Total Mensual (10 minutos)
- **Frecuencia**: Mensual
- **Unidad**: milímetros (mm)
- **Significado**: Total acumulado de precipitación cada mes

#### 5. `PT_AUT_10` - Precipitación Automática (10 minutos)
- **Frecuencia**: Variable (datos automáticos de la estación)
- **Unidad**: milímetros (mm)
- **Significado**: Registros automáticos de precipitación cada 10 minutos

### TEMPERATURA (5 archivos)

#### 1. `TAMN2_MEDIA_D` - Temperatura Mínima Media Diaria (2 metros)
- **Período**: 2006-2024
- **Frecuencia**: Diaria
- **Unidad**: grados Celsius (°C)
- **Significado**: Promedio de las temperaturas mínimas diarias medidas a 2 metros de altura
- **Nota**: Muchos NaN por períodos sin datos

#### 2. `TAMN2_MEDIA_M` - Temperatura Mínima Media Mensual (2 metros)
- **Frecuencia**: Mensual
- **Unidad**: grados Celsius (°C)
- **Significado**: Promedio mensual de temperaturas mínimas

#### 3. `TAMN2_MN_D` - Temperatura Mínima Diaria (2 metros)
- **Frecuencia**: Diaria
- **Unidad**: grados Celsius (°C)
- **Significado**: Temperatura mínima registrada cada día

#### 4. `TAMN2_MN_M` - Temperatura Mínima Mensual (2 metros)
- **Frecuencia**: Mensual
- **Unidad**: grados Celsius (°C)
- **Significado**: Temperatura mínima del mes

#### 5. `TAMX2_AUT_60` - Temperatura Máxima Automática (60 minutos, 2 metros)
- **Período**: 2006-2024 (¡el más largo y detallado!)
- **Frecuencia**: Cada hora (aproximadamente)
- **Unidad**: grados Celsius (°C)
- **Significado**: Registros automáticos horarios de temperatura máxima
- **Nota**: ~184,000 registros - el dataset más grande

## Decodificación de Nomenclatura

### Precipitación (PT)
- **PT** = Precipitación Total
- **10** = Intervalo de 10 minutos
- **MX** = Máximo
- **TT** = Total
- **D** = Diario
- **M** = Mensual
- **AUT** = Automático

### Temperatura (TAM)
- **TAM** = Temperatura Ambiente
- **N2** = Mínima a 2 metros
- **X2** = Máxima a 2 metros
- **MEDIA** = Promedio
- **MN** = Mínimo
- **D** = Diario
- **M** = Mensual
- **AUT** = Automático
- **60** = Intervalo de 60 minutos (1 hora)

## Problemas Identificados en los Datos

### 1. **Valores NaN**
- Representan períodos sin medición (fallas del sensor, mantenimiento, etc.)
- Muy comunes en los datos de temperatura
- Necesitarás decidir cómo manejarlos: eliminar, interpolar, o analizar por períodos

### 2. **Errores de Precisión Numérica**
- Valores como `2,8000000000000003` o `0,30000000000000004`
- Son errores de punto flotante normales
- Deberías redondear a 1-2 decimales

### 3. **Formato de Números**
- Usan coma (`,`) como separador decimal (formato europeo)
- Al importar en Python/R necesitarás especificar `decimal=','`

### 4. **Zonas Horarias**
- Todos los datos están en UTC-05:00 (hora de Colombia)
- Consistente en todos los archivos

### 5. **Períodos Diferentes**
- Precipitación: desde 2016
- Temperatura: desde 2006
- No todos los archivos cubren el mismo período

## Recomendaciones para el Análisis

### 1. **Limpieza de Datos**
```python
# Ejemplo en Python
import pandas as pd

# Leer con formato correcto
df = pd.read_csv('archivo.csv', 
                 sep=';', 
                 decimal=',',
                 skiprows=1,  # Saltar la primera línea de metadatos
                 parse_dates=[0])

# Manejar NaN
df = df.dropna()  # o df.fillna() según tu estrategia

# Redondear valores
df['Valor'] = df['Valor'].round(2)
```

### 2. **Análisis Sugeridos**
- **Series temporales**: Tendencias de temperatura y precipitación a lo largo de los años
- **Estacionalidad**: Patrones mensuales/anuales
- **Correlaciones**: Relación entre temperatura y precipitación
- **Estadísticas descriptivas**: Media, mediana, desviación estándar, percentiles
- **Valores extremos**: Identificar eventos climáticos inusuales
- **Distribuciones**: Histogramas y análisis de normalidad

### 3. **Visualizaciones Útiles**
- Gráficos de línea temporal
- Boxplots por mes/año
- Histogramas de distribución
- Heatmaps de correlación
- Gráficos de dispersión temperatura vs precipitación

### 4. **Preguntas de Investigación Posibles**
- ¿Cómo ha cambiado la temperatura promedio en los últimos años?
- ¿Hay tendencia al calentamiento?
- ¿Cuáles son los meses más lluviosos?
- ¿Existe relación entre temperatura alta y baja precipitación?
- ¿Hay eventos extremos identificables?

## Estructura de Archivos

```
Trabajo-Final-Descriptiva/
├── Precipitacion/
│   ├── PT_10_MX_D (diario)
│   ├── PT_10_MX_M (mensual)
│   ├── PT_10_TT_D (diario)
│   ├── PT_10_TT_M (mensual)
│   └── PT_AUT_10 (automático)
└── Temperatura/
    ├── TAMN2_MEDIA_D (diario)
    ├── TAMN2_MEDIA_M (mensual)
    ├── TAMN2_MN_D (diario)
    ├── TAMN2_MN_M (mensual)
    └── TAMX2_AUT_60 (horario - el más detallado)
```

## Próximos Pasos

1. **Exploración inicial**: Cargar los datos y ver estadísticas básicas
2. **Limpieza**: Manejar NaN y errores numéricos
3. **Visualización exploratoria**: Gráficos iniciales para entender patrones
4. **Análisis descriptivo**: Calcular medidas de tendencia central y dispersión
5. **Análisis temporal**: Estudiar tendencias y estacionalidad
6. **Conclusiones**: Interpretar resultados en contexto climático colombiano

---

**Nota**: Para información más específica sobre la ubicación exacta de la estación 26055120, deberías consultar el catálogo de estaciones del IDEAM.
