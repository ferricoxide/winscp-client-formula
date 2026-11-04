# Agent Instructions

Before starting any task in this repository:

1. Run `make agents/sync`. It writes the shared Plus3 IT instructions for this repository's tardigrade-ci version to `.agents/plus3it/AGENTS.md`.
2. Read `.agents/plus3it/AGENTS.md` and follow it together with this file. If the sync fails, tell the user, and don't guess the conventions.

These rules always apply, even without the shared instructions:

- Don't push, open pull requests, publish releases, or apply infrastructure changes unless the user asks. List those steps for a person in your final report.
- Do not alter the user's git config and, especially do not alter the user's `user.email` or `user.name` values
- Don't edit files under `.agents/plus3it/`; they are generated and overwritten by the sync.

@.agents/plus3it/AGENTS.md

## Repository-specific

<!--
  INSTRUCTIONS FOR REPOSITORY MAINTAINERS:
  Fill in the sections below for your specific repository. Remove this comment and any
  placeholder sections that don't apply. Don't add tool-specific instruction files such as
  CLAUDE.md; agent tools read AGENTS.md directly.
  
  If this repository fits one of the profiles (terraform-module, salt-formula, tardigrade-deployment),
  set AGENTS_PROFILE := <profile> in the Makefile before the include line.
-->


### Purpose

<!-- Describe what this repository does. For Terraform modules, describe the AWS resources it manages.
For Salt formulas, describe the security controls or configurations it applies. For deployment repos,
describe which accounts and environments it manages. Keep this to 1-2 paragraphs. -->
This repository implements a Saltstack formula for managing the installation, configuration &mdash; or complete reversal of same &mdash; of the WinSCP graphical file-transfer utility.

### Layout

<!-- Describe the directory structure and key files. For Terraform modules, mention modules/, tests/,
and any special directories. For Salt formulas, mention pillar structure. For deployment repos, describe
the stacks/roots/modules organization. -->
Project layout:

<PROJECT_ROOT>/
├── AGENTS.md: This file
├── CHANGELOG.md: Summarization of changes across update-increments
├── Dockerfile: Generic-used Dockerfile definition that enables use of the standard, P3-managed `tardigrade-ci` testing-enablement container
├── LICENSE: Description of how this project may be used:
├── Makefile: Bootstraps the Tardigrade CI in standard use on P3-managed projects
├── README.md: Overview of what this project does.
├── tests: Directory-tree containing content for exercising the formula-contents hosted under the `winscp-client` directory-tree
│   ├── pillar: Testing-supporting SaltStack "Pillar" content
│   └── requirements*.txt: files used by testing-harness to know which supplemental Python packages to import
└── winscp-client: Directory-tree containing automation templated from the public "SaltStack formulas template" project found at https://github.com/saltstack-formulas/template-formula. This directory-tree contains the primary functionality of this project
    ├── _mapdata: Contains dumped/cached mapdata YAML exports used to test and validate parameter resolution across platforms
    ├── config: Saltstack states handling configuration of WinSCP file-transfer utility
    ├── files: Contains static configuration files and Jinja templates managed by Salt states
    ├── package: Saltstack states handling installation/removal of WinSCP file-transfer utility
    └── parameters: Directory-tree containing files describing general and platform-specific parameter-value defaults that can also be overridden via SaltStack's "Pillar" capability

### CI/CD

- PRs trigger lint and test workflows
- Uses GitHub Actions with reusable workflows from plus3it/actions-workflows

### Testing

<!-- Describe how to run tests locally and what they test. For Terraform modules:
- "Run `make mockstack/up`, `make mockstack/pytest`, then `make mockstack/clean`, the same way CI does"
- "Tests are in tests/ and use pytest-terraform"
- "Tests use moto by default; setting `USE_LOCALSTACK` routes them through LocalStack. `ONLY_MOTO` is obsolete and has no effect"
For other repos, describe the test strategy. -->
