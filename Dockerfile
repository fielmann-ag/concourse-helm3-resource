ARG ALPINE_HELM_IMAGE=alpine/helm:3.5.2

FROM $ALPINE_HELM_IMAGE
LABEL maintainer "Yann David (@Typositoire) <davidyann88@gmail>"

RUN apk add --update --upgrade --no-cache \
  python3\
  py3-pip \
  jq \
  bash \
  curl \
  git && \
  pip3 install --upgrade awscli

ARG KUBERNETES_VERSION=1.18.2
RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl; \
  chmod +x /usr/local/bin/kubectl

ARG AWS_IAM_AUTHENTICATOR_VERSION=0.5.2
RUN curl -L -o /usr/local/bin/aws-iam-authenticator https://github.com/kubernetes-sigs/aws-iam-authenticator/releases/download/v${AWS_IAM_AUTHENTICATOR_VERSION}/aws-iam-authenticator_${AWS_IAM_AUTHENTICATOR_VERSION}_linux_amd64 && \
    chmod +x /usr/local/bin/aws-iam-authenticator

ADD assets /opt/resource
RUN chmod +x /opt/resource/*

ARG HELM_PLUGINS="https://github.com/helm/helm-2to3 https://github.com/databus23/helm-diff"
RUN for i in $(echo $HELM_PLUGINS | xargs -n1); do helm plugin install $i; done

RUN curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"  | bash && \
  install kustomize /usr/local/bin/kustomize

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
