CREATE OR REPLACE FUNCTION table_columns_info(name text, schema text) RETURNS VOID AS
$$
DECLARE
    i record;
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
                and (space.nspname = schema or schema = ''))
        LOOP
            RAISE NOTICE '% % Type    :  % %', RPAD(i.attnum::text, 5, ' '), RPAD(i.attname::text, 16, ' '),
                i.type, CASE WHEN i.attnotnull = true THEN 'Not null' ELSE '' END;
            RAISE NOTICE '% Commen  :  "%"', RPAD('⠀', 22, ' '), CASE WHEN i.description is null THEN '' ELSE i.description END;
        end loop;
end;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION schemas_table(table_name text) RETURNS VOID AS
$$
DECLARE
    col         record;
    table_count int;
BEGIN
    table_count := (SELECT COUNT(DISTINCT nspname)
                    FROM pg_class class
                             JOIN pg_namespace ns on class.relnamespace = ns.oid
                    WHERE relname = table_name);
    IF
        table_count < 1 THEN
        RAISE EXCEPTION 'Таблица "%" не найдена!', table_name;
    ELSE
        RAISE NOTICE ' ';
        RAISE NOTICE 'Выберите схему, с которой вы хотите получить данные: ';

        FOR col in (
            SELECT space.nspname namespace
            FROM pg_class tab
                     JOIN pg_namespace space on tab.relnamespace = space.oid
            WHERE tab.relname = table_name
            ORDER BY space.nspname
        )
            LOOP
                RAISE NOTICE '%', col.namespace;
            END LOOP;
        RAISE NOTICE ' ';
    END IF;
END
$$ LANGUAGE plpgsql;