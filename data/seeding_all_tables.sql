-- Seeding script for PostgreSQL database: ghostbusters_db

\c ghostbusters_db

--  Encodage client à UTF-8
SET client_encoding TO 'UTF8';

-- Assigner le propriétaire des tables à ghostbusters_admin
ALTER TABLE USERS OWNER TO ghostbusters_admin;
ALTER TABLE VISITORS OWNER TO ghostbusters_admin;
ALTER TABLE ROLES OWNER TO ghostbusters_admin;
ALTER TABLE PERMISSIONS OWNER TO ghostbusters_admin;
ALTER TABLE SHOP_ITEMS OWNER TO ghostbusters_admin;
ALTER TABLE TEAMS OWNER TO ghostbusters_admin;
ALTER TABLE ENTITY_TYPES OWNER TO ghostbusters_admin;
ALTER TABLE ENTITY_CLASSES OWNER TO ghostbusters_admin;
ALTER TABLE CAPTURE_LOCATIONS OWNER TO ghostbusters_admin;
ALTER TABLE QUIZ OWNER TO ghostbusters_admin;
ALTER TABLE USER_HAS_ROLE OWNER TO ghostbusters_admin;
ALTER TABLE USER_HAS_PERMISSION OWNER TO ghostbusters_admin;
ALTER TABLE ORDERS OWNER TO ghostbusters_admin;
ALTER TABLE ORDER_ITEMS OWNER TO ghostbusters_admin;
ALTER TABLE KANBAN_BOARDS OWNER TO ghostbusters_admin;
ALTER TABLE KANBAN_CARDS OWNER TO ghostbusters_admin;
ALTER TABLE KANBAN_TAGS OWNER TO ghostbusters_admin;
ALTER TABLE KANBAN_CARD_HAS_TAG OWNER TO ghostbusters_admin;
ALTER TABLE ENTITIES OWNER TO ghostbusters_admin;
ALTER TABLE ENTITY_ATTRIBUTES OWNER TO ghostbusters_admin;
ALTER TABLE QUESTIONS OWNER TO ghostbusters_admin;
ALTER TABLE ANSWERS OWNER TO ghostbusters_admin;
ALTER TABLE QUIZ_ATTEMPTS OWNER TO ghostbusters_admin;

-- Nettoyage des tables avant insertion
TRUNCATE TABLE USERS RESTART IDENTITY CASCADE;
TRUNCATE TABLE VISITORS RESTART IDENTITY CASCADE;
TRUNCATE TABLE ROLES RESTART IDENTITY CASCADE;
TRUNCATE TABLE PERMISSIONS RESTART IDENTITY CASCADE;
TRUNCATE TABLE SHOP_ITEMS RESTART IDENTITY CASCADE;
TRUNCATE TABLE TEAMS RESTART IDENTITY CASCADE;
TRUNCATE TABLE ENTITY_TYPES RESTART IDENTITY CASCADE;
TRUNCATE TABLE ENTITY_CLASSES RESTART IDENTITY CASCADE;
TRUNCATE TABLE CAPTURE_LOCATIONS RESTART IDENTITY CASCADE;
TRUNCATE TABLE QUIZ RESTART IDENTITY CASCADE;
TRUNCATE TABLE USER_HAS_ROLE RESTART IDENTITY CASCADE;
TRUNCATE TABLE USER_HAS_PERMISSION RESTART IDENTITY CASCADE;
TRUNCATE TABLE ORDERS RESTART IDENTITY CASCADE;
TRUNCATE TABLE ORDER_ITEMS RESTART IDENTITY CASCADE;
TRUNCATE TABLE KANBAN_BOARDS RESTART IDENTITY CASCADE;
TRUNCATE TABLE KANBAN_CARDS RESTART IDENTITY CASCADE;
TRUNCATE TABLE KANBAN_TAGS RESTART IDENTITY CASCADE;
TRUNCATE TABLE KANBAN_CARD_HAS_TAG RESTART IDENTITY CASCADE;
TRUNCATE TABLE ENTITIES RESTART IDENTITY CASCADE;
TRUNCATE TABLE ENTITY_ATTRIBUTES RESTART IDENTITY CASCADE;
TRUNCATE TABLE QUESTIONS RESTART IDENTITY CASCADE;
TRUNCATE TABLE ANSWERS RESTART IDENTITY CASCADE;
TRUNCATE TABLE QUIZ_ATTEMPTS RESTART IDENTITY CASCADE;

-- 1. Tables sans dépendances
-- Table : USERS
INSERT INTO USERS (username, email, password, created_at, updated_at) VALUES
('peter_venkman', 'peter.venkman@ghostbusters.com', 'hashed_password1', NOW(), NOW()),
('ray_stantz', 'ray.stantz@ghostbusters.com', 'hashed_password2', NOW(), NOW()),
('egon_spengler', 'egon.spengler@ghostbusters.com', 'hashed_password3', NOW(), NOW()),
('winston_zeddemore', 'winston.zeddemore@ghostbusters.com', 'hashed_password4', NOW(), NOW());

