# GitHub Action for Hetzner Cloud Self-Hosted Runners

Fork of https://github.com/marketplace/actions/hetzner-cloud-self-hosted-runner-for-github-ci
Only difference is that will skip the deregistration/delete of runner.

## Usage

1. Bootstrap your CI job to create a new hetzner instance:

```yaml
jobs:
  prepare_env:
    runs-on: ubuntu-latest
    name: Create new Hetzner Cloud instance for build
    steps:
      - uses: stonemaster/hetzner-github-runner@HEAD
        with:
          github-api-key: ${{ secrets.GH_API_KEY }}
          hetzner-api-key: ${{ secrets.HETZNER_API_KEY }}
          hetzner-instance-type: cx11
```

2. After this step another workflow can run on this self-hosted machine. Note
   that this job depends on `prepare_env`:

```yaml
jobs:
  [...]
  actual_build:
    runs-on: self-hosted
    needs: prepare_env
    steps:
      - run: env
        shell: bash
```

## Security & Required Keys

**Never put the tokens into clear-text but use the Repository
[secrets feature](XXX) of the GitHub CI**

* The GitHub API Key provided should just have _read/write_ permission to
the *Repository Administration*. This is needed to obtain a new registration
token for your repository that is needed by the GitHub runner.
* A Hetzner API key needs to be generated for your project according to the
[offical documentation](https://docs.hetzner.cloud/#getting-started).
