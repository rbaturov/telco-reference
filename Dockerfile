FROM docker.io/golang:1.23 AS builder

WORKDIR /go/src/github.com/rbaturov/telco-reference

COPY . .

FROM registry.access.redhat.com/ubi9/ubi-minimal

COPY --from=builder /go/src/github.com/rbaturov/telco-reference/telco-core /usr/share/telco-core-rds

RUN microdnf install -y tar && \
    microdnf clean -y all

USER 65532:65532
ENTRYPOINT ["/bin/bash"]
CMD ["-c", "tar -cf - --directory /usr/share telco-core-rds | base64 -w0"]

LABEL com.redhat.component="openshift-telco-core-rds-container" \
      name="openshift4/openshift-telco-core-rds-rhel9" \
      upstream-vcs-type="git" \
      summary="Telco Core RDS manifests" \
      io.openshift.expose-services="" \
      io.openshift.tags="" \
      io.k8s.display-name="openshift-telco-core-rds" \
      maintainer="cnf-devel@redhat.com" \
      description="Telco Core RDS manifests" \
      io.openshift.maintainer.component="Telco Core RDS" \
      io.openshift.maintainer.product="OpenShift Container Platform"


