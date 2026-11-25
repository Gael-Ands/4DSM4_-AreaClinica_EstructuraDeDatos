package Caleb;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class CalculadoraVacunacion {
    //se crea el metodo para calcular las fechas, se crecolectan los datos y se mandan al metodo recursivo y regresa el resultado obtenido
    public static List<LocalDate> calcularFechas(LocalDate fechaPrimera, int intervalo, int totalDosis) {
        List<LocalDate> fechas = new ArrayList<>();
        generarFechas(fechaPrimera, intervalo, totalDosis, 1, fechas);
        return fechas;
    }

    //metodo recursivo "generarFechas"
    private static void generarFechas(LocalDate fechaActual, int intervalo, int totalDosis, int numeroDosis, List<LocalDate> fechas) {
        //se evalua si el numero de dosis supera al total para terminar
        if (numeroDosis > totalDosis) {
            return;
        }
        //si no, guarda la fecha que corresponde a la dosis que se esta calculando
        fechas.add(fechaActual);
        //se calcula la fecha de la siguiente dosis
        LocalDate siguienteFecha = fechaActual.plusDays(intervalo);
        //manda a llamar de nuevo al mismo metodo para calcular la siguiente dosis
        generarFechas(siguienteFecha, intervalo, totalDosis, numeroDosis + 1, fechas);
    }
}
