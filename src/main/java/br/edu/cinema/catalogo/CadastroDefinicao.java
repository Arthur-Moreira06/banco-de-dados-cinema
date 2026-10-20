package br.edu.cinema.catalogo;

import java.util.List;

public record CadastroDefinicao(String tipo, String titulo, String tabela, String colunaId,
        String consultaLista, List<String> colunas, List<CampoFormulario> campos) { }
