-- Função para Verificar se uma Subcategoria Existe em uma Categoria
CREATE OR REPLACE FUNCTION agenda.subcategoria_existe(nome_subcategoria VARCHAR, categoria_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    existe BOOLEAN;
BEGIN
    SELECT COUNT(1) > 0 INTO existe 
    FROM agenda.subcategorias 
    WHERE nome = nome_subcategoria AND categoria_id = categoria_id;
    RETURN existe;
END;
$$ LANGUAGE plpgsql;

-- Função para Inserir uma Nova Subcategoria
CREATE OR REPLACE FUNCTION agenda.inserir_subcategoria(nome_subcategoria VARCHAR, categoria_id INT)
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    -- Verifica se a categoria existe
    IF NOT agenda.categoria_existe(categoria_id) THEN
        RAISE EXCEPTION 'Categoria com ID % não existe', categoria_id;
    END IF;

    -- Insere a nova subcategoria
    INSERT INTO agenda.subcategorias (nome, categoria_id) 
    VALUES (nome_subcategoria, categoria_id) 
    RETURNING id INTO novo_id;

    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;

-- Função para Inserir Subcategoria Única
CREATE OR REPLACE FUNCTION agenda.inserir_subcategoria_unica(nome_subcategoria VARCHAR, categoria_id INT)
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    -- Verifica se a categoria existe
    IF NOT agenda.categoria_existe(categoria_id) THEN
        RAISE EXCEPTION 'Categoria com ID % não existe', categoria_id;
    END IF;

    -- Verifica se a subcategoria já existe na categoria
    IF agenda.subcategoria_existe(nome_subcategoria, categoria_id) THEN
        RAISE EXCEPTION 'Subcategoria "%", já existe na categoria com ID %', nome_subcategoria, categoria_id;
    END IF;

    -- Insere a nova subcategoria
    INSERT INTO agenda.subcategorias (nome, categoria_id) 
    VALUES (nome_subcategoria, categoria_id) 
    RETURNING id INTO novo_id;
    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;

-- Testar Funções
-- Inserir uma Nova Subcategoria
SELECT agenda.inserir_subcategoria('Subcategoria A1', 1);  -- Supondo que o ID da Categoria A é 1
-- Verificar se uma Subcategoria Existe
SELECT agenda.subcategoria_existe('Subcategoria A1', 1);

-- Tentar Inserir Subcategoria que já Existe
SELECT agenda.inserir_subcategoria_unica('Subcategoria A1', 1);

-- Tentar Inserir Subcategoria em Categoria Inexistente
SELECT agenda.inserir_subcategoria('Subcategoria B1', 999);

-- Limpar os Dados Após o Teste
DELETE FROM agenda.subcategorias WHERE nome IN ('Subcategoria A1', 'Subcategoria B1');



