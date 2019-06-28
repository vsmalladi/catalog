#!/usr/bin/env bash

## deploy.sh: run during a Travis CI build to deploy output directory to the gh-pages branch on GitHub.
## References
## - https://github.com/manubot/rootstock/blob/ddb0288895cd5bc5dab117fb366c52216a717d0e/ci/deploy.sh
## - https://github.com/wp-cli/wp-cli/issues/3798

# Configure git
git config --global push.default simple
git config --global user.name "Travis CI"
git config --global user.email "travis@travis-ci.com"
git checkout "$TRAVIS_BRANCH"
git remote set-url origin "git@github.com:$TRAVIS_REPO_SLUG.git"

# Ensure command traces are disabled while dealing with the private key
set +o xtrace
echo -e $GITHUB_DEPLOY_PRIVATE_KEY > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

commit_message="\
Generate catalog output on $(date --iso --utc)

built by $TRAVIS_JOB_WEB_URL
based on https://github.com/$TRAVIS_REPO_SLUG/commit/$TRAVIS_COMMIT

[skip ci]
"
echo >&2 commit_message

ghp-import \
  --push --no-jekyll \
  --message="$commit_message" \
  output
