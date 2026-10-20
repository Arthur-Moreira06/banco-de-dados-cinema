package br.edu.cinema.controller;

import br.edu.cinema.catalogo.CadastroDefinicao;
import br.edu.cinema.catalogo.CatalogoCadastros;
import br.edu.cinema.catalogo.ColunaTabela;
import br.edu.cinema.catalogo.CampoFormulario;
import br.edu.cinema.model.UsuarioAutenticado;
import br.edu.cinema.repository.CadastroRepository;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/gerente/cadastros")
public class CadastrosController {
    private final CatalogoCadastros catalogo;
    private final CadastroRepository repository;

    public CadastrosController(CatalogoCadastros catalogo, CadastroRepository repository) {
        this.catalogo = catalogo;
        this.repository = repository;
    }

    @GetMapping
    public String inicio() { return "redirect:/gerente"; }

    @GetMapping("/{tipo}")
    public String listar(@PathVariable String tipo, Model model, HttpSession session) {
        CadastroDefinicao d = catalogo.obter(tipo);
        model.addAttribute("usuario", session.getAttribute("usuario"));
        model.addAttribute("cadastro", d);
        model.addAttribute("linhas", repository.listar(d));
        model.addAttribute("colunas", colunas(tipo));
        return "cadastro-lista";
    }

    @GetMapping("/{tipo}/novo")
    public String novo(@PathVariable String tipo, Model model, HttpSession session) {
        CadastroDefinicao d = catalogo.obter(tipo);
        model.addAttribute("usuario", session.getAttribute("usuario"));
        model.addAttribute("cadastro", d);
        model.addAttribute("valores", vazios(d));
        model.addAttribute("erro", null);
        return "cadastro-formulario";
    }

    @GetMapping("/{tipo}/{id}/editar")
    public String editar(@PathVariable String tipo, @PathVariable int id, Model model, HttpSession session) {
        CadastroDefinicao d = catalogo.obter(tipo);
        model.addAttribute("usuario", session.getAttribute("usuario"));
        model.addAttribute("cadastro", d);
        model.addAttribute("id", id);
        model.addAttribute("valores", repository.valoresFormulario(d, id));
        model.addAttribute("erro", null);
        return "cadastro-formulario";
    }

    @PostMapping("/{tipo}/salvar")
    public String salvar(@PathVariable String tipo, @RequestParam(required = false) Integer id,
                         @RequestParam Map<String, String> valores, RedirectAttributes flash) {
        CadastroDefinicao d = catalogo.obter(tipo);
        try {
            repository.salvar(d, id, valores);
            flash.addFlashAttribute("sucesso", id == null ? "Cadastro realizado." : "Alterações salvas.");
        } catch (Exception ex) {
            flash.addFlashAttribute("erro", mensagem(ex));
            return id == null ? "redirect:/gerente/cadastros/" + tipo + "/novo"
                    : "redirect:/gerente/cadastros/" + tipo + "/" + id + "/editar";
        }
        return "redirect:/gerente/cadastros/" + tipo;
    }

    @PostMapping("/{tipo}/{id}/excluir")
    public String excluir(@PathVariable String tipo, @PathVariable int id, HttpSession session, RedirectAttributes flash) {
        CadastroDefinicao d = catalogo.obter(tipo);
        UsuarioAutenticado usuario = (UsuarioAutenticado) session.getAttribute("usuario");
        if (tipo.equals("funcionarios") && usuario != null && usuario.id() == id) {
            flash.addFlashAttribute("erro", "Não é possível excluir o próprio usuário enquanto estiver conectado.");
            return "redirect:/gerente/cadastros/funcionarios";
        }
        try {
            repository.excluir(d, id);
            flash.addFlashAttribute("sucesso", "Registro excluído.");
        } catch (Exception ex) {
            flash.addFlashAttribute("erro", mensagem(ex));
        }
        return "redirect:/gerente/cadastros/" + tipo;
    }

    private static Map<String, String> vazios(CadastroDefinicao d) {
        Map<String, String> values = new LinkedHashMap<>();
        d.campos().forEach(c -> values.put(c.nome(), ""));
        return values;
    }

    private static List<ColunaTabela> colunas(String tipo) {
        return switch (tipo) {
            case "clientes" -> List.of(new ColunaTabela("id", "ID"), new ColunaTabela("nome", "Nome"), new ColunaTabela("cpf", "CPF"), new ColunaTabela("telefone", "Telefone"), new ColunaTabela("email", "E-mail"), new ColunaTabela("data_nascimento", "Nascimento"));
            case "funcionarios" -> List.of(new ColunaTabela("id", "ID"), new ColunaTabela("nome", "Nome"), new ColunaTabela("cpf", "CPF"), new ColunaTabela("cargo", "Cargo"), new ColunaTabela("login", "Login"), new ColunaTabela("perfil_acesso", "Perfil"), new ColunaTabela("ativo", "Ativo"));
            case "filmes" -> List.of(new ColunaTabela("id", "ID"), new ColunaTabela("titulo", "Título"), new ColunaTabela("data_estreia", "Estreia"), new ColunaTabela("duracao", "Duração (min)"), new ColunaTabela("genero", "Gênero"), new ColunaTabela("classificacao", "Classificação"));
            case "salas" -> List.of(new ColunaTabela("id", "ID"), new ColunaTabela("numero", "Sala"), new ColunaTabela("capacidade", "Capacidade"), new ColunaTabela("tipo_projecao", "Projeção"));
            case "produtos" -> List.of(new ColunaTabela("id", "ID"), new ColunaTabela("nome", "Nome"), new ColunaTabela("categoria", "Categoria"), new ColunaTabela("preco", "Preço"), new ColunaTabela("estoque", "Estoque"), new ColunaTabela("minimo", "Mínimo"));
            case "sessoes" -> List.of(new ColunaTabela("id", "ID"), new ColunaTabela("filme", "Filme"), new ColunaTabela("sala", "Sala"), new ColunaTabela("data", "Data"), new ColunaTabela("inicio", "Horário"), new ColunaTabela("idioma", "Idioma"), new ColunaTabela("tipo", "Projeção"), new ColunaTabela("preco", "Preço"));
            default -> List.of();
        };
    }

    private static String mensagem(Exception ex) {
        Throwable causa = ex;
        while (causa.getCause() != null) causa = causa.getCause();
        String m = causa.getMessage() == null ? ex.getMessage() : causa.getMessage();
        if (m == null) return "Não foi possível concluir. Verifique os dados e os vínculos existentes.";
        if (m.contains("Duplicate entry")) return "Já existe um registro com um dos dados informados (por exemplo, CPF, e-mail ou número da sala).";
        if (m.contains("foreign key constraint")) return "Este registro possui vínculos e não pode ser removido ou alterado desta forma.";
        if (m.contains("Data truncation") || m.contains("Check constraint")) return "Algum valor está fora das regras aceitas pelo banco.";
        return m;
    }
}

