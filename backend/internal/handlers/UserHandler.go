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
	if err := handler.service.CreateUser(&createUserDTO); err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	w.WriteHeader(http.StatusCreated)
	w.Write([]byte("User created successfully"))
}

func (handler *UserHandler) Login(w http.ResponseWriter, r *http.Request) {
	var loginDTO models.LoginDTO
	err := json.NewDecoder(r.Body).Decode(&loginDTO)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
	}
	session, err := handler.service.Login(&loginDTO)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	}

	http.SetCookie(
		w,
		&http.Cookie{
			Name:     "session_id",
			Value:    session.TokenID,
			Path:     "/",
			HttpOnly: true,
			Secure:   false,
			SameSite: http.SameSiteLaxMode,
		},
	)
}
