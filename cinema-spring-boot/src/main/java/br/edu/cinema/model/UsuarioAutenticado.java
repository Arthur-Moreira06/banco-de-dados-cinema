package br.edu.cinema.model;

import java.util.Locale;

public record UsuarioAutenticado(int id, String nome, String cargo, String perfil) {
    public String iniciais() {
        if (nome == null || nome.isBlank()) return "?";
        String[] partes = nome.trim().split("\\s+");
        char primeira = partes[0].charAt(0);
        char segunda = partes.length > 1 ? partes[partes.length - 1].charAt(0) : primeira;
        return ("" + primeira + segunda).toUpperCase(Locale.ROOT);
    }

    public boolean gerente() {
        return "Gerente".equals(cargo) && "Administrativo".equals(perfil);
    }
}
