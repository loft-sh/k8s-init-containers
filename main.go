package main

import (
	"fmt"
	"os"
	"time"
)

func main() {
	log("-----------app has started!-----------")
	timeout := time.Second * 600
	end := time.Now().Add(timeout)
	for end.After(time.Now()) {
		log("-----------app is working!-----------")
		time.Sleep(time.Second * 1)
	}
	log("-----------app has finished!-----------")
	os.Exit(0)
}
func log(s string) (int, error) {
	return fmt.Println(os.Args[0], "(", os.Getpid(), ")", time.Now().Format(time.RFC3339), " : ", s)
}
