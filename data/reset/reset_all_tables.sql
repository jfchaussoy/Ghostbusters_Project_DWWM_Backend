-- Connexion à la base de données
\c ghostbusters_db

-- 1. Définir l'encodage client à UTF-8
SET client_encoding TO 'UTF8';

-- 2. Suppression des tables existantes si elles existent (évite les erreurs)
DO $$
DECLARE 
    rec RECORD;
BEGIN
    FOR rec IN SELECT tablename FROM pg_tables WHERE schemaname = 'public'
    LOOP
        EXECUTE 'DROP TABLE IF EXISTS ' || quote_ident(rec.tablename) || ' CASCADE';
    END LOOP;
END $$;

-- 3. Création des tables

-- Création de la table USERS
CREATE TABLE USERS (
    id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table VISITORS
CREATE TABLE VISITORS (
    id SERIAL PRIMARY KEY,
    session_id VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table ROLES
CREATE TABLE ROLES (
    id SERIAL PRIMARY KEY,
    role_label VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table PERMISSIONS
CREATE TABLE PERMISSIONS (
    id SERIAL PRIMARY KEY,
    permission_name VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table SHOP_ITEMS
CREATE TABLE SHOP_ITEMS (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    price NUMERIC(10,2) NOT NULL CHECK (price >= 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table TEAMS
CREATE TABLE TEAMS (
    id SERIAL PRIMARY KEY,
    team_name VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table ENTITY_TYPES
CREATE TABLE ENTITY_TYPES (
    id SERIAL PRIMARY KEY,
    type_label VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table ENTITY_CLASSES
CREATE TABLE ENTITY_CLASSES (
    id SERIAL PRIMARY KEY,
    class_label VARCHAR(50) NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table CAPTURE_LOCATIONS
CREATE TABLE CAPTURE_LOCATIONS (
    id SERIAL PRIMARY KEY,
    capture_location VARCHAR(100) NOT NULL,
    city VARCHAR(100) NOT NULL,
    latitude NUMERIC(9,6) NOT NULL,
    longitude NUMERIC(9,6) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table QUIZ
CREATE TABLE QUIZ (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table USER_HAS_ROLE
CREATE TABLE USER_HAS_ROLE (
    user_id INTEGER NOT NULL,
    role_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE CASCADE,
    FOREIGN KEY (role_id) REFERENCES ROLES(id) ON DELETE CASCADE
);

-- Création de la table USER_HAS_PERMISSION
CREATE TABLE USER_HAS_PERMISSION (
    user_id INTEGER NOT NULL,
    permission_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, permission_id),
    FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES PERMISSIONS(id) ON DELETE CASCADE
);

-- Création de la table ORDERS
CREATE TABLE ORDERS (
    id SERIAL PRIMARY KEY,
    order_date TIMESTAMP NOT NULL DEFAULT NOW(),
    total_amount NUMERIC(10,2) NOT NULL CHECK (total_amount >= 0),
    user_id INTEGER,
    visitor_id INTEGER,
    status VARCHAR(20) NOT NULL CHECK (status IN ('En attente', 'Expédiée', 'Livrée')),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE SET NULL,
    FOREIGN KEY (visitor_id) REFERENCES VISITORS(id) ON DELETE SET NULL,
    CHECK (
        (user_id IS NOT NULL AND visitor_id IS NULL) OR
        (user_id IS NULL AND visitor_id IS NOT NULL)
    )
);

-- Création de la table ORDER_ITEMS
CREATE TABLE ORDER_ITEMS (
    order_id INTEGER NOT NULL,
    shop_item_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (order_id, shop_item_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS(id) ON DELETE CASCADE,
    FOREIGN KEY (shop_item_id) REFERENCES SHOP_ITEMS(id)
);

-- Création de la table KANBAN_BOARDS
CREATE TABLE KANBAN_BOARDS (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    team_id INTEGER NOT NULL UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (team_id) REFERENCES TEAMS(id)
);

-- Création de la table KANBAN_CARDS
CREATE TABLE KANBAN_CARDS (
    id SERIAL PRIMARY KEY,
    title VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    position INTEGER NOT NULL,
    kanban_board_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (kanban_board_id) REFERENCES KANBAN_BOARDS(id) ON DELETE CASCADE
);

-- Création de la table KANBAN_TAGS
CREATE TABLE KANBAN_TAGS (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    color VARCHAR(7) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

-- Création de la table KANBAN_CARD_HAS_TAG
CREATE TABLE KANBAN_CARD_HAS_TAG (
    kanban_card_id INTEGER NOT NULL,
    kanban_tag_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    PRIMARY KEY (kanban_card_id, kanban_tag_id),
    FOREIGN KEY (kanban_card_id) REFERENCES KANBAN_CARDS(id) ON DELETE CASCADE,
    FOREIGN KEY (kanban_tag_id) REFERENCES KANBAN_TAGS(id) ON DELETE CASCADE
);

-- Création de la table ENTITIES
CREATE TABLE ENTITIES (
    id SERIAL PRIMARY KEY,
    entity_name VARCHAR(100) NOT NULL,
    entity_description TEXT NOT NULL,
    capture_date TIMESTAMP NOT NULL DEFAULT NOW(),
    team_id INTEGER NOT NULL,
    status VARCHAR(10) NOT NULL CHECK (status IN ('Captured', 'Free')),
    entity_type_id INTEGER NOT NULL,
    entity_class_id INTEGER NOT NULL,
    location_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (team_id) REFERENCES TEAMS(id),
    FOREIGN KEY (entity_type_id) REFERENCES ENTITY_TYPES(id),
    FOREIGN KEY (entity_class_id) REFERENCES ENTITY_CLASSES(id),
    FOREIGN KEY (location_id) REFERENCES CAPTURE_LOCATIONS(id)
);

-- Création de la table ENTITY_ATTRIBUTES
CREATE TABLE ENTITY_ATTRIBUTES (
    id SERIAL PRIMARY KEY,
    attribute_name VARCHAR(50) NOT NULL,
    attribute_value VARCHAR(255) NOT NULL,
    entity_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (entity_id) REFERENCES ENTITIES(id) ON DELETE CASCADE,
    UNIQUE (entity_id, attribute_name)
);

-- Création de la table QUESTIONS
CREATE TABLE QUESTIONS (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    quiz_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (quiz_id) REFERENCES QUIZ(id) ON DELETE CASCADE
);

-- Création de la table ANSWERS
CREATE TABLE ANSWERS (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    is_correct BOOLEAN NOT NULL,
    question_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (question_id) REFERENCES QUESTIONS(id) ON DELETE CASCADE
);

-- Création de la table QUIZ_ATTEMPTS
CREATE TABLE QUIZ_ATTEMPTS (
    id SERIAL PRIMARY KEY,
    score INTEGER NOT NULL CHECK (score >= 0),
    attempt_date TIMESTAMP NOT NULL DEFAULT NOW(),
    user_id INTEGER NOT NULL,
    quiz_id INTEGER NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE CASCADE,
    FOREIGN KEY (quiz_id) REFERENCES QUIZ(id) ON DELETE CASCADE
);

-- 4. Message de confirmation
\echo 'Script terminé.';
