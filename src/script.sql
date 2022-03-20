\echo 'Введите название таблицы: '
\prompt 'Введите название таблицы: ' name_table

\set name_tab '\'' :name_table '\''

SELECT get_schemas(:name_tab::text);

\echo 'Введите название схемы: '
\prompt 'Введите название схемы: ' schema_name_cur

\set name_shem '\'' :schema_name_cur '\''

SELECT columns_info(:name_tab::text, :name_shem::text);