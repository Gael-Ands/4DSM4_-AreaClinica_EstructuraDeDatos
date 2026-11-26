// Direccion principal de la API
const BASE = "https://servicios-proyecto-ed.vercel.app/api/v1";


// Funcion para buscar los datos del paciente
async function buscarPaciente() {

    // Obtener el NSS ingresado por el usuario
    const nssBuscado = document.getElementById("nss").value.trim();

    // Elemento donde mostraremos los mensajes
    const mensaje = document.getElementById("mensaje");

    // Validar que se haya ingresado un NSS de 11 digitos
    if (!/^\d{11}$/.test(nssBuscado)) {
        mensaje.textContent = "Ingresa un NSS de 11 digitos.";
        return;
    }

    // Mostrar mensaje mientras se realizan las consultas
    mensaje.textContent = "Consultando informacion del paciente...";

    // Limpiar los datos de una busqueda anterior
    limpiarDatos();

    try {

        // Consultar el padron de asegurados
        const respuestaPadron = await fetch(`${BASE}/padron_asegurados`);

        // Consultar las admisiones
        const respuestaAdmisiones = await fetch(`${BASE}/admisiones`);

        // Consultar el catalogo de medicos
        const respuestaMedicos = await fetch(`${BASE}/catalogo_medicos`);

        // Comprobar que todas las consultas fueron exitosas
        if (!respuestaPadron.ok || !respuestaAdmisiones.ok || !respuestaMedicos.ok) {
            throw new Error("No fue posible consultar las API.");
        }

        // Convertir las respuestas a formato JSON
        const jsonPadron = await respuestaPadron.json();
        const jsonAdmisiones = await respuestaAdmisiones.json();
        const jsonMedicos = await respuestaMedicos.json();

        // ==========================================
        // 1. BUSCAR LOS DATOS DEL PACIENTE
        // ==========================================

        // Buscar al paciente por su NSS
        const paciente = jsonPadron.datos.find(registro => String(registro.nss) === nssBuscado);

        // Comprobar si existe el paciente
        if (!paciente) {
            mensaje.textContent = "El NSS no se encuentra en el padron.";
            limpiarDatos();
            return;
        }

        // Colocar los datos personales en el formulario
        document.getElementById("nombre").value = paciente.nombre ?? "";
        document.getElementById("matricula").value = paciente.matricula ?? "";
        document.getElementById("carrera").value = paciente.carrera ?? "";
        document.getElementById("vigente").value = paciente.vigente ?? "";
        
        // Determinar el estatus del paciente
        const vigente = String(paciente.vigente ?? "").toUpperCase();

        if (vigente === "S") {
            document.getElementById("estatus").value = "ATENCION CON CARGO AL SEGURO FACULTATIVO";
        } else {
            document.getElementById("estatus").value = "ATENCION PARTICULAR";
        }
        
        // ==========================================
        // 2. BUSCAR LOS DATOS DE ADMISION
        // ==========================================

        // Buscar las admisiones correspondientes al NSS
        const admisiones = jsonAdmisiones.datos.filter(registro => String(registro.nss) === nssBuscado);

        // Comprobar si existen admisiones
        if (admisiones.length === 0) {
            mensaje.textContent = "Paciente encontrado, pero no tiene admisiones registradas.";
            limpiarAdmision();
            return;
        }

        // Ordenar las admisiones por fecha y hora
        admisiones.sort((a, b) => (`${b.fecha} ${b.hora}`).localeCompare(`${a.fecha} ${a.hora}`));
        
        // Obtener la admision mas reciente
        const admision = admisiones[0];
        
        // Mostrar los datos de admision
        document.getElementById("folio_admision").value = admision.folio_admision ?? "";
        document.getElementById("fecha_admision").value = admision.fecha ?? "";
        document.getElementById("hora_admision").value = admision.hora ?? "";
        document.getElementById("tipo_atencion").value = admision.tipo ?? "";
        document.getElementById("gravedad").value = admision.gravedad ?? "";
        
        // Obtener la clave del medico asignado
        const claveMedico = admision.clave_medico;

        // Mostrar la clave del medico en admisiones
        document.getElementById("clave_medico_admision").value = claveMedico ?? "";
        
        // ==========================================
        // 3. BUSCAR LOS DATOS DEL DOCTOR
        // ==========================================

        // Buscar al medico en el catalogo utilizando su clave
        const medico = jsonMedicos.datos.find(registro => registro.clave_medico === claveMedico);

        // Comprobar si se encontro al medico
        if (!medico) {
            limpiarDoctor();
            mensaje.textContent = "Paciente y admision encontrados, pero no se encontro al medico.";
            return;
        }
        
        // Mostrar los datos del doctor en el formulario
        document.getElementById("clave_medico_doc").value = medico.clave_medico ?? "";
        document.getElementById("nombre_doc").value = medico.nombre ?? "";
        document.getElementById("cedula").value = medico.cedula ?? "";
        document.getElementById("especialidad").value = medico.especialidad ?? "";
        document.getElementById("area").value = medico.area ?? "";
        
        // ==========================================
        // 4. CONFIRMAR LA CONSULTA
        // ==========================================

        mensaje.textContent = "Paciente, admision y doctor encontrados correctamente.";
    } catch (error) {
        // Mostrar cualquier error de conexion o consulta
        mensaje.textContent = "Error al consultar los servicios: " + error.message;
        console.error("Error en la consulta:", error);
    }
}

// ==========================================
// FUNCION PARA LIMPIAR LOS DATOS PERSONALES
// ==========================================

function limpiarDatos() {
    document.getElementById("nombre").value = "";
    document.getElementById("matricula").value = "";
    document.getElementById("carrera").value = "";
    document.getElementById("vigente").value = "";
    document.getElementById("estatus").value = "";
    limpiarAdmision();
}

// ==========================================
// FUNCION PARA LIMPIAR LOS DATOS DE ADMISION
// ==========================================

function limpiarAdmision() {
    document.getElementById("folio_admision").value = "";
    document.getElementById("fecha_admision").value = "";
    document.getElementById("hora_admision").value = "";
    document.getElementById("tipo_atencion").value = "";
    document.getElementById("gravedad").value = "";
    document.getElementById("clave_medico_admision").value = "";
    limpiarDoctor();
}

// ==========================================
// FUNCION PARA LIMPIAR LOS DATOS DEL DOCTOR
// ==========================================

function limpiarDoctor() {
    document.getElementById("clave_medico_doc").value = "";
    document.getElementById("nombre_doc").value = "";
    document.getElementById("cedula").value = "";
    document.getElementById("especialidad").value = "";
    document.getElementById("area").value = "";
}
