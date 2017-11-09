package main

import (
	"database/sql"
)

// START OMIT
type app struct {
	db sql.DB
}

func (a *app) GetUser(id int64) (*User, error) {
	return a.db.Query("SELECT * FROM User WHERE ID=?", id)
}

// END OMIT
