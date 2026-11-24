package rogelio;

import java.io.Serializable;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Queue;
import java.util.Set;

public final class FilaPacientes implements Serializable {

    private static final long serialVersionUID = 1L;

    private final Queue<Paciente> pacientes = new ArrayDeque<>();
    private final Set<String> nssRegistrados = new HashSet<>();

    public synchronized boolean agregarPaciente(Paciente paciente) {
        if (paciente == null) {
            throw new IllegalArgumentException("El paciente no puede ser nulo.");
        }

        String nss = paciente.getNss() == null
                ? null : paciente.getNss().trim();
        if (nss == null || nss.trim().isEmpty()) {
            throw new IllegalArgumentException("El paciente debe tener un NSS.");
        }

        if (!nssRegistrados.add(nss)) {
            return false;
        }

        pacientes.offer(paciente);
        return true;
    }

    public synchronized List<Paciente> obtenerPacientes() {
        return Collections.unmodifiableList(new ArrayList<>(pacientes));
    }

    public synchronized Paciente sacarSiguiente() {
        return pacientes.poll();
    }
}
