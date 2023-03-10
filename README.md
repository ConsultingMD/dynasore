# Dynasore

Supports configuration of DynamoDB tables using a `.yml` file, including
a method for giving individual developer and test environments their own
tables within a single AWS account.

Also adds methods for declaring "binary" attributes: arbitrary base64-encoded blobs.

# Adding to your Rails project


# Development


# Testing

rspec for the win


## How to Create a Release

Releases happen in CircleCI when a tag is pushed to the repository.

To create a release, you will need to do the following:

1. Change the version in `lib/dynasore/version.rb` to the new version and create a PR with the change.
1. Once the PR is merged, switch to the master branch and `git pull`.
1. `git tag <version from version.rb>`
1. `git push origin --tags`

CircleCI will see the tag push, build, and release a new version of the library.
