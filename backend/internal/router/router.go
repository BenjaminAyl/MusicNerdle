package router

import (
	"fmt"
	"net/http"

	"MusicNerdle/internal/db"
	"MusicNerdle/internal/handlers"
	"MusicNerdle/internal/middleware"
	"MusicNerdle/internal/models"
	"MusicNerdle/internal/services"
	"MusicNerdle/internal/session"

	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

func NewRouter() *mux.Router {
	muxServer := mux.NewRouter()
	db := db.Connect()
	MigrateDB(db)
	session := session.Init()
	muxServer.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, World!")
	})
	userService := services.NewUserService(db, session)
	userHandler := handlers.NewUserHandler(userService)
	muxServer.HandleFunc("/signup", userHandler.SignUp).Methods("POST")
	muxServer.HandleFunc("/login", userHandler.Login).Methods("POST")

	api := muxServer.PathPrefix("/api").Subrouter()
	api.Use(middleware.AuthMiddleware(session))
	api.HandleFunc("/me", userHandler.Me)

	return muxServer
}

func MigrateDB(db *gorm.DB) {
	db.AutoMigrate(&models.UserModel{}, &models.UserData{})
}
