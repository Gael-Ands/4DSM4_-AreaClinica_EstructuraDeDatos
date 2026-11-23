<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Vacunación y Agenda</title>
</head>
<body>
    <h1>Vacunación y agenda</h1>
    <form action="esquema_vacunacion.jsp" method="POST">
        
        <h3>Datos del paciente</h3>
        NSS <br>
        <input type="text" id="nss" name="nss" maxlength="11" required>
        <button type="button" onclick="buscarPaciente()">Obtener datos del paciente</button>
        <br><br>
        Nombre <br>
        <input type="text" id="nombre" name="nombre" readonly required>
        <br><br>
        Matrícula <br>
        <input type="text" id="matricula" name="matricula" readonly>
        <br><br>
        Carrera <br>
        <input type="text" id="carrera" name="carrera" readonly>
        <br><br>
        Vigente <br>
        <input type="text" id="vigente" name="vigente" readonly>
        <br><br>
        Estatus <br>
        <input type="text" id="estatus" name="estatus" readonly>
        <br><br>
        
        <h3>Datos de admisión</h3>
        Folio de admisión <br>
        <input type="text" id="folio_admision" name="folio_admision" readonly>
        <br><br>
        Fecha de admisión <br>
        <input type="text" id="fecha_admision" name="fecha_admision" readonly>
        <br><br>
        Hora de admisión <br>
        <input type="text" id="hora_admision" name="hora_admision" readonly>
        <br><br>
        Tipo de atención <br>
        <input type="text" id="tipo_atencion" name="tipo_atencion" readonly>
        <br><br>
        Gravedad <br>
        <input type="text" id="gravedad" name="gravedad" readonly>
        <br><br>
        Médico asignado <br>
        <input type="text" id="clave_medico_admision" name="clave_medico_admision" readonly>
        <br><br>
        
        <h3>Datos del Doctor</h3>
        Clave Médico <br>
        <input type="text" id="clave_medico_doc" name="clave_medico_doc" readonly>
        <br><br>
        Nombre <br>
        <input type="text" id="nombre_doc" name="nombre_doc" readonly>
        <br><br>
        Cédula <br>
        <input type="text" id="cedula" name="cedula" readonly>
        <br><br>
        Especialidad <br>
        <input type="text" id="especialidad" name="especialidad" readonly>
        <br><br>
        Área <br>
        <input type="text" id="area" name="area" readonly>
        <br><br>
        <p id="mensaje"></p>
        
        <h3>Datos de la vacuna</h3>
        Nombre de la vacuna <br>
        <input type="text" id="vacuna" name="vacuna" required>
        <br><br>
        Primera dosis <br>
        <input type="date" id="fecha_primera_dosis" name="fecha_primera_dosis" required>
        <br><br>
        Intervalo (días) <br>
        <input type="number" id="intervalo" name="intervalo" min="1" required>
        <br><br>
        Total de dosis <br>
        <input type="number" id="total_dosis" name="total_dosis" min="1" required>
        <br><br>
        Dosis aplicadas <br>
        <input type="number" id="dosis_aplicadas" name="dosis_aplicadas" min="0" required>
        <br><br>
        
        <input type="submit" value="Calcular dosis pendientes">
    </form>
    <script src="codigo_javascript/vacunacion.js"></script>
</body>
</html>
