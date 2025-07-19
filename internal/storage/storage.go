package storage

type Storage interface {
	Read(path string) ([]byte, error)
	Write(path string, data []byte) error
	Exists(path string) bool
	Delete(path string) error
	GetURL(path string) (string, error)
}
