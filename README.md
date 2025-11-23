# GT


## Git setup
```
# run following command or put it in the batch file in the working durectory to start bash-git from that directory (save some cd command). Note that there is no " at the end
"C:\Program Files\Git\git-bash.exe" --cd=.\
```

[Mosh - Git Tutorial for Beginners](https://www.youtube.com/watch?v=8JJ101D3knE)
```
# setup name and email
git config --global user.name "vtr0"
git config --global user.email "icwt@rocketmail.com"

# set-up new line char (cr+lf in windows and lf in MacOs). In MacOS should set following value of autocrlf to "input" (instead of true)
git config --global core.autocrlf true

# default editor is vsc and git wait for vsc tab to close before continue
git config --global core.editor "code --wait"

# Edit config on editor
git config --global -e
```

## Working with GIT

### Check git status
```
# check status, see if any tracked file modified, on staging area
git status [file_name] [--graph]

# Shows a compact, two-column summary of changes in your repo.
- git status -s 
- git status --short

# Shows the specific changes you've staged in the files.
git diff --staged

# see the log
git log [file_name] [--all] [--graph]

# see remote repository
git remote [-v]
# see remote branch
git branch [-r|-a]
```

### Clone remote repository into local repository
```
# create a local repo
git clone "https://github.com/Vtr0/gt/"
```

### Create new repository with command line
```
# create a local repo
git init
# add README.md to staging area
git add README.md
# remove README.md out of staging area
git reset README.md
# commit to local repository
git commit -m "Initial commit"
# connect with remote repository
git remote add origin "https://github.com/Vtr0/gt"
# push from local repo to remote repo
git push -u origin master #or main
```

### Switch to another branch
```
# create a local branch named "readme"
git branch readme
# switch to branch "readme"
git checkout readme

# these above two commands can be combined into one
git checkout -b <new_branch>
# or more recently
git switch -c <new-branch-name>

# see local and remote branch (-r to see only remote branch)
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
```

### Merge new branch (template branch) to the main branch and delete the template branch
```
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

## Restore a file to a specific previous commit 


```
# First, find the commit hash:
git log -- path/to/file

# ✅ Then restore the file (but keep the change staged). Note that <commit-hash> can be just some few chars of the full hash (say 6 chars):
git restore --source <commit-hash> path/to/file
# This places the old version in your working directory.

# ✅ Restore a file to a previous commit and stage the change
git restore --source=<commit-hash> --staged path/to/file

# After reviewing the restored file, commit it to the remote repository:
git add path/to/file
git commit -m "Revert file to version from <commit-hash>"
# and finally push it into remote repo

# Short-way for above 3 commands:
git commit -am "Your commit message" && git push
```

```
# If you’ve made changes to a file and want to discard those changes, you can restore the file back to its last committed state
git restore <file_name>

# restore a file to the version in a specific commit
git restore --source=<commit_hash> <file_name>

# unstage the file, but the changes to the file will still remain in your working directory
git restore --staged example.txt

# command effectively discards all changes and restores the working directory and staging area to the state of the latest commit
git restore --source=HEAD --staged --worktree .

# interactively choose chunks of the file to restore (similar to git checkout -p or git reset -p)
git restore --source=HEAD --patch <file_name>

# restore a file from a different branch (not the current one)
git restore --source=<branch_name> <file_name>

# similar to old git-checkout, git-reset
```
## Git Youtube resource
[Mosh - Learn Git in 1 Hour](https://www.youtube.com/watch?v=8JJ101D3knE)  
[Tôi Đi Code Dạo](https://www.youtube.com/watch?v=1JuYQgpbrW0) - [Slide](https://docs.google.com/presentation/d/12i4myOgbukiXtX185Kir1qE2SXIpcrd6uik4wJL_KjU/edit?slide=id.p4#slide=id.p4)

### SuperSimpleDev
> [SuperSimpleDev - Git and GitHub - Part 1](https://www.youtube.com/watch?v=hrTQipWp6co)  
> [SuperSimpleDev - Git and GitHub - Part 2](https://www.youtube.com/watch?v=1ibmWyt8hfw) - Deeper on git. Also there is instruction about  Personal Access Token, SSH-key  
> [SuperSimpleDev - Branchng and Merging](https://www.youtube.com/watch?v=Q1kHG842HoI)  
> [SuperSimpleDev - Git cheatsheet - PDF](https://supersimpledev.github.io/references/git-github-reference.pdf)  

### FreeCodeCamp
> [FreeCodeCamp - Crash Course](https://www.youtube.com/watch?v=RGOj5yH7evk)  
> [FreeCodeCamp - Learn Git – Full Course for Beginners](https://www.youtube.com/watch?v=zTjRZNkhiEU)  

[JavaScript Mastery - Visualized Git Course](https://www.youtube.com/watch?v=S7XpTAnSDL4)
# GIT scheme
[ByteByteGo - Git scheme](https://www.youtube.com/watch?v=e9lnsKot_SQ)

![Git scheme and corresponding basic commands](./images/git_merge_rebase_squash.jpg)
![Git pull scheme](./images/git_pull.jpg)
![Git Merge vs Rebase vs Squash](./images/git_merge_rebase_squash.jpg)
# Markdown language
[GIT scheme](https://commonmark.org/help/)