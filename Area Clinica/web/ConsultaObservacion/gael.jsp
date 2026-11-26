<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    if (request.getAttribute("consultorios") == null
            && request.getAttribute("errorCatalogo") == null) {
        response.sendRedirect(request.getContextPath() + "/gael");
        return;
    }

    java.util.List<gael.ConsultorioGeneral> consultorios =
            (java.util.List<gael.ConsultorioGeneral>) request.getAttribute("consultorios");
    java.util.List<rogelio.Paciente> pacientesEnFila =
            (java.util.List<rogelio.Paciente>) request.getAttribute("pacientesEnFila");
    String mensaje = (String) request.getAttribute("mensaje");
    String tipoMensaje = (String) request.getAttribute("tipoMensaje");
    String errorCatalogo = (String) request.getAttribute("errorCatalogo");
    if (consultorios == null) {
        consultorios = java.util.Collections.emptyList();
    }
    if (pacientesEnFila == null) {
        pacientesEnFila = java.util.Collections.emptyList();
    }
%>
<%!
    private String escaparHtmlGael(String valor) {
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
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gael | Consulta y Observación</title>
    <link rel="stylesheet"
            href="<%= request.getContextPath() %>/ConsultaObservacion/estilos/gael.css">
    <link rel="stylesheet"
            href="<%= request.getContextPath() %>/ConsultaObservacion/estilos/navegacion.css">
</head>
<body>
    <header class="encabezado">
        <h1>Gael</h1>
        <p>Consultorios de medicina general</p>
        <nav class="indice" aria-label="Navegación principal">
            <a href="<%= request.getContextPath() %>/ConsultaObservacion/fila.html">Fila</a>
            <a href="<%= request.getContextPath() %>/ConsultaObservacion/baruch.html">Baruch</a>
            <a href="<%= request.getContextPath() %>/rogelio">Rogelio</a>
            <a href="<%= request.getContextPath() %>/ConsultaObservacion/suares.html">Suares</a>
            <a href="<%= request.getContextPath() %>/ConsultaObservacion/piches.html">Piches</a>
            <a href="<%= request.getContextPath() %>/gael" aria-current="page">Gael</a>
        </nav>
    </header>

    <main class="contenedor">
        <section class="panel" aria-labelledby="titulo-consultorios">
            <h2 id="titulo-consultorios">Consultorios</h2>
            <p class="descripcion">
                Ocupa un consultorio para asignar al siguiente paciente de la fila.
            </p>

            <% if (errorCatalogo != null) { %>
                <p class="mensaje error" role="alert">
                    <%= escaparHtmlGael(errorCatalogo) %>
                </p>
            <% } %>
            <% if (mensaje != null) { %>
                <p class="mensaje <%= "exito".equals(tipoMensaje) ? "exito" : "error" %>"
                        role="status"><%= escaparHtmlGael(mensaje) %></p>
            <% } %>

            <% if (consultorios.isEmpty() && errorCatalogo == null) { %>
                <p>No hay médicos generales registrados en el catálogo.</p>
            <% } else { %>
                <div class="rejilla-consultorios">
                    <% for (gael.ConsultorioGeneral consultorio : consultorios) {
                        boolean ocupado = consultorio.isOcupado();
                        gael.MedicoGeneral medico = consultorio.getMedico();
                    %>
                        <article class="consultorio <%= ocupado ? "ocupado" : "disponible" %>">
                            <div class="consultorio-encabezado">
                                <h3><%= escaparHtmlGael(medico.getNombre()) %></h3>
                                <span class="estado">
                                    <%= ocupado ? "Ocupado" : "Disponible" %>
                                </span>
                            </div>
                            <dl>
                                <div>
                                    <dt>Especialidad</dt>
                                    <dd><%= escaparHtmlGael(medico.getEspecialidad()) %></dd>
                                </div>
                                <div>
                                    <dt>Cédula</dt>
                                    <dd><%= escaparHtmlGael(medico.getCedula()) %></dd>
                                </div>
                                <div>
                                    <dt>Área</dt>
                                    <dd><%= escaparHtmlGael(medico.getArea()) %></dd>
                                </div>
                                <div>
                                    <dt>Clave</dt>
                                    <dd><%= escaparHtmlGael(medico.getClave()) %></dd>
                                </div>
                            </dl>

                            <% if (ocupado) { %>
                                <div class="paciente-asignado">
                                    <h4>Paciente en consulta</h4>
                                    <p><strong><%= escaparHtmlGael(consultorio.getPaciente().getNombre()) %></strong></p>
                                    <p>NSS: <%= escaparHtmlGael(consultorio.getPaciente().getNss()) %></p>
                                </div>
                            <% } %>

                            <div class="acciones">
                                <form method="post" action="<%= request.getContextPath() %>/gael">
                                    <input type="hidden" name="medico"
                                            value="<%= escaparHtmlGael(medico.getClave()) %>">
                                    <button type="submit" name="accion" value="ocupar"
                                            <%= ocupado || pacientesEnFila.isEmpty() ? "disabled" : "" %>>
                                        Ocupar
                                    </button>
                                </form>
                                <form method="post" action="<%= request.getContextPath() %>/gael">
                                    <input type="hidden" name="medico"
                                            value="<%= escaparHtmlGael(medico.getClave()) %>">
                                    <button class="boton-desocupar" type="submit"
                                            name="accion" value="desocupar"
                                            <%= ocupado ? "" : "disabled" %>>
                                        Desocupar
                                    </button>
                                </form>
                            </div>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </section>

        <section class="panel" aria-labelledby="titulo-fila">
            <h2 id="titulo-fila">Fila de pacientes</h2>
            <% if (pacientesEnFila.isEmpty()) { %>
                <p>La fila está vacía.</p>
            <% } else { %>
                <ol class="lista-fila">
                    <% for (rogelio.Paciente paciente : pacientesEnFila) { %>
                        <li>
                            <strong><%= escaparHtmlGael(paciente.getNombre()) %></strong>
                            — NSS: <%= escaparHtmlGael(paciente.getNss()) %>
                            — Matrícula: <%= escaparHtmlGael(paciente.getMatricula()) %>
                        </li>
                    <% } %>
                </ol>
            <% } %>
        </section>
    </main>
</body>
</html>
