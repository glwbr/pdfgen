CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE document_category AS ENUM ('legal', 'personal', 'business');
CREATE TYPE field_type AS ENUM ('text', 'date', 'currency', 'number', 'email', 'select', 'textarea', 'checkbox', 'radio');
CREATE TYPE document_status AS ENUM ('draft', 'preview', 'final');

-- INFO: trigger function for updating `updated_at`
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;