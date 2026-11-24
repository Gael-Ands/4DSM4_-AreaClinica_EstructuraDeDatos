/**
 * Archivo: reglasNegocio.js
 * Responsable: Kevin Giovanni Sevilla Lopez - Integrante 2 (equipo 1)
 */

const BASE = "https://servicios-proyecto-ed.vercel.app/api/v1";

let diccionarioPadron = new Map();

async function cargarPadron() {
    const estadoDiv = document.getElementById("estadoServicio");
    try {
        const respuesta = await fetch(`${BASE}/padron_asegurados`);
        const json = await respuesta.json();

        diccionarioPadron = new Map(json.datos.map(registro => [registro.nss, registro]));

        estadoDiv.innerHTML = `
            <strong> Servicio conectado correctamente </strong><br>
            Total de registros recibidos: <strong>${json.total}</strong> | 
            Guardados en diccionario: <strong>${diccionarioPadron.size}</strong>
        `;

        console.log("Total de registros llegaron:", json.total);
        if (diccionarioPadron.size > 0) {
            const primerNss = diccionarioPadron.keys().next().value;
            console.log("Ejemplo de registro buscado por clave (" + primerNss + "):", diccionarioPadron.get(primerNss));
            document.getElementById("inputNss").placeholder = `Ej. ${primerNss}`;
        }

    } catch (error) {
        estadoDiv.innerHTML = ` Error al conectar con el servicio:  ${error.message}`;
        console.error(error);
    }
}

function buscarPaciente() {
    const nssBuscado = document.getElementById("inputNss").value.trim();
    const caja = document.getElementById("cajaResultado");

    if (!nssBuscado) {
        alert("Por favor ingresa un número de NSS.");
        return;
    }

    caja.style.display = "block";

    if (!diccionarioPadron.has(nssBuscado)) {
        caja.className = "resultado no-asegurado";
        caja.innerHTML = `
            <h3>Resultado: No asegurado</h3>
            <p>El NSS ${nssBuscado}no se encuentra.</p>
        `;
        return;
    }

    const paciente = diccionarioPadron.get(nssBuscado);

    if (paciente.vigente && paciente.vigente.toUpperCase() === "S") {
        caja.className = "resultado vigente-s";
        caja.innerHTML = `
            <h3> Paciente Asegurado (Vigente) </h3>
            <p><strong>Nombre:</strong> ${paciente.nombre}</p>
            <p><strong>Matrícula:</strong> ${paciente.matricula} | <strong>NSS:</strong> ${paciente.nss}</p>
            <p><strong>Carrera:</strong> ${paciente.carrera}</p>
            <p><strong>Vigente:</strong> ${paciente.vigente}</p>
        `;
    } else {
        caja.className = "resultado vigente-n";
        caja.innerHTML = `
            <h3> Seguro No Vigente </h3>
            <p><strong>Nombre:</strong> ${paciente.nombre}</p>
            <p><strong>Matrícula:</strong> ${paciente.matricula} | <strong>NSS:</strong> ${paciente.nss}</p>
            <p><strong>Carrera:</strong> ${paciente.carrera}</p>
            <p><strong>Vigente:</strong> ${paciente.vigente}</p>
        `;
    }
}

window.onload = cargarPadron;