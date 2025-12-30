package router

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func NewRouter() *mux.Router {
	muxServer := mux.NewRouter()
	InitRoutes(muxServer)
	return muxServer
}

func InitRoutes(muxServer *mux.Router) {
	muxServer.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, World!")
	})
	InitUserRoutes(muxServer)
	InitGameRoutes(muxServer)
}

func InitUserRoutes(muxServer *mux.Router) {

}

func InitGameRoutes(muxServer *mux.Router) {

}
