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
        model.addAttribute("produtos", jdbc.queryForList("SELECT id_produto AS id,nome,preco_unitario_atual AS preco,estoque_atual AS estoque FROM produto ORDER BY nome"));
        model.addAttribute("clientes", jdbc.queryForList("SELECT id_cliente AS id,nome FROM cliente ORDER BY nome"));
        return "venda-produtos";
    }

    @PostMapping("/vendas-produtos")
    public String venderProduto(@RequestParam int produtoId, @RequestParam int quantidade,
            @RequestParam(required=false) Integer clienteId, @RequestParam String pagamento,
            HttpSession session, RedirectAttributes flash) {
        UsuarioAutenticado usuario = (UsuarioAutenticado) session.getAttribute("usuario");
        try {
            vendas.venderProduto(produtoId, quantidade, clienteId, usuario.id(), pagamento);
            flash.addFlashAttribute("sucesso", "Venda de produto registrada.");
        } catch (Exception e) {
            flash.addFlashAttribute("erro", mensagem(e));
        }
        return "redirect:/funcionario/vendas-produtos";
    }

    @GetMapping("/vendas-ingressos")
    public String formularioIngressos(@RequestParam(required=false) Integer sessaoId, Model model, HttpSession session) {
        model.addAttribute("usuario", session.getAttribute("usuario"));
        model.addAttribute("sessoes", jdbc.queryForList("SELECT s.id_sessao AS id,CONCAT(f.titulo_original,' — ',s.data_sessao,' ',s.horario_inicio,' — Sala ',sa.numero) AS rotulo FROM sessao s JOIN filme f ON f.id_filme=s.id_filme JOIN sala sa ON sa.id_sala=s.id_sala ORDER BY s.data_sessao,s.horario_inicio"));
        model.addAttribute("sessaoSelecionada", sessaoId);
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
        model.addAttribute("documentos", jdbc.queryForList("SELECT d.id_documento AS id,CONCAT(d.id_documento,' — Cliente ',d.id_cliente,' — ',d.tipo_documento) AS rotulo FROM documento_meia_entrada d ORDER BY d.id_cliente,d.tipo_documento"));
        return "venda-ingressos";
    }

    @PostMapping("/vendas-ingressos")
    public String venderIngresso(@RequestParam int sessaoId, @RequestParam int assentoId,
            @RequestParam int clienteId, @RequestParam(required=false) Integer documentoId,
            @RequestParam String tipo, @RequestParam String pagamento, HttpSession session, RedirectAttributes flash) {
        UsuarioAutenticado usuario = (UsuarioAutenticado) session.getAttribute("usuario");
        try {
            vendas.venderIngresso(sessaoId, assentoId, clienteId, documentoId, tipo, usuario.id(), pagamento);
            flash.addFlashAttribute("sucesso", "Ingresso vendido com sucesso.");
        } catch (Exception e) {
            flash.addFlashAttribute("erro", mensagem(e));
        }
        return "redirect:/funcionario/vendas-ingressos?sessaoId=" + sessaoId;
    }

    @GetMapping("/consultas")
    public String consultas(@RequestParam(defaultValue="sessoes") String tipo,
            @RequestParam(required=false) String inicio, @RequestParam(required=false) String fim,
            @RequestParam(defaultValue="") String filme, @RequestParam(defaultValue="Todas") String categoria,
            Model model, HttpSession session) {
        LocalDate hoje = LocalDate.now();
        if (inicio == null || inicio.isBlank()) inicio = hoje.withDayOfMonth(1).toString();
        if (fim == null || fim.isBlank()) fim = hoje.withDayOfMonth(hoje.lengthOfMonth()).toString();
        model.addAttribute("usuario", session.getAttribute("usuario"));
        model.addAttribute("tipo", tipo);
        model.addAttribute("inicio", inicio);
        model.addAttribute("fim", fim);
        model.addAttribute("filmeSelecionado", filme);
        model.addAttribute("categoriaSelecionada", categoria);
        model.addAttribute("filmes", consultas.filmes());
        model.addAttribute("categorias", List.of("Todas", "Pipoca", "Bebida", "Doce", "Combo", "Outro"));
        List<Map<String,Object>> linhas;
        List<String> colunas;
        if (tipo.equals("produtos")) {
            linhas = consultas.produtos(inicio, fim, categoria);
            colunas = List.of("id", "nome", "categoria", "unidades", "faturamento");
        } else if (tipo.equals("relatorio")) {
            linhas = consultas.relatorio();
            colunas = linhas.isEmpty() ? List.of() : List.copyOf(linhas.getFirst().keySet());
        } else {
            linhas = consultas.sessoes(inicio, fim, filme);
            colunas = List.of("id", "data", "horario", "filme", "ingressos", "receita");
            tipo = "sessoes";
        }
        model.addAttribute("tipo", tipo);
        model.addAttribute("linhas", linhas);
        model.addAttribute("colunas", colunas);
        return "consultas";
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


