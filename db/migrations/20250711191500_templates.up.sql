CREATE TABLE templates (
    id KSUID PRIMARY KEY DEFAULT idkit_ksuid_generate(),
    name VARCHAR(200) NOT NULL,
    type_id KSUID NOT NULL REFERENCES document_types(id) ON DELETE CASCADE,
    file_path VARCHAR(500) NOT NULL ,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_name_type_id UNIQUE (name, type_id)
);

CREATE TRIGGER update_templates_updated_at
BEFORE UPDATE ON templates
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_templates_type_id ON templates(type_id);
CREATE INDEX idx_templates_active ON templates(is_active);
