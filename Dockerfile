# ============LICENSE_START==========================================
# org.onap.vvp/jenkins
# ===================================================================
# Copyright © 2017 AT&T Intellectual Property. All rights reserved.
# ===================================================================
#
# Unless otherwise specified, all software contained herein is licensed
# under the Apache License, Version 2.0 (the “License”);
# you may not use this software except in compliance with the License.
# You may obtain a copy of the License at
#
#             http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#
#
# Unless otherwise specified, all documentation contained herein is licensed
# under the Creative Commons License, Attribution 4.0 Intl. (the “License”);
# you may not use this documentation except in compliance with the License.
# You may obtain a copy of the License at
#
#             https://creativecommons.org/licenses/by/4.0/
#
# Unless required by applicable law or agreed to in writing, documentation
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# ============LICENSE_END============================================
#
# ECOMP is a trademark and service mark of AT&T Intellectual Property.
FROM jenkinsci/jenkins:alpine

# TODO revisit these additions. Are they all still needed after discarding
# containerkit?
USER root
RUN apk add --no-cache \
    bash \
    coreutils \
    curl \
    git \
    jq \
    openssh-client \
    py-pip \
    python3 \
    ttf-dejavu \
    unzip \
    zip \
    && :

ENV JAVA_OPTS="-Djava.awt.headless=true -Dhudson.DNSMultiCast.disabled=true -Dhudson.udp=-1"

COPY \
    ice-testengine \
    bootstrap \
    /usr/local/bin/

# Insert a skeleton config.xml that enables security
COPY config.xml /usr/share/jenkins/ref/

# Insert our bootstrap before upstream's
RUN mv /usr/local/bin/jenkins.sh /usr/local/bin/upstream_jenkins.sh; \
    mv /usr/local/bin/bootstrap /usr/local/bin/jenkins.sh

RUN pip install -U pytest pyyaml pytest-tap boltons

USER jenkins

ENV CURL_CONNECTION_TIMEOUT=60

#RUN install-plugins.sh notification workflow-aggregator tap
#Add debug mode for onapp debugging
RUN /bin/bash -x /usr/local/bin/install-plugins.sh notification workflow-aggregator tap
