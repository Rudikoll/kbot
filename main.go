package main

import (
	"log"
	"os"

	telebot "gopkg.in/telebot.v3"
)

func main() {
	token := os.Getenv("TELE_TOKEN")
	if token == "" {
		log.Fatal("TELE_TOKEN is not set")
	}

	pref := telebot.Settings{
		Token: token,
	}

	bot, err := telebot.NewBot(pref)
	if err != nil {
		log.Fatal(err)
	}

	bot.Handle("/start", func(c telebot.Context) error {
		return c.Send("Hello! I am kbot.")
	})

	bot.Handle("/hello", func(c telebot.Context) error {
		return c.Send("Hello, " + c.Sender().FirstName + "!")
	})

	log.Println("kbot started...")
	bot.Start()
}
