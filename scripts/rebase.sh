# Show merge-base
git merge-base -a upstream/master HEAD

# list commits that are in master but not in the branch 2016_04_md
git rev-list --left-only upstream/master...2016_04_md

# 351abf9e035581e3320fbb72ec5b1fa452b09c2f