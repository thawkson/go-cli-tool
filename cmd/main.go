package main

import (
	"os"
	cmd "github.com/thawkson/go-cli-tool/pkg/version"
	"github.com/spf13/cobra"
)

func main() {
	cmdVersion := cmd.BuildVersion()

	PrintAsciiArt := cmd.PrintAsciiArt

	var rootCmd = &cobra.Command{
		Use: "tool",
		Run: func(cmd *cobra.Command, args []string) {
			PrintAsciiArt()
			cmd.Help()
		},
	}

	rootCmd.AddCommand(cmdVersion)
	
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}