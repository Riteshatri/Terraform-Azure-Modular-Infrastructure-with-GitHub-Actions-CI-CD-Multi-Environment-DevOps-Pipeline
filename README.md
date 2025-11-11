# 🏗️ Terraform Azure Modular Infrastructure + GitHub Actions CI/CD

A **production-ready Infrastructure as Code (IaC)** solution using **Terraform** and **Microsoft Azure**,  
fully automated with **GitHub Actions Workflows** for multi-environment deployment — **Dev → QA → Test → UAT → Prod**.  

This project demonstrates **enterprise-grade DevOps practices**: modular Terraform, reusable pipelines, secure authentication, and environment-specific automation.

---

## 🧭 Architecture Overview

```
👨‍💻 Developer Commit
       │
       ▼
GitHub Repository (main branch)
       │
       ▼
GitHub Actions (Self-Hosted Runner)
       │
       ├── terraform init
       ├── terraform fmt
       ├── terraform validate
       ├── terraform plan
       ├── terraform apply
       └── terraform destroy
       │
       ▼
☁️ Azure Cloud
       ├── Resource Groups
       ├── VNets + NSGs + Subnets
       ├── Virtual Machines + Bastion
       ├── Load Balancers
       └── SQL Servers + Databases
```

---

## 🧱 Section 1: Terraform Modular Infrastructure

### 🚀 Key Features
- **Modular Architecture** — each Azure service is an independent reusable module  
- **for_each implementation** — dynamically deploy multiple resources  
- **Remote Backend** in Azure Storage for secure state management  
- **Clean, Parameterized Design** via `variables.tf` and environment-specific `.tfvars`  
- **Compatible with local execution and CI/CD automation**

---

### 📁 Directory Layout

```
infra/
├── main.tf
├── provider.tf
├── variables.tf
├── terraform.tfvars
├── output.tf
└── modules/
    ├── resourceGroup/
    │   └── azurerm_resource_group
    ├── networking/
    │   ├── virtual_network
    │   ├── nsg
    │   ├── nic
    │   ├── bastion
    │   └── pip
    ├── virtual_machine/
    │   └── azurerm_linux_virtual_machine
    ├── database/
    │   ├── mssql_server
    │   ├── mssql_database
    │   └── firewall_rule
    └── loadBalancer/
        ├── lb
        ├── probe
        └── rule
```

---

### 🧩 Local Setup (Manual Execution)

```bash
# Clone the repository
git clone https://github.com/<your-username>/terraform-azure-modular-infra.git
cd terraform-azure-modular-infra/infra

# Initialize Terraform
terraform init

# Validate, plan and apply
terraform validate
terraform plan
terraform apply -auto-approve

# Destroy when done
terraform destroy -auto-approve
```

---

### ☁️ Remote Backend Setup
Before using CI/CD:
- Create Azure Storage Account and Container for Terraform state  
- Store backend details in each workflow (state key per environment)  
- Authenticate via OIDC or Azure CLI  

---

## ⚙️ Section 2: CI/CD Automation (GitHub Actions)

### 🔁 Multi-Environment Workflows

| Environment | Trigger | State File | Auto Apply | Runner |  
|--------------|----------|-------------|-------------|---------|  
| **Dev** | Push to `dev.tfvars` or Manual | `dev.tfstate` | Optional | Self-hosted |  
| **QA** | Push to `qa.tfvars` or Manual | `qa.tfstate` | Optional | Self-hosted |  
| **Test** | Push to `test.tfvars` or Manual | `test.tfstate` | Optional | Self-hosted |  
| **UAT** | Push to `uat.tfvars` or Manual | `uat.tfstate` | Optional | Self-hosted |  
| **Prod** | Push to `prod.tfvars` or Manual | `prod.tfstate` | Requires approval | Self-hosted |  

---

### 🧩 Reusable Workflow — `terraform-multi.yaml`

This central file defines reusable jobs for all environments.

**Workflow Inputs**
- `environment` – dev / qa / test / uat / prod  
- `tfvars_file` – Environment variables file  
- `rgname`, `saname`, `scname`, `key` – Remote backend config  
- `runInit`, `runFmt`, `runValidate`, `runPlan`, `runApply`, `runDestroy` – Boolean flags to control stages  

**Job Stages**

