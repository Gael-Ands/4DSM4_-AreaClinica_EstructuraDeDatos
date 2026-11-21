<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="modelo.CalculadoraVacunacion" %>
<%
    // Asegura que los caracteres especiales (acentos, ñ) se lean bien
    request.setCharacterEncoding("UTF-8");

    // 1. Datos del paciente
    String nss = request.getParameter("nss");
    String nombre = request.getParameter("nombre");
    String matricula = request.getParameter("matricula");
    String carrera = request.getParameter("carrera");
    String vigente = request.getParameter("vigente");
    String estatus = request.getParameter("estatus");

    // 2. Datos de admisión
    String folioAdmision = request.getParameter("folio_admision");
    String fechaAdmision = request.getParameter("fecha_admision");
    String horaAdmision = request.getParameter("hora_admision");
    String tipoAtencion = request.getParameter("tipo_atencion");
    String gravedad = request.getParameter("gravedad");
    String claveMedicoAdmision = request.getParameter("clave_medico_admision");

    // 3. Datos del doctor
    String claveMedicoDoc = request.getParameter("clave_medico_doc");
    String nombreDoc = request.getParameter("nombre_doc");
    String cedula = request.getParameter("cedula");
    String especialidad = request.getParameter("especialidad");
    String area = request.getParameter("area");

    // 4. Datos de la vacuna
    String nombreVacuna = request.getParameter("vacuna");
    String fechaPrimero = request.getParameter("fecha_primera_dosis");
    String intervaloStr = request.getParameter("intervalo");
    String totalDosisStr = request.getParameter("total_dosis");
    String dosisAplicadasStr = request.getParameter("dosis_aplicadas");
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Esquema de Vacunación</title>
    </head>
    <body>
        <h1>Esquema de Vacunación</h1>
        <form action="index.jsp" method="GET">
            
            <h3>Datos del paciente</h3>
            NSS: <strong><%= (nss != null && !nss.isEmpty()) ? nss : "No especificado" %></strong><br>
            Nombre: <strong><%= (nombre != null && !nombre.isEmpty()) ? nombre : "No especificado" %></strong><br>
            Matrícula: <strong><%= (matricula != null && !matricula.isEmpty()) ? matricula : "No especificado" %></strong><br>
            Carrera: <strong><%= (carrera != null && !carrera.isEmpty()) ? carrera : "No especificado" %></strong><br>
            Vigente: <strong><%= (vigente != null && !vigente.isEmpty()) ? vigente : "No especificado" %></strong><br>
            Estatus: <strong><%= (estatus != null && !estatus.isEmpty()) ? estatus : "No especificado" %></strong><br><br>

            <h3>Datos de admisión</h3>
            Folio de admisión: <strong><%= (folioAdmision != null && !folioAdmision.isEmpty()) ? folioAdmision : "No especificado" %></strong><br>
            Fecha de admisión: <strong><%= (fechaAdmision != null && !fechaAdmision.isEmpty()) ? fechaAdmision : "No especificado" %></strong><br>
            Hora de admisión: <strong><%= (horaAdmision != null && !horaAdmision.isEmpty()) ? horaAdmision : "No especificado" %></strong><br>
            Tipo de atención: <strong><%= (tipoAtencion != null && !tipoAtencion.isEmpty()) ? tipoAtencion : "No especificado" %></strong><br>
            Gravedad: <strong><%= (gravedad != null && !gravedad.isEmpty()) ? gravedad : "No especificado" %></strong><br>
            Médico asignado: <strong><%= (claveMedicoAdmision != null && !claveMedicoAdmision.isEmpty()) ? claveMedicoAdmision : "No especificado" %></strong><br><br>

            <h3>Datos del Doctor</h3>
            Clave Médico: <strong><%= (claveMedicoDoc != null && !claveMedicoDoc.isEmpty()) ? claveMedicoDoc : "No especificado" %></strong><br>
            Nombre: <strong><%= (nombreDoc != null && !nombreDoc.isEmpty()) ? nombreDoc : "No especificado" %></strong><br>
            Cédula: <strong><%= (cedula != null && !cedula.isEmpty()) ? cedula : "No especificado" %></strong><br>
            Especialidad: <strong><%= (especialidad != null && !especialidad.isEmpty()) ? especialidad : "No especificado" %></strong><br>
            Área: <strong><%= (area != null && !area.isEmpty()) ? area : "No especificado" %></strong><br><br>

            <h3>Datos de la vacuna</h3>
            Nombre de la Vacuna: <strong><%= (nombreVacuna != null && !nombreVacuna.isEmpty()) ? nombreVacuna : "No especificado" %></strong><br>
            Primera dosis: <strong><%= (fechaPrimero != null && !fechaPrimero.isEmpty()) ? fechaPrimero : "No especificado" %></strong><br>
            Intervalo (días): <strong><%= (intervaloStr != null && !intervaloStr.isEmpty()) ? intervaloStr : "No especificado" %></strong><br>
            Total de dosis: <strong><%= (totalDosisStr != null && !totalDosisStr.isEmpty()) ? totalDosisStr : "No especificado" %></strong><br>
            Dosis aplicadas: <strong><%= (dosisAplicadasStr != null && !dosisAplicadasStr.isEmpty()) ? dosisAplicadasStr : "No especificado" %></strong><br><br>

            <h3>Calendario de Dosis</h3>
            <%
                if (fechaPrimero != null && !fechaPrimero.isEmpty() && intervaloStr != null && totalDosisStr != null && dosisAplicadasStr != null) {
                    try {
                        LocalDate fecha = LocalDate.parse(fechaPrimero);
                        int intervalo = Integer.parseInt(intervaloStr);
                        int dosis = Integer.parseInt(totalDosisStr);
                        int dosisAplicado = Integer.parseInt(dosisAplicadasStr);

                        // Obtener todas las fechas mediante recursividad
                        List<LocalDate> fechas = CalculadoraVacunacion.calcularFechas(fecha, intervalo, dosis);

                        // Mostrar cada fecha y su estado
                        for (int i = 0; i < fechas.size(); i++) {
                            if (i < dosisAplicado) {
                                out.println("<label>Fecha de la dosis " + (i + 1) + ": " + fechas.get(i) + ". <b>Aplicado</b></label><br>");
                            } else {
                                out.println("<label>Fecha de la dosis " + (i + 1) + ": " + fechas.get(i) + ". <b>No Aplicado (Pendiente)</b></label><br>");
                            }
                        }
                    } catch (Exception e) {
                        out.println("<p style='color:red;'>Ocurrió un error al procesar los datos: " + e.getMessage() + "</p>");
                    }
                } else {
                    out.println("<p>No se recibieron datos completos para calcular el esquema.</p>");
                }
            %>
            <br>
            <input type="submit" value="Regresar">
        </form>
    </body>
</html>