package gael;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import rogelio.FilaPacientes;
import rogelio.Paciente;

@WebServlet(name = "GaelServlet", urlPatterns = {"/gael"})
public class GaelServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String ATRIBUTO_CONSULTORIOS = "consultoriosGenerales";
    private static final String ATRIBUTO_FILA = "filaPacientes";
    private static final String VISTA = "/ConsultaObservacion/gael.jsp";

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        mostrarPagina(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String accion = request.getParameter("accion");
        String claveMedico = request.getParameter("medico");

        try {
            ConsultoriosGenerales consultorios =
                    obtenerConsultorios(request.getServletContext());
            FilaPacientes fila = obtenerFila(request.getServletContext());

            if (claveMedico == null || claveMedico.trim().isEmpty()) {
                request.setAttribute("mensaje", "Selecciona un consultorio válido.");
                request.setAttribute("tipoMensaje", "error");
            } else if ("ocupar".equals(accion)) {
                ConsultoriosGenerales.ResultadoOcupacion resultado =
                        consultorios.ocupar(claveMedico, fila);
                switch (resultado) {
                    case OCUPADO:
                        request.setAttribute(
                                "mensaje",
                                "El siguiente paciente de la fila fue asignado al consultorio."
                        );
                        request.setAttribute("tipoMensaje", "exito");
                        break;
                    case YA_OCUPADO:
                        request.setAttribute(
                                "mensaje",
                                "Este consultorio ya está ocupado."
                        );
                        request.setAttribute("tipoMensaje", "error");
                        break;
                    case FILA_VACIA:
                        request.setAttribute(
                                "mensaje",
                                "No hay pacientes en la fila para ocupar el consultorio."
                        );
                        request.setAttribute("tipoMensaje", "error");
                        break;
                    default:
                        request.setAttribute(
                                "mensaje", "No se encontró el consultorio."
                        );
                        request.setAttribute("tipoMensaje", "error");
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        break;
                }
            } else if ("desocupar".equals(accion)) {
                if (consultorios.desocupar(claveMedico)) {
                    request.setAttribute(
                            "mensaje",
                            "Consultorio desocupado. El paciente atendido salió de la fila."
                    );
                    request.setAttribute("tipoMensaje", "exito");
                } else {
                    request.setAttribute(
                            "mensaje",
                            "El consultorio ya estaba desocupado o no existe."
                    );
                    request.setAttribute("tipoMensaje", "error");
                }
            } else {
                request.setAttribute("mensaje", "Acción no válida.");
                request.setAttribute("tipoMensaje", "error");
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            }
        } catch (IOException ex) {
            log("No se pudieron cargar los consultorios de medicina general.", ex);
            request.setAttribute(
                    "mensaje",
                    "No se pudo consultar el catálogo de médicos. Inténtalo más tarde."
            );
            request.setAttribute("tipoMensaje", "error");
        }

        mostrarPagina(request, response);
    }

    private void mostrarPagina(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        try {
            ConsultoriosGenerales consultorios =
                    obtenerConsultorios(request.getServletContext());
            request.setAttribute(
                    "consultorios",
                    consultorios.obtenerConsultorios()
            );
        } catch (IOException ex) {
            log("No se pudieron cargar los consultorios de medicina general.", ex);
            request.setAttribute(
                    "errorCatalogo",
                    "No se pudo consultar el catálogo de médicos. Inténtalo más tarde."
            );
        }

        request.setAttribute(
                "pacientesEnFila",
                obtenerFila(request.getServletContext()).obtenerPacientes()
        );
        request.getRequestDispatcher(VISTA).forward(request, response);
    }

    private ConsultoriosGenerales obtenerConsultorios(ServletContext contexto)
            throws IOException {
        synchronized (contexto) {
            ConsultoriosGenerales consultorios =
                    (ConsultoriosGenerales) contexto.getAttribute(
                            ATRIBUTO_CONSULTORIOS
                    );
            if (consultorios == null) {
                consultorios = ConsultoriosGenerales.cargarDesdeApi();
                contexto.setAttribute(ATRIBUTO_CONSULTORIOS, consultorios);
            }
            return consultorios;
        }
    }

    private FilaPacientes obtenerFila(ServletContext contexto) {
        synchronized (contexto) {
            FilaPacientes fila =
                    (FilaPacientes) contexto.getAttribute(ATRIBUTO_FILA);
            if (fila == null) {
                fila = new FilaPacientes();
                contexto.setAttribute(ATRIBUTO_FILA, fila);
            }
            return fila;
        }
    }
}
