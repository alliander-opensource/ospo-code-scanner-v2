<!--
SPDX-FileCopyrightText: Copyright contributors to the OSPO Code Scanner project
SPDX-License-Identifier: Apache-2.0
-->

# How to contribute

We welcome your contributions to this project.
Follow these guidelines when submitting changes.

## Ways of contributing

You can contribute in many ways, not just by writing code.
We recognize the following types of contributions:

1. Use and test the project. Share feedback and suggest new features.
2. Report bugs or security vulnerabilities.
3. Fix bugs.
4. Develop new features and help improve the project.


## Bugs, security vulnerability or feature requests

Use GitHub Issues to report bugs or request new features. Consult [Creating an issue](https://docs.github.com/en/free-pro-team@latest/github/managing-your-work-on-github/creating-an-issue) for more  information.
If you need help creating an issue, see the GitHub documentation.
If you discover a potential security vulnerability, follow the [Security](SECURITY.md) guidelines.

## Community guidelines

This project follows the following [Code of Conduct](CODE_OF_CONDUCT.md).

## REUSE compliance and source code headers

All files in the repository must be [REUSE compliant](https://reuse.software/).
Our pipeline automatically checks this requirement. If a file is not compliant, the pipeline will fail and the pull request is not merged.
All source code files must include copyright and license information. This also applies to JavaScript and CSS files.
Each new source code file, must contain the following header.

```text
SPDX-FileCopyrightText: 'Copyright contributors to the OSPO Code Scanner project'
SPDX-License-Identifier: Apache-2.0
```

## Git branching

This project uses the [Gitflow Workflow](https://www.atlassian.com/git/tutorials/comparing-workflows/gitflow-workflow) and branching model.
The `main` branch always has the latest release.
After a release, developers create new feature branches from the `develop` branch.
When a feature finishes, it merges back into `develop`.
At the end of development cycle, `develop` merges back into `main` or (optional) into a `release` branch first before merging into `main`.

## Developer certificate of origin (DCO)

This project uses a Developer Certificate of Origin (DCO).
It ensures that contributors can legally submit their changes.
Specifically, the project uses [Developer Certificate of Origin, Version 1.1](http://developercertificate.org/).
This process is the same process that the Linux® kernel and many other communities use to manage code contributions.
The DCO is one of the simplest ways to collect contributor sign-offs.
Contributors add a sign-off to their commit message.

This means that each contributor signs a commit off using the following statement:

`Signed-off-by: John Doe <john.doe@alliander.com>`

The project requires that the name used is your real name and the email used is your real email.
Usage of anonymous contributions and usage of pseudonyms is not accepted.

Several tools can help you add DCO sign-offs automatically:

When using Git, add the sign-off with the `-s` or `--signoff` option when creating a commit.
Make sure to correctly configure `user.name` and `user.email`.
If you create commits in the GitHub web interface, your organization or repository administrator might be able to enable automatic sign-offs, visit [Github UI automatic sign-off capabilities](https://github.blog/changelog/2022-06-08-admins-can-require-sign-off-on-web-based-commits/) for more information.
You can also automate sign-offs by using Git hooks or shell scripts.

## Code reviews

All patches and contributions.
The project requires a review by one of the project maintainers for each contribution.
We use GitHub pull requests for this purpose.
Consult [GitHub Help](https://help.github.com/articles/about-pull-requests/) for more information about pull requests.

## Pull request process
Submit contributions as pull requests. Visit [Creating a pull request](https://docs.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) for more information about this concept.

The process for a code change and pull request you should follow:

1. Create a topic branch in your local repository, following the naming format "feature-[description]".
   For more information read the Git branching guideline.
2. Make changes, compile, and test thoroughly.
   Remove any install or build dependencies before the end of the layer when doing a build.
   Code style should match existing style and conventions.
   Changes should address the topic of the pull request.
3. Push commits to your fork.
4. Create a pull request from your topic branch.
5. One of the maintainers will review the pull request.
   The maintainer might discuss, offer constructive feedback, request changes, or approve the work.
6. When the maintainer approves the pull-request. you can merge your changes.
   If you do not have permission to do that, you can request a maintainer to merge it for you.
