package main

import "testing"

// START OMIT
import "github.com/Shopify/sarama"

var newAP = sarama.NewAsyncProducer

func Func() error {
	producer, _ := newAP([]string{"127.0.0.1:9092"}, &sarama.Config{})
	// some actions with producer...
	return nil
}

func TestFunc(t *testing.T) {
	originalNewAsyncProducer := newAP
	defer func() { newAP = originalNewAsyncProducer }()
	newAP = func(addrs []string, conf *sarama.Config) (sarama.AsyncProducer, error) {
		return MockAP{}, nil
	}
}

// END OMIT
