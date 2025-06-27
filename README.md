# Cloud Security Toolkit Docker Image

This Docker image provides a comprehensive CLI-based environment for cloud security assessments, red team operations, and DevSecOps validation. It includes official or recommended installations of widely used tools across AWS, Azure, GCP, and Kubernetes.

## 🔧 What's Inside

The container includes the following tools:

### Cloud Provider CLIs
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install)
- [Kubernetes CLI (kubectl)](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [GitHub CLI (gh)](https://cli.github.com/)
- `git`

### Security & Assessment Tools
- [ScoutSuite](https://github.com/nccgroup/ScoutSuite)
- [Prowler](https://github.com/prowler-cloud/prowler)
- [CloudSploit](https://github.com/aquasecurity/cloudsploit)
- [CloudFox](https://github.com/BishopFox/cloudfox)
- [Steampipe](https://steampipe.io/)
- [Powerpipe](https://powerpipe.io/)
- [Pacu](https://github.com/RhinoSecurityLabs/pacu)
- [Trivy](https://github.com/aquasecurity/trivy)
- [Checkov](https://github.com/bridgecrewio/checkov)
- [Snyk](https://snyk.io/)
- [git-secrets](https://github.com/awslabs/git-secrets)
- [TruffleHog](https://github.com/trufflesecurity/trufflehog)
- [Kubenumerate](https://github.com/0x5ubt13/kubenumerate)

## 📦 Build Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/your-org/cloud-security-toolkit.git
cd cloud-security-toolkit
```

### 2. Build the Docker Image

```bash
docker build -t cloudsec-toolkit .
```

### 3. Run the Container

```bash
docker run -it --rm \
  --name cloudsec \
  cloudsec-toolkit
```

### 4. Optional: Mount Credentials

To use your local AWS, Azure, or GCP credentials:

```bash
docker run -it --rm \
  -v ~/.aws:/home/secuser/.aws \
  -v ~/.azure:/home/secuser/.azure \
  -v ~/.config/gcloud:/home/secuser/.config/gcloud \
  -v $(pwd):/workspace \
  cloudsec-toolkit
```

## 👤 User

The container runs as a non-root user `secuser` with `sudo` access.

## 💡 Notes

- This image is **Debian-based** for compatibility and stability.
- CLI-only tooling—no GUI or X11 dependencies included.
- All tools are installed using **officially recommended methods**.
- Tools requiring Docker, GUI interaction, or Windows/PowerShell are excluded.

---



