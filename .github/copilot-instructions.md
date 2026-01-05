# Copilot Instructions for ensure-environment-protected

## Repository Overview

This repository contains a GitHub composite action that validates GitHub environment configurations. The action checks whether a specified environment exists and has proper protection rules configured, including required reviewers and prevent self-review settings.

## Key Technical Details

- **Action Type**: GitHub composite action (not a container or JavaScript action)
- **Primary Language**: PowerShell (used in the composite action steps)
- **Action File**: `action.yml` - defines inputs, outputs, and execution steps
- **Execution Environment**: Runs on GitHub-hosted runners using `pwsh` shell

## Code Style and Conventions

### PowerShell Script Conventions
- Use PascalCase for variables (e.g., `$protectionRules`, `$requireReviewers`)
- Use environment variables for input parameters (accessed via `$env:` prefix)
- Include comprehensive error handling with try-catch blocks
- Provide clear, actionable error messages
- Use `Write-Host` for console output
- Exit with code 1 on errors, 0 on success

### Action Definition (action.yml)
- Follow GitHub Actions metadata syntax v1
- Use clear, descriptive names for inputs and outputs
- Set sensible defaults for optional inputs
- Use composite action structure with explicit shell declarations
- Map inputs to environment variables using `${{ inputs.* }}` syntax

## Testing and Validation

### CI Workflow
- The repository includes a CI workflow (`.github/workflows/ci.yml`)
- The CI workflow tests the action itself by checking a 'ci' environment
- Tests run on push to main and on pull requests

### Manual Testing
To test changes to the action:
1. Create or use an existing GitHub environment in the repository settings
2. Update the CI workflow or create a test workflow that uses the action
3. Push changes and verify the action behaves as expected

## API Integration

- Uses GitHub REST API: `https://api.github.com/repos/{owner}/{repo}/environments/{environment}` (where `{owner}/{repo}` is the repository full name like `dpvreony/ensure-environment-protected`)
- Requires authentication via GitHub token
- Needs specific permissions: `actions: read`, `contents: read`, `deployments: read`

## Security and Permissions

### Required Permissions
Workflows using this action must declare:
```yaml
permissions:
  actions: read
  contents: read
  deployments: read
```

### Input Validation
- Validate that required inputs (github_token, environment_name) are provided
- Handle API errors gracefully (403 Forbidden, 404 Not Found)

## Common Modification Patterns

### Adding New Checks
When adding new environment validation checks:
1. Add a new input to `action.yml` with appropriate description and default
2. Add corresponding environment variable mapping in the `env:` section
3. Parse the environment variable in the PowerShell script
4. Extract relevant data from the API response (`$response.protection_rules`)
5. Implement validation logic with clear error messages
6. Update the README.md with new input documentation

### Modifying Protection Rule Checks
- Protection rules are accessed via `$response.protection_rules`
- Use `Where-Object` to filter rules by type (e.g., `type -eq 'required_reviewers'`)
- Check rule properties (e.g., `reviewers`, `prevent_self_review`)
- Provide specific error messages for each validation failure

## Documentation Standards

- Keep README.md synchronized with action.yml inputs/outputs
- Include usage examples for common scenarios
- Document all permissions requirements
- Explain error conditions and how to resolve them
- Use tables for input/output documentation

## Action Publishing

- This is a public action that can be referenced as `dpvreony/ensure-environment-protected@main`
- Breaking changes should be communicated clearly
- Consider semantic versioning for major releases

## Best Practices for Contributors

1. **Minimal Changes**: Make surgical, focused changes that address specific issues
2. **Error Handling**: Always include proper error handling for new API calls or validations
3. **Security First**: Default to secure settings (e.g., `require-reviewers` defaults to `true`)
4. **Backward Compatibility**: Avoid breaking changes to existing inputs/outputs
5. **Testing**: Test against real GitHub environments before committing
6. **Documentation**: Update README.md whenever action.yml changes
