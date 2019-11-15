FROM registry.access.redhat.com/ubi8/ubi:latest

RUN yum clean all \
    && yum install -y wget gcc zlib-devel zlib-devel \
    && yum install -y siege jq \
    && yum clean all

RUN wget -O /tmp/odo.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/odo/latest/odo-linux-amd64.tar.gz \
        && tar -xfvz /tmp/odo.tar.gz -C /usr/local/bin \
	&& chmod +x /usr/local/bin/odo \
        && rm -f /tmp/odo.tar.gz

RUN wget -O /tmp/oc.tar.gz https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz \
    && tar -xvzf /tmp/oc.tar.gz -c /usr/bin \
    && chmod a+x /usr/bin/oc \
    && rm -f /tmp/oc.tar.gz

RUN wget -O /tmp/graalvm.tar.gz https://github.com/oracle/graal/releases/download/vm-19.2.1/graalvm-ce-linux-amd64-19.2.1.tar.gz \
    && tar -xvzf /tmp/graalvm.tar.gz -C /usr/local \
    && rm -rf /tmp/graalvm.tar.gz

ENV GRAALVM_HOME=/usr/local/graalvm-ce-19.2.1

RUN ${GRAALVM_HOME}/bin/gu install native-image

RUN wget -O /tmp/mvn.tar.gz http://apache.tt.co.kr/maven/maven-3/3.6.2/binaries/apache-maven-3.6.2-bin.tar.gz \
    && tar xzf /tmp/mvn.tar.gz -C /usr/local \
    && rm -rf /tmp/mvn.tar.gz \
    && mkdir /usr/local/maven \
    && mv apache-maven-3.6.2/ /usr/local/maven/ \
    && alternatives --install /usr/bin/mvn mvn /usr/local/maven/apache-maven-3.6.2/bin/mvn 1

ENV PATH=/usr/local/maven/apache-maven-3.6.2/bin:${PATH}
ENV MAVEN_OPTS="-Xmx4G -Xss128M -XX:MetaspaceSize=1G -XX:MaxMetaspaceSize=2G -XX:+CMSClassUnloadingEnabled"

RUN wget -O /tmp/tkn.tar.gz https://github.com/tektoncd/cli/releases/download/v0.5.0/tkn_0.5.0_Linux_arm64.tar.gz \ 
    && tar xvzf tkn.tar.gz -C /usr/local/bin \
    && rm -fr /tmp/tkn.tar.gz

RUN wget -O /tmp/kn.tar.gz https://github.com/knative/client/releases/download/v0.10.0/kn-linux-amd64 \
    && tar xvfz /tmp/kn.tar.gz -C /usr/local/bin \
    && rm -fr /tmp/kn.tar.gz
    

RUN /bin/sh -c chown -R jboss /home/jboss/.m2

USER jboss


