--Criar a Função para Inserir Registro
CREATE OR REPLACE FUNCTION agenda.inserir_excecao(
    p_prestador_id INTEGER,
    p_data_bloqueio DATE,
    p_hora_inicio TIME,
    p_hora_fim TIME,
    p_assunto TEXT
) 
RETURNS VOID AS $$
BEGIN
    INSERT INTO agenda.excecoes (prestador_id, data_bloqueio, hora_inicio, hora_fim, assunto)
    VALUES (p_prestador_id, p_data_bloqueio, p_hora_inicio, p_hora_fim, p_assunto);
END;
$$ LANGUAGE plpgsql;


--Criar a Função para Remover Registro

CREATE OR REPLACE FUNCTION agenda.deletar_excecao(
    p_id INTEGER
) 
RETURNS VOID AS $$
BEGIN
    DELETE FROM agenda.excecoes
    WHERE id = p_id;
END;
$$ LANGUAGE plpgsql;

--Criar a Função para Consultar Registros
CREATE OR REPLACE FUNCTION agenda.listar_excecoes_prestador(
    p_prestador_id INTEGER,
    p_data_inicio DATE,
    p_data_fim DATE
) 
RETURNS TABLE (
    id INTEGER,
    prestador_id INTEGER,
    data_bloqueio DATE,
    hora_inicio TIME,
    hora_fim TIME,
    assunto TEXT,
    criado_em TIMESTAMP,
    atualizado_em TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        e.id,
        e.prestador_id,
        e.data_bloqueio,
        e.hora_inicio,
        e.hora_fim,
        e.assunto,
        e.criado_em,
        e.atualizado_em
    FROM 
        agenda.excecoes e
    WHERE 
        e.prestador_id = p_prestador_id
        AND e.data_bloqueio BETWEEN p_data_inicio AND p_data_fim;
END;
$$ LANGUAGE plpgsql;

--Testar as Funções

--Inserir um Usuário (Se Necessário):
INSERT INTO agenda.usuarios (nome, email, senha, telefone, ativo, tipo_usuario, cidade_id)
VALUES ('Nome do Usuário', 'usuario@example.com', 'senha123', '123456789', TRUE, 'prestador', NULL);

--Inserir um Novo Prestador(Se Necessário):
INSERT INTO agenda.prestadores (usuario_id, cpf_cnpj, atividade, listado, ativo)
VALUES (1, '12345678901', 'Exemplo de Atividade', TRUE, TRUE);

--SQL para testar a inserção:

SELECT agenda.inserir_excecao(2, '2024-11-01', '09:00:00', '17:00:00', 'Férias');

--SQL para testar a remoção
SELECT agenda.remover_excecao(2);

--SQL para testar a consulta:

SELECT * FROM agenda.consultar_excecoes(2, '2024-11-01', '2024-11-30');

--Verificar Resultados
SELECT * FROM agenda.excecoes;

