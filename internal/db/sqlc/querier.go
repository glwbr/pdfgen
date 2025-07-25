// Code generated by sqlc. DO NOT EDIT.
// versions:
//   sqlc v1.28.0

package db

import (
	"context"

	"github.com/segmentio/ksuid"
)

type Querier interface {
	// Templates
	CreateTemplate(ctx context.Context, arg CreateTemplateParams) (Template, error)
	DeleteTemplate(ctx context.Context, id ksuid.KSUID) error
	GetTemplateByID(ctx context.Context, id ksuid.KSUID) (Template, error)
	GetTemplateWithType(ctx context.Context, id ksuid.KSUID) (GetTemplateWithTypeRow, error)
	ListTemplates(ctx context.Context) ([]Template, error)
	ListTemplatesByType(ctx context.Context, typeID ksuid.KSUID) ([]Template, error)
	UpdateTemplate(ctx context.Context, arg UpdateTemplateParams) (Template, error)
}

var _ Querier = (*Queries)(nil)
