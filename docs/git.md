# diff a whole branch
git difftool --tool=meld --dir-diff $(git merge-base HEAD upstream/master)..

# git diff a single commit with its parent
git diff '6cd21d2f45363e5c97d50ca68050e339808e29f7^!' --color-moved=dimmed-zebra --color-moved-ws=ignore-all-space --word-diff-regex=.