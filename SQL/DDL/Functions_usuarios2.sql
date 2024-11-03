CREATE OR REPLACE FUNCTION agenda.listar_usuarios_ativos()
RETURNS TABLE (
    usuarios_id INT,
    usuarios_nome VARCHAR,
    usuarios_email VARCHAR,
    usuarios_telefone VARCHAR,
    usuarios_tipo_usuario CHAR(20),
    usuarios_criado_em TIMESTAMP,
    usuarios_atualizado_em TIMESTAMP
) AS $$
BEGIN
    -- Retorna todos os usuários ativos, ou seja, com a coluna 'ativo' marcada como TRUE
    RETURN QUERY
    SELECT id, nome, email, telefone, tipo_usuario, criado_em, atualizado_em
    FROM agenda.usuarios
    WHERE ativo = TRUE;
END;
$$ LANGUAGE plpgsql;

-- uso: SELECT * FROM agenda.listar_usuarios_ativos();
-- ---------------------------------------------------


CREATE OR REPLACE FUNCTION agenda.listar_todos_usuarios()
RETURNS TABLE (
    usuarios_id INT,
    usuarios_nome VARCHAR,
    usuarios_email VARCHAR,
    usuarios_telefone VARCHAR,
    usuarios_tipo_usuario CHAR(20),
    usuarios_criado_em TIMESTAMP,
    usuarios_atualizado_em TIMESTAMP
) AS $$
BEGIN
    -- Retorna todos os usuários sem filtro de "ativo"
    RETURN QUERY
    SELECT id, nome, email, telefone, tipo_usuario, criado_em, atualizado_em
    FROM agenda.usuarios;
END;
$$ LANGUAGE plpgsql;

-- uso: SELECT * FROM agenda.listar_todos_usuarios();
-- --------------------------------------------------


CREATE OR REPLACE FUNCTION agenda.obter_dados_completos_prestador(prestador_id_input INT)
RETURNS TABLE (
    usuario_id INT,
    nome_usuario VARCHAR,
    email_usuario VARCHAR,
    telefone_usuario VARCHAR,
    nome_cidade CHAR(100),
    sigla_estado CHAR(2),
    tipo_usuario CHAR(20),
    prestador_id INT,
    cpf_cnpj VARCHAR,
    atividade VARCHAR,
    services TEXT,
    logo TEXT,
    instagram TEXT,
    website TEXT,
    listado BOOLEAN,
    criado_em_usuario TIMESTAMP,
    atualizado_em_usuario TIMESTAMP,
    criado_em_prestador TIMESTAMP,
    atualizado_em_prestador TIMESTAMP
) AS $$
BEGIN
    -- Seleciona os dados do prestador e seus respectivos dados de usuário, cidade e estado
    RETURN QUERY
    SELECT 
        p.usuario_id,
        u.nome AS nome_usuario,
        u.email AS email_usuario,
        u.telefone AS telefone_usuario,
        c.nome AS nome_cidade,
        e.sigla AS sigla_estado,
        u.tipo_usuario,
        p.id AS prestador_id,
        p.cpf_cnpj,
        p.atividade,
        p.services,
        p.logo,
        p.instagram,
        p.website,
        p.listado,
        u.criado_em AS criado_em_usuario,
        u.atualizado_em AS atualizado_em_usuario,
        p.criado_em AS criado_em_prestador,
        p.atualizado_em AS atualizado_em_prestador
    FROM agenda.prestadores p
    JOIN agenda.usuarios u ON p.usuario_id = u.id
    LEFT JOIN agenda.cidades c ON u.cidade_id = c.id
    LEFT JOIN agenda.estados e ON c.estado_id = e.id
    WHERE p.id = prestador_id_input;
END;
$$ LANGUAGE plpgsql;



-- DROP FUNCTION agenda.listar_usuarios_ativos();
-- DROP FUNCTION agenda.listar_todos_usuarios();
-- DROP FUNCTION agenda.obter_dados_completos_prestador(prestador_id_input INT);
