package integration

import (
	"fmt"
	"os"
	"path/filepath"
	"strings"
	"testing"

	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/gruntwork-io/terratest/modules/test-structure"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestDatadogWebsiteMonitor(t *testing.T) {
	t.Parallel()

	if os.Getenv("DD_API_KEY") == "" || os.Getenv("DD_APP_KEY") == "" || os.Getenv("DD_HOST") == "" {
		t.Skip("DD_API_KEY, DD_APP_KEY, and DD_HOST must be set to run the integration test")
	}

	fixtureDir := test_structure.CopyTerraformFolderToTemp(t, "..", "fixtures/basic")
	uniqueID := strings.ToLower(random.UniqueId())
	moduleDir, err := filepath.Abs("../../datadog_website_monitor")
	require.NoError(t, err)
	tempModuleDir := filepath.Clean(filepath.Join(fixtureDir, "../../../datadog_website_monitor"))
	require.NoError(t, copyDir(moduleDir, tempModuleDir))

	terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: fixtureDir,
		Vars: map[string]interface{}{
			"url":                                  "https://www.vlucaswang.com/",
			"service":                              fmt.Sprintf("engineering-blog-%s", uniqueID),
			"environment":                          "ci",
			"team":                                 "platform",
			"alert_recipients":                     []string{},
			"locations":                            []string{"aws:us-east-2", "aws:eu-west-2"},
			"response_time_warning_threshold_ms":   1500,
			"response_time_critical_threshold_ms":  3000,
			"test_status":                          "paused",
			"extra_tags": map[string]interface{}{
				"test_run": uniqueID,
			},
		},
		NoColor: true,
	})

	defer terraform.Destroy(t, terraformOptions)

	terraform.InitAndApply(t, terraformOptions)

	syntheticTestID := terraform.Output(t, terraformOptions, "synthetic_test_id")
	availabilityMonitorID := terraform.Output(t, terraformOptions, "availability_monitor_id")
	latencyMonitorID := terraform.Output(t, terraformOptions, "latency_monitor_id")
	dashboardURL := terraform.Output(t, terraformOptions, "dashboard_url")

	require.NotEmpty(t, syntheticTestID)
	require.NotEmpty(t, availabilityMonitorID)
	require.NotEmpty(t, latencyMonitorID)
	require.NotEmpty(t, dashboardURL)
	assert.Contains(t, dashboardURL, "/dashboard/")
}

func copyDir(src, dst string) error {
	return filepath.Walk(src, func(path string, info os.FileInfo, err error) error {
		if err != nil {
			return err
		}

		relativePath, err := filepath.Rel(src, path)
		if err != nil {
			return err
		}

		targetPath := filepath.Join(dst, relativePath)

		if info.IsDir() {
			return os.MkdirAll(targetPath, info.Mode())
		}

		sourceFile, err := os.ReadFile(path)
		if err != nil {
			return err
		}

		return os.WriteFile(targetPath, sourceFile, info.Mode())
	})
}
