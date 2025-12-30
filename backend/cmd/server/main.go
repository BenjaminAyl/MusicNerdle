package main

import (
	"MusicNerdle/internal/router"
	"net/http"
)

func main() {
	server := router.NewRouter()

	http.ListenAndServe(":8080", server)
}
