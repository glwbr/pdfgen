CREATE TABLE template_fields (
    id KSUID PRIMARY KEY DEFAULT idkit_ksuid_generate(),
    template_id KSUID NOT NULL REFERENCES templates(id) ON DELETE CASCADE,
    field_name VARCHAR(100) NOT NULL,
    field_label VARCHAR(200) NOT NULL,
    field_type field_type NOT NULL DEFAULT 'text',
    is_required BOOLEAN NOT NULL DEFAULT FALSE,
    field_order INTEGER NOT NULL DEFAULT 0,
    default_value TEXT,
    placeholder TEXT,
    help_text TEXT,
    validation_rules JSONB DEFAULT '{}',
    options JSONB,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT unique_template_field_name UNIQUE (template_id, field_name)
);

CREATE TRIGGER update_template_fields_updated_at
BEFORE UPDATE ON template_fields
FOR EACH ROW 
EXECUTE FUNCTION update_updated_at_column();

CREATE INDEX idx_template_fields_template_id ON template_fields(template_id);
CREATE INDEX idx_template_fields_order ON template_fields(template_id, field_order);
CREATE INDEX idx_template_fields_validation_rules ON template_fields USING GIN (validation_rules);