| Stage | Purpose | Command |
|--------|----------|----------|
| 🏁 Init | Initialize Terraform backend | `terraform init` |
| 🧹 Fmt | Format TF code | `terraform fmt` |
| 🔍 Validate | Validate configuration | `terraform validate` |
| 🧭 Plan | Create execution plan | `terraform plan -var-file=...` |
| ⚙️ Apply | Deploy infra | `terraform apply` |
| 💣 Destroy | Remove infra | `terraform destroy` |

**Trigger Behavior**
- **Push Event on Dev/Test/QA/Uat:**   runs init → fmt → validate → plan
- **Push Event on Prod:**           runs init → fmt → validate → plan → apply   
- **Manual Dispatch:**              user selects which stages to execute  

---

### 🧠 Example: `dev.yaml` Workflow

```yaml
name: dev
on:
  push:
    paths:
      - 'environments/dev.tfvars'
  workflow_dispatch:
    inputs:
      do_init:     { type: boolean, default: true }
      do_fmt:      { type: boolean, default: true }
      do_validate: { type: boolean, default: true }
      do_plan:     { type: boolean, default: true }
      do_apply:    { type: boolean, default: false }
      do_destroy:  { type: boolean, default: false }

jobs:
  call:
    uses: ./.github/workflows/terraform-multi.yaml
    with:
      environment: dev
      tfvars_file: environments/dev.tfvars
      rgname: ritkargs
      saname: ritkasas
      scname: ritkascs
      key: dev.tfstate
      runInit:     ${{ github.event_name == 'push' || inputs.do_init }}
      runFmt:      ${{ github.event_name == 'push' || inputs.do_fmt }}
      runValidate: ${{ github.event_name == 'push' || inputs.do_validate }}
      runPlan:     ${{ github.event_name == 'push' || inputs.do_plan }}
      runApply:    ${{ github.event_name != 'push' && inputs.do_apply }}
      runDestroy:  ${{ github.event_name != 'push' && inputs.do_destroy }}

    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

Each environment file (`qa.yaml`, `test.yaml`, `uat.yaml`, `prod.yaml`) follows the same structure  
but uses its own `tfvars` file and backend key.

---

### 🔒 Secure Azure Login (OIDC)

All workflows use **OpenID Connect (OIDC)** for passwordless authentication:

```yaml
- name: Azure Login
  uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

✅ No credentials stored  
✅ Secure token-based login  
✅ Works seamlessly across environments

---

### ⚡ Self-Hosted Runner
All jobs run on a **self-hosted runner** for:
- Faster builds  
- Private network connectivity to Azure  
- Full control over Terraform dependencies  

```yaml
runs-on: self-hosted
```

---

### 🧭 Workflow Flow Diagram

```
┌────────────┐
│  Developer │
└─────┬──────┘
      ▼
Push / Manual Dispatch
      ▼
.github/workflows/*.yaml
      ▼
Calls terraform-multi.yaml
      ▼
┌───────────────┬───────────────┬───────────────┐
│ Init          │ Fmt           │ Validate      │
└─────┬─────────┴───────────────┴───────────────┘
      ▼
Terraform Plan
      ▼
Manual Approval → Apply
      ▼
Deployed Infra in Azure
```

---

## 🧰 Prerequisites

| Requirement | Description |
|--------------|--------------|
| Terraform | v1.6 or higher |
| Azure CLI | For local testing (`az login`) |
| Azure Storage | For remote state backend |
| GitHub Secrets | `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID` |

---


## 🔐  Azure App Registration and Federated Credential Setup

This section explains how to securely connect **GitHub Actions → Azure Portal** using **OpenID Connect (OIDC)** and **Federated Credentials**.

### **Step 1: Create App Registration in Azure AD**
1. Go to **Azure Portal → Azure Active Directory → App registrations**
2. Click **New registration**
3. Fill details:
   - Name: `github-oidc-terraform-app`
   - Supported account type: *Accounts in this organizational directory only*
   - Redirect URI: Leave blank
4. Click **Register**
5. Copy the **Application (client) ID** and **Directory (tenant) ID**

---

