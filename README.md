# Sistema de Gestão para Rede de Cinemas

Aplicação web acadêmica para administrar filmes, sessões, salas, clientes, funcionários, vendas de ingressos e produtos de bomboniere. O sistema usa Java, Spring Boot, Thymeleaf, JDBC e MySQL.

## Requisitos

- Java 26 (conforme configurado no `pom.xml`)
- Maven instalado e disponível no terminal (`mvn`)
- MySQL 8.x em execução
- Git, caso o projeto seja obtido por clone

## Preparar o banco de dados

No MySQL Workbench, conecte-se com uma conta administrativa, abra cada arquivo SQL com **File > Open SQL Script** e execute-o pelo botão do raio. Para uma instalação nova, execute os scripts nesta ordem:

1. `sql/01_ddl.sql` — cria o banco `cinema` e suas tabelas.
2. `sql/02_carga.sql` — insere dados fictícios para demonstração.
3. `sql/03_consultas.sql` — opcional; executa consultas de conferência.

> **Atenção:** `sql/01_ddl.sql` começa com `DROP DATABASE IF EXISTS cinema`. Isso apaga por completo um banco `cinema` existente. Use-o somente em uma instalação nova ou em um ambiente descartável, depois de confirmar que não há dados a preservar.

Se você já tem um banco criado pela versão anterior, mantenha os dados e execute uma única vez `sql/04_remover_campos_estreia_e_capa.sql` para remover as colunas antigas de estreia e URL de capa. Não execute essa migração numa instalação nova: o `01_ddl.sql` já cria a tabela sem esses campos.

Depois de criar e carregar o banco, crie uma conta local para a aplicação. Execute no Workbench como administrador:

```sql
CREATE USER IF NOT EXISTS 'cinema_app'@'localhost'
    IDENTIFIED BY 'CinemaApresentacao#26';
ALTER USER 'cinema_app'@'localhost'
    IDENTIFIED BY 'CinemaApresentacao#26';
GRANT SELECT, INSERT, UPDATE, DELETE ON cinema.*
    TO 'cinema_app'@'localhost';
```

### Configurar o acesso da aplicação

A aplicação lê a configuração do banco pelas variáveis abaixo. Crie um arquivo `.env` na raiz do projeto (ele é ignorado pelo Git) ou defina as variáveis no ambiente:

```properties
CINEMA_DB_URL=jdbc:mysql://localhost:3306/cinema?serverTimezone=America/Sao_Paulo&useSSL=false&allowPublicKeyRetrieval=true
CINEMA_DB_USER=cinema_app
CINEMA_DB_PASSWORD=CinemaApresentacao#26
```

O usuário do banco precisa conseguir conectar e executar `SELECT`, `INSERT`, `UPDATE` e `DELETE` nas tabelas de `cinema`. A senha acima é padronizada para desenvolvimento e apresentação local; não a reutilize em produção ou em outros serviços. O projeto não inclui um script versionado para criar esse usuário do MySQL.

Não compartilhe nem publique o `.env`. O arquivo já está listado no `.gitignore`.

## Executar a aplicação

Na raiz do projeto, com o MySQL ativo e a configuração do banco preenchida:

```powershell
mvn spring-boot:run
```

Quando a inicialização terminar, acesse [http://localhost:8080](http://localhost:8080). Para interromper a aplicação, pressione `Ctrl+C` no terminal.

Também é possível abrir a pasta no IntelliJ IDEA, aguardar a importação do Maven e executar a classe `br.edu.cinema.app.CinemaApplication`.

## Acesso de demonstração

Os funcionários fictícios inseridos por `sql/02_carga.sql` usam a senha `CinemaFuncionario#26` e hashes PBKDF2 compatíveis com a aplicação. Logins disponíveis: `carla.alves` (gerente), `mariana.costa` e `bruno.lima` (atendentes), `diego.souza` e `eduardo.rocha` (projecionistas). Essas credenciais são somente para demonstração local; troque-as antes de qualquer uso fora desse contexto.

Se o banco já foi carregado por uma versão anterior de `sql/02_carga.sql`, execute uma vez `sql/05_atualizar_senhas_demo.sql` no Workbench para substituir os hashes fictícios dos funcionários de demonstração. Não coloque senhas em texto puro diretamente no banco.

## Arquivos SQL disponíveis

- `sql/01_ddl.sql` — criação do esquema e objetos do banco.
- `sql/02_carga.sql` — dados fictícios de demonstração.
- `sql/03_consultas.sql` — consultas de conferência do projeto.
- `sql/04_remover_campos_estreia_e_capa.sql` — migração de bancos antigos descrita acima; não faz parte da carga inicial.
- `sql/05_atualizar_senhas_demo.sql` — atualiza as senhas dos funcionários fictícios em bancos já carregados com a versão anterior da carga.

## Observações

- O projeto usa o banco MySQL `cinema` e a aplicação escuta na porta `8080` por padrão.
- `sql/02_carga.sql` contém dados fictícios; não use informações pessoais reais em demonstrações ou commits.
- A seleção de sessões mantém a capa genérica do filme e exibe sinopse e horários cadastrados.

## Integrantes

- Arthur Moreira Alves da Silva
- Andrey Gabriel Lins Ferreira
- Paulo Fernando Santos Amorim dos Reis
- Alexandre Braga Rodrigues
- Ana Beatriz Caldeira Faulin
