-- Execute uma vez em bancos já populados com sql/02_carga.sql.
-- Define a senha de demonstração dos cinco funcionários fictícios.
-- Não use estas credenciais fora de uma instalação local de demonstração.
USE cinema;

UPDATE funcionario SET senha_hash = CASE login
    WHEN 'mariana.costa' THEN '$pbkdf2-sha256$210000$b3fkkCU-yE9Lp6VK92iI2g$yE5NpaHc_T7A0Fc7TIBPmqp3J5FmmOz5PB8Ss7l3wvU'
    WHEN 'bruno.lima' THEN '$pbkdf2-sha256$210000$DqJE5dJt83bsTGO__2uGWw$QpqcA6mUqPrLBEU-74YAS_4xQTQqYFRuzX28IsFAhdk'
    WHEN 'carla.alves' THEN '$pbkdf2-sha256$210000$hKgC8eWfhl2ayG28A7aKZQ$3PRcSrnqPsuLVVn4JvcCE2YV_vHiy_rDjowaHL8WKUs'
    WHEN 'diego.souza' THEN '$pbkdf2-sha256$210000$QDFYP_MiWJMzipDgR3pYsA$bDmuUqCzT9a__4dTdCM3bIIYibPwtau343qUiCbPFpU'
    WHEN 'eduardo.rocha' THEN '$pbkdf2-sha256$210000$PIwDW3-j8vtl2x4rzzxjpQ$BXfhuYt4itEAwqZXyLyYbnAUWg-fz-xFdv_mjPKjlXk'
    ELSE senha_hash
END
WHERE login IN ('mariana.costa', 'bruno.lima', 'carla.alves', 'diego.souza', 'eduardo.rocha');
