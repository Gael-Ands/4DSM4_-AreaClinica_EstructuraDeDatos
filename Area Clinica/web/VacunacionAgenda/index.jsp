<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Vacunación y Agenda</title>
    <link rel="stylesheet" href="Interfaz/interfazEstructura.css"/>
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
        <div class="breadcrumb">VACUNACIÓN / NUEVO REGISTRO</div>
        <h1 class="page-title">Vacunación y agenda</h1>
        <p class="page-subtitle">Consulta al paciente y organiza sus próximas dosis en un solo lugar.</p>

        <!-- Barra de pasos -->
        <div class="stepper-card">
            <div class="step active">
                <div class="step-circle">1</div>
                <span>Paciente y vacuna</span>
            </div>
            <div class="step-line"></div>
            <div class="step">
                <div class="step-circle">2</div>
                <span>Esquema de vacunación</span>
            </div>
        </div>

        <div class="main-grid">
            <!-- Columna Izquierda: Formulario con toda tu funcionalidad -->
            <form action="esquema_vacunacion.jsp" method="POST">

                <!-- Tarjeta 01: Datos del paciente -->
                <div class="card">
                    <div class="card-header-num"><span>01</span> Datos del paciente</div>

                    <div class="form-group">
                        <label for="nss">NSS</label>
                        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                            <input type="text" id="nss" name="nss" class="form-control" maxlength="11" placeholder="Ej. 48276190352" style="flex: 1; min-width: 180px;" required>
                            <button type="button" class="btn-primary" onclick="buscarPaciente()">Obtener datos del paciente</button>
                        </div>
                    </div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="nombre">Nombre</label>
                            <input type="text" id="nombre" name="nombre" class="form-control" readonly required>
                        </div>
                        <div class="form-group">
                            <label for="matricula">Matrícula</label>
                            <input type="text" id="matricula" name="matricula" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="carrera">Carrera</label>
                            <input type="text" id="carrera" name="carrera" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="vigente">Vigente</label>
                            <input type="text" id="vigente" name="vigente" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="estatus">Estatus</label>
                            <input type="text" id="estatus" name="estatus" class="form-control" readonly>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta 02: Datos de admisión -->
                <div class="card">
                    <div class="card-header-num"><span>02</span> Datos de admisión</div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="folio_admision">Folio de admisión</label>
                            <input type="text" id="folio_admision" name="folio_admision" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="fecha_admision">Fecha de admisión</label>
                            <input type="text" id="fecha_admision" name="fecha_admision" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="hora_admision">Hora de admisión</label>
                            <input type="text" id="hora_admision" name="hora_admision" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="tipo_atencion">Tipo de atención</label>
                            <input type="text" id="tipo_atencion" name="tipo_atencion" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="gravedad">Gravedad</label>
                            <input type="text" id="gravedad" name="gravedad" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="clave_medico_admision">Médico asignado</label>
                            <input type="text" id="clave_medico_admision" name="clave_medico_admision" class="form-control" readonly>
                        </div>
                    </div>
                </div>

                <!-- Tarjeta 03: Datos del Doctor -->
                <div class="card">
                    <div class="card-header-num"><span>03</span> Datos del Doctor</div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="clave_medico_doc">Clave Médico</label>
                            <input type="text" id="clave_medico_doc" name="clave_medico_doc" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="nombre_doc">Nombre</label>
                            <input type="text" id="nombre_doc" name="nombre_doc" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="cedula">Cédula</label>
                            <input type="text" id="cedula" name="cedula" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="especialidad">Especialidad</label>
                            <input type="text" id="especialidad" name="especialidad" class="form-control" readonly>
                        </div>
                        <div class="form-group">
                            <label for="area">Área</label>
                            <input type="text" id="area" name="area" class="form-control" readonly>
                        </div>
                    </div>

                    <p id="mensaje" style="margin-top: 0.5rem; font-size: 0.9rem; font-weight: 600; color: var(--primary);"></p>
                </div>

                <!-- Tarjeta 04: Datos de la vacuna -->
                <div class="card">
                    <div class="card-header-num"><span>04</span> Datos de la vacuna</div>

                    <div class="form-grid">
                        <div class="form-group">
                            <label for="vacuna">Nombre de la vacuna</label>
                            <input type="text" id="vacuna" name="vacuna" class="form-control" placeholder="Ej. Pfizer" required>
                        </div>
                        <div class="form-group">
                            <label for="fecha_primera_dosis">Primera dosis</label>
                            <input type="date" id="fecha_primera_dosis" name="fecha_primera_dosis" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="intervalo">Intervalo (días)</label>
                            <input type="number" id="intervalo" name="intervalo" class="form-control" min="1" required>
                        </div>
                        <div class="form-group">
                            <label for="total_dosis">Total de dosis</label>
                            <input type="number" id="total_dosis" name="total_dosis" class="form-control" min="1" required>
                        </div>
                        <div class="form-group">
                            <label for="dosis_aplicadas">Dosis aplicadas</label>
                            <input type="number" id="dosis_aplicadas" name="dosis_aplicadas" class="form-control" min="0" required>
                        </div>
                    </div>

                    <hr style="border: 0; border-top: 1px solid var(--border); margin: 1.5rem 0;">

                    <div style="display: flex; justify-content: space-between; align-items: center; gap: 12px; flex-wrap: wrap;">
                        <span style="font-size: 0.8rem; color: var(--text-muted);">Revisa los datos antes de continuar.</span>
                        <input type="submit" class="btn-primary" value="Calcular dosis pendientes">
                    </div>
                </div>

            </form>

            <!-- Columna Derecha: Panel de ayuda visual -->
            <aside>
                <div class="info-card-green">
                    <div class="breadcrumb">UNA AGENDA MÁS CLARA</div>
                    <h3>Su próxima dosis empieza aquí.</h3>
                    <p style="font-size: 0.9rem; color: var(--text-muted); margin-bottom: 1rem;">
                        Genera un esquema a partir de los datos de vacunación del paciente.
                    </p>
                    <hr style="border: 0; border-top: 1px solid #C6E6B3; margin: 1rem 0;">
                    <p style="font-size: 0.85rem; margin-bottom: 8px;"><strong style="color:var(--primary)">01</strong> Busca al paciente por NSS</p>
                    <p style="font-size: 0.85rem; margin-bottom: 8px;"><strong style="color:var(--primary)">02</strong> Verifica admisión y médico</p>
                    <p style="font-size: 0.85rem;"><strong style="color:var(--primary)">03</strong> Calcula el esquema de dosis</p>
                </div>

                <div class="card">
                    <h4 style="font-size: 0.95rem; margin-bottom: 0.5rem;">Antes de calcular</h4>
                    <p style="font-size: 0.85rem; color: var(--text-muted);">
                        Confirma el intervalo y las dosis aplicadas con el expediente del paciente.
                    </p>
                </div>
            </aside>
        </div>
    </main>

    <script src="codigo_javascript/vacunacion.js"></script>
</body>
</html>