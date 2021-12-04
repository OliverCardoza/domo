# domo

domo is a Discord bot to help you manage your FOMO (fear of missing out).

## Development

Download and install Go: [Instructions](https://go.dev/doc/install)

To run the bot first grab the token from the
[bot page](https://discord.com/developers/applications/916474357256171561/bot).
It needs to be included in the run command below:

```bash
go run cmd/bot/main.go -t ${TOKEN_GOES_HERE}
```

This registers the bot to listen for events in the
[Dev Server](https://discord.com/channels/916746698490015744/916746698490015747).
It overrides the default/main `config.json` which is used in the deployed bot.

To run the bot using the main config:

```bash
go run cmd/bot/main.go -t ${TOKEN_GOES_HERE} -c config/bot_main.json
```

## Deployment

First ensure `gcloud` is installed
([Instructions](https://cloud.google.com/sdk/docs/install)):

```bash
# Install ko
go install github.com/google/ko@latest
```

```bash
export KO_DOCKER_REPO=northamerica-northeast2-docker.pkg.dev/domo-334121/domo
gcloud auth configure-docker northamerica-northeast2-docker.pkg.dev
ko publish ./cmd/bot/
```

From there go to the Cloud Run page and push a new instance, selecting latest
image. All of the secrets/configs/run server are manually configured.

## Discord App setup

1. Visit https://discord.com/developers/applications
1. Create a new application
1. Within the app go to "Bot section and create a bot
1. Disable "Public Bot": this prevents random people adding it to their servers
1. Enable "Presence Intent": provides access to view user presence updates

## Add to a Server

Complete the authorization flow by visiting the following link:

* https://discord.com/api/oauth2/authorize?client_id=916474357256171561&permissions=274877910016&scope=bot%20applications.commands

This link identifies the `domo` app id and includes the required permission set:

* Read Messages/View Channels
* Send Messages
* Send Messages in Threads

## Register domo update channel

Each server domo is added to must be added to the domo config. This is
inconvenient but is fine for the initial intent of using this in only a few
servers. It also saves the hassle of integrating a secondary storage system.

Update `cmd/bot/config.json` with the server's `GuildID` and a channel ID
where `domo` has permission to post messages. This channel is where `domo`
will publish its update messages.

## Links

* Deployment Links
  * Discord App: https://discord.com/developers/applications/916474357256171561
  * Cloud Project: https://console.cloud.google.com/home/dashboard?project=domo-334121
* discordgo docs: https://pkg.go.dev/github.com/bwmarrin/discordgo
* Useful Guides
  * [How to run discord bot on cloud run](https://emilwypych.com/2020/10/25/how-to-run-discord-bot-on-cloud-run/)
  * [discord.js introduction](https://discordjs.guide/#before-you-begin)
* Google Cloud docs
  * [Cloud Run Pricing](https://cloud.google.com/run/pricing)
  * [Cloud Run: Build and Deploy Go](https://cloud.google.com/run/docs/quickstarts/build-and-deploy/go)
* Discord API pages
  * [Channel Resource](https://discord.com/developers/docs/resources/channel)
  * [Voice State Object](https://discord.com/developers/docs/resources/voice#voice-state-object)
  * [Permissions](https://discord.com/developers/docs/topics/permissions)
