
Réinitialiser la base de données et créer l'utilisateur :

psql -U postgres
SET client_encoding = 'UTF8';

bash
Copier le code
psql -U postgres -f "C:\Users\docje\OneDrive\Documents\Ghostbusters\database\reset\reboot_user_and_database_complete.sql"

Créer les tables dans la base de données :

bash
Copier le code
psql -U postgres -f "C:\Users\docje\OneDrive\Documents\Ghostbusters\database\reset\reset_all_tables.sql"
Insérer les données dans les tables :

Test dans la base de données :

psql -U ghostbusters_admin -d ghostbusters_db

Test des requêtes SQL :

SELECT * FROM USERS;
SELECT * FROM VISITORS;
SELECT * FROM ROLES;
SELECT * FROM ORDERS;
SELECT * FROM KANBAN_BOARDS;

Test des Index :

\d USERS;
\d VISITORS;
\d ROLES;

Test de recherche :

SELECT * FROM USERS WHERE username = 'peter_venkman';
