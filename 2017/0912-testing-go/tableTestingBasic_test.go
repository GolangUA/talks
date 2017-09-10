package main

import "testing"

func TestAdd_Basic(t *testing.T) {
	cases := []struct{ A, B, Expected int }{
		{1, 1, 2},
		{1, -1, 0},
		{1, 0, 1},
		{0, 0, 0},
	}

	for _, tc := range cases {
		actual := Add(tc.A, tc.B)
		if actual != tc.Expected {
			t.Errorf("%d + %d = %d, expected %d", tc.A, tc.B, actual, tc.Expected)
		}
	}
}
