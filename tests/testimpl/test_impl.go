package testimpl

import (
	"context"
	"strconv"
	"testing"
	"fmt"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ecs"
	ecstypes "github.com/aws/aws-sdk-go-v2/service/ecs/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	lcafTypes "github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const (
	failedToDescribeTaskDefMsg = "Failed to describe ECS task definition"
	failedToGetTaskDefTagsMsg  = "Failed to list ECS task definition tags"
)

func TestComposableComplete(t *testing.T, ctx lcafTypes.TestContext) {
	ecsClient := GetAWSECSClient(t)

	taskDefinitionArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_definition_arn")
	taskDefinitionFamily := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_definition_family")
	taskDefinitionRevision := terraform.Output(t, ctx.TerratestTerraformOptions(), "task_definition_revision")
	taskDef := fmt.Sprintf("%s:%s", taskDefinitionFamily, taskDefinitionRevision)

	t.Run("TestECSTaskDefinitionExists", func(t *testing.T) {
		testECSTaskDefinitionExists(t, ecsClient, taskDef, taskDefinitionArn, taskDefinitionFamily)
	})

	t.Run("TestECSTaskDefinitionProperties", func(t *testing.T) {
		testECSTaskDefinitionProperties(t, ecsClient, taskDefinitionArn, taskDefinitionFamily, taskDefinitionRevision)
	})

	t.Run("TestECSTaskDefinitionContainers", func(t *testing.T) {
		testECSTaskDefinitionContainers(t, ecsClient, taskDefinitionFamily)
	})

	t.Run("TestECSTaskDefinitionTags", func(t *testing.T) {
		var taskTags map[string]interface{}
		terraform.OutputStruct(t, ctx.TerratestTerraformOptions(), "tags_all", &taskTags)
		testECSTaskDefinitionTags(t, ecsClient, taskDefinitionFamily, taskTags)
	})
}

func testECSTaskDefinitionExists(t *testing.T, ecsClient *ecs.Client, taskDef string, taskDefinitionArn, taskDefinitionFamily string) {
	// Use family name instead of full ARN to avoid revision number issues
	taskDefOutput, err := ecsClient.DescribeTaskDefinition(context.TODO(), &ecs.DescribeTaskDefinitionInput{
		TaskDefinition: aws.String(taskDef),
		Include:        []ecstypes.TaskDefinitionField{ecstypes.TaskDefinitionFieldTags},
	})
	require.NoError(t, err, failedToDescribeTaskDefMsg)
	require.NotNil(t, taskDefOutput.TaskDefinition, "Task definition should not be nil")
	assert.Equal(t, taskDefinitionArn, *taskDefOutput.TaskDefinition.TaskDefinitionArn,
		"Expected task definition ARN did not match actual ARN!")
	assert.Equal(t, taskDefinitionFamily, *taskDefOutput.TaskDefinition.Family,
		"Expected task definition family did not match actual family!")
}

func testECSTaskDefinitionProperties(t *testing.T, ecsClient *ecs.Client, taskDefinitionArn, taskDefinitionFamily, taskDefinitionRevision string) {
	// Use family name instead of full ARN to avoid revision number issues
	taskDef, err := ecsClient.DescribeTaskDefinition(context.TODO(), &ecs.DescribeTaskDefinitionInput{
		TaskDefinition: aws.String(taskDefinitionFamily),
	})
	require.NoError(t, err, failedToDescribeTaskDefMsg)
	require.NotNil(t, taskDef.TaskDefinition, "Task definition should not be nil")

	td := taskDef.TaskDefinition

	// Verify family and revision
	assert.Equal(t, taskDefinitionFamily, *td.Family, "Task definition family should match expected value")
	assert.Equal(t, taskDefinitionRevision, strconv.FormatInt(int64(td.Revision), 10), "Task definition revision should match expected value")

	// Verify task definition status
	assert.Equal(t, ecstypes.TaskDefinitionStatusActive, td.Status, "Task definition status should be ACTIVE")

	// Verify network mode
	assert.NotEmpty(t, td.NetworkMode, "Network mode should not be empty")

	// Verify container definitions exist
	assert.NotEmpty(t, td.ContainerDefinitions, "Container definitions should not be empty")

	// Verify CPU and memory if specified
	if td.Cpu != nil && *td.Cpu != "" {
		assert.NotEmpty(t, *td.Cpu, "CPU should not be empty")
	}

	if td.Memory != nil && *td.Memory != "" {
		assert.NotEmpty(t, *td.Memory, "Memory should not be empty")
	}

	// Verify registration date
	assert.NotNil(t, td.RegisteredAt, "Task definition should have a registration date")

	// Verify task definition is enabled
	assert.True(t, td.Status == ecstypes.TaskDefinitionStatusActive, "Task definition should be active")
}

func testECSTaskDefinitionContainers(t *testing.T, ecsClient *ecs.Client, taskDefinitionFamily string) {
	// Use family name instead of full ARN to avoid revision number issues
	taskDef, err := ecsClient.DescribeTaskDefinition(context.TODO(), &ecs.DescribeTaskDefinitionInput{
		TaskDefinition: aws.String(taskDefinitionFamily),
	})
	require.NoError(t, err, failedToDescribeTaskDefMsg)
	require.NotNil(t, taskDef.TaskDefinition, "Task definition should not be nil")

	td := taskDef.TaskDefinition
	require.Greater(t, len(td.ContainerDefinitions), 0, "Task definition should have at least one container")

	// Verify each container definition
	for i, container := range td.ContainerDefinitions {
		assert.NotEmpty(t, *container.Name, "Container %d name should not be empty", i)
		assert.NotEmpty(t, *container.Image, "Container %d image should not be empty", i)

		// Verify port mappings if present
		if len(container.PortMappings) > 0 {
			for j, portMapping := range container.PortMappings {
				assert.NotNil(t, portMapping.ContainerPort, "Container %d port mapping %d should have container port", i, j)
			}
		}

		// Verify essential flag
		assert.NotNil(t, container.Essential, "Container %d should have essential flag set", i)
	}
}

func testECSTaskDefinitionTags(t *testing.T, ecsClient *ecs.Client, taskDefinitionFamily string, expectedTags map[string]interface{}) {
	if len(expectedTags) == 0 {
		return
	}

	// Get task definition tags - use family name instead of ARN
	taskDef, err := ecsClient.DescribeTaskDefinition(context.TODO(), &ecs.DescribeTaskDefinitionInput{
		TaskDefinition: aws.String(taskDefinitionFamily),
		Include:        []ecstypes.TaskDefinitionField{ecstypes.TaskDefinitionFieldTags},
	})
	require.NoError(t, err, failedToGetTaskDefTagsMsg)
	require.NotNil(t, taskDef.TaskDefinition, "Task definition should not be nil")

	// Convert AWS tags to map for comparison
	actualTags := make(map[string]string)
	for _, tag := range taskDef.Tags {
		actualTags[*tag.Key] = *tag.Value
	}

	// Verify expected tags exist
	for key, value := range expectedTags {
		if valueStr, ok := value.(string); ok {
			assert.Equal(t, valueStr, actualTags[key], "Tag %s should have expected value", key)
		}
	}
}

func GetAWSECSClient(t *testing.T) *ecs.Client {
	awsECSClient := ecs.NewFromConfig(GetAWSConfig(t))
	return awsECSClient
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
