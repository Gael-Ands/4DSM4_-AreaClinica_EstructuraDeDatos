/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author User
 */

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.function.Consumer;

import javax.swing.*;
import java.awt.*;

public class Paciente {

    // URL del padrón de asegurados.
    private static final String URL_API =
            "https://servicios-proyecto-ed.vercel.app/api/v1/padron_asegurados";

    // Información del paciente obtenida de la API.
    private final String matricula;
    private final String nss;
    private final String nombre;
    private final String fechaNacimiento;
    private final String carrera;
    private final String vigente;

    /*
     * Constructor privado.
     * Los pacientes se crean mediante la búsqueda en la API.
     * Esto evita crear pacientes sin validar.
     */
    private Paciente(String matricula, String nss,
                     String nombre, String fechaNacimiento,
                     String carrera, String vigente) {

        this.matricula = matricula;
        this.nss = nss;
        this.nombre = nombre;
        this.fechaNacimiento = fechaNacimiento;
        this.carrera = carrera;
        this.vigente = vigente;
    }

    /*
     * Busca un paciente por matrícula o NSS.
     *
     * Si existe y tiene seguro vigente, devuelve
     * un objeto Paciente.
     *
     * Si no existe o no está vigente, devuelve null.
     *
     * Si ocurre un error de conexión, lanza una excepción
     * para distinguirlo de un paciente no registrado.
     */
    public static Paciente buscarPaciente(String identificador)
            throws Exception {

        if (identificador == null ||
                !identificador.trim().matches("\\d+")) {
            return null;
        }

        identificador = identificador.trim();

        HttpURLConnection conexion = null;

        try {
            URL url = new URL(URL_API);

            conexion = (HttpURLConnection) url.openConnection();

            conexion.setRequestMethod("GET");
            conexion.setConnectTimeout(5000);
            conexion.setReadTimeout(5000);

            if (conexion.getResponseCode() != 200) {
                throw new Exception(
                        "Error HTTP: " + conexion.getResponseCode()
                );
            }

            // Leer el JSON recibido desde la API.
            try (InputStreamReader lector = new InputStreamReader(
                    conexion.getInputStream(),
                    StandardCharsets.UTF_8)) {

                JsonObject respuesta =
                        JsonParser.parseReader(lector).getAsJsonObject();

                // Obtener el arreglo de asegurados.
                JsonArray datos = respuesta.getAsJsonArray("datos");

                // Recorrer cada registro del padrón.
                for (int i = 0; i < datos.size(); i++) {

                    JsonObject registro =
                            datos.get(i).getAsJsonObject();

                    String matricula =
                            registro.get("matricula").getAsString();

                    String nss =
                            registro.get("nss").getAsString();

                    // Permitir buscar por matrícula o NSS.
                    if (identificador.equals(matricula) ||
                            identificador.equals(nss)) {

                        String vigente =
                                registro.get("vigente").getAsString();

                        // Solo permitir seguros vigentes.
                        if (!vigente.equalsIgnoreCase("S")) {
                            return null;
                        }

                        // Crear y devolver el paciente validado.
                        return new Paciente(
                                matricula,
                                nss,
                                registro.get("nombre").getAsString(),
                                registro.get("fecha_nacimiento").getAsString(),
                                registro.get("carrera").getAsString(),
                                vigente
                        );
                    }
                }
            }

            // No se encontró la matrícula ni el NSS.
            return null;

        } finally {
            if (conexion != null) {
                conexion.disconnect();
            }
        }
    }

    /*
     * Crea el contenedor gráfico de Rogelio.
     *
     * Recibe una función que será ejecutada cuando
     * se encuentre un paciente válido.
     *
     * Así, la clase de Gael puede recibir pacientes
     * sin que Paciente.java dependa de su implementación.
     */
    public static JPanel crearContenedor(
            Consumer<Paciente> alAgregarPaciente) {

        JPanel panel = new JPanel(new GridBagLayout());

        panel.setBorder(BorderFactory.createTitledBorder(
                "Registro de pacientes"
        ));

        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(8, 8, 8, 8);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        JLabel etiqueta = new JLabel(
                "Ingrese matrícula o NSS:"
        );

        JTextField campoMatricula = new JTextField(20);

        JButton botonAgregar = new JButton(
                "Agregar a la fila"
        );

        JLabel mensaje = new JLabel(" ");
        mensaje.setHorizontalAlignment(SwingConstants.CENTER);

        gbc.gridx = 0;
        gbc.gridy = 0;
        panel.add(etiqueta, gbc);

        gbc.gridy = 1;
        panel.add(campoMatricula, gbc);

        gbc.gridy = 2;
        panel.add(botonAgregar, gbc);

        gbc.gridy = 3;
        panel.add(mensaje, gbc);

        /*
         * Acción del botón.
         * La búsqueda se realiza en segundo plano
         * para evitar congelar la interfaz gráfica.
         */
        botonAgregar.addActionListener(e -> {

            String identificador = campoMatricula.getText().trim();

            if (!identificador.matches("\\d+")) {
                mensaje.setForeground(Color.RED);
                mensaje.setText("Ingrese una matrícula o NSS válido.");
                return;
            }

            botonAgregar.setEnabled(false);
            mensaje.setForeground(Color.BLACK);
            mensaje.setText("Consultando padrón...");

            SwingWorker<Paciente, Void> trabajador =
                    new SwingWorker<Paciente, Void>() {

                @Override
                protected Paciente doInBackground() throws Exception {
                    return buscarPaciente(identificador);
                }

                @Override
                protected void done() {

                    botonAgregar.setEnabled(true);

                    try {
                        Paciente paciente = get();

                        if (paciente == null) {
                            mensaje.setForeground(Color.RED);
                            mensaje.setText(
                                    "Paciente no registrado o sin vigencia."
                            );
                            return;
                        }

                        /*
                         * Entregar el paciente validado
                         * a la función proporcionada por
                         * la clase que administra la cola.
                         */
                        if (alAgregarPaciente != null) {
                            alAgregarPaciente.accept(paciente);

                            mensaje.setForeground(
                                    new Color(0, 128, 0)
                            );

                            mensaje.setText(
                                    "Paciente agregado: "
                                    + paciente.getNombre()
                            );

                            campoMatricula.setText("");

                        } else {
                            mensaje.setForeground(Color.RED);
                            mensaje.setText(
                                    "No se ha conectado la cola."
                            );
                        }

                    } catch (Exception ex) {

                        mensaje.setForeground(Color.RED);
                        mensaje.setText(
                                "Error al validar o agregar paciente."
                        );

                        ex.printStackTrace();
                    }
                }
            };

            trabajador.execute();
        });

        return panel;
    }

    // Métodos públicos para acceder a la información.

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

    /*
     * Permite comprobar si el seguro está vigente.
     */
    public boolean estaVigente() {
        return "S".equalsIgnoreCase(vigente);
    }

    /*
     * Representación del paciente en texto.
     * Útil para mostrar los pacientes en la cola.
     */
    @Override
    public String toString() {
        return "Matrícula: " + matricula
                + " | Nombre: " + nombre
                + " | Carrera: " + carrera;
    }
}

