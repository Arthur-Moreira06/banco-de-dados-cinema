-- Conta técnica local para a aplicação Java.
-- Execute uma vez no MySQL Workbench depois de 03_etapa2.sql, usando uma conta DBA.
-- Esta senha é somente para a demonstração local da disciplina.

CREATE USER IF NOT EXISTS 'cinema_app'@'localhost'
    IDENTIFIED BY 'CinemaApresentacao#26';

-- Alinha a senha ao arquivo .env, inclusive se a conta já existia.
ALTER USER 'cinema_app'@'localhost'
    IDENTIFIED BY 'CinemaApresentacao#26';

GRANT 'cinema_operacional', 'cinema_gerencia'
    TO 'cinema_app'@'localhost';

-- O programa precisa consultar o funcionário antes de escolher o papel de gerente.
SET DEFAULT ROLE 'cinema_operacional'
    TO 'cinema_app'@'localhost';

FLUSH PRIVILEGES;
