package template

import (
	"net/http"

	"github.com/gin-gonic/gin"
	sqlc "github.com/glwbr/pdfgen/internal/db/sqlc"
	"github.com/segmentio/ksuid"
)

type TemplateHandler struct {
	service *TemplateService
}

func NewTemplateHandler(ts *TemplateService) *TemplateHandler {
	return &TemplateHandler{
		service: ts,
	}
}

func RegisterTemplateRoutes(r gin.IRouter, ts *TemplateService) {
	th := NewTemplateHandler(ts)
	th.registerRoutes(r.Group("/templates"))
}

func (h *TemplateHandler) registerRoutes(r gin.IRouter) {
	r.GET("/", h.List)
	r.POST("/", h.Create)
	r.GET("/:id", h.Show)
	r.DELETE("/:id", h.Delete)
	// templates.POST("/:id/generate", middleware.ValidateUserInput(), generationHandler.GenerateFromTemplate)
}

// @Summary Create a new template
// @Description Create a new PDF template with the given parameters
// @Tags Templates
// @Accept json
// @Produce json
// @Param input body db.CreateTemplateParams true "Template creation parameters"
// @Success 201 {object} db.Template "Successfully created template"
// @Failure 400 {object} map[string]string "Invalid request body"
// @Failure 500 {object} map[string]string "Internal server error"
// @Router /api/v1/templates [post]
func (h *TemplateHandler) Create(c *gin.Context) {
	var params sqlc.CreateTemplateParams
	if err := c.ShouldBindJSON(&params); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	template, err := h.service.CreateTemplate(c.Request.Context(), params)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create template"})
		return
	}

	c.JSON(http.StatusCreated, template)
}

// @Summary Get template details
// @Description Get detailed information about a specific template
// @Tags Templates
// @Produce json
// @Param id path string true "Template ID" format(ksuid)
// @Success 200 {object} db.Template "Successfully retrieved template"
// @Failure 400 {object} map[string]string "Invalid ID format"
// @Failure 404 {object} map[string]string "Template not found"
// @Router /api/v1/templates/{id} [get]
func (h *TemplateHandler) Show(c *gin.Context) {
	id, err := ksuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid ID format"})
		return
	}

	template, err := h.service.GetTemplate(c.Request.Context(), id)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "template not found"})
		return
	}

	c.JSON(http.StatusOK, template)
}

// @Summary List all templates
// @Description Get a list of all available templates
// @Tags Templates
// @Produce json
// @Success 200 {array} db.Template "Successfully retrieved templates"
// @Failure 500 {object} map[string]string "Internal server error"
// @Router /api/v1/templates [get]
func (h *TemplateHandler) List(c *gin.Context) {
	templates, err := h.service.ListTemplates(c.Request.Context())
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to list templates"})
		return
	}

	c.JSON(http.StatusOK, templates)
}

func (h *TemplateHandler) Delete(c *gin.Context) {
	id, err := ksuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid ID format"})
		return
	}

	if err := h.service.DeleteTemplate(c.Request.Context(), id); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to delete template"})
		return
	}

	c.Status(http.StatusNoContent)
}
