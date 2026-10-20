package br.edu.cinema.catalogo;

import java.util.List;

public record CampoFormulario(String nome, String rotulo, String tipo, boolean obrigatorio, List<String> opcoes) {
    public CampoFormulario(String nome, String rotulo, String tipo, boolean obrigatorio) {
        this(nome, rotulo, tipo, obrigatorio, List.of());
    }
}
