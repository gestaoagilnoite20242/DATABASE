CREATE OR REPLACE FUNCTION agenda.email_existe(email_input VARCHAR)
RETURNS BOOLEAN AS $$
BEGIN
    -- Usa PERFORM para verificar se o e-mail existe
    PERFORM 1 FROM agenda.usuarios WHERE email = email_input;
    
    -- Se PERFORM encontrar um resultado, retorna TRUE, caso contrário FALSE
    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- uso: SELECT agenda.email_existe('email@example.com');
-- -----------------------------------------------------


CREATE OR REPLACE FUNCTION agenda.usuario_existe_id(
    usuario_id_input INT
)
RETURNS BOOLEAN AS $$
BEGIN
    -- Usa PERFORM para verificar se o usuário com o id fornecido existe
    PERFORM 1 FROM agenda.usuarios WHERE id = usuario_id_input;

    -- Se o usuário foi encontrado, retorna TRUE, caso contrário FALSE
    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- uso: SELECT agenda.usuario_existe(1);
-- ------------------------------------


CREATE OR REPLACE FUNCTION agenda.prestador_existe_cpf_cnpj(
    cpf_cnpj_input VARCHAR
)
RETURNS BOOLEAN AS $$
BEGIN
    -- Usa PERFORM para verificar se o prestador com o cpf_cnpj fornecido existe
    PERFORM 1 FROM agenda.prestadores WHERE cpf_cnpj = cpf_cnpj_input;

    -- Se o prestador foi encontrado, retorna TRUE, caso contrário FALSE
    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- uso: SELECT agenda.prestador_existe_cpf_cnpj('123.456.789-09');
-- ---------------------------------------------------------------


CREATE OR REPLACE FUNCTION agenda.prestador_existe_id(
    prestador_id_input VARCHAR
)
RETURNS BOOLEAN AS $$
BEGIN
    -- Usa PERFORM para verificar se o prestador com o cpf_cnpj fornecido existe
    PERFORM 1 FROM agenda.prestadores WHERE prestador_id = prestador_id_input;

    -- Se o prestador foi encontrado, retorna TRUE, caso contrário FALSE
    IF FOUND THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- uso: SELECT agenda.prestador_existe_id(10);
-- ---------------------------------------------------------------


CREATE OR REPLACE FUNCTION agenda.inserir_usuario(
    nome_input VARCHAR,
    email_input VARCHAR,
    senha_input VARCHAR,
    telefone_input VARCHAR,
    tipo_usuario_input CHAR(20),
    cidade_id_input INT
)
RETURNS INT AS $$
DECLARE
    novo_usuario_id INT;
BEGIN

    PERFORM 1 FROM agenda.usuarios WHERE email = email_input;

    IF NOT FOUND THEN
        -- Insere um novo registro na tabela 'usuarios'
        INSERT INTO agenda.usuarios (nome, email, senha, telefone, tipo_usuario, cidade_id, criado_em)
        VALUES (nome_input, email_input, senha_input, telefone_input, tipo_usuario_input, cidade_id_input, CURRENT_TIMESTAMP)
        RETURNING id INTO novo_usuario_id;

        -- Retorna o id do novo usuário inserido
        RETURN novo_usuario_id;
    ELSE 
        RAISE EXCEPTION 'O e-mail % já existe na base.', email_input;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- uso: SELECT agenda.inserir_usuario('Rodrigo', 'rodrigo@example.com', 'senha123', '123456789', 'prestador', 1);
-- --------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION agenda.alterar_usuario(
    usuario_id_input INT,
    nome_input VARCHAR,
    email_input VARCHAR,
    senha_input VARCHAR,
    telefone_input VARCHAR,
    tipo_usuario_input CHAR(20),
    cidade_id_input INT
)
RETURNS VOID AS $$
BEGIN
    -- Atualiza os dados do usuário com base no id fornecido
    UPDATE agenda.usuarios
    SET nome = nome_input,
        email = email_input,
        senha = senha_input,
        telefone = telefone_input,
        tipo_usuario = tipo_usuario_input,
        cidade_id = cidade_id_input,
        atualizado_em = CURRENT_TIMESTAMP
    WHERE id = usuario_id_input;

    -- Verifica se o usuário foi encontrado e atualizado
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Usuário com ID % não encontrado', usuario_id_input;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- uso SELECT agenda.alterar_usuario(1, 'Novo Nome', 'novoemail@example.com', 'novasenha', '123456789', 'prestador', 2);
-- ---------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION agenda.inserir_prestador(
    usuario_id_input INT,
    cpf_cnpj_input VARCHAR,
    atividade_input VARCHAR,
    listado_input BOOLEAN,
    categoria_input TEXT,
    services_input TEXT,
    logo_input TEXT,
    instagram_input TEXT,
    website_input TEXT
)
RETURNS INT AS $$
DECLARE
    novo_prestador_id INT;
BEGIN
    
    PERFORM 1 FROM agenda.prestadores WHERE cpf_cnpj = cpf_cnpj_input;

    IF NOT FOUND THEN
        -- Insere um novo registro na tabela 'prestadores'
        INSERT INTO agenda.prestadores (usuario_id, cpf_cnpj, atividade, listado, categoria, 
                                        services, logo, instagram, website, criado_em)
        VALUES (usuario_id_input, cpf_cnpj_input, atividade_input, listado_input, categoria_input, 
                services_input, logo_input, instagram_input, website_input, CURRENT_TIMESTAMP)
        RETURNING id INTO novo_prestador_id;

        -- Retorna o id do novo prestador inserido
        RETURN novo_prestador_id;
    ELSE 
        RAISE EXCEPTION 'O CPF/CNPJ % já existe na base.',  cpf_cnpj_input;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- uso: SELECT agenda.inserir_prestador(1, '123.456.789-09', 'Cabeleireiro', 'Beleza', 'Corte de cabelo, Penteado', 'url_logo', 'instagram_user', 'www.website.com');
-- ------------------------------------------------------------------------------------------------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION agenda.alterar_prestador(
    prestador_id_input INT,
    cpf_cnpj_input VARCHAR,
    atividade_input VARCHAR,
    listado_input BOOLEAN,
    categoria_input TEXT,
    services_input TEXT,
    logo_input TEXT,
    instagram_input TEXT,
    website_input TEXT,
    listado_input BOOLEAN
)
RETURNS VOID AS $$
BEGIN
    -- Atualiza os dados do prestador com base no id fornecido
    UPDATE agenda.prestadores
    SET cpf_cnpj = cpf_cnpj_input,
        atividade = atividade_input,
        listado = listado_input
        categoria = categoria_input,
        services = services_input,
        logo = logo_input,
        instagram = instagram_input,
        website = website_input,
        listado = listado_input,
        atualizado_em = CURRENT_TIMESTAMP
    WHERE id = prestador_id_input;

    -- Verifica se o prestador foi encontrado e atualizado
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Prestador com ID % não encontrado', prestador_id_input;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- uso SELECT agenda.alterar_prestador(1, '123.456.789-09', 'Novo Serviço', 'Nova Categoria', 'Serviço atualizado', 'novologo.png', '@instagram', 'www.site.com', TRUE);
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------



