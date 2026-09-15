# SPDX-FileCopyrightText: Copyright contributors to the OSPO Code Scanner project
# SPDX-License-Identifier: Apache-2.0

ARG image=debian@sha256:28de0877c2189802884ccd20f15ee41c203573bd87bb6b883f5f46362d24c5c2
FROM ${image}

ARG script_mount_point=/mnt/scripts

ARG apt_repository=deb.debian.org/debian
ARG apt_security_repository=deb.debian.org/debian-security
ARG apt_repository_schema=http
ARG auto_trust=no

# Run commands to set up a reasonable starting state
RUN rm /etc/apt/sources.list.d/* && mkdir -p /usr/share/ca-certificates

COPY certificates/ /usr/share/ca-certificates
COPY custom-apt.conf.d/ /etc/apt/apt.conf.d/

RUN --mount=type=secret,id=apt_repository_credentials,target=/var/run/secrets/repository_credentials \
    --mount=type=bind,source=scripts/run-apt,target=${script_mount_point}/run-apt \
    --mount=type=tmpfs,target=/etc/apt/sources.list.d \
    "${script_mount_point}/run-apt" $apt_repository $apt_security_repository $apt_repository_schema $auto_trust /var/run/secrets/repository_credentials update && \
    "${script_mount_point}/run-apt" $apt_repository $apt_security_repository $apt_repository_schema $auto_trust /var/run/secrets/repository_credentials install git curl nodejs python3 python3-pip pipx sudo util-linux tree cargo

RUN --mount=type=bind,source=scripts/install-certificates,target=${script_mount_point}/install-certificates \
    "${script_mount_point}/install-certificates"

ARG jdk_source=github.com/adoptium/temurin25-binaries/releases/download/
ARG jdk_source_schema=https
ARG adoptium_jdk_version=25.0.4+7

RUN --mount=type=secret,id=jdk_repository_credentials,target=/var/run/secrets/repository_credentials \
    --mount=type=bind,source=scripts/install-jdk,target=${script_mount_point}/install-jdk \
    "${script_mount_point}/install-jdk" $jdk_source $jdk_source_schema $adoptium_jdk_version /var/run/secrets/repository_credentials

ARG ort_source=github.com/oss-review-toolkit/ort/releases/download/
ARG ort_source_schema=https
ARG ort_version=91.2.0

ENV JAVA_OPTS="-Xmx8g"

RUN --mount=type=secret,id=ort_repository_credentials,target=/var/run/secrets/repository_credentials \
    --mount=type=bind,source=scripts/install-ort,target=${script_mount_point}/install-ort \
    "${script_mount_point}/install-ort" $ort_source $ort_source_schema $ort_version /var/run/secrets/repository_credentials

ARG vale_source=github.com/vale-cli/vale/releases/download/
ARG vale_source_schema=https
ARG vale_version=3.15.2

RUN --mount=type=secret,id=vale_repository_credentials,target=/var/run/secrets/repository_credentials \
    --mount=type=bind,source=scripts/install-vale,target=${script_mount_point}/install-vale \
    "${script_mount_point}/install-vale" $vale_source $vale_source_schema $vale_version /var/run/secrets/repository_credentials

ARG scan_code_source=github.com/aboutcode-org/scancode-toolkit/releases/download/
ARG scan_code_source_schema=https
ARG scan_code_version=32.5.0

RUN --mount=type=secret,id=scan_code_repository_credentials,target=/var/run/secrets/repository_credentials \
    --mount=type=bind,source=scripts/install-scan_code,target=${script_mount_point}/install-scan_code \
    "${script_mount_point}/install-scan_code" $scan_code_source $scan_code_source_schema $scan_code_version /var/run/secrets/repository_credentials

RUN cd /opt/scancode-toolkit && ./configure

RUN adduser --disabled-password --uid 1000 --home /ocs ospo-code-scanner && \
    mkdir /ocs/scanner && chown ospo-code-scanner:ospo-code-scanner /ocs/scanner && \
    mkdir /entry && chown ospo-code-scanner:ospo-code-scanner /entry && \
    mkdir /src  && chown ospo-code-scanner:ospo-code-scanner /src

COPY etc/ocs /etc/ocs

USER ospo-code-scanner
WORKDIR /src

COPY entrypoint /entry/entry
RUN ln -s /entry/entry /entry/vale && \
    ln -s /entry/entry /entry/ort && \
    ln -s /entry/entry /entry/shell && \
    ln -s /entry/entry /entry/tree

ENV HOME=/tmp

ARG ort_out=/src/ort-out
ENV ORT_OUT=${ort_out}

ARG ort_enable_scanner=true
ENV ORT_ENABLE_SCANNER=${ort_enable_scanner}

ARG ort_enable_evaluator=true
ENV ORT_ENABLE_EVALUATOR=${ort_enable_evaluator}

ARG ort_config=/etc/ocs/ort/config.yml
ENV ORT_CONFIG=${ort_config}

ARG ort_evaluator_license_classifications=/etc/ocs/ort/evaluator/license-classifications.yml
ENV ORT_EVALUATOR_LICENSE_CLASSIFICATIONS=${ort_evaluator_license_classifications}

ARG ort_evaluator_curations=/etc/ocs/ort/evaluator/curations.yml
ENV ORT_EVALUATOR_CURATIONS=${ort_evaluator_curations}

ARG ort_evaluator_rules=/etc/ocs/ort/evaluator/rules.kts
ENV ORT_EVALUATOR_RULES=${ort_evaluator_rules}

ARG ort_report_format=StaticHtml
ENV ORT_REPORT_FORMAT=${ort_report_format}

ENV ORT_REPORT_OPTIONS=""

ENV PATH=/entry

ENTRYPOINT ["shell"]
