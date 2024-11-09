-- 1. Changer l'encodage de la console à UTF-8 (si nécessaire)
\! chcp 65001

-- 2. Vérifier la configuration du client PostgreSQL
SHOW client_encoding;

-- 3. Définir l'encodage client à UTF-8 si nécessaire
SET client_encoding TO 'UTF8';

-- 4. Vérifier l'encodage du serveur PostgreSQL
SHOW server_encoding;

-- 5. Créer l'utilisateur ghostbusters_admin si nécessaire, avec les permissions appropriées
DO $$ 
BEGIN
   IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'ghostbusters_admin') THEN
      CREATE USER ghostbusters_admin WITH PASSWORD 'spengler19021986';
      ALTER USER ghostbusters_admin CREATEDB;
      RAISE NOTICE 'Utilisateur ghostbusters_admin créé avec succès.';
   ELSE
      RAISE NOTICE 'Utilisateur ghostbusters_admin existe déjà.';
   END IF;
END $$;

-- 6. Forcer la déconnexion des connexions actives sur la base de données
\echo 'Forcer la déconnexion des connexions actives sur ghostbusters_db.'
REVOKE CONNECT ON DATABASE ghostbusters_db FROM public;
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'ghostbusters_db'
  AND pid <> pg_backend_pid();

-- 7. Supprimer la base de données si elle existe
\echo 'Suppression de la base de données ghostbusters_db si elle existe.'
DROP DATABASE IF EXISTS ghostbusters_db;

-- 8. Recréer la base de données avec les bons paramètres (UTF-8 et propriétaire ghostbusters_admin)
\echo 'Création de la base de données ghostbusters_db avec les bonnes locales et encodage.'
CREATE DATABASE ghostbusters_db
    WITH 
    OWNER = ghostbusters_admin
    ENCODING = 'UTF8'
    LC_COLLATE = 'fr_FR.UTF-8'
    LC_CTYPE = 'fr_FR.UTF-8'
    TEMPLATE = template0;

-- 9. Accorder la permission de connexion à la base de données
GRANT CONNECT ON DATABASE ghostbusters_db TO ghostbusters_admin;

-- 10. Connexion à la base de données fraîchement recréée
\c ghostbusters_db;

-- 11. Importer le script pour recréer les tables
\echo 'Création des tables.'
\i 'C:\\Users\\docje\\OneDrive\\Documents\\Ghostbusters\\database\\reset\\reset_all_tables.sql'

-- 12. Changer immédiatement la propriété des tables à ghostbusters_admin après leur création
DO $$
DECLARE 
    rec RECORD;
BEGIN
    FOR rec IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
    LOOP
        EXECUTE 'ALTER TABLE ' || quote_ident(rec.tablename) || ' OWNER TO ghostbusters_admin';
    END LOOP;
END $$;

-- 13. Vérification de l'encodage client pour s'assurer de l'alignement avec UTF-8
SET client_encoding TO 'UTF8';
SHOW client_encoding;

-- 14. Message de confirmation pour indiquer que tout a été correctement configuré
\echo 'La base de données ghostbusters_db a été réinitialisée avec succès et les tables ont été recréées.'
