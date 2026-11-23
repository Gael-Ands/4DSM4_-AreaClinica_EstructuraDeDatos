//direccion principal de la API
const BASE = "https://servicios-proyecto-ed.vercel.app/api/v1";


//funcion para buscar los datos del paciente (Datos del paciente, Datos de admision, Datos del doctor)
async function buscarPaciente() {
    //captura el nss de la caja de texto
    const nssBuscado = document.getElementById("nss").value.trim();
    //se prepara la etiqueta con id "mensaje" para colocar texto acontinuación
    const mensaje = document.getElementById("mensaje");
    //se pregunta si el nss ingresado es de 11 digitos
    if (!/^\d{11}$/.test(nssBuscado)) {
        mensaje.textContent = "Ingresa un NSS de 11 digitos.";
        return;
    }
    //se muestra un mensaje para dar a enteder que se esta buscando los datos del paciente
    mensaje.textContent = "Consultando informacion del paciente...";
    //limpia los datos de la consulta anterior
    limpiarDatos();
    try {
        //consulta el padron de asegurados
        const respuestaPadron = await fetch(`${BASE}/padron_asegurados`);
        //consulta las admisiones
        const respuestaAdmisiones = await fetch(`${BASE}/admisiones`);
        //consulta el catalogo de medicos
        const respuestaMedicos = await fetch(`${BASE}/catalogo_medicos`);
        //se comprueba que todas las consultas hayan sido exitosas
        if (!respuestaPadron.ok || !respuestaAdmisiones.ok || !respuestaMedicos.ok) {
            throw new Error("No fue posible consultar las API.");
        }
        //convierte la respuestas en formato json
        const jsonPadron = await respuestaPadron.json();
        const jsonAdmisiones = await respuestaAdmisiones.json();
        const jsonMedicos = await respuestaMedicos.json();
        
        //en esta seccion se busca los datos de los pacientes
        //se busca al paciente por su nss
        const paciente = jsonPadron.datos.find(registro => String(registro.nss) === nssBuscado);
        //busca si el paciente existe en el json
        if (!paciente) {
            mensaje.textContent = "El NSS no se encuentra en el padron.";
            limpiarDatos();
            return;
        }
        //de acuerdo al dato obtenido de "paciente" se recolecta los siguiente datos
        document.getElementById("nombre").value = paciente.nombre ?? "";
        document.getElementById("matricula").value = paciente.matricula ?? "";
        document.getElementById("carrera").value = paciente.carrera ?? "";
        document.getElementById("vigente").value = paciente.vigente ?? "";
        //se crea la variable que determina si el paciente tiene vigencia
        const vigente = String(paciente.vigente ?? "").toUpperCase();
        if (vigente === "S") {
            document.getElementById("estatus").value = "ATENCION CON CARGO AL SEGURO FACULTATIVO";
        } else {
            document.getElementById("estatus").value = "ATENCION PARTICULAR";
        }
        
        //en esta seccion se busca los datos de admision
        //busca la admision de acuerdo al nss del paciente
        const admisiones = jsonAdmisiones.datos.filter(registro => String(registro.nss) === nssBuscado);
        //busca si la admision existe en el json
        if (admisiones.length === 0) {
            mensaje.textContent = "Paciente encontrado, pero no tiene admisiones registradas.";
            limpiarAdmision();
            return;
        }
        //ordena las admisiones por la fecha y hora
        admisiones.sort((a, b) => (`${b.fecha} ${b.hora}`).localeCompare(`${a.fecha} ${a.hora}`));
        //obetiene la admision mas reciente
        const admision = admisiones[0];
        //de acuerdo al dato obtenido de "admision" se recolecta los siguiente datos
        document.getElementById("folio_admision").value = admision.folio_admision ?? "";
        document.getElementById("fecha_admision").value = admision.fecha ?? "";
        document.getElementById("hora_admision").value = admision.hora ?? "";
        document.getElementById("tipo_atencion").value = admision.tipo ?? "";
        document.getElementById("gravedad").value = admision.gravedad ?? "";
        //se obtiene la clave del medico de la admision
        const claveMedico = admision.clave_medico;
        document.getElementById("clave_medico_admision").value = claveMedico ?? "";
        
        //en esta seccion se busca los datos del doctor
        //se busca al doctor del json de acuerdo a su clave
        const doctor = jsonMedicos.datos.find(registro => registro.clave_medico === claveMedico);
        //busca si el doctor existe en el json
        if (!doctor) {
            limpiarDoctor();
            mensaje.textContent = "Paciente y admision encontrados, pero no se encontro al medico.";
            return;
        }
        //de acuerdo al dato obtenido de "doctor" se recolecta los siguiente datos
        document.getElementById("clave_medico_doc").value = doctor.clave_medico ?? "";
        document.getElementById("nombre_doc").value = doctor.nombre ?? "";
        document.getElementById("cedula").value = doctor.cedula ?? "";
        document.getElementById("especialidad").value = doctor.especialidad ?? "";
        document.getElementById("area").value = doctor.area ?? "";
        
        //se muestra el mensaje de los datos encontrador en la etiqueta con id "mensaje"
        mensaje.textContent = "Paciente, admision y doctor encontrados correctamente.";
    } catch (error) {
        //se muestra el mensaje del error que ocurrio durante el proceso
        mensaje.textContent = "Error al consultar los servicios: " + error.message;
        console.error("Error en la consulta:", error);
    }
}

function limpiarDatos() {
    document.getElementById("nombre").value = "";
    document.getElementById("matricula").value = "";
    document.getElementById("carrera").value = "";
    document.getElementById("vigente").value = "";
    document.getElementById("estatus").value = "";
    limpiarAdmision();
}

function limpiarAdmision() {
    document.getElementById("folio_admision").value = "";
    document.getElementById("fecha_admision").value = "";
    document.getElementById("hora_admision").value = "";
    document.getElementById("tipo_atencion").value = "";
    document.getElementById("gravedad").value = "";
    document.getElementById("clave_medico_admision").value = "";
    limpiarDoctor();
}

function limpiarDoctor() {
    document.getElementById("clave_medico_doc").value = "";
    document.getElementById("nombre_doc").value = "";
    document.getElementById("cedula").value = "";
    document.getElementById("especialidad").value = "";
    document.getElementById("area").value = "";
}
