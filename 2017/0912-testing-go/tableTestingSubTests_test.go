package main

import "testing"

func TestAdd_Sub(t *testing.T) {
	cases := []struct {
		Name           string
		A, B, Expected int
	}{
		{"Positive values", 1, 1, 2},
		{"Positive with negative", 1, -1, 0},
		{"Positive with zero", 1, 0, 1},
		{"Zeros", 0, 0, 1}, // <--- !!!ERROR!!!
	}

	for _, tc := range cases {
		tc := tc // To avoid data race
		t.Run(tc.Name, func(t *testing.T) {
			t.Parallel()
			actual := Add(tc.A, tc.B)
			if actual != tc.Expected {
				t.Errorf("%d + %d = %d, expected %d", tc.A, tc.B, actual, tc.Expected)
			}
		})
	}
}
