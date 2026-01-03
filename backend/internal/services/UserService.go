package services

import (
	"MusicNerdle/internal/models"
	"MusicNerdle/internal/session"
	"MusicNerdle/internal/utils"
	"errors"
	"time"

	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
)

type UserService struct {
	db    *gorm.DB
	store *session.SessionStore
}

func NewUserService(db *gorm.DB, session *session.SessionStore) *UserService {
	return &UserService{db: db, store: session}
}

func (service *UserService) CreateUser(createUserDTO *models.CreateUserDTO) error {
	if err := service.db.Where("email = ?", createUserDTO.Email).First(&models.UserModel{}).Error; err == nil {
		return errors.New("email already exists")
	}
	if err := service.db.Where("username = ?", createUserDTO.Username).First(&models.UserModel{}).Error; err == nil {
		return errors.New("username already exists")
	}
	hashedPassword, err := bcrypt.GenerateFromPassword([]byte(createUserDTO.Password), bcrypt.DefaultCost)
	if err != nil {
		return errors.New("failed to hash password")
	}
	user := models.UserModel{
		Username: createUserDTO.Username,
		Email:    createUserDTO.Email,
		Password: string(hashedPassword),
	}
	return service.db.Create(&user).Error
}

func (service *UserService) Login(loginDTO *models.LoginDTO) (*session.Session, error) {
	var user models.UserModel
	if err := service.db.Where("email = ?", loginDTO.Email).First(&user).Error; err != nil {
		return nil, errors.New("invalid email")
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.Password), []byte(loginDTO.Password)); err != nil {
		return nil, errors.New("invalid password")
	}

	session := &session.Session{
		UserID:    user.ID.String(),
		TokenID:   utils.GenerateRandomString(32),
		CreatedOn: time.Now(),
	}

	service.store.Add(session)

	return session, nil
}
