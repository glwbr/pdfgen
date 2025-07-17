CREATE TABLE document_types (
    id KSUID PRIMARY KEY DEFAULT idkit_ksuid_generate(),
    name VARCHAR(200) NOT NULL UNIQUE,
    category document_category NOT NULL,
    description VARCHAR(200),
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TRIGGER update_document_types_updated_at
BEFORE UPDATE ON document_types
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();