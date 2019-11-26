FROM quay.io/openshiftlabs/cloudnative-workspaces-quarkus:1.3

USER root

RUN wget -O /tmp/odo.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64.tar.gz \
        && tar xfvz /tmp/odo.tar.gz -C /usr/local/bin \
	&& chmod +x /usr/local/bin/odo \
        && rm -f /tmp/odo.tar.gz

RUN wget -O /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest-4.2/openshift-client-linux-4.2.7.tar.gz \
    && tar xvzf /tmp/oc.tar.gz -C /usr/bin \
    && chmod a+x /usr/bin/oc \
    && chmod a+x /usr/bin/kubectl \
    && rm -f /tmp/oc.tar.gz

RUN wget -O /tmp/graalvm.tar.gz https://github.com/oracle/graal/releases/download/vm-19.2.1/graalvm-ce-linux-amd64-19.2.1.tar.gz \
    && tar xvzf /tmp/graalvm.tar.gz -C /usr/local \
    && rm -rf /tmp/graalvm.tar.gz

ENV GRAALVM_HOME=/usr/local/graalvm-ce-19.2.1
ENV PATH=${GRAALVM_HOME}/bin:${PATH}

RUN ${GRAALVM_HOME}/bin/gu install native-image

RUN wget -O /tmp/mvn.tar.gz http://apache.uvigo.es/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz \
    && tar xzf /tmp/mvn.tar.gz -C /usr/local \
    && rm -rf /tmp/mvn.tar.gz \
    && alternatives --install /usr/bin/mvn mvn /usr/local/apache-maven-3.6.2/bin/mvn 1

ENV PATH=/usr/local/maven/apache-maven-3.6.2/bin:${PATH}
ENV MAVEN_OPTS="-Xmx4G -Xss128M -XX:MetaspaceSize=1G -XX:MaxMetaspaceSize=2G -XX:+CMSClassUnloadingEnabled"

RUN wget -O /tmp/tkn.tar.gz https://github.com/tektoncd/cli/releases/download/v0.5.0/tkn_0.5.0_Linux_x86_64.tar.gz \ 
    && tar xvzf /tmp/tkn.tar.gz -C /usr/local/bin \
    && rm -fr /tmp/tkn.tar.gz \
    && chmod a+x /usr/local/bin/tkn

RUN wget -O /usr/local/bin/kn https://github.com/knative/client/releases/download/v0.10.0/kn-linux-amd64 \
    && chmod a+x /usr/local/bin/kn

RUN wget -O /usr/local/bin/operator-sdk https://github.com/operator-framework/operator-sdk/releases/download/v0.12.0/operator-sdk-v0.12.0-x86_64-linux-gnu \
    && chmod a+x /usr/local/bin/operator-sdk

USER jboss 
