package config

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"

	"gopkg.in/yaml.v2"
)

var Config config

func Load(filePath string) error {
	Config = config{}

	if _, err := os.Stat(filePath); os.IsNotExist(err) {
		return fmt.Errorf("Config file not found")
	}

	configContent, err := ioutil.ReadFile(filepath.Clean(filePath))
	if err != nil {
		return err
	}

	err = yaml.Unmarshal([]byte(os.ExpandEnv(string(configContent))), &Config)
	if err != nil {
		return fmt.Errorf("Error parsing config file: %s", err)
	}

	return nil
}
