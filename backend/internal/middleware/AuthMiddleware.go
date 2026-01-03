package middleware

import (
	"MusicNerdle/internal/session"
	"context"
	"net/http"

	"github.com/gorilla/mux"
)

func AuthMiddleware(store *session.SessionStore) mux.MiddlewareFunc {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			// Look for the session cookie
			cookie, err := r.Cookie("session_id")
			if err != nil {
				if err == http.ErrNoCookie {
					http.Error(w, "Missing session cookie", http.StatusUnauthorized)
					return
				}
				http.Error(w, "Error reading session cookie", http.StatusBadRequest)
				return
			}

			token := cookie.Value

			// Check if token is valid
			session, err := store.Check(token)
			if err != nil {
				http.Error(w, "Invalid or expired session", http.StatusUnauthorized)
				return
			}

			ctx := context.WithValue(r.Context(), "userId", session.UserID)
			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}
