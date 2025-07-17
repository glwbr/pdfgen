-- Templates
-- name: CreateTemplate :one
INSERT INTO templates (name, type_id, file_path, is_active)
VALUES ($1, $2, $3, $4)
RETURNING *;

-- name: ListTemplates :many
SELECT * FROM templates
WHERE is_active = true
ORDER BY name;

-- name: GetTemplateByID :one
SELECT * FROM templates WHERE id = $1;

-- name: GetTemplateWithType :one
SELECT t.*, dt.name as type_name, dt.category
FROM templates t
JOIN document_types dt ON t.type_id = dt.id
WHERE t.id = $1;

-- name: ListTemplatesByType :many
SELECT * FROM templates
WHERE type_id = $1 AND is_active = true
ORDER BY name;

-- name: UpdateTemplate :one
UPDATE templates
SET name = $2, type_id = $3, file_path = $4, is_active = $5
WHERE id = $1
RETURNING *;

-- name: DeleteTemplate :exec
UPDATE templates SET is_active = false WHERE id = $1;
