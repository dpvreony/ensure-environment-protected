# Check GitHub Environment Action

This GitHub Action checks if a specified environment exists in the repository and verifies whether protection rules (such as approvals) are configured. It is useful for ensuring environments are properly set up before running further actions, like deploying to production.

## Features
- Checks if the specified environment exists in the repository.
- Verifies if the environment has protection rules configured (like required approvals).
- Optionally checks that the environment has at least one required reviewer configured (enabled by default for "secure first" approach).
- Optionally checks that the environment has prevent self-review enabled.
- Fails gracefully with detailed error messages when permissions or setup are missing.

## Inputs

| Name             | Description                                                                 | Required | Default |
|------------------|-----------------------------------------------------------------------------|----------|---------|
| `github_token`   | The GitHub token used to authenticate API requests.                         | `true`   | N/A     |
| `environment_name`| The name of the environment to check (e.g., `production`, `staging`).        | `true`   | N/A     |
| `require-reviewers`| Check that the environment has at least one required reviewer (secure first).| `false`  | `true`  |
| `require-prevent-self-review`| Check that the environment has prevent self-review enabled.    | `false`  | `false` |

## Outputs

This action does not produce any outputs but will fail the workflow if:
- The environment does not exist.
- The environment has no protection rules (such as required approvals).
- The environment has no required reviewers configured (when `require-reviewers` is `true`, which is the default).
- The environment does not have prevent self-review enabled (when `require-prevent-self-review` is `true`).
- The action lacks necessary permissions to read the environment or its rules.

## Example Usage

### Basic Usage (with default settings)

This will check that the environment exists, has protection rules, and has at least one required reviewer (default behavior):

```yaml
name: Check Environment and Deploy

on:
  push:
    branches:
      - main

jobs:
  check-environment:
    runs-on: ubuntu-latest
    permissions:
      actions: read
      contents: read
      deployments: read
    steps:
      - name: Check if 'production' environment exists and has protection rules
        uses: dpvreony/ensure-environment-protected@main
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          environment_name: 'production'

  deploy:
    needs: check-environment
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to production
        run: echo "Deploying to production environment"
```

### Check for Prevent Self-Review

This example also checks that prevent self-review is enabled:

```yaml
steps:
  - name: Check if 'production' environment has prevent self-review
    uses: dpvreony/ensure-environment-protected@main
    with:
      github_token: ${{ secrets.GITHUB_TOKEN }}
      environment_name: 'production'
      require-prevent-self-review: 'true'
```

### Skip Required Reviewers Check

If you want to only check that protection rules exist without verifying reviewers:

```yaml
steps:
  - name: Check if 'staging' environment has protection rules
    uses: dpvreony/ensure-environment-protected@main
    with:
      github_token: ${{ secrets.GITHUB_TOKEN }}
      environment_name: 'staging'
      require-reviewers: 'false'
```

## Error Handling

The action fails with the following errors:
- **404 Not Found**: If the specified environment does not exist.
- **403 Forbidden**: If the GitHub token provided does not have sufficient permissions to read the environment.
- **No Protection Rules**: If the environment exists but has no protection rules configured.
- **No Required Reviewers Protection Rule**: If the environment has no `required_reviewers` protection rule configured (when `require-reviewers` is `true`, which is the default).
- **No Reviewers Assigned**: If the environment has a `required_reviewers` protection rule but no actual reviewers are assigned to it (when `require-reviewers` is `true`).
- **No Prevent Self-Review**: If the environment does not have prevent self-review enabled (when `require-prevent-self-review` is `true`).

## Permissions

To use this action, ensure that the `GITHUB_TOKEN` or any custom token provided has the following permissions:
- `actions: read`
- `contents: read`
- `deployments: read`

You can configure these permissions explicitly in your workflow file:

```yaml
permissions:
  actions: read
  contents: read
  deployments: read
```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---
