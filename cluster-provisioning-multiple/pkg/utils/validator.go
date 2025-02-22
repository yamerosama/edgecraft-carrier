package utils

import (
	"bytes"
	"fmt"
	"os"
	"strings"

	"github.com/spf13/cobra"
)

func CheckCommand(cmd *cobra.Command) error {
	cmdCheck := cmd.Commands()

	if len(os.Args[1:]) == 0 {
		fmt.Println("Error: unknown command, Run 'koreonctl --help' for usage.")
		os.Exit(1)
	}

	if os.Args[1] == cmd.Name() {
		if len(os.Args[1:]) < 2 {
			if cmd.Name() == "init" {
				return nil
			}
			if cmd.Name() == "bastion" {
				return nil
			}
			args := append([]string{"koreonctl"}, os.Args[1:]...)
			buf := new(bytes.Buffer)
			cmd.SetErr(buf)
			fmt.Println("Error: unknown command", args)
			fmt.Printf("Run 'koreonctl %s --help' for usage.", cmd.Name())
			os.Exit(1)
		}
		subcmd := os.Args[2]
		for _, cv := range cmdCheck {
			if cv.Name() == subcmd {
				return nil
			}
		}

		for _, cv := range cmdCheck {
			if cv.Name() != subcmd && string(subcmd[0]) != "-" {
				strContains := ""
				errMessage := ""
				for _, v := range cmdCheck {
					if strings.Contains(v.Name(), subcmd) {
						strContains = v.Name()
						break
					}
				}
				args := append([]string{"koreonctl"}, os.Args[1:]...)
				buf := new(bytes.Buffer)
				cmd.SetErr(buf)
				fmt.Println("Error: unknown command", args)
				if strContains != "" {
					errMessage = fmt.Sprintf("Did you mean this?\n\t%s\n\nRun 'koreonctl %s --help' for usage.", strContains, cmd.Name())
				} else {
					errMessage = fmt.Sprintf("Run 'koreonctl %s --help' for usage.", cmd.Name())
				}
				fmt.Println(errMessage)
				os.Exit(1)
			}
		}
	}

	return nil
}
