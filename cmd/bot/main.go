package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"net/http"
	"os"

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

	if token == "" {
		token = os.Getenv("DISCORD_TOKEN")
		if token == "" {
			fmt.Printf("error discord token not provided via -t arg or DISCORD_TOKEN env var")
			return
		}
	}

	bot, err := domo.NewDomoBot(token, config)
	if err != nil {
		fmt.Printf("error creating bot: %v", err)
		return
	}
	defer bot.Close()

	// Open the channel to start receiving.
	err = bot.Open()
	if err != nil {
		fmt.Printf("error opening bot: %v", err)
		return
	}

	// Implement HTTP health check, which is somewhat required by cloud run.
	port := ":8080"
	if osPort := os.Getenv("PORT"); osPort != "" {
		port = ":" + osPort
	}
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Everything is under control, situation normal. How are you?")
	})
	err = http.ListenAndServe(port, nil)
	if err != nil {
		fmt.Printf("http serving error")
	}

}
