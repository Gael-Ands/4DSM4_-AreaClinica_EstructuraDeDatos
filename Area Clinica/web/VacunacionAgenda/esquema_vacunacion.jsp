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

    int totalDosisNum = 0;
    int dosisAplicadasNum = 0;
    int dosisPendientesNum = 0;
    int intervaloNum = 0;

    try {
        if (intervaloStr != null && !intervaloStr.isEmpty()) {
            intervaloNum = Integer.parseInt(intervaloStr);
        }
        if (totalDosisStr != null && !totalDosisStr.isEmpty()) {
            totalDosisNum = Integer.parseInt(totalDosisStr);
        }
        if (dosisAplicadasStr != null && !dosisAplicadasStr.isEmpty()) {
            dosisAplicadasNum = Integer.parseInt(dosisAplicadasStr);
        }
        dosisPendientesNum = Math.max(0, totalDosisNum - dosisAplicadasNum);
    } catch (Exception e) {
        // Se maneja el detalle en el bloque del cálculo
    }
%>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Esquema de Vacunación</title>
        <link rel="stylesheet" href="Interfaz/interfazEstructura.css">
    </head>
    <body>

        <header class="navbar">
            <div class="brand">
                <div class="brand-icon">+</div>
                VacunaAgenda
            </div>
            <nav class="nav-links">
                <span class="active">Vacunación</span>
                <span>Agenda</span>
                <span>Pacientes</span>
            </nav>
            <div class="nav-links">
                <span>Consulta de enfermería</span>
            </div>
        </header>

        <main class="container">
            <div class="breadcrumb">VACUNACIÓN / ESQUEMA DEL PACIENTE</div>
            <h1 class="page-title">Esquema de Vacunación</h1>
            <p class="page-subtitle">Consulta las dosis registradas y las próximas fechas de aplicación.</p>

            <!-- Barra de pasos -->
            <div class="stepper-card">
                <div class="step completed">
                    <div class="step-circle">&#10003;</div>
                    <span>Paciente y vacuna</span>
                </div>
                <div class="step-line"></div>
                <div class="step active">
                    <div class="step-circle">2</div>
                    <span>Esquema de vacunación</span>
                </div>
            </div>

            <div class="main-grid">
                <!-- Columna Izquierda -->
                <div>
                    <!-- 1. Datos del paciente -->
                    <div class="card">
                        <div class="card-header-num"><span>01</span> Datos del paciente</div>
                        <div class="form-grid">
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">NSS</span>
                                <p style="font-weight: 600;"><%= (nss != null && !nss.isEmpty()) ? nss : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Nombre</span>
                                <p style="font-weight: 600;"><%= (nombre != null && !nombre.isEmpty()) ? nombre : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Matrícula</span>
                                <p style="font-weight: 600;"><%= (matricula != null && !matricula.isEmpty()) ? matricula : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Carrera</span>
                                <p style="font-weight: 600;"><%= (carrera != null && !carrera.isEmpty()) ? carrera : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Vigente</span>
                                <p style="font-weight: 600;"><%= (vigente != null && !vigente.isEmpty()) ? vigente : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Estatus</span>
                                <p style="font-weight: 600;"><%= (estatus != null && !estatus.isEmpty()) ? estatus : "No especificado" %></p>
                            </div>
                        </div>
                    </div>

                    <!-- 2. Datos de admisión -->
                    <div class="card">
                        <div class="card-header-num"><span>02</span> Datos de admisión</div>
                        <div class="form-grid">
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Folio de admisión</span>
                                <p style="font-weight: 600;"><%= (folioAdmision != null && !folioAdmision.isEmpty()) ? folioAdmision : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Fecha de admisión</span>
                                <p style="font-weight: 600;"><%= (fechaAdmision != null && !fechaAdmision.isEmpty()) ? fechaAdmision : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Hora de admisión</span>
                                <p style="font-weight: 600;"><%= (horaAdmision != null && !horaAdmision.isEmpty()) ? horaAdmision : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Tipo de atención</span>
                                <p style="font-weight: 600;"><%= (tipoAtencion != null && !tipoAtencion.isEmpty()) ? tipoAtencion : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Gravedad</span>
                                <p style="font-weight: 600;"><%= (gravedad != null && !gravedad.isEmpty()) ? gravedad : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Médico asignado</span>
                                <p style="font-weight: 600;"><%= (claveMedicoAdmision != null && !claveMedicoAdmision.isEmpty()) ? claveMedicoAdmision : "No especificado" %></p>
                            </div>
                        </div>
                    </div>

                    <!-- 3. Datos del Doctor -->
                    <div class="card">
                        <div class="card-header-num"><span>03</span> Datos del Doctor</div>
                        <div class="form-grid">
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Clave Médico</span>
                                <p style="font-weight: 600;"><%= (claveMedicoDoc != null && !claveMedicoDoc.isEmpty()) ? claveMedicoDoc : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Nombre</span>
                                <p style="font-weight: 600;"><%= (nombreDoc != null && !nombreDoc.isEmpty()) ? nombreDoc : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Cédula</span>
                                <p style="font-weight: 600;"><%= (cedula != null && !cedula.isEmpty()) ? cedula : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Especialidad</span>
                                <p style="font-weight: 600;"><%= (especialidad != null && !especialidad.isEmpty()) ? especialidad : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Área</span>
                                <p style="font-weight: 600;"><%= (area != null && !area.isEmpty()) ? area : "No especificado" %></p>
                            </div>
                        </div>
                    </div>

                    <!-- 4. Datos de la vacuna -->
                    <div class="card">
                        <div class="card-header-num"><span>04</span> Datos de la vacuna</div>
                        <div class="form-grid">
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Nombre de la Vacuna</span>
                                <p style="font-weight: 600;"><%= (nombreVacuna != null && !nombreVacuna.isEmpty()) ? nombreVacuna : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Primera dosis</span>
                                <p style="font-weight: 600;"><%= (fechaPrimero != null && !fechaPrimero.isEmpty()) ? fechaPrimero : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Intervalo (días)</span>
                                <p style="font-weight: 600;"><%= (intervaloStr != null && !intervaloStr.isEmpty()) ? intervaloStr : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Total de dosis</span>
                                <p style="font-weight: 600;"><%= (totalDosisStr != null && !totalDosisStr.isEmpty()) ? totalDosisStr : "No especificado" %></p>
                            </div>
                            <div>
                                <span style="font-size: 0.75rem; color: var(--text-muted);">Dosis aplicadas</span>
                                <p style="font-weight: 600;"><%= (dosisAplicadasStr != null && !dosisAplicadasStr.isEmpty()) ? dosisAplicadasStr : "No especificado" %></p>
                            </div>
                        </div>
                    </div>

                    <!-- Métricas de dosis -->
                    <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 1.5rem;">
                        <div class="card" style="margin-bottom: 0; padding: 1.2rem; text-align: center;">
                            <div style="font-size: 1.6rem; font-weight: 700; color: var(--primary);"><%= totalDosisNum %></div>
                            <div style="font-size: 0.85rem; color: var(--text-muted);">Total de dosis</div>
                        </div>
                        <div class="card" style="margin-bottom: 0; padding: 1.2rem; text-align: center;">
                            <div style="font-size: 1.6rem; font-weight: 700; color: var(--primary);"><%= dosisAplicadasNum %></div>
                            <div style="font-size: 0.85rem; color: var(--text-muted);">Dosis aplicadas</div>
                        </div>
                        <div class="card" style="margin-bottom: 0; padding: 1.2rem; text-align: center; background-color: var(--primary-light);">
                            <div style="font-size: 1.6rem; font-weight: 700; color: var(--primary);"><%= dosisPendientesNum %></div>
                            <div style="font-size: 0.85rem; color: var(--primary);">Dosis pendientes</div>
                        </div>
                    </div>

                    <!-- Calendario de Dosis -->
                    <div class="card">
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1rem;">
                            <h3 style="font-size: 1.05rem;">Calendario de Dosis</h3>
                            <span style="font-size: 0.8rem; color: var(--text-muted);"><%= dosisAplicadasNum %> de <%= totalDosisNum %> aplicadas</span>
                        </div>

                        <%
                            if (fechaPrimero != null && !fechaPrimero.isEmpty() && intervaloStr != null && totalDosisStr != null && dosisAplicadasStr != null) {
                                try {
                                    LocalDate fecha = LocalDate.parse(fechaPrimero);
                                    int intervalo = Integer.parseInt(intervaloStr);
                                    int dosis = Integer.parseInt(totalDosisStr);
                                    int dosisAplicado = Integer.parseInt(dosisAplicadasStr);

                                    // Obtener todas las fechas mediante recursividad
                                    List<LocalDate> fechas = CalculadoraVacunacion.calcularFechas(fecha, intervalo, dosis);
                        %>
                        <table style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="border-bottom: 1px solid var(--border);">
                                    <th style="text-align: left; font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; padding-bottom: 10px;">Dosis</th>
                                    <th style="text-align: left; font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; padding-bottom: 10px;">Fecha</th>
                                    <th style="text-align: left; font-size: 0.75rem; color: var(--text-muted); text-transform: uppercase; padding-bottom: 10px;">Estado</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    // Mostrar cada fecha y su estado
                                    for (int i = 0; i < fechas.size(); i++) {
                                        boolean aplicada = (i < dosisAplicado);
                                %>
                                <tr style="border-bottom: 1px solid var(--border);">
                                    <td style="padding: 12px 0; font-weight: 600;">Dosis <%= (i + 1) %></td>
                                    <td style="padding: 12px 0;"><%= fechas.get(i) %></td>
                                    <td style="padding: 12px 0;">
                                        <% if (aplicada) { %>
                                            <span style="background-color: var(--primary-light); color: var(--primary); padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600;">Aplicado</span>
                                        <% } else { %>
                                            <span style="background-color: #EBFAE3; color: #556B42; padding: 4px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600;">No Aplicado (Pendiente)</span>
                                        <% } %>
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                        <%
                                } catch (Exception e) {
                                    out.println("<p style='color:red;'>Ocurrió un error al procesar los datos: " + e.getMessage() + "</p>");
                                }
                            } else {
                                out.println("<p>No se recibieron datos completos para calcular el esquema.</p>");
                            }
                        %>

                        <hr style="border: 0; border-top: 1px solid var(--border); margin: 1.5rem 0;">

                        <form action="index.jsp" method="GET" style="margin: 0;">
                            <button type="submit" class="btn-primary">&larr; Regresar</button>
                        </form>
                    </div>
                </div>

                <!-- Columna Derecha: Panel lateral -->
                <aside>
                    <div class="info-card-green">
                        <div class="breadcrumb">ESQUEMA GENERADO</div>
                        <h3><%= (nombreVacuna != null && !nombreVacuna.isEmpty()) ? nombreVacuna : "Vacuna" %></h3>
                        <p style="font-size: 0.9rem; color: var(--text-muted); margin-bottom: 1rem;">
                            Intervalo configurado: <strong><%= intervaloNum %> días</strong>.
                        </p>
                        <hr style="border: 0; border-top: 1px solid #C6E6B3; margin: 1rem 0;">
                        <p style="font-size: 0.85rem; margin-bottom: 8px;"><strong style="color:var(--primary)">Total:</strong> <%= totalDosisNum %> dosis</p>
                        <p style="font-size: 0.85rem; margin-bottom: 8px;"><strong style="color:var(--primary)">Aplicadas:</strong> <%= dosisAplicadasNum %> dosis</p>
                        <p style="font-size: 0.85rem;"><strong style="color:var(--primary)">Pendientes:</strong> <%= dosisPendientesNum %> dosis</p>
                    </div>

                    <div class="card">
                        <h4 style="font-size: 0.95rem; margin-bottom: 0.5rem;">Un esquema para dar seguimiento</h4>
                        <p style="font-size: 0.85rem; color: var(--text-muted);">
                            Las fechas son orientativas, no citas confirmadas. El personal de salud debe validar el esquema.
                        </p>
                    </div>
                </aside>
            </div>
        </main>
    </body>
</html>