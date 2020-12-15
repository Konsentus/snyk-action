# snyk-action

A GitHub action to use Snyk to check project for dependency vulnerabilities

## How to Use

1. Add a new action workflow to your project
2. Add a secret to the Github repo (eg. `SNYK_TOKEN`) and populate with the API token from Snyk
3. Within `jobs.<job_id>.steps` of the action workflow, add a `uses` statement similar to the following (note that the input parameter passed to the action is required).
   ```yml
   - uses: konsentus/snyk-action/python@master
     with:
       ignore: ["SNYK", "VULNERABILITY", "IDS", "TO", "IGNORE"]
     env:
       SNYK_TOKEN: ${{ secrets.SNYK_TOKEN }}
   ```
4. See the relevant action.yml file for additional information for each language.

## Optional Inputs

### localPackages

To handle installation of private repos, paths to local packages which have already been downloaded can be passed into this action with
the localPackages flag.

```yml
  - name: Install SSH Key (for private repo access)
      run: |
        mkdir ~/.ssh && chmod 700 ~/.ssh
        echo "${{ secrets.BOT_SSH_KEY }}" > ~/.ssh/id_rsa && chmod 600 ~/.ssh/id_rsa
        eval $(ssh-agent)
        ssh-add ~/.ssh/id_rsa

  - name: Download private dependencies
        run: |
          git clone git@github.com:Konsentus/lib.activitylogging.python.git
          git clone git@github.com:Konsentus/lib.certificates.git


  - uses: konsentus/snyk-action/python@master
    with:
      localPackages: |
             [lib.activitylogging.python,
              lib.certificates]
      packageFile: requirements-locked.txt
```