-- Table : VISITORS
INSERT INTO VISITORS (session_id, created_at) VALUES
('session_abc123', NOW()),
('session_def456', NOW()),
('session_ghi789', NOW());

-- Table : ROLES
INSERT INTO ROLES (role_label, created_at, updated_at) VALUES
('Administrateur', NOW(), NOW()),
('Utilisateur', NOW(), NOW()),
('Chef d''équipe', NOW(), NOW());

-- Table : PERMISSIONS
INSERT INTO PERMISSIONS (permission_name, created_at, updated_at) VALUES
('Gérer les utilisateurs', NOW(), NOW()),
('Gérer les articles', NOW(), NOW()),
('Gérer les commandes', NOW(), NOW()),
('Accéder au Kanban', NOW(), NOW()),
('Gérer les entités', NOW(), NOW()),
('Participer aux quiz', NOW(), NOW());

-- Table : SHOP_ITEMS
INSERT INTO SHOP_ITEMS (name, description, price, stock_quantity, created_at, updated_at) VALUES
('Pack de Protons', 'Un pack de protons pour capturer les fantômes.', 2999.99, 5, NOW(), NOW()),
('Piège à Fantômes', 'Piège portatif pour contenir les entités paranormales.', 499.99, 10, NOW(), NOW()),
('Combinaison Ghostbusters', 'Combinaison officielle avec logo.', 199.99, 20, NOW(), NOW()),
('Ecto-1 Miniature', 'Réplique miniature de la célèbre voiture.', 49.99, 50, NOW(), NOW());

-- Table : TEAMS
INSERT INTO TEAMS (team_name, created_at, updated_at) VALUES
('Équipe Manhattan', NOW(), NOW()),
('Équipe Brooklyn', NOW(), NOW());

-- Table : ENTITY_TYPES
INSERT INTO ENTITY_TYPES (type_label, created_at, updated_at) VALUES
('Fantôme', NOW(), NOW()),
('Esprit', NOW(), NOW()),
('Poltergeist', NOW(), NOW());

-- Table : ENTITY_CLASSES
INSERT INTO ENTITY_CLASSES (class_label, created_at, updated_at) VALUES
('Classe I', NOW(), NOW()),
('Classe II', NOW(), NOW()),
('Classe III', NOW(), NOW());

-- Table : CAPTURE_LOCATIONS
INSERT INTO CAPTURE_LOCATIONS (capture_location, city, latitude, longitude, created_at, updated_at) VALUES
('Hôtel Sedgewick', 'New York', 40.755, -73.984, NOW(), NOW()),
('Musée d''art de Manhattan', 'New York', 40.779, -73.963, NOW(), NOW()),
('Bibliothèque Publique de New York', 'New York', 40.753, -73.982, NOW(), NOW());

-- Table : QUIZ
INSERT INTO QUIZ (title, description, created_at, updated_at) VALUES
('Quiz sur les Fantômes', 'Testez vos connaissances sur les entités paranormales.', NOW(), NOW()),
('Quiz Ghostbusters', 'Connaissez-vous bien les Ghostbusters ?', NOW(), NOW());

-- 2. Tables avec dépendances directes
-- Table : USER_HAS_ROLE
INSERT INTO USER_HAS_ROLE (user_id, role_id, created_at) VALUES
(1, 1, NOW()), -- Peter Venkman est Administrateur
(2, 3, NOW()), -- Ray Stantz est Chef d'équipe
(3, 3, NOW()), -- Egon Spengler est Chef d'équipe
(4, 2, NOW()); -- Winston Zeddemore est Utilisateur

-- Table : USER_HAS_PERMISSION
INSERT INTO USER_HAS_PERMISSION (user_id, permission_id, created_at) VALUES
(1, 1, NOW()), -- Peter peut gérer les utilisateurs
(1, 2, NOW()), -- Peter peut gérer les articles
(1, 3, NOW()), -- Peter peut gérer les commandes
(1, 4, NOW()), -- Peter peut accéder au Kanban
(1, 5, NOW()), -- Peter peut gérer les entités
(1, 6, NOW()), -- Peter peut participer aux quiz
(2, 4, NOW()), -- Ray peut accéder au Kanban
(2, 5, NOW()), -- Ray peut gérer les entités
(2, 6, NOW()), -- Ray peut participer aux quiz
(3, 4, NOW()), -- Egon peut accéder au Kanban
(3, 5, NOW()), -- Egon peut gérer les entités
(3, 6, NOW()), -- Egon peut participer aux quiz
(4, 6, NOW()); -- Winston peut participer aux quiz

-- Table : ORDERS
INSERT INTO ORDERS (order_date, total_amount, user_id, status, created_at, updated_at) VALUES
(NOW(), 249.98, 4, 'En attente', NOW(), NOW()); -- Winston
INSERT INTO ORDERS (order_date, total_amount, visitor_id, status, created_at, updated_at) VALUES
(NOW(), 49.99, 1, 'Expédiée', NOW(), NOW()); -- session_abc123

-- Fin du script
