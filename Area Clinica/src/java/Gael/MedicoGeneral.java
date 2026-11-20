package gael;

import java.io.Serializable;

public final class MedicoGeneral implements Serializable {

    private static final long serialVersionUID = 1L;

    private final String clave;
    private final String nombre;
    private final String cedula;
    private final String especialidad;
    private final String area;

    public MedicoGeneral(String clave, String nombre, String cedula,
            String especialidad, String area) {
        this.clave = clave;
        this.nombre = nombre;
        this.cedula = cedula;
        this.especialidad = especialidad;
        this.area = area;
    }

    public String getClave() {
        return clave;
    }

    public String getNombre() {
        return nombre;
    }

    public String getCedula() {
        return cedula;
    }

    public String getEspecialidad() {
        return especialidad;
    }

    public String getArea() {
        return area;
    }
}
