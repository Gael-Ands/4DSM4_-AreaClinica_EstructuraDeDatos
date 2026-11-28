/**
 * Archivo: buscar.js
 * Responsables: Sevilla Lopez Kevin Giovanni [Integrante 2]
 */

let diccionarioPadron = new Map();      // NSS -> Datos del alumno asegurado
let diccionarioExpedientes = new Map(); // NSS -> Lista (Array) de atenciones cerradas

function cargarExpedientesLocales() {
    const guardado = JSON.parse(localStorage.getItem("expedientesClinicos")) || [];
    diccionarioExpedientes = new Map(guardado);
}

function guardarExpedientesLocales() {
    localStorage.setItem(
        "expedientesClinicos",
        JSON.stringify(Array.from(diccionarioExpedientes.entries()))
    );
}

async function cargarPadron() {
    const estadoDiv = document.getElementById("estadoServicio");

    try {
        const respuesta = await fetch(`${BASE}/padron_asegurados`);

        if (!respuesta.ok) {
            throw new Error(`Error HTTP ${respuesta.status}`);
        }

        const json = await respuesta.json();
        diccionarioPadron = new Map(
            json.datos.map(registro => [String(registro.nss).trim(), registro])
        );

        if (estadoDiv) {
            estadoDiv.innerHTML = `
                <strong>Servicio conectado correctamente</strong><br>
                Total de registros recibidos: <strong>${json.total}</strong> | 
                Guardados en diccionario: <strong>${diccionarioPadron.size}</strong>
            `;
        }

        if (diccionarioPadron.size > 0) {
            const primerNss = diccionarioPadron.keys().next().value;
            const inputNss = document.getElementById("numero");
            if (inputNss) {
                inputNss.placeholder = `Ej. ${primerNss}`;
            }
        }

    } catch (error) {
        const mensajeError = `Aviso: No se pudo conectar con el servicio (${error.message}). Operando con respaldo local.`;
        if (estadoDiv) {
            estadoDiv.innerHTML = `<strong>${mensajeError}</strong>`;
        }
        console.warn(mensajeError);
    }

    const pacientesLocales = JSON.parse(localStorage.getItem("padronPacientes")) || [];
    pacientesLocales.forEach(p => {
        const nssLocal = String(p.nss || p.numero || "").trim();
        if (nssLocal && !diccionarioPadron.has(nssLocal)) {
            diccionarioPadron.set(nssLocal, {
                nss: nssLocal,
                nombre: p.nombre || `${p.nombres || ""} ${p.apellidos || ""}`.trim(),
                matricula: p.matricula || "N/A",
                carrera: p.carrera || "N/A",
                vigente: p.vigente || "N"
            });
        }
    });
}

function buscarPaciente() {
    const numero = document.getElementById("numero").value.trim();
    const divEncontrado = document.getElementById("encontrado");
    const divNoEncontrado = document.getElementById("noEncontrado");

    divEncontrado.classList.add("oculto");
    divNoEncontrado.classList.add("oculto");

    if (numero === "") {
        alert("Ingresa el número de seguridad social");
        return;
    }

    const paciente = diccionarioPadron.get(numero);

    if (paciente) {
        const esVigente = paciente.vigente && String(paciente.vigente).toUpperCase() === "S";
        const estatusSeguro = esVigente
            ? "Asegurado (Vigente)"
            : "Seguro No Vigente (Atención como Particular)";

        divEncontrado.classList.remove("oculto");

        document.getElementById("datosPaciente").textContent =
            `NSS: ${paciente.nss} | Nombre: ${paciente.nombre} | ` +
            `Matrícula: ${paciente.matricula} | Carrera: ${paciente.carrera} | ` +
            `Estatus: ${estatusSeguro}`;
            
        document.getElementById("nss").value = paciente.nss || "";
        document.getElementById("nombre").value = paciente.nombre || "";
        document.getElementById("matricula").value = paciente.matricula || "";
        document.getElementById("carrera").value = paciente.carrera || "";
        document.getElementById("estatus").value = estatusSeguro;

        sessionStorage.setItem("pacienteVerificado", numero);
        sessionStorage.setItem("datosPacienteActual", JSON.stringify({
            ...paciente,
            esVigente,
            estatusSeguro
        }));

    } else {
        divNoEncontrado.classList.remove("oculto");
        sessionStorage.removeItem("pacienteVerificado");
        sessionStorage.removeItem("datosPacienteActual");
    }
}

