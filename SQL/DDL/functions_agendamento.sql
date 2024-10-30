CREATE OR REPLACE FUNCTION agenda.inserir_agendamento(
    cliente_id INT,
    prestador_id INT,
    data_agendamento DATE,
    hora_inicio TIME,
    hora_fim TIME,
    assunto TEXT
)
RETURNS INT AS $$
DECLARE
    novo_agendamento_id INT;
BEGIN

    INSERT INTO agenda.agendamentos (cliente_id, prestador_id, data_agendamento, hora_inicio, hora_fim, assunto, criado_em, atualizado_em)
    VALUES (cliente_id, prestador_id, data_agendamento, hora_inicio, hora_fim, assunto, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)
    RETURNING id INTO novo_agendamento_id;

    -- Retorna o id do novo agendamento inserido
    RETURN novo_agendamento_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION agenda.listar_agendamentos_prestador(
    prestador_id_input INT,
    data_agendamento_input_de DATE DEFAULT NULL,
    data_agendamento_input_ate DATE DEFAULT NULL
)
RETURNS TABLE (
    id INT,
    cliente_id INT,
    prestador_id INT,
    data_agendamento DATE,
    hora_inicio TIME,
    hora_fim TIME,
    assunto TEXT,
    status VARCHAR,
    criado_em TIMESTAMP,
    atualizado_em TIMESTAMP
) AS $$
BEGIN
    -- Retorna todos os agendamentos de um prestador de serviço
    RETURN QUERY
    SELECT 
        age.id,
        age.cliente_id,
        age.prestador_id,
        age.data_agendamento,
        age.hora_inicio,
        age.hora_fim,
        age.assunto,
        age.status,
        age.criado_em,
        age.atualizado_em
    FROM 
        agenda.agendamentos age
    WHERE age.prestador_id = prestador_id_input
    -- Verificando se a data de agendamento está vazia, se não estiver vazia ele pega os intervalos das datas
    AND (data_agendamento_input_de IS NULL OR age.data_agendamento >= data_agendamento_input_de)
    AND (data_agendamento_input_ate IS NULL OR age.data_agendamento <= data_agendamento_input_ate);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION agenda.listar_agendamentos_cliente(
    cliente_id_input INT,
    data_agendamento_input_de DATE DEFAULT NULL,
    data_agendamento_input_ate DATE DEFAULT NULL
)
RETURNS TABLE (
    id INT,
    cliente_id INT,
    prestador_id INT,
    data_agendamento DATE,
    hora_inicio TIME,
    hora_fim TIME,
    assunto TEXT,
    status VARCHAR,
    criado_em TIMESTAMP,
    atualizado_em TIMESTAMP
) AS $$
BEGIN
    -- Retorna todos os agendamentos de um cliente
    RETURN QUERY
    SELECT 
        age.id,
        age.cliente_id,
        age.prestador_id,
        age.data_agendamento,
        age.hora_inicio,
        age.hora_fim,
        age.assunto,
        age.status,
        age.criado_em,
        age.atualizado_em
    FROM 
        agenda.agendamentos age
    WHERE age.cliente_id = cliente_id_input
    -- Verificando se a data de agendamento está vazia, se não estiver vazia ele pega os intervalos das datas
    AND (data_agendamento_input_de IS NULL OR age.data_agendamento >= data_agendamento_input_de)
    AND (data_agendamento_input_ate IS NULL OR age.data_agendamento <= data_agendamento_input_ate);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION agenda.deletar_agendamento(agendamento_id_input INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM agenda.agendamentos
    WHERE id = agendamento_id_input;

    -- Verifica se o prestador foi encontrado e atualizado
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Agendamento com ID % não encontrado', agendamento_id_input;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION agenda.listar_agendamento_id(
    agendamento_id_input INT
)
RETURNS TABLE (
    id INT,
    cliente_id INT,
    prestador_id INT,
    data_agendamento DATE,
    hora_inicio TIME,
    hora_fim TIME,
    assunto TEXT,
    status VARCHAR,
    criado_em TIMESTAMP,
    atualizado_em TIMESTAMP
) AS $$
BEGIN
    -- Retorna o agendamento pelo id 
    RETURN QUERY
    SELECT 
        age.id,
        age.cliente_id,
        age.prestador_id,
        age.data_agendamento,
        age.hora_inicio,
        age.hora_fim,
        age.assunto,
        age.status,
        age.criado_em,
        age.atualizado_em
    FROM 
        agenda.agendamentos age
    WHERE age.id = agendamento_id_input;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION agenda.alterar_agendamento(
    agendamento_id_input INT,
    cliente_id_input INT,
    prestador_id_input INT,
    data_agendamento_input DATE,
    hora_inicio_input TIME,
    hora_fim_input TIME,
    assunto_input TEXT,
    status_input VARCHAR
)
RETURNS VOID AS $$
BEGIN
    -- Atualiza os dados do agendamento com base no id fornecido
    UPDATE agenda.agendamentos
    SET cliente_id = cliente_id_input,
        prestador_id = prestador_id_input,
        data_agendamento = data_agendamento_input,
        hora_inicio = hora_inicio_input,
        hora_fim = hora_fim_input,
        assunto = assunto_input,
        status = status_input,
        atualizado_em = CURRENT_TIMESTAMP
    WHERE id = agendamento_id_input;

    -- Verifica se o agendamento foi encontrado para atualizar
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Agendamento com ID % não encontrado', agendamento_id_input;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Verificações
select agenda.inserir_agendamento(
1,                  -- cliente_id
2,                  -- prestador_id
'2024-11-01',       -- data_agendamento
'10:00:00',         -- hora_inicio
'11:00:00',         -- hora_fim
'Consulta inicial'  -- assunto
);

select agenda.listar_agendamentos_prestador(2, '2024-11-01', '2024-11-11');

select agenda.listar_agendamentos_cliente(2, '2024-11-11', '2024-11-13');

select * from agenda.prestadores p;
--5

select * from agenda.usuarios u;
--2

select * from agenda.agendamentos a;

select * from agenda.listar_agendamento_id(4);

select * from agenda.alterar_agendamento(
5,
1,
5,
'2024-11-15',
'16:00:00',
'17:00:00',
'Testando o update',
'pendente'
);