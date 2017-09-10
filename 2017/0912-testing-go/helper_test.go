package main

import (
	"io/ioutil"
	"os"
	"testing"
)

func testTempFile(t *testing.T) (*os.File, func()) {

	t.Helper() // marks the calling function as a test helper function

	tf, err := ioutil.TempFile("", "test")
	if err != nil {
		t.Fatalf("rr: %s", err)
	}

	return tf, func() { tf.Close() }
}
