# 🧮 Calculadora Digital en Verilog

Proyecto desarrollado en **Verilog HDL** y sintetizado en **Quartus Prime**, que implementa una calculadora aritmética de 8 bits con operaciones básicas y visualización en displays de 7 segmentos.

## ⚙️ Descripción General

La calculadora realiza operaciones aritméticas entre un **acumulador** (`ACC`) y un **dato de entrada** (`DATA_IN`), controladas mediante un conjunto de **interruptores y pulsadores**.  
El resultado se muestra en **cinco displays de 7 segmentos**, representando centenas, decenas, unidades, décimas y centésimas, además de una salida binaria a través de **LEDs**.

---

## 🧩 Funcionalidad Principal

| Operación | Descripción | Selección (`op_sel`) |
|------------|--------------|----------------------|
| **Suma** | ACC ← ACC + DATA_IN | `00` |
| **Resta** | ACC ← ACC - DATA_IN | `01` |
| **Multiplicación ×2** | ACC ← ACC × 2 | `10` |
| **División ÷2** | ACC ← ACC ÷ 2 | `11` |

El **acumulador** conserva su valor entre operaciones, permitiendo cálculos secuenciales.  
El sistema incluye **detección de overflow** y control de errores en división/multiplicación.

---

## 🧠 Arquitectura del Sistema

El diseño se estructura de manera **modular**, asegurando una jerarquía clara y un `top.v` limpio (sin lógica interna).  
Los principales módulos son:

- `alu_add_sub.v` → Suma y resta con detección de overflow.  
- `alu_shift_mul2_div2.v` → Multiplicación y división por 2 mediante desplazamientos aritméticos.  
- `op_decoder.v` → Decodifica la operación seleccionada desde los switches.  
- `accumulator.v` → Almacena el resultado parcial y habilita carga mediante control.  
- `result_mux.v` → Multiplexa las salidas de la ALU según la operación activa.  
- `bcd_converter.v` → Convierte el resultado binario a formato decimal BCD.  
- `display_driver.v` → Controla los cinco displays de 7 segmentos.  
- `debouncer.v` → Elimina rebotes de los pulsadores físicos.  
- `top.v` → Interconecta todos los módulos anteriores sin añadir lógica adicional.

---

## 🔌 Entradas y Salidas

### Entradas
| Señal | Descripción |
|-------|--------------|
| `clk` | Reloj principal del sistema |
| `rst` | Reset global (activo en bajo) |
| `data_in[7:0]` | Valor ingresado desde switches |
| `op_sel[1:0]` | Selección de operación |
| `calc_btn` | Pulsador de cálculo con antirrebote |

### Salidas
| Señal | Descripción |
|-------|--------------|
| `acc_out[7:0]` | Resultado binario del acumulador (también reflejado en LEDs) |
| `seg[6:0]`, `an[4:0]` | Control de segmentos y dígitos de los displays |
| `ovf_flag` | Indica overflow aritmético |
| `err_flag` | Indica error en operaciones de desplazamiento |

---

## 📊 Visualización

| Display | Contenido | Posición |
|----------|------------|-----------|
| `DISP4` | Centenas | Izquierda |
| `DISP3` | Decenas | — |
| `DISP2` | Unidades | — |
| `DISP1` | Décimas | — |
| `DISP0` | Centésimas | Derecha |

Los LEDs muestran el valor binario de `acc_out`, y los displays presentan el valor decimal total (con parte entera y fraccional, según la operación).

---

## ⚠️ Limitaciones y Consideraciones

- El rango de trabajo es **de -127 a +127**, simétrico en ambos extremos.  
- El cálculo decimal es limitado a dos posiciones fraccionales (décimas y centésimas).  
- En divisiones sucesivas puede presentarse truncamiento por redondeo binario.  
- Los pulsadores deben pasar por el módulo **debouncer** para evitar conteos erróneos.  

---

## 🛠️ Herramientas Utilizadas

- **Intel Quartus Prime Lite Edition**  
- **Verilog HDL (IEEE 1364-2001)**  
- **Plataforma FPGA: Cyclone IV (EP4CE115F29C7)**  
- **Git / GitHub** para control de versiones  

---

## 👨‍💻 Autor

Proyecto desarrollado por **José Ramón Sánchez Acosta**  
Repositorio oficial: [Calculadora_Verilog_Perrona](https://github.com/Zanz-19/Calculadora_Verilog_Perrona)

---

## 🧾 Licencia
Este proyecto se distribuye bajo la licencia **MIT**, permitiendo su uso y modificación con atribución al autor original.

---
