package main

import (
	"log"
	"net/http"
)

func main() {
	// Logging middleware
	logging := func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			log.Printf("%s %s %s", r.RemoteAddr, r.Method, r.URL)
			next.ServeHTTP(w, r)
		})
	}

	// Serve static files (like resume.pdf)
	fs := http.FileServer(http.Dir("static"))
	http.Handle("/static/", logging(http.StripPrefix("/static/", fs)))

	// Serve the main HTML page
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		log.Printf("Serving index.html to %s", r.RemoteAddr)
		http.ServeFile(w, r, "index.html")
	})

	// health check endpoint
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
		w.Write([]byte("OK"))
	})

	// Start the server
	log.Println("Starting server on :8080...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}
