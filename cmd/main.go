package main

import (
	"log"
	"os"
)

func main() {
	token := os.Getenv("TELE_TOKEN")
	if token == "" {
		log.Fatal("No TELE_TOKEN")
	}

	log.Println("Bot started")
}
