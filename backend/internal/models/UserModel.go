package models

import (
	"time"

	"github.com/gofrs/uuid"
	"gorm.io/gorm"
)

type UserModel struct {
	ID        uuid.UUID `gorm:"primaryKey"`
	Username  string    `gorm:"not null;unique"`
	Email     string    `gorm:"not null;unique"`
	Password  string    `gorm:"not null"`
	CreatedAt time.Time `gorm:"not null"`
	UpdatedAt time.Time `gorm:"not null"`
	UserData  UserData  `gorm:"foreignKey:ID;references:ID;constraint:OnDelete:CASCADE;"`
}

func (user *UserModel) BeforeCreate(tx *gorm.DB) (err error) {
	user.ID = uuid.Must(uuid.NewV4())
	user.CreatedAt = time.Now()
	user.UpdatedAt = time.Now()

	user.UserData.ID = user.ID
	return
}
