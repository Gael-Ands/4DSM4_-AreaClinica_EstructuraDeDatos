// ==========================================
// Proyecto Integrador - Sprint 1
// Equipo 1: Recepción y Expediente
// Hecho por: Oliver Juárez Prado
// ==========================================

// Dirección del servicio web que nos dio el profe
const urlServicio = "https://servicios-proyecto-ed.vercel.app/api/v1/padron_asegurados";

// Aquí guardamos los datos en un diccionario (Map)
const miDiccionario = new Map();

async function cargarDatos() {
    try {
        console.log("Cargando los datos del padrón...");
        
        // Pedimos los datos al servidor
        const respuesta = await fetch(urlServicio);
        const datosJson = await respuesta.json();

        // Metemos cada paciente al diccionario usando su NSS como llave
        datosJson.datos.forEach(function(paciente) {
            miDiccionario.set(paciente.nss, paciente);
        });

        // Lo que nos pide el profesor que se vea en la consola:
        console.log("------------------------------------------");
        console.log("Total de pacientes que llegaron:", datosJson.total);
        console.log("Total guardados en el diccionario:", miDiccionario.size);
        console.log("------------------------------------------");

        // Buscamos un paciente de prueba para comprobar que sí funciona
        const nssDePrueba = datosJson.datos[0].nss;
        const encontrado = miDiccionario.get(nssDePrueba);

        console.log("Buscando al paciente con NSS:", nssDePrueba);
        if (encontrado) {
            console.log("¡Sí se encontró!");
            console.log("Nombre:", encontrado.nombre);
            console.log("Carrera:", encontrado.carrera);
            console.log("¿Tiene seguro vigente?:", encontrado.vigente);
        } else {
            console.log("No asegurado");
        }

    } catch (error) {
        console.log("Hubo un error de conexión:", error);
    }
}

// Ejecutamos la función
cargarDatos();
