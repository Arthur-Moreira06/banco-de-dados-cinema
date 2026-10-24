package br.edu.cinema.controller;

import br.edu.cinema.model.UsuarioAutenticado;
import br.edu.cinema.repository.ConsultaWebRepository;
import br.edu.cinema.service.VendaAplicacaoService;
import jakarta.servlet.http.HttpSession;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/funcionario")
public class OperacaoFuncionarioController {
    private final JdbcTemplate jdbc;
    private final VendaAplicacaoService vendas;
    private final ConsultaWebRepository consultas;

    public OperacaoFuncionarioController(JdbcTemplate jdbc, VendaAplicacaoService vendas, ConsultaWebRepository consultas) {
        this.jdbc = jdbc;
        this.vendas = vendas;
        this.consultas = consultas;
    }

    @GetMapping("/vendas-produtos")
    public String formularioProdutos(Model model, HttpSession session) {
        model.addAttribute("usuario", session.getAttribute("usuario"));
        model.addAttribute("produtos", jdbc.queryForList("SELECT id_produto AS id,nome,categoria,preco_unitario_atual AS preco,estoque_atual AS estoque FROM produto ORDER BY categoria,nome"));
        model.addAttribute("clientes", jdbc.queryForList("SELECT id_cliente AS id,nome FROM cliente ORDER BY nome"));
        return "venda-produtos";
    }

    @PostMapping("/vendas-produtos")
    public String venderProduto(@RequestParam(required=false) Integer clienteId, @RequestParam String pagamento,
            @RequestParam Map<String,String> parametros, HttpSession session, RedirectAttributes flash) {
        UsuarioAutenticado usuario = (UsuarioAutenticado) session.getAttribute("usuario");
        try {
            Map<Integer,Integer> produtos = new LinkedHashMap<>();
            parametros.forEach((chave, valor) -> {
                if (chave.startsWith("produto_")) {
                    int produtoId = Integer.parseInt(chave.substring("produto_".length()));
                    int quantidade = Integer.parseInt(valor);
                    if (quantidade > 0) produtos.put(produtoId, quantidade);
                }
            });
            vendas.venderProdutos(produtos, clienteId, usuario.id(), pagamento);
            flash.addFlashAttribute("sucesso", "Venda de produtos registrada.");
        } catch (Exception e) {
            flash.addFlashAttribute("erro", mensagem(e));
        }
        return "redirect:/funcionario/vendas-produtos";
    }

    @GetMapping("/vendas-ingressos")
    public String formularioIngressos(@RequestParam(required=false) Integer sessaoId, Model model, HttpSession session) {
        model.addAttribute("usuario", session.getAttribute("usuario"));
        model.addAttribute("filmesProgramacao", agruparProgramacao(consultas.filmesComSessoes()));
        model.addAttribute("sessaoSelecionada", sessaoId);
        model.addAttribute("detalhesSessao", sessaoId == null ? null : consultas.detalhesSessao(sessaoId));
        model.addAttribute("produtosDisponiveis", jdbc.queryForList("SELECT id_produto AS id,nome,categoria,preco_unitario_atual AS preco,estoque_atual AS estoque FROM produto ORDER BY categoria,nome"));
        List<Map<String,Object>> assentos = new ArrayList<>();
        Map<String,List<Map<String,Object>>> fileiras = new LinkedHashMap<>();
        if (sessaoId != null) {
            assentos = jdbc.queryForList("""
                    SELECT a.id_assento AS id, a.fileira, a.numero, a.tipo,
                           CASE WHEN EXISTS (
                               SELECT 1 FROM ingresso i
                               WHERE i.id_sessao=s.id_sessao AND i.id_assento=a.id_assento
                                 AND COALESCE((SELECT h.status FROM ingresso_status_historico h
                                               WHERE h.id_ingresso=i.id_ingresso
                                               ORDER BY h.data_hora DESC,h.id_status_hist DESC LIMIT 1), 'Reservado') <> 'Cancelado'
                           ) THEN TRUE ELSE FALSE END AS ocupado
                    FROM sessao s JOIN assento a ON a.id_sala=s.id_sala
                    WHERE s.id_sessao=? ORDER BY a.fileira,a.numero
                    """, sessaoId);
            for (Map<String,Object> assento : assentos) {
                Object ocupado = assento.get("ocupado");
                assento.put("ocupado", ocupado instanceof Boolean valor
                        ? valor
                        : ocupado instanceof Number numero && numero.intValue() != 0);
                fileiras.computeIfAbsent(String.valueOf(assento.get("fileira")), chave -> new ArrayList<>()).add(assento);
            }
        }
        model.addAttribute("assentos", assentos);
        model.addAttribute("fileiras", fileiras.entrySet());
        model.addAttribute("clientes", jdbc.queryForList("SELECT id_cliente AS id,nome FROM cliente ORDER BY nome"));
        model.addAttribute("documentos", jdbc.queryForList("SELECT d.id_documento AS id,CONCAT(d.id_documento,' — Cliente ',d.id_cliente,' — ',d.tipo_documento) AS rotulo FROM documento_meia_entrada d JOIN cliente c ON c.id_cliente=d.id_cliente WHERE (d.validade IS NULL OR d.validade>=CURDATE()) AND (d.tipo_documento<>'Idoso' OR c.data_nascimento<=DATE_SUB(CURDATE(),INTERVAL 60 YEAR)) ORDER BY d.id_cliente,d.tipo_documento"));
        return "venda-ingressos";
    }

