-- Execute uma vez apenas em bancos existentes que ainda tenham estes campos.
USE cinema;

ALTER TABLE filme
    DROP COLUMN data_estreia,
    DROP COLUMN url_capa;
