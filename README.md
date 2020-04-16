# snyk-action

A GitHub action to use Snyk to check project for dependency vulnerabilities

## How to Use

1. Add a new action workflow to your project
2. Add a secret to the Github repo (eg. `SNYK_TOKEN`) and populate with the API token from Snyk
3. Within `jobs.<job_id>.steps` of the action workflow, add a `uses` statement similar to the following (note that the input parameter passed to the action is required).
   ```yml
   - uses: konsentus/snyk-action/python@master
     with:
       ignore: ['SNYK', 'VULNERABILITY', 'IDS', 'TO', 'IGNORE']
     env:
       SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
   ```
4. See the relevant action.yml file for additional information for each language.