    @PostMapping("/vendas-ingressos")
    public String venderIngresso(@RequestParam int sessaoId, @RequestParam(name="assentoIds") List<Integer> assentoIds,
            @RequestParam int clienteId, @RequestParam(required=false) Integer documentoId,
            @RequestParam String tipo, @RequestParam String pagamento, @RequestParam Map<String,String> parametros,
            HttpSession session, RedirectAttributes flash) {
        UsuarioAutenticado usuario = (UsuarioAutenticado) session.getAttribute("usuario");
        try {
            Map<Integer,Integer> produtos = new LinkedHashMap<>();
            parametros.forEach((chave, valor) -> {
                if (chave.startsWith("produto_")) {
                    int produtoId = Integer.parseInt(chave.substring("produto_".length()));
                    int quantidade = Integer.parseInt(valor);
                    if (quantidade > 0) produtos.put(produtoId, quantidade);
                }
            });
            vendas.venderIngressos(sessaoId, assentoIds, clienteId, documentoId, tipo, usuario.id(), pagamento, produtos);
            flash.addFlashAttribute("sucesso", "Pedido finalizado com sucesso.");
        } catch (Exception e) {
            flash.addFlashAttribute("erro", mensagem(e));
        }
        return "redirect:/funcionario/vendas-ingressos?sessaoId=" + sessaoId;
    }

    @GetMapping("/consultas")
    public String consultas(@RequestParam(defaultValue="sessoes") String tipo,
            @RequestParam(required=false) String inicio, @RequestParam(required=false) String fim,
            @RequestParam(defaultValue="") String filme, @RequestParam(defaultValue="Todas") String categoria,
            @RequestParam(defaultValue="") String ordem, @RequestParam(defaultValue="") String direcao,
            Model model, HttpSession session) {
        LocalDate hoje = LocalDate.now();
        if (inicio == null || inicio.isBlank()) inicio = hoje.withDayOfMonth(1).toString();
        if (fim == null || fim.isBlank()) fim = hoje.withDayOfMonth(hoje.lengthOfMonth()).toString();
        String erroConsulta = null;
        try {
            LocalDate dataInicio = LocalDate.parse(inicio);
            LocalDate dataFim = LocalDate.parse(fim);
            if (dataInicio.isAfter(dataFim)) throw new DateTimeParseException("Período inválido", inicio, 0);
        } catch (DateTimeParseException ex) {
            inicio = hoje.withDayOfMonth(1).toString();
            fim = hoje.withDayOfMonth(hoje.lengthOfMonth()).toString();
            erroConsulta = "Informe um período válido, com a data inicial anterior à final.";
        }
        if (!List.of("sessoes", "produtos", "relatorio", "geral").contains(tipo)) {
            tipo = "sessoes";
            erroConsulta = "O tipo de consulta informado é inválido.";
        }
        if (!filme.isBlank()) {
            try {
                Integer.parseInt(filme);
            } catch (NumberFormatException ex) {
                filme = "";
                erroConsulta = "O filtro de filme informado é inválido.";
            }
        }
        if (!List.of("Todas", "Pipoca", "Bebida", "Doce", "Combo", "Outro").contains(categoria)) {
            categoria = "Todas";
            erroConsulta = "A categoria informada é inválida.";
        }
        List<String> colunasOrdenaveis = switch (tipo) {
            case "produtos" -> List.of("id", "nome", "categoria", "unidades", "faturamento");
            case "relatorio" -> List.of("id", "data", "horario", "filme", "capacidade", "ingressos", "ocupacao_percentual", "receita");
            case "sessoes" -> List.of("id", "data", "horario", "filme", "ingressos", "receita");
            default -> List.of();
        };
        String ordemPadrao = tipo.equals("produtos") ? "faturamento" : "data";
        if (!colunasOrdenaveis.contains(ordem)) ordem = ordemPadrao;
        direcao = direcao.toLowerCase();
        if (!List.of("asc", "desc").contains(direcao)) direcao = tipo.equals("produtos") ? "desc" : "asc";
        model.addAttribute("usuario", session.getAttribute("usuario"));
        model.addAttribute("tipo", tipo);
        model.addAttribute("inicio", inicio);
        model.addAttribute("fim", fim);
        model.addAttribute("filmeSelecionado", filme);
        model.addAttribute("categoriaSelecionada", categoria);
        model.addAttribute("ordem", ordem);
        model.addAttribute("direcao", direcao);
        model.addAttribute("erroConsulta", erroConsulta);
        model.addAttribute("filmes", consultas.filmes());
        model.addAttribute("categorias", List.of("Todas", "Pipoca", "Bebida", "Doce", "Combo", "Outro"));
        List<Map<String,Object>> linhas;
        List<String> colunas;
        List<Map<String,Object>> grafico = List.of();
        if (erroConsulta != null) {
            linhas = List.of();
            colunas = tipo.equals("produtos")
                    ? List.of("id", "nome", "categoria", "unidades", "faturamento")
                    : tipo.equals("sessoes")
                    ? List.of("id", "data", "horario", "filme", "ingressos", "receita")
                    : tipo.equals("relatorio")
                    ? List.of("id", "data", "horario", "filme", "capacidade", "ingressos", "ocupacao_percentual", "receita")
                    : List.of();
        } else if (tipo.equals("geral")) {
            linhas = List.of();
            colunas = List.of();
            grafico = prepararGrafico(consultas.graficoVendasGerais(inicio, fim));
        } else if (tipo.equals("produtos")) {
            linhas = consultas.produtos(inicio, fim, categoria, ordem, direcao);
            colunas = List.of("id", "nome", "categoria", "unidades", "faturamento");
        } else if (tipo.equals("relatorio")) {
            linhas = consultas.relatorio(ordem, direcao);
            colunas = List.of("id", "data", "horario", "filme", "capacidade", "ingressos", "ocupacao_percentual", "receita");
        } else {
            linhas = consultas.sessoes(inicio, fim, filme, ordem, direcao);
            colunas = List.of("id", "data", "horario", "filme", "ingressos", "receita");
            tipo = "sessoes";
        }
        model.addAttribute("tipo", tipo);
        model.addAttribute("linhas", linhas);
        model.addAttribute("colunas", colunas);
        model.addAttribute("grafico", grafico);
        return "consultas";
    }

