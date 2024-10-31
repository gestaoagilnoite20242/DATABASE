--Para retornar todos os dados da cidade dado um ID
CREATE OR REPLACE FUNCTION agenda.listar_cidade_id(cidade_id_input INT)
RETURNS TABLE(id INT, nome VARCHAR, estado_nome VARCHAR, estado_sigla CHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT c.id, c.nome, e.nome AS estado_nome, e.sigla AS estado_sigla
    FROM agenda.cidades c
    JOIN agenda.estados e ON c.estado_id = e.id
    WHERE c.id = cidade_id_input;
END;
$$ LANGUAGE plpgsql;

--Para retornar todas as cidades de um estado dado o ID do estado
CREATE OR REPLACE FUNCTION agenda.listar_cidades_estado_id(estado_id_input INT)
RETURNS TABLE(id INT, nome VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT c.id, c.nome
    FROM agenda.cidades c
    WHERE c.estado_id = estado_id_input;  -- Prefixo p_ para a variável
END;
$$ LANGUAGE plpgsql;
--DROP FUNCTION get_cidades_by_estado(integer)

--Para retornar cidades cujo nome começa com uma determinada string
CREATE OR REPLACE FUNCTION agenda.listar_cidades_prefixo(nome_prefix VARCHAR)
RETURNS TABLE(id INT, nome VARCHAR, estado_nome VARCHAR, estado_sigla CHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT c.id, c.nome, e.nome AS estado_nome, e.sigla AS estado_sigla
    FROM agenda.cidades c
    JOIN agenda.estados e ON c.estado_id = e.id
    WHERE c.nome ILIKE nome_prefix || '%';
END;
$$ LANGUAGE plpgsql;

--Para inserir uma nova cidade
CREATE OR REPLACE FUNCTION agenda.inserir_cidade(nome VARCHAR, estado_id_input INT)
RETURNS VOID AS $$
BEGIN
    INSERT INTO agenda.cidades (nome, estado_id)
    VALUES (nome, estado_id_input);
END;
$$ LANGUAGE plpgsql;

--Para remover uma cidade pelo ID
CREATE OR REPLACE FUNCTION agenda.deletar_cidade(cidade_id_input INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM agenda.cidades
    WHERE id = cidade_id_input;
END;
$$ LANGUAGE plpgsql;

--Para atualizar os dados de uma cidade pelo ID
CREATE OR REPLACE FUNCTION agenda.alterar_cidade(cidade_id_input INT, novo_nome VARCHAR, novo_estado_id INT)
RETURNS VOID AS $$
BEGIN
    UPDATE agenda.cidades
    SET nome = novo_nome, estado_id = novo_estado_id
    WHERE id = cidade_id_input;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------
SELECT * FROM agenda.listar_cidade_id(2);

SELECT * FROM agenda.listar_cidades_estado_id(3);

select * from agenda.listar_cidades_prefixo('S')

SELECT agenda.inserir_cidade('Nova Cidade',3);

SELECT agenda.deletar_cidade(7);

SELECT agenda.alterar_cidade(7, 'Nova Cidade2', 1);
------------------------------------
select * from agenda.cidades;
------------------------------------
select * from agenda.cidades