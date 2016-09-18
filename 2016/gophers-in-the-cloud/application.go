package main

import (
	"fmt"
	"github.com/kelseyhightower/envconfig"
	"html"
	"log"
	"net/http"
)

type configuration struct {
	Listen string `default:"5000" envconfig:"http_platform_port"`
}

func main() {
	var cnf configuration
	err := envconfig.Process("", &cnf)
	if err != nil {
		log.Fatal(err.Error())
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		str := fmt.Sprintf("Hi, %q", html.EscapeString(r.URL.Path))
		fmt.Fprintf(w, str)
		log.Println(str)
	})

	http.HandleFunc("/hi", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello, Golang Meetup!")
		log.Println("Hello, Golang Meetup")
	})
	log.Printf("Starting web server on port %s", cnf.Listen)
	log.Fatal(http.ListenAndServe(fmt.Sprintf(":%s", cnf.Listen), nil))
}
