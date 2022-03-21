-- \echo 'Введите название таблицы: '
-- \prompt 'Введите название таблицы: ' table
\set table '\'' `echo $input` '\''
SELECT get_schemas(:table);
\echo 'Введите название схемы: '
\prompt 'Введите название схемы: ' schema
\set schema '\'' :schema '\''
SELECT columns_info(:table, :schema);