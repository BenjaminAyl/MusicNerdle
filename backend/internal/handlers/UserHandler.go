package handlers

import (
	"MusicNerdle/internal/models"
	"MusicNerdle/internal/services"
	"encoding/json"
	"net/http"
)

type UserHandler struct {
	service *services.UserService
}

func NewUserHandler(userService *services.UserService) *UserHandler {
	return &UserHandler{service: userService}
}

func (handler *UserHandler) SignUp(w http.ResponseWriter, r *http.Request) {
	var createUserDTO models.CreateUserDTO
	err := json.NewDecoder(r.Body).Decode(&createUserDTO)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	handler.service.CreateUser(&createUserDTO)
}
