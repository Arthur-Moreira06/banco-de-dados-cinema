# Sistema de Gestão para Rede de Cinemas

Aplicação web acadêmica para administrar filmes, sessões, salas, clientes, funcionários, vendas de ingressos e produtos de bomboniere. O sistema usa Java, Spring Boot, Thymeleaf, JDBC e MySQL.

## Requisitos

- Java 26 (conforme configurado no `pom.xml`)
- Maven disponível no terminal (`mvn`)
- MySQL 8.0 ou superior
- Git, caso o projeto seja obtido por clone

## Instalação em uma base nova

No MySQL Workbench, conecte-se com uma conta administrativa. Abra cada arquivo com **File > Open SQL Script** e execute pelo raio, nesta ordem:

1. `sql/01_ddl.sql` cria o banco e as tabelas.
2. `sql/02_carga.sql` insere casos de demonstração e o lote sintético de volume.
3. `sql/03_consultas.sql` executa as quinze consultas de verificação.

> **Atenção:** `01_ddl.sql` começa com `DROP DATABASE IF EXISTS cinema`. Ele apaga o banco `cinema` e todos os dados nele. Use somente para instalação nova ou ambiente descartável, depois de confirmar que não há dados a preservar.

Depois da carga, as principais dimensões têm pelo menos 40 registros; o lote inclui 100 compras, 100 ingressos e mais de 200 eventos de status. Os dados adicionais são fictícios e gerados para demonstração de consultas. O lote de demonstração não representa volume de produção.

## Bancos existentes

O DDL recria o banco inteiro. Em uma base com dados que precisam ser mantidos, faça backup antes e não execute `sql/01_ddl.sql` sem planejar migração. Os scripts `04` e `05` citados em versões antigas do README não fazem parte desta entrega.

## Usuário e credenciais da aplicação

No Workbench, como administrador, crie/configure a conta local da aplicação:

```sql
CREATE USER IF NOT EXISTS 'cinema_app'@'localhost'
    IDENTIFIED BY 'CinemaApresentacao#26';
ALTER USER 'cinema_app'@'localhost'
    IDENTIFIED BY 'CinemaApresentacao#26';
GRANT SELECT, INSERT, UPDATE, DELETE ON cinema.*
    TO 'cinema_app'@'localhost';
```

Crie um arquivo `.env` na raiz ou defina estas variáveis no ambiente:

```properties
CINEMA_DB_URL=jdbc:mysql://localhost:3306/cinema?serverTimezone=America/Sao_Paulo&useSSL=false&allowPublicKeyRetrieval=true
CINEMA_DB_USER=cinema_app
CINEMA_DB_PASSWORD=CinemaApresentacao#26
```

O `.env` está no `.gitignore`. Não o publique nem o envie ao repositório. A senha fixa é apenas para a apresentação local do projeto; não a reutilize em produção.

## Iniciar

Com MySQL ativo, banco carregado e variáveis definidas, execute na pasta raiz:

```powershell
mvn spring-boot:run
```

Abra [http://localhost:8080](http://localhost:8080). Para parar, pressione `Ctrl+C`. No IntelliJ, importe a pasta pelo `pom.xml`, aguarde a carga do Maven e execute `br.edu.cinema.app.CinemaApplication`.

## Usuários de demonstração

Os registros da carga base usam a senha `CinemaFuncionario#26`. Logins: `carla.alves` (gerente), `mariana.costa` e `bruno.lima` (atendentes), `diego.souza` e `eduardo.rocha` (projecionistas). Os logins sintéticos `volume.demoNNN` servem para carga e ficam inativos; não são contas de apresentação.

## Documentação revisada

- `docs/MER cinema.pdf` e `docs/modelo logico relacional cinema.pdf`: diagramas originais da Etapa 1, mantidos sem substituição.
- `docs/Dicionario_MER_Atualizado.pdf`: dicionário MER independente revisado, com a capa e a tabela de 20 RNs alinhadas.
- `docs/RelatorioGeral_Etapa1_Atualizado.pdf`: relatório atualizado. Ele distingue os diagramas originais da implementação física descrita no DDL vigente.
- `docs/RelatorioGeral.pdf`: relatório original, preservado.

Os diagramas originais representam a modelagem entregue na Etapa 1 e não foram redesenhados nesta revisão.

## Integrantes — Grupo 3

- Arthur Moreira Alves da Silva
- Andrey Gabriel Lins Ferreira
- Paulo Fernando Santos Amorim dos Reis
- Alexandre Braga Rodrigues
- Ana Beatriz Caldeira Faulin

