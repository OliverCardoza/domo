#!/bin/bash

go vet ./... &&
go build ./... &&
go test ./...
