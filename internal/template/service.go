package template

import (
	"context"
	"fmt"

	sqlc "github.com/glwbr/pdfgen/internal/db/sqlc"
	"github.com/segmentio/ksuid"
)

type TemplateService struct {
	queries sqlc.Querier
}

func NewTemplateService(queries sqlc.Querier) *TemplateService {
	return &TemplateService{
		queries: queries,
	}
}

func (s *TemplateService) CreateTemplate(ctx context.Context, params sqlc.CreateTemplateParams) (sqlc.Template, error) {
	template, err := s.queries.CreateTemplate(ctx, params)
	if err != nil {
		return sqlc.Template{}, fmt.Errorf("create template: %w", err)
	}
	return template, nil
}

func (s *TemplateService) GetTemplate(ctx context.Context, id ksuid.KSUID) (sqlc.Template, error) {
	template, err := s.queries.GetTemplateByID(ctx, id)
	if err != nil {
		return sqlc.Template{}, fmt.Errorf("failed to get template: %w", err)
	}
	return template, nil
}

func (s *TemplateService) ListTemplates(ctx context.Context) ([]sqlc.Template, error) {
	templates, err := s.queries.ListTemplates(ctx)
	if err != nil {
		return nil, fmt.Errorf("failed to list templates: %w", err)
	}
	return templates, nil
}

func (s *TemplateService) DeleteTemplate(ctx context.Context, id ksuid.KSUID) error {
	if err := s.queries.DeleteTemplate(ctx, id); err != nil {
		return fmt.Errorf("failed to delete template: %w", err)
	}
	return nil
}

func (s *TemplateService) GenerateDocument(templatePath string, data map[string]any) (string, error) {
	return "", nil
}

func (s *TemplateService) GeneratePreview(templatePath string, data map[string]any) ([]byte, error) {
	return nil, nil
}
