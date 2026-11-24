package gael;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import rogelio.FilaPacientes;
import rogelio.Paciente;

public final class ConsultoriosGenerales {

    private static final String URL_CATALOGO =
            "https://servicios-proyecto-ed.vercel.app/api/v1/catalogo_medicos";

    public enum ResultadoOcupacion {
        OCUPADO,
        YA_OCUPADO,
        FILA_VACIA,
        MEDICO_NO_ENCONTRADO
    }

    private final Map<String, MedicoGeneral> medicos = new LinkedHashMap<>();
    private final Map<String, Paciente> pacientesPorMedico =
            new LinkedHashMap<>();

    private ConsultoriosGenerales(List<MedicoGeneral> medicos) {
        for (MedicoGeneral medico : medicos) {
            this.medicos.put(medico.getClave(), medico);
        }
    }

    public static ConsultoriosGenerales cargarDesdeApi() throws IOException {
        HttpURLConnection conexion =
                (HttpURLConnection) new URL(URL_CATALOGO).openConnection();
        conexion.setRequestMethod("GET");
        conexion.setConnectTimeout(10000);
        conexion.setReadTimeout(10000);

        try {
            int codigoRespuesta = conexion.getResponseCode();
            if (codigoRespuesta != HttpURLConnection.HTTP_OK) {
                throw new IOException(
                        "El catálogo de médicos respondió con HTTP "
                        + codigoRespuesta + "."
                );
            }

            try (Reader lector = new InputStreamReader(
                    conexion.getInputStream(), StandardCharsets.UTF_8)) {
                JsonElement json = JsonParser.parseReader(lector);
                if (!json.isJsonObject()) {
                    throw new IOException(
                            "La respuesta del catálogo no es un objeto JSON."
                    );
                }

                JsonArray datos = json.getAsJsonObject()
                        .getAsJsonArray("datos");
                if (datos == null) {
                    throw new IOException(
                            "El catálogo no contiene la lista de médicos."
                    );
                }

                List<MedicoGeneral> medicosGenerales = new ArrayList<>();
                for (JsonElement elemento : datos) {
                    if (!elemento.isJsonObject()) {
                        continue;
                    }

                    JsonObject registro = elemento.getAsJsonObject();
                    String especialidad = obtenerTexto(
                            registro, "especialidad"
                    );
                    if (!"Medicina general".equalsIgnoreCase(especialidad)) {
                        continue;
                    }

                    String clave = obtenerTexto(registro, "clave_medico");
                    if (clave.isEmpty()) {
                        continue;
                    }

                    medicosGenerales.add(new MedicoGeneral(
                            clave,
                            obtenerTexto(registro, "nombre"),
                            obtenerTexto(registro, "cedula"),
                            especialidad,
                            obtenerTexto(registro, "area")
                    ));
                }

                if (medicosGenerales.isEmpty()) {
                    throw new IOException(
                            "El catálogo no contiene médicos de medicina general."
                    );
                }
                return new ConsultoriosGenerales(medicosGenerales);
            } catch (JsonParseException | IllegalStateException ex) {
                throw new IOException(
                        "El catálogo de médicos devolvió un JSON inválido.", ex
                );
            }
        } finally {
            conexion.disconnect();
        }
    }

    public synchronized List<ConsultorioGeneral> obtenerConsultorios() {
        List<ConsultorioGeneral> consultorios = new ArrayList<>();
        for (MedicoGeneral medico : medicos.values()) {
            consultorios.add(new ConsultorioGeneral(
                    medico, pacientesPorMedico.get(medico.getClave())
            ));
        }
        return Collections.unmodifiableList(consultorios);
    }

    public synchronized ResultadoOcupacion ocupar(
            String claveMedico, FilaPacientes fila) {
        if (!medicos.containsKey(claveMedico)) {
            return ResultadoOcupacion.MEDICO_NO_ENCONTRADO;
        }
        if (pacientesPorMedico.containsKey(claveMedico)) {
            return ResultadoOcupacion.YA_OCUPADO;
        }

        Paciente siguiente = fila.sacarSiguiente();
        if (siguiente == null) {
            return ResultadoOcupacion.FILA_VACIA;
        }

        pacientesPorMedico.put(claveMedico, siguiente);
        return ResultadoOcupacion.OCUPADO;
    }

    public synchronized boolean desocupar(String claveMedico) {
        if (!medicos.containsKey(claveMedico)) {
            return false;
        }
        return pacientesPorMedico.remove(claveMedico) != null;
    }

    private static String obtenerTexto(JsonObject objeto, String propiedad) {
        JsonElement valor = objeto.get(propiedad);
        return valor == null || valor.isJsonNull()
                ? "" : valor.getAsString().trim();
    }
}