    private static List<Map<String,Object>> prepararGrafico(List<Map<String,Object>> resultados) {
        double maiorFaturamento = resultados.stream()
                .mapToDouble(linha -> ((Number) linha.get("faturamento")).doubleValue())
                .max().orElse(0);
        List<Map<String,Object>> itens = new ArrayList<>();
        for (Map<String,Object> linha : resultados) {
            Map<String,Object> item = new LinkedHashMap<>();
            item.put("tipo", linha.get("tipo"));
            item.put("nome", linha.get("nome"));
            item.put("unidades", linha.get("unidades"));
            item.put("faturamento", linha.get("faturamento"));
            double faturamento = ((Number) linha.get("faturamento")).doubleValue();
            item.put("percentual", maiorFaturamento == 0 ? 0 : Math.max(4, Math.round(faturamento * 100.0 / maiorFaturamento)));
            itens.add(item);
        }
        return itens;
    }

    private static List<Map<String,Object>> agruparProgramacao(List<Map<String,Object>> linhas) {
        Map<Object,Map<String,Object>> filmes = new LinkedHashMap<>();
        for (Map<String,Object> linha : linhas) {
            Object id = linha.get("id");
            Map<String,Object> filme = filmes.computeIfAbsent(id, chave -> {
                Map<String,Object> novo = new LinkedHashMap<>();
                novo.put("id", id);
                novo.put("titulo", linha.get("titulo"));
                novo.put("sinopse", linha.get("sinopse"));
                novo.put("genero", linha.get("genero"));
                novo.put("classificacao", linha.get("classificacao"));
                novo.put("sessoes", new ArrayList<Map<String,Object>>());
                return novo;
            });
            if (linha.get("sessao_id") != null) {
                Map<String,Object> sessao = new LinkedHashMap<>();
                sessao.put("id", linha.get("sessao_id"));
                sessao.put("data", linha.get("data"));
                sessao.put("horario", linha.get("horario"));
                sessao.put("idioma", linha.get("idioma"));
                sessao.put("tipo", linha.get("tipo"));
                sessao.put("sala", linha.get("sala"));
                sessao.put("preco", linha.get("preco"));
                @SuppressWarnings("unchecked")
                List<Map<String,Object>> sessoes = (List<Map<String,Object>>) filme.get("sessoes");
                sessoes.add(sessao);
            }
        }
        return new ArrayList<>(filmes.values());
    }

    private static String mensagem(Exception e) {
        Throwable cause = e;
        while (cause.getCause() != null) cause = cause.getCause();
        String text = cause.getMessage() == null ? e.getMessage() : cause.getMessage();
        if (text == null) return "Não foi possível concluir a operação.";
        if (text.contains("Duplicate entry")) return "Esse assento já foi vendido ou algum campo único já está cadastrado.";
        if (text.contains("foreign key")) return "Não foi possível concluir: há um vínculo inválido.";
        return text;
    }
}


