package main

import (
	"flag"
	"testing"
)

var integration = flag.Bool("integration", false, "integration")

func TestAdd_OnlyForIntegration(t *testing.T) {
	if !*integration {
		t.Skip("I will not run... It is not integration")
	}
	// test code that interact with real DB/service/queue/etc...
}
