-- Execute uma vez em bancos já existentes para habilitar capa e data de estreia.
USE cinema;

ALTER TABLE filme
    ADD COLUMN data_estreia DATE NULL AFTER sinopse,
    ADD COLUMN url_capa VARCHAR(500) NULL AFTER data_estreia;
