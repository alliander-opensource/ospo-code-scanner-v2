<!--
SPDX-FileCopyrightText: Copyright contributors to the OSPO Code Scanner project

SPDX-License-Identifier: Apache-2.0
-->

# OSPO Code Scanner v2

This repository contains a container with software and related configuration files to check if code repositories follow typical open source practices.
The OSPO Code Scanner helps analyze a project before it's made open source.
This is a typical responsibility of Open Source Program Offices (OSPOs).
By running various checks, the OSPO Code Scanner aims to find issues that might be important to address before the code is open sourced.

This is a revision of the [original OSPO Code Scanner](https://github.com/Alliander-opensource/ospo-code-scanner) which was a GitHub Actions workflow.

The commands can be run indiviually.
Using the hooks for the [pre-commit framework](https://pre-commit.com/) is recommended to run all the checks on a project.

You are welcome to use the OSPO Code Scanner, adapt it to your needs, and suggest improvements through pull requests.
The configurations can and should be changed to fit your internal processes.

The Docker/Podman container image is able to lint projects both locally and in build pipelines.

## Basic Installation

To install the OSPO Code Scanner from source using Docker, run:

```bash
docker build --platform=linux/amd64 -f Containerfile -t ospo-code-scanner .
```

To install the OSPO Code Scanner from source using Podman, run:

```bash
podman build --platform=linux/amd64 -f Containerfile -t ospo-code-scanner .
```

## Building behind enterprise caching proxies

If your enterprise uses caching proxies, it might be necessary to change a number of settings, such that it is possible to build the image using those caching proxies. Note that it is required for those caching proxies to be set up for the necessary dependencies. The following table shows the different arguments which can be adjusted, and also allows insight into which artifacts should be proxied.

| Argument                | Description                                             | Default                                                      |
|-------------------------|---------------------------------------------------------|--------------------------------------------------------------|
| apt_repository          | The location of regular Debian artifacts                | deb.debian.org/debian                                        |
| apt_security_repository | The location of Debian security artifacts               | deb.debian.org/debian-security                               |
| apt_repository_schema   | The schema of both Debian artifact repositories         | http                                                         |
| auto_trust              | Whether to automatically trust the set sources          | no                                                           |
| jdk_source              | The location of the Adoptium JDK artifact               | github.com/adoptium/temurin25-binaries/releases/download/    |
| jdk_source_schema       | The schema of the Adoptium JDK site                     | https                                                        |
| ort_source              | The location of the OSS-review-toolkit artifact         | github.com/oss-review-toolkit/ort/releases/download/         |
| ort_source_schema       | The schema of the OSS-review-toolkit site               | https                                                        |
| vale_source             | The location of the Vale artifact                       | github.com/vale-cli/vale/releases/download/                  |
| vale_source_schema      | The schema of the Vale site                             | https                                                        |
| scan_code_source        | The location of the Scan Code artifact                  | github.com/aboutcode-org/scancode-toolkit/releases/download/ |
| scan_code_source_schema | The schema of the Scan Code site                        | https                                                        |
| ort_out                 | The default location for ORT to store intermediate work | /tmp/ort-out                                                 |


The following table describes possible secrets to be used to allow authentication using the normative methods of the associated repositories. Each secret using a username and password construct (whether the password is a token or not), requires the format "<username>:<password>". By default, all secrets are empty.

| Build secret                     | Description                                                                                             |
|----------------------------------|---------------------------------------------------------------------------------------------------------|
| apt_repository_credentials       | The credentials to log into the Debian artifact registries (apt_repository and apt_security_repository) |
| jdk_repository_credentials       | The credentials to log into the JDK site (jdk_source)                                                   |
| ort_repository_credentials       | The credentials to log into the OSS-review-toolkit site (ort_source)                                    |
| vale_repository_credentials      | The credentials to log into the Vale site (vale_source)                                                 |
| scan_code_repository_credentials | The credentials to log into the Scan Code site (scan_code_source)                                       |

### APT Configuration

To adjust how APT works, files can be placed into the `custom-apt.conf.d/` directory. These will be copied over from this directory to the `/etc/apt/apt.conf.d/` directory. If it is necessary to pre-install additional certificates from custom certificate authorities, they can be places in the certificates folder. These will be copied into the /usr/share/ca-certificates directory. **Note:** if certificates are required for APT, please use a custom APT configuration.

Below an example APT configuration:

```perl
Acquire::https::<my-site>::CAInfo "/usr/share/ca-certificates/<my-site>.pem";
Acquire::https::<my-site>::Verify-Peer "true";
Acquire::https::<my-site>::Verify-Host "true";
```

After installation of the Debian artifacts, the certificates will be installed properly, making them available to all commands thereafter.

## Developer notes

### Using the pre-commit hooks

The published pre-commit hooks run from the OSPO Code Scanner container. Add the
following repository to a project's `.pre-commit-config.yaml`:

```yaml
- repo: https://github.com/Alliander/ospo-code-scanner-v2
       rev: <version>
       hooks:
       - id: vale
       - id: ort
```

Before publication, replace the placeholder image reference in
`.pre-commit-hooks.yaml` with the tagged image published by the project.
The repository's own pre-commit configuration builds a local image for
self-validation. Consumers of the published hooks pull the tagged image from
the configured container registry instead.

### Passing build arguments during pre-commit framework run

The project uses the pre-commit framework for internal validation. To be able to modify the build arguments and secrets, by adding a `build-config` file in the project root, it is possible to add additional arguments through this file. Currently, the file contents will be copied as-is into the build-scanner.sh execution of the container.

## Runtime notes

The ORT_OUT environment variable normally takes the value of the ort_out argument during image build, but can be overridden during the runtime.

## Scanner configuration

The scanner is configured from a number of sources, mostly in the [etc/ocs/](etc/ocs/) folder.

- Some [ORT Config](https://github.com/oss-review-toolkit/ort-config) with rules and curations for OSS Review Toolkit. The link to the OSS Review Toolkit configuration is hardcoded in the workflow.
- [vale.ini](etc/ocs/vale/vale.ini) describing the scanning configuration of Vale and the packages to be used.

## License

Copyright 2026 Contributors to the OSPO Code Scanner project

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
Read the License for the specific language governing permissions and
limitations under the License.

### Licenses third-party libraries

This project includes third-party libraries, which are licensed under their own respective Open Source licenses.
SPDX-License-Identifier headers are used to show which license is applicable.
The concerning license files can be found in the LICENSES directory.

## Contributing

Please read [CODE_OF_CONDUCT](CODE_OF_CONDUCT.md) and [CONTRIBUTING](CONTRIBUTING.md) for details on the process for submitting pull requests to us.

## Contact

Please read [SUPPORT](SUPPORT.md) for how to connect and get into contact with the OSPO Code Scanner project.