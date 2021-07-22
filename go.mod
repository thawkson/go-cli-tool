module example.com/go-cmdline

go 1.15

replace example.com/cmd => ./cmd

require (
	example.com/cmd v0.0.0-00010101000000-000000000000
	example.com/pkg/archive v0.0.0-00010101000000-000000000000 // indirect
	example.com/pkg/config v0.0.0-00010101000000-000000000000 // indirect
	github.com/Masterminds/semver v1.5.0 // indirect
	github.com/cheggaaa/pb/v3 v3.0.8 // indirect
	github.com/hashicorp/hcl/v2 v2.10.0 // indirect
	github.com/morikuni/aec v1.0.0 // indirect
	github.com/spf13/cobra v1.1.3
	github.com/zclconf/go-cty v1.8.3 // indirect
)

replace example.com/pkg/config => ./pkg/config

replace example.com/pkg/archive => ./pkg/archive
