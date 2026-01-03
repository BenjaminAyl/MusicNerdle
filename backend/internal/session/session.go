package session

import (
	"fmt"
	"time"
)

type SessionStore struct {
	store map[string]Session
}

type Session struct {
	UserID    string
	TokenID   string
	CreatedOn time.Time
}

func Init() *SessionStore {
	return &SessionStore{store: make(map[string]Session)}
}

func (s *SessionStore) Add(session *Session) {
	s.store[session.TokenID] = *session
}

func (s *SessionStore) Evict(TokenID string) {
	delete(s.store, TokenID)
}

func (s *SessionStore) Check(tokenID string) (Session, error) {
	sess, ok := s.store[tokenID]
	if !ok {
		return Session{}, fmt.Errorf("session not found")
	}
	return sess, nil
}
