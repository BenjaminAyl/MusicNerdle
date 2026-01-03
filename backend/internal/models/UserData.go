package models

import "github.com/gofrs/uuid"

type UserData struct {
	ID       uuid.UUID `gorm:"type:uuid;primaryKey" json:"userId"`
	Username string    `json:"username"`
}
