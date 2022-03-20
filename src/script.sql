\echo 'Введите название таблицы: '
\prompt 'Введите название таблицы: ' table

\set table '\'' :table '\''

SELECT get_schemas(:table);

\echo 'Введите название схемы: '
\prompt 'Введите название схемы: ' schema

\set schema '\'' :schema '\''

SELECT columns_info(:table, :schema);