### **Step 2: Assign Role to Your App**
1. Go to your **Azure Subscription → Access Control (IAM) → Add role assignment**
2. Choose a role (e.g., `Contributor`)
3. Select **Members → Assign access to User, Group, or Service Principal**
4. Find and select your **App Registration**
5. Click **Review + Assign**

---

### **Step 3: Configure Federated Credentials**
1. Open your App Registration → **Certificates & Secrets → Federated Credentials**
2. Click **Add Credential**
3. Fill in details:

| Field | Description |
|--------|-------------|
| **Federated credential scenario** | GitHub Actions deploying Azure resources |
| **Organization** | Your GitHub Organization name |
| **Repository** | Your repository name |
| **Entity Type** | Choose Environment or Branch |
| **Environment/Branch Name** | Example: `prod` or `main` |
| **Name** | Example: `prod-deploy-oidc` |

4. Click **Add**

**Note:** If user doesn’t see that option, they can manually choose “Other” and fill the repo/org details

---

### 💡 **Branch vs Environment — When and Why**

When creating **Federated Credentials** in your Azure App Registration, Azure needs to know **“from where GitHub will send identity tokens”**.  
That’s where you must choose **either a Branch or an Environment**, depending on how your pipeline is triggered.

#### 🧩 1. **Branch-Based Federation (Automatic CI/CD)**

✅ **Use this when your workflows run automatically on every code push or PR.**

**Example Use Case:**
- You want Terraform to plan/deploy automatically every time someone pushes to `main`, `dev`, or `feature/*` branch.  
- No manual approval is needed — pipeline runs instantly.

**Azure Setup:**
- In Federated Credential setup:
  - Choose **Entity Type:** `Branch`
  - Enter **Branch name:** `main` or `dev`
- Azure will trust GitHub tokens coming **only from that branch**.

**GitHub Example:**
```yaml
on:
  push:
    branches:
      - main
      - dev
```

🧠 So here, as soon as you push — OIDC auth + Terraform runs automatically.  

---

#### 🧱 2. **Environment-Based Federation (Manual Approval Flow)**

✅ **Use this when you need manual approvals before applying or destroying infrastructure.**

**Example Use Case:**
- You have environments like `dev`, `qa`, `prod`.
- You want `terraform plan` to run automatically, but `terraform apply` should wait for approval.

**Azure Setup:**
- In Federated Credential setup:
  - Choose **Entity Type:** `Environment`
  - Enter **Environment name:** `prod` or `qa`
- Azure will now only trust GitHub tokens **when the job is tied to that environment**.

**GitHub Example:**
```yaml
jobs:
  apply:
    environment:
      name: prod
    runs-on: ubuntu-latest
```

🧠 Here, when the job reaches `environment: prod`,  
GitHub sends an approval request to reviewers → once approved → OIDC token is validated → job executes.

---

#### ⚖️ **Summary — Which One Should You Use?**

| Scenario | Entity Type | When to Use |
|-----------|--------------|--------------|
| Continuous Integration (auto deploy on push) | **Branch** | Dev/Test pipelines that run frequently |
| Controlled Deployment (manual approval needed) | **Environment** | QA/Prod pipelines that need approval |

💬 **Rule of Thumb:**  
- Use **Branch** for speed & automation.  
- Use **Environment** for safety & compliance.

---

### **Step 4: Verify OIDC Authentication in Workflow**
Example GitHub Action step:

```yaml
- name: Azure Login via OIDC
  uses: azure/login@v1
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```

✅ Once this step succeeds, your workflow is authenticated to Azure via OIDC.

---

### **Step 5: Workflow Execution Flow**
1. Push code or trigger the workflow.
2. GitHub sends an OIDC token to Azure.
3. Azure validates it using the Federated Credential.
4. If valid → authentication succeeds → Terraform runs securely.

---


### 🧭 For more clarity

```
┌─────────────┐      ┌─────────────────┐
│  Branch CI  │ ---> │   Auto Deploy   │
└─────────────┘      └─────────────────┘
       ↑
       │
┌─────────────┐      ┌─────────────────┐
│ Environment │ ---> │ Manual Approval │
└─────────────┘      └─────────────────┘

```
## 🧱 Terraform Deployment Flow with Manual Approval

Typical GitHub Actions Workflow:

