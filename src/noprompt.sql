-- \echo 'Введите название таблицы: '
-- \prompt 'Введите название таблицы: ' table
\set table '\'' `echo $table` '\''
-- SELECT get_schemas(:table);
-- \echo 'Введите название схемы: '
-- \prompt 'Введите название схемы: ' schema
\set schema '\'' `echo $schema` '\''
SELECT columns_info(:table, :schema);