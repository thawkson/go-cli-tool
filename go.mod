module example.com/go-cmdline

go 1.15

replace example.com/cmd => ./cmd

require (
	example.com/cmd v0.0.0-00010101000000-000000000000
	github.com/morikuni/aec v1.0.0 // indirect
	github.com/spf13/cobra v1.1.3
)
