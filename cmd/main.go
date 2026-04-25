package main

import (
	"log"
	"os"
	"time"
)

func main() {
	token := os.Getenv("TELE_TOKEN")
	if token == "" {
		log.Fatal("No TELE_TOKEN")
	}

	log.Println("Bot started")

	for {
		time.Sleep(time.Hour)
	}
}