```yaml
jobs:
  terraform-apply:
    environment:
      name: prod
      url: https://portal.azure.com
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Login to Azure
        uses: azure/login@v1
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Init & Plan
        run: |
          terraform init
          terraform plan

      - name: Terraform Apply (Manual Approval Required)
        run: terraform apply -auto-approve
```

🧠 The `environment` block enforces **manual approval** before `apply` or `destroy` executes.

---

## 🎯 Important Points

✅ Secure GitHub-to-Azure connection using **OIDC** (no passwords).  
✅ Enforced **manual approval** with environments.  
✅ Centralized **secret management** via GitHub Actions.  
✅ Fully automated **Terraform deployment** workflow.

---



## 🔐 Environment Protection & Manual Approvals (Step-by-Step Guide)

> We use **GitHub Environments** to enforce **manual approvals** for critical stages like `apply` and `destroy`.  
> When a workflow job references an environment, GitHub automatically pauses the job and sends an approval request to the configured reviewers.  
> The job resumes only after one or more reviewers approve the request.

---

### 🪜 Step-by-Step Setup

#### 1. Add Collaborators / Teams
- Go to your repository → **Settings → Collaborators & Teams**.  
- Add the users or teams who will act as approvers for environment deployments.  
- (Recommended) Create a GitHub Team (e.g., `infra-approvers`) to manage permissions easily.

#### 2. Create Environments
- Go to **Settings → Environments → New Environment**.  
- Create a separate environment for each stage:  
  `dev`, `qa`, `test`, `uat`, `prod`, etc.  
- Each environment should represent a logical stage in your deployment pipeline.

#### 3. Configure Protection Rules and Reviewers
- Click on each environment name → set **Protection Rules**.  
- Under **Required reviewers**, select the collaborators or teams added earlier.  
- Optionally, configure:
  - **Wait timer** (delay before auto-deployment),
  - **Deployment branch policies**, and
  - **Minimum number of required reviewers**.

#### 4. Add Environment Secrets (optional but recommended)
- Under each environment, go to **Secrets → Add Secret**.  
- Store sensitive data (e.g., credentials, API keys) specific to that environment.  
- These secrets are only accessible by jobs that use this environment.

#### 5. Link Workflow Jobs to Environments
In your GitHub Actions workflow (e.g., `terraform-multi.yaml`), define the `environment` key in jobs that require approval.

Example:
```yaml
apply:
  runs-on: self-hosted
  environment: prod           # Links this job to the GitHub Environment 'prod'
  defaults:
    run:
      working-directory: infra
  steps:
    - name: Checkout Repository
      uses: actions/checkout@v4

    - name: Azure Login (OIDC)
      uses: azure/login@v2
      with:
        client-id: ${{ secrets.AZURE_CLIENT_ID }}
        tenant-id: ${{ secrets.AZURE_TENANT_ID }}
        subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}

    - name: Terraform Init
      run: terraform init -input=false

    - name: Terraform Apply
      run: terraform apply -auto-approve "plan-${{ inputs.environment }}.tfplan"
```


## 🔑 GitHub Secrets Configuration (for Terraform + Azure OIDC)

This project uses **GitHub Secrets** to store sensitive credentials required for authentication and deployment via Terraform.

Secrets are **encrypted** and securely managed by GitHub. They can be defined either:
- At the **Repository level** (accessible by all workflows)
- Or at the **Environment level** (restricted to specific stages like `dev`, `qa`, `prod`)

---

### 🧱 Required Secrets

The following secrets are mandatory for Azure-based Terraform authentication (via OIDC):

| Secret Name | Description |
|--------------|-------------|
| `AZURE_CLIENT_ID` | The Azure AD App (Service Principal) client ID |
| `AZURE_TENANT_ID` | The Azure Active Directory tenant ID |
| `AZURE_SUBSCRIPTION_ID` | The Azure subscription ID used for deployment |

---

### ⚙️ How to Add Secrets (Step-by-Step)

#### Step 1 — Navigate to Secrets
1. Go to your GitHub repository.  
2. Click on **Settings → Secrets and variables → Actions**.

#### Step 2 — Add Repository Secrets
1. Under the **Repository secrets** section, click on **New repository secret**.
2. Add each of the following secrets one by one:
   - **Name:** `AZURE_CLIENT_ID` → **Value:** *Your Azure App’s Client ID*  
   - **Name:** `AZURE_TENANT_ID` → **Value:** *Your Azure Tenant ID*  
   - **Name:** `AZURE_SUBSCRIPTION_ID` → **Value:** *Your Azure Subscription ID*
