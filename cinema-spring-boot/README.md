# Cinema Web — migração para Spring Boot

Aplicação web acadêmica para o banco Cinema. O projeto usa Java 26, Spring Boot 4.1.1, Spring MVC, Thymeleaf, Spring JDBC e MySQL, seguindo a separação de camadas do projeto de referência da clínica.

## Abrir no IntelliJ IDEA

1. Extraia a pasta `cinema-spring-boot`.
2. Abra essa pasta no IntelliJ e aceite a importação do Maven.
3. Selecione JDK 26 para o Project SDK e para o Maven importer.
4. Configure as variáveis de ambiente usando `.env` como referência. A senha fica apenas na configuração local; não versione `.env`.
5. Execute `sql/01_ddl.sql`, `sql/02_carga.sql`, `sql/03_etapa2.sql` e `sql/05_usuario_aplicacao_local.sql` no MySQL, nessa ordem, em uma base de demonstração. O DDL remove a base `cinema` existente; preserve os dados e faça backup antes de executar o DDL.
6. Inicie `CinemaApplication` e abra `http://localhost:8080`.

As telas serão migradas por etapas sem alterar os scripts oficiais do banco. O diretório `sql` contém cópias dos scripts existentes; `01_ddl.sql` permanece intacto.

## Organização

```text
src/main/java/br/edu/cinema/
├── app/          inicialização Spring Boot
├── config/       configuração web e conexão
├── controller/   rotas e páginas
├── dto/          dados e validações de formulários
├── model/        entidades e usuário da sessão
├── repository/   consultas SQL parametrizadas via Spring JDBC
├── security/     controle de sessão e permissões
└── service/      login e regras de negócio
src/main/resources/
├── templates/    páginas Thymeleaf
└── static/       CSS e recursos visuais
sql/              scripts SQL originais do Cinema
```

## Banco e autenticação

O login da aplicação usa `funcionario.login` e a senha armazenada em `funcionario.senha_hash`. A conta técnica MySQL é apenas a conexão interna da aplicação; ela não é o login visível para funcionários. O sistema controla as telas de gerente e funcionário pelo cargo/perfil do funcionário autenticado.

A conta técnica de demonstração permite as operações declaradas em `03_etapa2.sql`. As rotas administrativas também precisam ser protegidas pela sessão da aplicação. Não compartilhe senhas reais no repositório.
