package main

import (
	"os"
	"cmd"
	"github.com/spf13/cobra"
)

func main() {
	cmdVersion := cmd.Version()

	PrintAsciiArt := cmd.PrintAsciiArt

	var rootCmd = &cobra.Command{
		Use: "tool",
		Run: func(cmdn *cobra.Command, args []string) {
			PrintAsciiArt()
		}
	},
	rootCmd.AddCommand(cmdVersion)
	if err := rootCmd.Execute(); err != nil {
		os.Exit(1)
	}
}