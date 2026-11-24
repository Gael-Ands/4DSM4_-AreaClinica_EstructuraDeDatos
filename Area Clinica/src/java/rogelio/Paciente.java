package rogelio;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParseException;
import com.google.gson.JsonParser;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Reader;
import java.io.Serializable;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;

public final class Paciente implements Serializable {

    private static final long serialVersionUID = 1L;
    private static final String URL_API =
            "https://servicios-proyecto-ed.vercel.app/api/v1/padron_asegurados";

    private final String matricula;
    private final String nss;
    private final String nombre;
    private final String fechaNacimiento;
    private final String carrera;
    private final String vigente;

    private Paciente(String matricula, String nss, String nombre,
            String fechaNacimiento, String carrera, String vigente) {
        this.matricula = matricula;
        this.nss = nss;
        this.nombre = nombre;
        this.fechaNacimiento = fechaNacimiento;
        this.carrera = carrera;
        this.vigente = vigente;
    }

    public static Paciente buscarPorNss(String nss) throws IOException {
        if (nss == null || !nss.trim().matches("\\d{11}")) {
            throw new IllegalArgumentException("El NSS debe contener 11 dígitos.");
        }

        HttpURLConnection conexion =
                (HttpURLConnection) new URL(URL_API).openConnection();
        conexion.setRequestMethod("GET");
        conexion.setConnectTimeout(10000);
        conexion.setReadTimeout(10000);

        try {
            int codigoRespuesta = conexion.getResponseCode();
            if (codigoRespuesta != HttpURLConnection.HTTP_OK) {
                throw new IOException(
                        "La API respondió con HTTP " + codigoRespuesta + "."
                );
            }

            try (Reader lector = new InputStreamReader(
                    conexion.getInputStream(), StandardCharsets.UTF_8)) {
                try {
                    JsonElement json = JsonParser.parseReader(lector);
                    if (!json.isJsonObject()) {
                        throw new IOException(
                                "La respuesta de la API no es un objeto JSON."
                        );
                    }

                    JsonArray datos = json.getAsJsonObject()
                            .getAsJsonArray("datos");
                    if (datos == null) {
                        throw new IOException(
                                "La respuesta de la API no contiene la lista de pacientes."
                        );
                    }

                    for (JsonElement elemento : datos) {
                        if (!elemento.isJsonObject()) {
                            continue;
                        }

                        JsonObject registro = elemento.getAsJsonObject();
                        String nssRegistro =
                                obtenerTexto(registro, "nss").trim();
                        if (!nss.trim().equals(nssRegistro)) {
                            continue;
                        }

                        String vigente = obtenerTexto(registro, "vigente");
                        if (!"S".equalsIgnoreCase(vigente)) {
                            return null;
                        }

                        return new Paciente(
                                obtenerTexto(registro, "matricula"),
                                nssRegistro,
                                obtenerTexto(registro, "nombre"),
                                obtenerTexto(registro, "fecha_nacimiento"),
                                obtenerTexto(registro, "carrera"),
                                vigente
                        );
                    }
                } catch (JsonParseException | IllegalStateException
                        | UnsupportedOperationException ex) {
                    throw new IOException(
                            "La API devolvió un JSON inválido.", ex
                    );
                }
            }
        } finally {
            conexion.disconnect();
        }

        return null;
    }

    private static String obtenerTexto(JsonObject objeto, String propiedad) {
        JsonElement valor = objeto.get(propiedad);
        return valor == null || valor.isJsonNull() ? "" : valor.getAsString();
    }

    public String getMatricula() {
        return matricula;
    }

    public String getNss() {
        return nss;
    }

    public String getNombre() {
        return nombre;
    }

    public String getFechaNacimiento() {
        return fechaNacimiento;
    }

    public String getCarrera() {
        return carrera;
    }

    public String getVigente() {
        return vigente;
    }
}
