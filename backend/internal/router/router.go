package router

import (
	"fmt"
	"net/http"

	"MusicNerdle/internal/db"
	"MusicNerdle/internal/handlers"
	"MusicNerdle/internal/models"
	"MusicNerdle/internal/services"

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
	muxServer.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, World!")
	})
	InitUserRoutes(muxServer, db)
	InitGameRoutes(muxServer)
}

func InitUserRoutes(muxServer *mux.Router, db *gorm.DB) {
	userService := services.NewUserService(db)
	userHandler := handlers.NewUserHandler(userService)
	muxServer.HandleFunc("/signup", userHandler.SignUp).Methods("POST")
}

func InitGameRoutes(muxServer *mux.Router) {

}

func MigrateDB(db *gorm.DB) {
	db.AutoMigrate(&models.UserModel{})
}
