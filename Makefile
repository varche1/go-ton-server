ifneq ("$(wildcard .env.local)","")
	include .env.local
	export
endif

NAME := go-ton-server
DIRS := `find ./itests -mindepth 1 -maxdepth 1 -type d`

.PHONY: build
build:
	go build -mod=vendor -o "$(NAME)"

.PHONY: run
run:
	go run main.go

.PHONY: dep
dep:
	go mod vendor

.PHONY: install-bintools
install-bintools:
	GO111MODULE=off
	go get -u github.com/ahmetb/govvv
	go get -u github.com/kyoh86/richgo
	go get -u golang.org/x/tools/cmd/stringer
	go get -u github.com/abice/gencheck/gencheck
	go get -u golang.org/x/tools/cmd/goimports
	go get -u github.com/AlekSi/gocoverutil
	curl -sfL https://install.goreleaser.com/github.com/golangci/golangci-lint.sh | sh -s -- -b $$(go env GOPATH)/bin v1.15.0

.PHONY: lint
lint:
	golangci-lint run

.PHONY: test
test:
	GODEBUG=cgocheck=2 richgo test -coverprofile=coverage_unit.out -cover -v `(go list ./... | grep -Ev '(logger|itests)')`
	go tool cover -html=coverage_unit.out -o coverage_unit.html

.PHONY: gofmt
fmt:
	gofmt -l .

.PHONY: bench
bench:
	go test -v -bench=. -benchmem `(go list ./... | grep -Ev '(logger|itests)')`