3. Click **Add secret** after each entry.

Once saved, the secrets appear under the repository secrets list —  
you’ll see small lock icons 🔒 indicating they’re encrypted and secure.

#### Step 3 — (Optional) Environment Secrets
If you use **GitHub Environments** (e.g., `dev`, `qa`, `prod`), you can add environment-specific secrets too:
1. Go to **Settings → Environments → [Select environment] → Manage environment secrets**.  
2. Add secrets specific to that environment (for example, separate Azure accounts per stage).

---

### 🧩 How Secrets Are Used in the Workflow

In your workflow YAML (e.g., `terraform-multi.yaml`), you reference secrets like this:

```yaml
- name: Azure Login (OIDC)
  uses: azure/login@v2
  with:
    client-id: ${{ secrets.AZURE_CLIENT_ID }}
    tenant-id: ${{ secrets.AZURE_TENANT_ID }}
    subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
```




### 🧠 Best Practices for Secure Secret Management

To ensure your CI/CD pipeline and infrastructure remain secure and compliant, always follow these recommended practices:

---

#### 🔒 1. Use Environment-Level Secrets
- Prefer **environment-level secrets** instead of global repository secrets.  
- This ensures tighter access control — for example:
  - `dev` → test credentials  
  - `qa` → staging credentials  
  - `prod` → real production credentials  
- Environment secrets can only be accessed by jobs running in that environment.

---

#### ♻️ 2. Regularly Rotate Your Credentials
- Periodically **regenerate Azure credentials** (App registrations, service principals).  
- Update them immediately in your GitHub secrets.  
- This minimizes the risk of leaked or stale credentials being reused.

---

#### 🚫 3. Never Expose Secrets in Logs
- Avoid using `echo`, `print`, or `terraform output` commands that might reveal secrets.  
- GitHub automatically masks secrets in logs, but avoid printing any variable containing them.  
- Example of what **not** to do:
  ```yaml
  - run: echo "Client ID: ${{ secrets.AZURE_CLIENT_ID }}"  # ❌ Unsafe
---

#### 🧍‍♂️ 4. Restrict Secret Access & Editing

Keeping your secrets secure also means **controlling who can manage them**. Follow these steps:

- ✅ **Allow only trusted collaborators or admins** to edit secrets.  
  This limits potential security risks from unauthorized changes.

- ⚙️ Navigate to **Repository → Settings → Manage Access**  
  Here you can view and modify collaborator permissions.

- 🔁 **Review access regularly** — remove inactive users or anyone who no longer needs secret management privileges.

- 🔐 Keep a minimal privilege policy — “**least privilege principle**” always applies.

---

#### 🧰 5. Validate Before Deploying

Before you deploy to production, make sure all configurations and secrets are valid:

- 🧪 **Test your workflows in a non-production environment** first (like `dev` or `qa`).  
  This prevents accidental deployments or resource destruction in live systems.

- 📋 Run `terraform plan` before `terraform apply`.  
  This checks authentication, access roles, and infrastructure changes without making modifications.

- 🕵️‍♂️ Validate all Azure credentials (Client ID, Tenant ID, Subscription ID)  
  to ensure they match the correct environment setup.





## 🔐 Security Practices
- `.gitignore` excludes `*.tfstate`, `terraform.tfvars`, and `.terraform/`  
- Secrets never committed to code  
- Each environment isolated with separate state files  

---

## 📤 Terraform Outputs
- Resource Group Names & IDs  
- VNet & Subnet IDs  
- NIC IPs & IDs  
- Load Balancer Rules & Probes  
- SQL Server & Database IDs  

---


## 📃 License
**MIT License** – Free to use and modify with attribution.

---

## 👨‍💻 Author
**Ritesh Sharma | DevOps Engineer**  
🔗 [LinkedIn Profile](https://www.linkedin.com/in/riteshatri)

---

> 💡 *This repository showcases a complete DevOps automation workflow — from modular Terraform design to multi-environment GitHub Actions pipelines — demonstrating scalable, secure, and production-ready IaC deployment on Microsoft Azure.*
