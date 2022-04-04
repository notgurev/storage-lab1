CREATE OR REPLACE FUNCTION columns_info(name text, schema text) RETURNS VOID AS
$$
DECLARE
    i     record;
    count boolean;
    fullName text;
BEGIN
    fullName := schema || '.' || name;
    SELECT to_regclass(fullName) into count;
    if count is null then
        raise exception 'Таблица "%s" не существует', fullName;
    end if;
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
end ;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_schemas(name text) RETURNS VOID AS
$$
DECLARE
    col record;
BEGIN
    IF (SELECT COUNT(DISTINCT nspname)
        FROM pg_class class
                 JOIN pg_namespace ns on class.relnamespace = ns.oid
        WHERE relname = name) < 1
    THEN
        RAISE EXCEPTION 'Таблица "%" не существует!', name;
    ELSE
        RAISE NOTICE ' ';
        RAISE NOTICE 'Схемы с таблицей %: ', name;

        FOR col in (
            SELECT space.nspname namespace
            FROM pg_class tab
                     JOIN pg_namespace space on tab.relnamespace = space.oid
            WHERE tab.relname = name
            ORDER BY space.nspname
        )
            LOOP
                RAISE NOTICE '%', col.namespace;
            END LOOP;

        RAISE NOTICE ' ';
    END IF;
END
$$ LANGUAGE plpgsql;