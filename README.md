# Check GitHub Environment Action

This GitHub Action checks if a specified environment exists in the repository and verifies whether protection rules (such as approvals) are configured. It is useful for ensuring environments are properly set up before running further actions, like deploying to production.

## Features
- Checks if the specified environment exists in the repository.
- Verifies if the environment has protection rules configured (like required approvals).
- Fails gracefully with detailed error messages when permissions or setup are missing.

## Inputs

| Name             | Description                                                                 | Required | Default |
|------------------|-----------------------------------------------------------------------------|----------|---------|
| `github_token`   | The GitHub token used to authenticate API requests.                         | `true`   | N/A     |
| `environment_name`| The name of the environment to check (e.g., `production`, `staging`).        | `true`   | N/A     |

## Outputs

This action does not produce any outputs but will fail the workflow if:
- The environment does not exist.
- The environment has no protection rules (such as required approvals).
- The action lacks necessary permissions to read the environment or its rules.

## Example Usage

```yaml
name: Check Environment and Deploy

on:
  push:
    branches:
      - main

permissions:
  actions: read
  contents: read
  deployments: read

jobs:
  check-environment:
    runs-on: ubuntu-latest
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

## Error Handling

The action fails with the following errors:
- **404 Not Found**: If the specified environment does not exist.
- **403 Forbidden**: If the GitHub token provided does not have sufficient permissions to read the environment.
- **No Protection Rules**: If the environment exists but has no protection rules configured.

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
