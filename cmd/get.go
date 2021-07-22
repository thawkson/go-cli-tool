package cmd

import (
	"fmt"
	"io"
	"net/http"
	"os"
	"path"
	"strings"

	"github.com/cheggaaa/pb/v3"
	"example.com/pkg/archive"
	"example.com/pkg/config"
	"github.com/pkg/errors"
	"github.com/spf13/cobra"
)

func GetCommand(product string) *cobra.Command {

	var version string
	var destination string

	var command = &cobra.Command{
		Use:          "get",
		Short:        fmt.Sprintf("Download %s on your local machine", strings.Title(product)),
		Long:         fmt.Sprintf("Download %s on your local machine", strings.Title(product)),
		SilenceUsage: true,
	}

	title := strings.Title(product)

	command.Flags().StringVarP(&version, "version", "v", "", fmt.Sprintf("Version of %s to install", title))
	command.Flags().StringVarP(&destination, "dest", "d", expandPath("~/bin"), "Target directory for the downloaded binary")

	command.RunE = func(command *cobra.Command, args []string) error {

		if len(version) == 0 {
			latest, err := config.GetLatestVersion(product)

			if err != nil {
				return errors.Wrapf(err, "unable to get latest version number, define a version manually with the --version flag")
			}

			version = latest
		}

		file, err := downloadFile(config.GetDownloadURL(product, version))

		if err != nil {
			return errors.Wrapf(err, "unable to download %s distribution", title)
		}

		if err := archive.Unzip(file, destination); err != nil {
			return errors.Wrapf(err, "unable to install %s distribution", title)
		}

		return nil
	}

	return command
}

func downloadFile(downloadURL string) (string, error) {
	fmt.Printf("Downloading file %s \n", downloadURL)
	res, err := http.DefaultClient.Get(downloadURL)
	if err != nil {
		return "", err
	}

	if res.Body != nil {
		defer res.Body.Close()
	}

	if res.StatusCode != http.StatusOK {
		return "", fmt.Errorf("incorrect status for downloading %s: %d", downloadURL, res.StatusCode)
	}

	_, fileName := path.Split(downloadURL)
	tmp := os.TempDir()
	outFilePath := path.Join(tmp, fileName)
	wrappedReader := withProgressBar(res.Body, int(res.ContentLength))
	out, err := os.Create(outFilePath)
	if err != nil {
		return "", err
	}

	defer out.Close()
	defer wrappedReader.Close()

	if _, err := io.Copy(out, wrappedReader); err != nil {
		return "", err
	}

	return outFilePath, nil
}

func withProgressBar(r io.ReadCloser, length int) io.ReadCloser {
	bar := pb.Simple.New(length).Start()
	return bar.NewProxyReader(r)
}