# snyk-action

A GitHub action to use Snyk to check project for dependency vulnerabilities

## How to Use
1. Add a new action to your project
2. Add a job step to use konsentus/synk-action@master
3. Add an env var called SNYK_TOKEN to step and set to ${{secrets.SNYK_TOKEN}}
4. Add a secret to the Github repo called SNYK_TOKEN and populate with the API token from Snyk.
