# GT
## Git Test for learning Git command and how to use it
## add one more line for testing readme branch using the pair

### Switch to another branch
```
# create a local branch named "readme"
git branch readme
# switch to branch "readme"
git checkout readme
# see local and remote branch
git branch -a
```
### Adding new file to new branch
```
# add and commit file README.md to local "reame" branch
git add README.md
git commit -m "Working on readme branch"

# create remote branch "readme" and push all files
git push origin readme

# switch to main branch
git checkout main

# pull down the main branch in-case somebody else already update the main branch, so we have the lastest version of main branch
git pull origin main

# check branches that already merged and not merged to current branch, which is "main"
git branch --merged
git branch --no-merged

# merge the "reame" branch to current branch (which is main)
git merge readme

# push to remote repository
git push origin main

# delete local branch "readme"
git branch -d readme

# delete remote branch "readme"
git push origin --delete readme

# see local and remote branch
git branch -a
```