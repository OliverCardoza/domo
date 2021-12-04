package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"os"
	"os/signal"
	"syscall"

	"github.com/OliverCardoza/domo/domo"
)

var (
	// domo bot's secret token.
	token string
	// path to domo config file
	configFile string
)

func init() {
	flag.StringVar(&token, "t", "", "Bot token")
	flag.StringVar(&configFile, "c", "./config/bot_test.json", "Path to config file")
	flag.Parse()
}

func main() {
	data, err := os.ReadFile(configFile)
	if err != nil {
		fmt.Printf("error reading config file, path: %s, err: %v", configFile, err)
		return
	}
	var config domo.DomoBotConfig
	err = json.Unmarshal(data, &config)
	if err != nil {
		fmt.Printf("error parsing config contents: %v", err)
		return
	}

	bot, err := domo.NewDomoBot(token, config)
	if err != nil {
		fmt.Printf("error creating bot: %v", err)
		return
	}

	// Open the channel to start receiving.
	err = bot.Open()
	if err != nil {
		fmt.Printf("error opening bot: %v", err)
		return
	}

	// Listen for kill command.
	sc := make(chan os.Signal, 1)
	signal.Notify(sc, syscall.SIGINT, syscall.SIGTERM, os.Interrupt, os.Kill)
	<-sc

	// Clean up bot.
	err = bot.Close()
	if err != nil {
		fmt.Printf("error closing bot: %v", err)
	}
}
