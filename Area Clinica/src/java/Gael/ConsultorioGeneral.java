package gael;

import rogelio.Paciente;

public final class ConsultorioGeneral {

    private final MedicoGeneral medico;
    private final Paciente paciente;

    ConsultorioGeneral(MedicoGeneral medico, Paciente paciente) {
        this.medico = medico;
        this.paciente = paciente;
    }

    public MedicoGeneral getMedico() {
        return medico;
    }

    public Paciente getPaciente() {
        return paciente;
    }

    public boolean isOcupado() {
        return paciente != null;
    }
}
