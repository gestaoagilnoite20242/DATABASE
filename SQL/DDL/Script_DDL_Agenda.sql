CREATE SCHEMA IF NOT EXISTS agenda;

-- Tabela de Estados (nova)
CREATE TABLE IF NOT EXISTS agenda.estados (
    id SERIAL PRIMARY KEY,
    nome CHAR(100) NOT NULL,
    sigla CHAR(2) UNIQUE NOT NULL
);

-- Tabela de Cidades (nova)
CREATE TABLE IF NOT EXISTS agenda.cidades (
    id SERIAL PRIMARY KEY,
    nome CHAR(100) NOT NULL,
    estado_id INT REFERENCES agenda.estados(id)
);

-- Tabela de Usuários
CREATE TABLE agenda.usuarios (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    senha VARCHAR(255) NOT NULL,
    telefone VARCHAR(20),
    ativo BOOLEAN DEFAULT TRUE,
    tipo_usuario CHAR(20) NOT NULL,
    CONSTRAINT tipo_usuario CHECK (tipo_usuario IN ('prestador', 'cliente', 'adm')),
    cidade_id INT REFERENCES agenda.cidades(id), -- Permite que o usuário seja removido sem remover a cidade
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP
);

-- Tabela de Prestadores -- SE tipo_usuario == 'prestador'
CREATE TABLE agenda.prestadores (
    id SERIAL PRIMARY KEY,
    usuario_id INT,
    cpf_cnpj VARCHAR(20) UNIQUE NOT NULL,
    atividade VARCHAR(100) NOT NULL,
    listado BOOLEAN DEFAULT TRUE;
    ativo BOOLEAN DEFAULT TRUE,
    tipo_agenda CHAR(20) DEFAULT 'privado',
    categoria_id INT,
    subcategoria_id INT,
    services TEXT,
    logo TEXT,
    instagram TEXT,
    website TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES agenda.usuarios(id) ON DELETE CASCADE
);

-- Tabela de Ritmo de Trabalho (Disponibilidade regular)
-- Define os dias da semana e os horários que o prestador trabalha regularmente
CREATE TABLE agenda.ritmo_trabalho (
    id SERIAL PRIMARY KEY,
    prestador_id INT,
    dia_semana CHAR(20) NOT NULL,
    CONSTRAINT dia_semana_check CHECK (dia_semana IN ('segunda', 'terça', 'quarta', 'quinta', 'sexta', 'sábado', 'domingo')),
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP,
    FOREIGN KEY (prestador_id) REFERENCES agenda.prestadores(id) ON DELETE CASCADE
);

-- Tabela de Exceções (dias ou horários bloqueados)
-- Permite que o prestador bloqueie dias ou horários específicos, como férias ou compromissos pessoais
CREATE TABLE agenda.excecoes (
    id SERIAL PRIMARY KEY,
    prestador_id INT,
    data_bloqueio DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    assunto TEXT,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP,
    FOREIGN KEY (prestador_id) REFERENCES agenda.prestadores(id) ON DELETE CASCADE
);

-- Tabela de Agendamentos
CREATE TABLE agenda.agendamentos (
    id SERIAL PRIMARY KEY,
    cliente_id INT,
    prestador_id INT,
    data_agendamento DATE NOT NULL,
    hora_inicio TIME NOT NULL,
    hora_fim TIME NOT NULL,
    assunto TEXT,
    status CHAR(20) DEFAULT 'pendente', 
    CONSTRAINT status_check CHECK (status IN ('confirmado', 'cancelado', 'pendente')),
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    atualizado_em TIMESTAMP,
    FOREIGN KEY (cliente_id) REFERENCES agenda.usuarios(id) ON DELETE CASCADE,
    FOREIGN KEY (prestador_id) REFERENCES agenda.prestadores(id) ON DELETE CASCADE
);

-- Tabela de Categorias
CREATE TABLE IF NOT EXISTS agenda.categorias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabela de Subcategorias
CREATE TABLE IF NOT EXISTS agenda.subcategorias (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    categoria_id INT NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (categoria_id) REFERENCES agenda.categorias(id) ON DELETE CASCADE,
    UNIQUE (nome, categoria_id) -- Impede duplicação de subcategorias dentro da mesma categoria
);


-- Criar índice na coluna nome
CREATE INDEX idx_nome ON agenda.usuarios (nome);

-- Criar índice na coluna tipo_usuario
CREATE INDEX idx_tipo_usuario ON agenda.usuarios (tipo_usuario);

-- Criar índice na coluna telefone
CREATE INDEX idx_telefone ON agenda.usuarios (telefone);

-- Índice composto nas colunas prestador_id e data_bloqueio
CREATE INDEX idx_prestador_data_bloqueio ON agenda.excecoes (prestador_id, data_bloqueio);

-- Índice composto nas colunas prestador_id e data_agendamento
CREATE INDEX idx_prestador_data_agendamento ON agenda.agendamentos (prestador_id, data_agendamento);

-- Índice composto nas colunas prestador_id e data_agendamento
CREATE INDEX idx_prestador_categoria_subcategoria ON agenda.prestadores (categoria_id, subcategoria_id);



CREATE OR REPLACE FUNCTION atualizar_data_atualizacao()
RETURNS TRIGGER AS $$
BEGIN
    -- Atualiza o campo atualizado_em com o timestamp atual
    NEW.atualizado_em := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualiza_data_usuarios
BEFORE UPDATE ON agenda.usuarios
FOR EACH ROW
EXECUTE FUNCTION agenda.atualizar_data_atualizacao();

CREATE TRIGGER trigger_atualiza_data_prestadores
BEFORE UPDATE ON agenda.prestadores
FOR EACH ROW
EXECUTE FUNCTION agenda.atualizar_data_atualizacao();

CREATE TRIGGER trigger_atualiza_data_ritmo_trabalho
BEFORE UPDATE ON agenda.ritmo_trabalho
FOR EACH ROW
EXECUTE FUNCTION agenda.atualizar_data_atualizacao();

CREATE TRIGGER trigger_atualiza_data_excecoes
BEFORE UPDATE ON agenda.excecoes
FOR EACH ROW
EXECUTE FUNCTION agenda.atualizar_data_atualizacao();

CREATE TRIGGER trigger_atualiza_data_agendamentos
BEFORE UPDATE ON agenda.agendamentos
FOR EACH ROW
EXECUTE FUNCTION agenda.atualizar_data_atualizacao();



-- DROP TRIGGER IF EXISTS trigger_atualiza_data_usuarios ON agenda.usuarios;
-- DROP TRIGGER IF EXISTS trigger_atualiza_data_prestadores ON agenda.prestadores;
-- DROP TRIGGER IF EXISTS trigger_atualiza_data_ritmo_trabalho ON agenda.ritmo_trabalho;
-- DROP TRIGGER IF EXISTS trigger_atualiza_data_excecoes ON agenda.excecoes;
-- DROP TRIGGER IF EXISTS trigger_atualiza_data_agendamentos ON agenda.agendamentos;


-- drop table agenda.agenda.agendamentos;
-- drop table agenda.agenda.excecoes;
-- drop table agenda.agenda.ritmo_trabalho;
-- drop table agenda.agenda.prestadores;
-- drop table agenda.agenda.usuarios;
-- drop table agenda.agenda.cidades;
-- drop table agenda.agenda.estados;
