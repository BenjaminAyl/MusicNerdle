package services

import (
	"MusicNerdle/internal/models"

	"gorm.io/gorm"
)

type UserService struct {
	db *gorm.DB
}

func NewUserService(db *gorm.DB) *UserService {
	return &UserService{db: db}
}

func (service *UserService) CreateUser(createUserDTO *models.CreateUserDTO) error {
	user := models.UserModel{
		Username: createUserDTO.Username,
		Email:    createUserDTO.Email,
		Password: createUserDTO.Password,
	}
	return service.db.Create(&user).Error
}
