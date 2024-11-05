-- Função para Inserir uma Nova Categoria
CREATE OR REPLACE FUNCTION agenda.inserir_categoria(nome_categoria VARCHAR)
RETURNS INTEGER AS $$
DECLARE
    novo_id INTEGER;
BEGIN
    INSERT INTO agenda.categorias (nome) 
    VALUES (nome_categoria) 
    RETURNING id INTO novo_id;
    RETURN novo_id;
END;
$$ LANGUAGE plpgsql;

-- Função para Verificar se uma Categoria Existe
CREATE OR REPLACE FUNCTION agenda.categoria_existe(categoria_id INT)
RETURNS BOOLEAN AS $$
DECLARE
    existe BOOLEAN;
BEGIN
    SELECT COUNT(1) > 0 INTO existe FROM agenda.categorias WHERE id = categoria_id;
    RETURN existe;
END;
$$ LANGUAGE plpgsql;


-- Testar Funções
-- Inserir uma Nova Categoria
SELECT agenda.inserir_categoria('Categoria Teste');

-- Inserir uma Nova Categoria para Subcategoria
SELECT agenda.inserir_categoria('Categoria A');

-- Obter o ID da Categoria Inserida
SELECT * FROM agenda.categorias WHERE nome = 'Categoria A';

-- Verificar se uma Categoria Existe
SELECT agenda.categoria_existe(1);  -- Verifique o ID da categoria


DELETE FROM agenda.categorias WHERE nome = 'Categoria Teste' OR nome = 'Categoria A';




