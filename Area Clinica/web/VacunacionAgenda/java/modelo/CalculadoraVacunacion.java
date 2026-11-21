package modelo;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CalculadoraVacunacion {
    // Método que inicia el cálculo de las fechas
    public static List<LocalDate> calcularFechas(LocalDate fechaPrimera, int intervalo, int totalDosis) {
        List<LocalDate> fechas = new ArrayList<>();
        generarFechas(fechaPrimera, intervalo, totalDosis, 1, fechas);
        return fechas;
    }

    // Método recursivo que genera las fechas
    private static void generarFechas(LocalDate fechaActual, int intervalo, int totalDosis, int numeroDosis, List<LocalDate> fechas) {
        // CASO BASE:
        // Cuando el número de dosis supera el total,
        // se detiene la recursividad.
        if (numeroDosis > totalDosis) {
            return;
        }
        // Guardar la fecha correspondiente a la dosis actual
        fechas.add(fechaActual);
        // Calcular la fecha de la siguiente dosis
        LocalDate siguienteFecha = fechaActual.plusDays(intervalo);
        // LLAMADA RECURSIVA:
        // Volver a ejecutar el método para la siguiente dosis.
        generarFechas(siguienteFecha, intervalo, totalDosis, numeroDosis + 1, fechas);
    }
}