function registrarAtencionEnExpediente(nss, fecha, area, diagnostico, foliosReceta) {
    cargarExpedientesLocales();
    const nssLimpio = String(nss).trim();
    const areasValidas = ["URG", "MG", "MP"];

    if (!areasValidas.includes(area)) {
        console.error("Área no válida para el expediente (RN-A06):", area);
        return false;
    }

    if (!diccionarioExpedientes.has(nssLimpio)) {
        diccionarioExpedientes.set(nssLimpio, []);
    }

    const nuevaAtencion = {
        fecha: fecha,
        area: area,
        diagnostico: diagnostico,
        folios_receta: foliosReceta || []
    };

    diccionarioExpedientes.get(nssLimpio).push(nuevaAtencion);
    guardarExpedientesLocales();
    return true;
}

function consultarExpediente(nss) {
    cargarExpedientesLocales();
    const inputNumero = document.getElementById("numero");
    const nssLimpio = nss ? String(nss).trim() : (inputNumero ? inputNumero.value.trim() : "");
    const cajaExpediente = document.getElementById("cajaExpediente");

    if (!nssLimpio) {
        alert("Ingresa un NSS para consultar su expediente.");
        return [];
    }

    const historial = diccionarioExpedientes.get(nssLimpio) || [];

    if (cajaExpediente) {
        cajaExpediente.classList.remove("oculto");
        if (historial.length === 0) {
            cajaExpediente.innerHTML = `<p>El paciente con NSS <strong>${nssLimpio}</strong> no tiene atenciones previas registradas.</p>`;
        } else {
            let html = `<h3>Expediente Clínico - NSS: ${nssLimpio}</h3><ul>`;
            historial.forEach((atencion, index) => {
                const recetasTexto = atencion.folios_receta.length > 0
                    ? atencion.folios_receta.join(", ")
                    : "Sin receta";
                html += `
                    <li>
                        <strong>Atención #${index + 1} (${atencion.fecha})</strong> - Área: ${atencion.area}<br>
                        Diagnóstico: ${atencion.diagnostico}<br>
                        Recetas emitidas: ${recetasTexto}
                    </li>
                `;
            });
            html += `</ul>`;
            cajaExpediente.innerHTML = html;
        }
    }

    return historial;
}

// INICIALIZACIÓN Y EVENTOS DEL DOM
document.addEventListener("DOMContentLoaded", async function() {
    cargarExpedientesLocales();
    await cargarPadron();

    const btnBuscar = document.getElementById("btnBuscar");
    if (btnBuscar) {
        btnBuscar.addEventListener("click", buscarPaciente);
    }

    const btnExpediente = document.getElementById("btnExpediente");
    if (btnExpediente) {
        btnExpediente.addEventListener("click", () => consultarExpediente());
    }

    const btnRegistro = document.getElementById("btnRegistro");
    if (btnRegistro) {
        btnRegistro.addEventListener("click", function() {
            window.location.href = "registro.html";
        });
    }

    const btnContinuar = document.getElementById("btnContinuar");
    if (btnContinuar) {
        btnContinuar.addEventListener("click", function() {
            const numero = document.getElementById("numero").value.trim();
            const verificado = sessionStorage.getItem("pacienteVerificado");

            if (!verificado || verificado !== numero) {
                alert("Primero verifica al paciente");
                return;
            }

            const tipo = document.getElementById("tipo").value;
            const altura = document.getElementById("altura").value;
            const peso = document.getElementById("peso").value;
            const sangre = document.getElementById("sangre").value;
            const descripcion = document.getElementById("descripcion").value;

            if (!tipo || !altura || !peso || !sangre || !descripcion.trim()) {
                alert("Completa todos los datos de atención");
                return;
            }

            if (Number(altura) <= 0 || Number(peso) <= 0) {
                alert("Ingresa valores válidos mayores a 0 para altura y peso");
                return;
            }

            const paginas = {
                urgencias: "urgencias.html",
                consultas: "consultas.html",
                vacunacion: "vacunacion.html"
            };

            if (!paginas[tipo]) {
                alert("Selecciona un tipo de atención válido");
                return;
            }

            const pacienteActual = JSON.parse(sessionStorage.getItem("datosPacienteActual")) || {};

            const datosAtencion = {
                numero: numero,
                paciente: pacienteActual,
                tipo: tipo,
                altura: altura,
                peso: peso,
                sangre: sangre,
                descripcion: descripcion.trim()
            };

            sessionStorage.setItem("datosAtencion", JSON.stringify(datosAtencion));

            window.location.href = `${paginas[tipo]}?nss=${encodeURIComponent(numero)}`;
        });
    }

    const parametros = new URLSearchParams(window.location.search);
    if (parametros.has("numero") && document.getElementById("numero")) {
        document.getElementById("numero").value = parametros.get("numero");
        buscarPaciente();
    }
});