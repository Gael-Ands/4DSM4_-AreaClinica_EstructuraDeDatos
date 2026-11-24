<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rogelio | Consulta y Observación</title>
    <link rel="stylesheet"
            href="<%= request.getContextPath() %>/ConsultaObservacion/estilos/rogelio.css">
    <link rel="stylesheet"
            href="<%= request.getContextPath() %>/ConsultaObservacion/estilos/navegacion.css">
    <%
        if (request.getAttribute("pacientesEnFila") == null) {
            response.sendRedirect(request.getContextPath() + "/rogelio");
            return;
        }
    %>
    <%!
        private String escaparHtml(String valor) {
            if (valor == null) {
                return "";
            }
            return valor.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#39;");
        }
    %>
    <%
        String nss = (String) request.getAttribute("nss");
        rogelio.Paciente paciente =
                (rogelio.Paciente) request.getAttribute("paciente");
        String mensaje = (String) request.getAttribute("mensaje");
        String tipoMensaje = (String) request.getAttribute("tipoMensaje");
        if (nss == null) {
            nss = "";
        }
    %>
</head>
<body>
    <header class="encabezado">
        <h1>Rogelio</h1>
        <p>Consulta de pacientes por NSS</p>
        <nav class="indice" aria-label="Navegación principal">
            <a href="<%= request.getContextPath() %>/ConsultaObservacion/fila.html">Fila</a>
            <a href="<%= request.getContextPath() %>/ConsultaObservacion/baruch.html">Baruch</a>
            <a href="<%= request.getContextPath() %>/rogelio" aria-current="page">Rogelio</a>
            <a href="<%= request.getContextPath() %>/ConsultaObservacion/suares.html">Suares</a>
            <a href="<%= request.getContextPath() %>/ConsultaObservacion/piches.html">Piches</a>
            <a href="<%= request.getContextPath() %>/gael">Gael</a>
        </nav>
    </header>

    <main class="contenedor">
        <section class="panel-consulta" aria-labelledby="titulo-consulta">
            <h2 id="titulo-consulta">Buscar paciente</h2>
            <p class="descripcion">
                Ingresa el Número de Seguridad Social para consultar el padrón.
            </p>

            <form id="formulario-nss" method="post"
                    action="<%= request.getContextPath() %>/rogelio">
                <input type="hidden" name="accion" value="buscar">
                <label for="nss">Número de Seguridad Social (NSS)</label>
                <div class="controles-formulario">
                    <input
                        id="nss"
                        name="nss"
                        type="text"
                        inputmode="numeric"
                        autocomplete="off"
                        maxlength="11"
                        pattern="[0-9]{11}"
                        placeholder="Ej. 12345678901"
                        value="<%= escaparHtml(nss) %>"
                        aria-describedby="ayuda-nss"
                        required
                    >
                    <button id="boton-buscar" type="submit">Buscar paciente</button>
                </div>
                <small id="ayuda-nss">Escribe los 11 dígitos del NSS.</small>
            </form>

            <% if (mensaje != null) { %>
                <p class="mensaje" data-estado="<%= escaparHtml(tipoMensaje) %>"
                        role="status"><%= escaparHtml(mensaje) %></p>
            <% } %>

            <% if (paciente != null) { %>
            <section id="resultado-paciente" class="resultado" aria-labelledby="titulo-resultado">
                <h2 id="titulo-resultado">Datos del paciente</h2>
                <dl>
                    <div><dt>Nombre</dt><dd><%= escaparHtml(paciente.getNombre()) %></dd></div>
                    <div><dt>NSS</dt><dd><%= escaparHtml(paciente.getNss()) %></dd></div>
                    <div><dt>Matrícula</dt><dd><%= escaparHtml(paciente.getMatricula()) %></dd></div>
                    <div><dt>Fecha de nacimiento</dt><dd><%= escaparHtml(paciente.getFechaNacimiento()) %></dd></div>
                    <div><dt>Carrera</dt><dd><%= escaparHtml(paciente.getCarrera()) %></dd></div>
                    <div><dt>Vigencia</dt><dd><%= escaparHtml(paciente.getVigente()) %></dd></div>
                </dl>
                <form method="post" action="<%= request.getContextPath() %>/rogelio">
                    <input type="hidden" name="accion" value="agregar">
                    <input type="hidden" name="nss" value="<%= escaparHtml(paciente.getNss()) %>">
                    <button type="submit">Agregar paciente</button>
                </form>
            </section>
            <% } %>
        </section>
    </main>
</body>
</html>
