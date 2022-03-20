CREATE OR REPLACE FUNCTION table_columns_info(t text, schema text) RETURNS VOID AS
$$
DECLARE
    i         record;
    name      text := t;
    namespace text := schema;
BEGIN
    raise notice ' ';
    raise notice 'Таблица: %', name;
    raise notice ' ';
    raise notice 'No. Имя столбца 		Атрибуты';
    raise notice '--- ----------------- ------------------------------------------------------';
    FOR i IN (select attnum,
                     attname,
                     attnotnull,
                     col_description(a.attrelid, a.attnum) as description,
                     format_type(a.atttypid, a.atttypmod)  as type
              from pg_attribute a
                       join pg_class pc on a.attrelid = pc.oid
                       JOIN pg_namespace space on pc.relnamespace = space.oid
              where relname = name
                and attnum > 0
                and (space.nspname = namespace or namespace = ''))
        LOOP
            RAISE NOTICE '% % Type    :  % %', RPAD(i.attnum::text, 5, ' '), RPAD(i.attname::text, 16, ' '),
                i.type, CASE WHEN i.attnotnull = true THEN 'Not null' ELSE '' END;
            RAISE NOTICE '% Commen  :  "%"', RPAD('⠀', 22, ' '), CASE WHEN i.description is null THEN '' ELSE i.description END;
        end loop;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION schemas_table(t text) RETURNS VOID AS
$$
DECLARE
    schema_tab CURSOR FOR (
        SELECT tab.relname, space.nspname
        FROM pg_class tab
                 JOIN pg_namespace space on tab.relnamespace = space.oid
        WHERE tab.relname = t
        ORDER BY space.nspname
    );
    table_count int;
BEGIN
    SELECT COUNT(DISTINCT nspname)
    INTO table_count
    FROM pg_class tab
             JOIN pg_namespace space on tab.relnamespace = space.oid
    WHERE relname = t;

    IF table_count < 1 THEN
        RAISE EXCEPTION 'Таблица "%" не найдена!', t;
    ELSE
        RAISE NOTICE ' ';
        RAISE NOTICE 'Выберите схему, с которой вы хотите получить данные: ';

        FOR col in schema_tab
            LOOP
                RAISE NOTICE '%', col.nspname;
            END LOOP;
        RAISE NOTICE ' ';
    END IF;
END
$$ LANGUAGE plpgsql;