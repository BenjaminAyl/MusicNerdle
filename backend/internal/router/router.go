package router

import (
	"fmt"
	"net/http"

	"MusicNerdle/internal/db"
	"MusicNerdle/internal/handlers"
	"MusicNerdle/internal/models"
	"MusicNerdle/internal/services"
	"MusicNerdle/internal/session"

	"github.com/gorilla/mux"
	"gorm.io/gorm"
)

func NewRouter() *mux.Router {
	muxServer := mux.NewRouter()
	InitRoutes(muxServer)
	return muxServer
}

func InitRoutes(muxServer *mux.Router) {
	db := db.Connect()
	MigrateDB(db)
	session := session.Init()
	muxServer.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, World!")
	})
	InitUserRoutes(muxServer, db, session)
	InitGameRoutes(muxServer)
}

func InitUserRoutes(muxServer *mux.Router, db *gorm.DB, session *session.SessionStore) {
	userService := services.NewUserService(db, session)
	userHandler := handlers.NewUserHandler(userService)
	muxServer.HandleFunc("/signup", userHandler.SignUp).Methods("POST")
	muxServer.HandleFunc("/login", userHandler.Login).Methods("POST")
}

func InitGameRoutes(muxServer *mux.Router) {

}

func MigrateDB(db *gorm.DB) {
	db.AutoMigrate(&models.UserModel{})
}
