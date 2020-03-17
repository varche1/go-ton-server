package main

import (
	tonlib "github.com/mercuryoio/tonlib-go/v2"
	_ "github.com/mercuryoio/tonlib-go/v2/lib"
)

func main() {
	options, err := tonlib.ParseConfigFile("./tonlib.config.json")
	if err != nil {
		panic(err)
	}

	// make req
	req := tonlib.TonInitRequest{
		"init",
		*options,
	}

	_, err = tonlib.NewClient(
		&req,            // init request
		tonlib.Config{}, // config
		10,              // timeout in seconds for each (currently only QueryEstimateFees) tonlib.Client`s public method
		true,            // enable client`s logs
		9,               // logging level in ton lib.
	)
	if err != nil {
		panic(err)
	}
	//defer tonClient.Destroy()
}
