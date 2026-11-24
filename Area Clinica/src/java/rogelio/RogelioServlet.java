package rogelio;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.ServletContext;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "RogelioServlet", urlPatterns = {"/rogelio"})
public class RogelioServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String ATRIBUTO_FILA = "filaPacientes";
    private static final String VISTA = "/ConsultaObservacion/rogelio.jsp";

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        mostrarPagina(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String nss = request.getParameter("nss");
        String accion = request.getParameter("accion");
        request.setAttribute("nss", nss == null ? "" : nss.trim());

        if (nss == null || !nss.trim().matches("\\d{11}")) {
            request.setAttribute("mensaje", "Ingresa un NSS válido de 11 dígitos.");
            request.setAttribute("tipoMensaje", "error");
            mostrarPagina(request, response);
            return;
        }

        if (!"buscar".equals(accion) && !"agregar".equals(accion)) {
            request.setAttribute("mensaje", "Acción no válida.");
            request.setAttribute("tipoMensaje", "error");
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            mostrarPagina(request, response);
            return;
        }

        try {
            Paciente paciente = Paciente.buscarPorNss(nss.trim());
            if (paciente == null) {
                request.setAttribute(
                        "mensaje",
                        "No se encontró un paciente con NSS vigente."
                );
                request.setAttribute("tipoMensaje", "error");
            } else {
                request.setAttribute("paciente", paciente);
                if ("agregar".equals(accion)) {
                    FilaPacientes fila =
                            obtenerFila(request.getServletContext());
                    if (fila.agregarPaciente(paciente)) {
                        request.setAttribute(
                                "mensaje",
                                "Paciente agregado al final de la fila."
                        );
                        request.setAttribute("tipoMensaje", "exito");
                    } else {
                        request.setAttribute(
                                "mensaje",
                                "Este paciente ya está en la fila."
                        );
                        request.setAttribute("tipoMensaje", "error");
                    }
                } else {
                    request.setAttribute(
                            "mensaje",
                            "Paciente encontrado. Puedes agregarlo a la fila."
                    );
                    request.setAttribute("tipoMensaje", "exito");
                }
            }
        } catch (IOException ex) {
            log("No se pudo consultar el padrón de asegurados.", ex);
            request.setAttribute(
                    "mensaje",
                    "No se pudo consultar el padrón. Inténtalo de nuevo más tarde."
            );
            request.setAttribute("tipoMensaje", "error");
        }

        mostrarPagina(request, response);
    }

    private void mostrarPagina(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        List<Paciente> pacientes =
                obtenerFila(request.getServletContext()).obtenerPacientes();
        request.setAttribute("pacientesEnFila", pacientes);
        request.getRequestDispatcher(VISTA).forward(request, response);
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
