FROM debian:bookworm-slim

# Install system prerequisites
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl wget sudo gnupg lsb-release apt-transport-https ca-certificates unzip \
    python3 python3-pip git nodejs npm openjdk-17-jre-headless \
    make && \
    rm -rf /var/lib/apt/lists/*

# Install Go 1.22+ 
RUN curl -LO https://go.dev/dl/go1.22.4.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.22.4.linux-amd64.tar.gz && \
    rm go1.22.4.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && \
    ln -s /usr/local/go/bin/gofmt /usr/local/bin/gofmt

# Create a non-root user with sudo
RUN useradd -ms /bin/bash secuser && usermod -aG sudo secuser
RUN echo 'secuser ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/secuser

# Install AWS CLI v2 (official installer)
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o awscliv2.zip && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm awscliv2.zip

# Install Azure CLI (via Microsoft repo)
RUN curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /usr/share/keyrings/microsoft.gpg >/dev/null && \
    echo "deb [signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/azure-cli.list && \
    apt-get update && apt-get install -y azure-cli && rm -rf /var/lib/apt/lists/*

# Install Google Cloud SDK (gcloud) via apt
RUN echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - && \
    apt-get update && apt-get install -y google-cloud-cli && rm -rf /var/lib/apt/lists/*

# Install kubectl (Kubernetes CLI)
RUN curl -Lo kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl

# Install GitHub CLI (gh) via official repo
RUN curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg && \
    chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list && \
    apt-get update && apt-get install -y gh && rm -rf /var/lib/apt/lists/*

# Cloud security tools (Python, Node.js, Go, etc.)
# Install ScoutSuite
RUN pip3 install --no-cache-dir --break-system-packages scoutsuite

# Install Prowler
RUN pip3 install --no-cache-dir --break-system-packages prowler

# Install PACU (AWS pentest toolkit)
RUN pip3 install --upgrade --break-system-packages pacu

# Install Checkov (Bridgecrew)
RUN pip3 install --no-cache-dir --break-system-packages checkov

# Install git-secrets (AWS)
RUN git clone https://github.com/awslabs/git-secrets.git /opt/git-secrets && \
    cd /opt/git-secrets && make install

# Install CloudSploit (Node.js)
RUN git clone https://github.com/aquasecurity/cloudsploit.git /opt/cloudsploit && \
    cd /opt/cloudsploit && npm install && \
    ln -s /opt/cloudsploit/index.js /usr/local/bin/cloudsploit

# Install CloudFox (Go)
RUN go install github.com/BishopFox/cloudfox@latest

# Install Steampipe (Turbot)
RUN /bin/sh -c "$(curl -fsSL https://steampipe.io/install/steampipe.sh)"

# Install Powerpipe (Turbot)
RUN /bin/sh -c "$(curl -fsSL https://powerpipe.io/install/powerpipe.sh)"

# Install Trivy (Aqua Security) via official install script
RUN curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin


# Install Snyk (via npm)
RUN npm install -g snyk

# Install TruffleHog (compile from source)
RUN git clone https://github.com/trufflesecurity/trufflehog.git /opt/trufflehog && \
    cd /opt/trufflehog && go install

# Install Kubenumerate
RUN git clone https://github.com/0x5ubt13/kubenumerate.git /opt/kubenumerate && \
    cd /opt/kubenumerate && pip install --no-cache-dir --break-system-packages -r requirements.txt && \
    chmod +x kubenumerate.py && sudo ln -s "$(pwd)"/kubenumerate.py /usr/bin/kubenumerate

# Switch to non-root user by default
USER secuser
WORKDIR /home/secuser

