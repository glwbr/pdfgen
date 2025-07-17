DROP FUNCTION IF EXISTS update_updated_at_column;

DROP DOMAIN IF EXISTS KSUID;

DROP TYPE IF EXISTS document_status;
DROP TYPE IF EXISTS field_type;
DROP TYPE IF EXISTS document_category;

DROP EXTENSION IF EXISTS "pg_idkit";