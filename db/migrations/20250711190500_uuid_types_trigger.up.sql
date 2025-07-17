-- INFO: This migration introduces the use of KSUIDs as primary keys in the database instead of UUIDs.
-- A custom KSUID type is created as an alias for CHAR(27) to represent KSUIDs, ensuring compatibility with sqlc-generated code.
-- For more details on KSUIDs, see github.com/segmentio/ksuid.
CREATE EXTENSION IF NOT EXISTS "pg_idkit";

CREATE TYPE document_category AS ENUM ('legal', 'personal', 'business');
CREATE TYPE field_type AS ENUM ('text', 'date', 'currency', 'number', 'email', 'select', 'textarea', 'checkbox', 'radio');
CREATE TYPE document_status AS ENUM ('draft', 'preview', 'final');

-- WARN: While KSUIDs are typically generated at the application layer in distributed systems, for simplicity, they are generated within the database in this implementation.
CREATE DOMAIN KSUID AS CHAR(27)
CHECK (LENGTH(VALUE) = 27 AND VALUE ~ '^[0-9A-Za-z]+$');

-- INFO: trigger function for updating `updated_at`
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';