CREATE TABLE documents (
    id KSUID PRIMARY KEY DEFAULT idkit_ksuid_generate(),
    template_id KSUID NOT NULL REFERENCES templates(id) ON DELETE CASCADE,
    name VARCHAR(200) NOT NULL,
    field_values JSONB NOT NULL DEFAULT '{}',
    file_path VARCHAR(500) NOT NULL ,
    status document_status NOT NULL DEFAULT 'draft',
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE TRIGGER update_documents_updated_at
BEFORE UPDATE ON documents
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_documents_template_id ON documents(template_id);
CREATE INDEX idx_documents_status ON documents(status);
CREATE INDEX idx_documents_field_values ON documents USING GIN (field_values);