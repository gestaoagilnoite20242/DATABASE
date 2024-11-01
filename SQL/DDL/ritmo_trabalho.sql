-- Inserir Ritmo de Trabalho

CREATE OR REPLACE FUNCTION agenda.insert_ritmo(prestador_id INT, dia_semana CHAR(20), hora_inicio TIME, hora_fim TIME)
RETURNS VOID AS $$
BEGIN
    INSERT INTO agenda.ritmo_trabalho (prestador_id, dia_semana, hora_inicio, hora_fim)
    VALUES (prestador_id, dia_semana, hora_inicio, hora_fim);
END;
$$ LANGUAGE plpgsql;


-- Remover Ritmo de Trabalho

CREATE OR REPLACE FUNCTION agenda.delete_ritmo(ritmo_id INT)
RETURNS VOID AS $$
BEGIN
    DELETE FROM agenda.ritmo_trabalho
    WHERE id = ritmo_id;
END;
$$ LANGUAGE plpgsql;


-- GET ritmos de trabalho
CREATE OR REPLACE FUNCTION agenda.get_ritmo_by_prestador(p_prestador_id INT)
RETURNS TABLE(
    id INT,
    dia_semana CHAR(20),
    hora_inicio TIME,
    hora_fim TIME,
    criado_em TIMESTAMP,
    atualizado_em TIMESTAMP
) AS $$
BEGIN
    RETURN QUERY
    SELECT rt.id, rt.dia_semana, rt.hora_inicio, rt.hora_fim, rt.criado_em, rt.atualizado_em
    FROM agenda.ritmo_trabalho AS rt
    WHERE rt.prestador_id = p_prestador_id;
END;
$$ LANGUAGE plpgsql;


-- Teste: Inserir horário de trabalho para o prestador com ID = 1
SELECT agenda.insert_ritmo(22, 'segunda', '09:00', '14:00'); -- primeiro argumento é o id do prestador


-- Teste: Remover o horário de trabalho com ID = 1
SELECT agenda.delete_ritmo(32); -- Entre parenteses o ID do Ritmo de trabalho


-- Teste: Retornar todos os horários de trabalho para o prestador com ID = 1
SELECT * FROM agenda.get_ritmo_by_prestador(22); -- entre parenteses o ID do prestador
