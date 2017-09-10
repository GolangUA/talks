package main

import (
	"github.com/Shopify/sarama"
	"github.com/bsm/sarama-cluster"
)

type consumerI interface {
	Close() error
	Messages() <-chan *sarama.ConsumerMessage
	Errors() <-chan error
}

func newConsumerProxy(a []string, id string, t []string, cfg *cluster.Config) (consumerI, error) {
	consumer, err := cluster.NewConsumer(a, id, t, cfg)
	return consumerI(consumer), err
}
