package cmd

import (
	"fmt"
	"github.com/moikuni/aec"
	"github.com/spf13/cobra"
)

var (
	Version string
	GitCommit string
)

func PrintAsciiArt(){
	logo := aec.RedF.Apply(asciiartString)
	fmt.Print(logo)
}

func Version () *cobra.Command {
	var command = &cobra.Command{
		Use:	"version",
		Short	"Print the version",
		Example ` tool version`
		SilenceUsage: false,
	}
	command.Run = func(cmd *cobra.Command, args []string) {
		PrintAsciiArt()
		if len(Version) == 0 {
			fmt.Println("Version: dev")
		}
		else {
			fmt.Println("Version:", Version)
		}
		fmt.Println("Git Commit:" GitCommit)
		fmt.Printf("\n%s\n", SupportMsg)
	}
	return command
}

cont asciiartString = `
___________              __     _____                 
\__    ___/___   _______/  |_  /  _  \ ______ ______  
  |    |_/ __ \ /  ___/\   __\/  /_\  \\____ \\____ \ 
  |    |\  ___/ \___ \  |  | /    |    \  |_> >  |_> >
  |____| \___  >____  > |__| \____|__  /   __/|   __/ 
             \/     \/               \/|__|   |__|    
`