# GitHub Secrets Configuration Guide

This guide provides step-by-step instructions for configuring GitHub Secrets needed for automatic deployment to AWS EC2.

## Why GitHub Secrets?

GitHub Secrets allow you to store sensitive information (like SSH keys, passwords, API tokens) securely in your repository. These secrets are encrypted and only accessible during GitHub Actions workflow execution.

---

## Required Secrets

Your deployment pipeline requires 3 secrets:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `EC2_HOST` | Your EC2 instance IP address or domain | `3.222.113.143` |
| `EC2_USERNAME` | SSH username for EC2 login | `ubuntu` |
| `EC2_SSH_KEY` | Private SSH key for authentication | Contents of `.pem` file |

---

## Step-by-Step Setup

### Step 1: Access GitHub Secrets Settings

1. Open your GitHub repository in a web browser
2. Click on **Settings** tab (top navigation)
3. In the left sidebar, click **Secrets and variables**
4. Click **Actions** from the dropdown
5. You should see the "Actions secrets and variables" page

**Navigation Path:**
```
Repository → Settings → Secrets and variables → Actions
```

---

### Step 2: Add EC2_HOST Secret

1. Click the **New repository secret** button (green button, top right)
2. In the "Name" field, enter: `EC2_HOST`
3. In the "Secret" field, enter your EC2 IP address: `3.222.113.143`
   - **Important**: Enter ONLY the IP address, no `http://`, no trailing slash
4. Click **Add secret**

**What this does:** Tells GitHub Actions which server to connect to.

---

### Step 3: Add EC2_USERNAME Secret

1. Click **New repository secret** again
2. In the "Name" field, enter: `EC2_USERNAME`
3. In the "Secret" field, enter: `ubuntu`
   - For Amazon Linux AMI, this would be `ec2-user`
   - For Ubuntu AMI, this is `ubuntu`
4. Click **Add secret**

**What this does:** Specifies which user to login as when connecting via SSH.

---

### Step 4: Add EC2_SSH_KEY Secret

This is the most important secret. You need your EC2 private key file (`.pem` file).

#### On macOS/Linux:

1. Open Terminal
2. Navigate to where your key file is stored:
   ```bash
   cd ~/.ssh/
   # or
   cd ~/Downloads/
   ```

3. Display the key content:
   ```bash
   cat rehman-travels-key.pem
   ```

4. You should see output like:
   ```
   -----BEGIN RSA PRIVATE KEY-----
   MIIEpAIBAAKCAQEA...
   [many lines of encoded text]
   ...
   -----END RSA PRIVATE KEY-----
   ```

5. **Copy the ENTIRE output** (including the BEGIN and END lines)

#### On Windows:

1. Open Command Prompt or PowerShell
2. Navigate to your key location:
   ```cmd
   cd C:\Users\YourName\Downloads\
   ```

3. Display the key:
   ```cmd
   type rehman-travels-key.pem
   ```

4. Copy the entire output

#### Add to GitHub:

1. Go back to GitHub Secrets page
2. Click **New repository secret**
3. In the "Name" field, enter: `EC2_SSH_KEY`
4. In the "Secret" field, **paste the entire key content** you just copied
   - Include `-----BEGIN RSA PRIVATE KEY-----`
   - Include all the encoded text
   - Include `-----END RSA PRIVATE KEY-----`
5. Click **Add secret**

**What this does:** Allows GitHub Actions to authenticate with your EC2 server without a password.

---

### Step 5: Verify All Secrets Are Added

After adding all three secrets, you should see:

```
EC2_HOST              Updated X minutes ago
EC2_USERNAME          Updated X minutes ago
EC2_SSH_KEY           Updated X minutes ago
```

**Note:** You can see when secrets were last updated, but you CANNOT view the secret values again. If you made a mistake, delete the secret and add it again.

---

## Testing Your Setup

### Option 1: Push to Main Branch (Automatic)

1. Make a small change to your code
2. Commit and push to main:
   ```bash
   git add .
   git commit -m "Test deployment"
   git push origin main
   ```
3. Go to **Actions** tab in GitHub
4. Watch the "Deploy to EC2" workflow run
5. If it succeeds, your secrets are configured correctly!

### Option 2: Manual Workflow Trigger

1. Go to **Actions** tab in GitHub
2. Click on **Deploy to EC2** workflow (left sidebar)
3. Click **Run workflow** button (right side)
4. Select `main` branch from dropdown
5. Click green **Run workflow** button
6. Watch the workflow execute

---

## Troubleshooting

### Error: "Permission denied (publickey)"

**Problem:** The SSH key secret is incorrect or incomplete.

**Solution:**
1. Delete the `EC2_SSH_KEY` secret
2. Re-copy your `.pem` file content (make sure to include BEGIN/END lines)
3. Add it again as a new secret
4. Make sure there are no extra spaces or line breaks

### Error: "Connection timeout" or "Host not found"

**Problem:** The EC2_HOST is incorrect or the server is not running.

**Solution:**
1. Verify your EC2 instance is running in AWS Console
2. Check the `EC2_HOST` secret has the correct IP address
3. Ensure EC2 Security Group allows SSH (port 22) from GitHub Actions IPs

### Error: "Permission denied, please try again"

**Problem:** Wrong username for your EC2 instance.

**Solution:**
1. Check which AMI you're using:
   - **Ubuntu AMI**: Use `ubuntu` as username
   - **Amazon Linux AMI**: Use `ec2-user` as username
   - **Other Linux**: Check AMI documentation
2. Update `EC2_USERNAME` secret with correct value

### Secrets Don't Seem to Update

**Problem:** Old secret values are cached.

**Solution:**
1. Delete the secret completely
2. Wait 1-2 minutes
3. Add it again with the new value
4. Re-run the workflow

---

## Security Best Practices

### DO:
- Store the `.pem` file in a secure location on your local machine
- Use `chmod 400 rehman-travels-key.pem` to set proper permissions
- Keep a backup of your SSH key in a secure password manager
- Rotate SSH keys periodically (every 6-12 months)
- Limit EC2 Security Group to allow SSH only from necessary IPs

### DON'T:
- Never commit `.pem` files to Git
- Never share your private key via email, Slack, or other messaging
- Never post secrets in GitHub Issues or Pull Requests
- Never use the same SSH key across multiple environments
- Never store unencrypted keys in cloud storage

---

## Updating Secrets

If you need to change a secret (e.g., new EC2 instance, rotated SSH key):

1. Go to **Settings → Secrets and variables → Actions**
2. Find the secret you want to update
3. Click the secret name
4. Click **Remove secret** button
5. Confirm removal
6. Click **New repository secret**
7. Add the secret again with new value

**Note:** You cannot edit existing secrets - you must delete and recreate them.

---

## Verification Checklist

Before running your first deployment, verify:

- [ ] All 3 secrets are added in GitHub
- [ ] `EC2_HOST` contains only the IP address (no protocol, no port)
- [ ] `EC2_USERNAME` matches your EC2 AMI type
- [ ] `EC2_SSH_KEY` includes BEGIN and END lines
- [ ] You can manually SSH to EC2 using the same `.pem` file
- [ ] EC2 Security Group allows inbound SSH (port 22)
- [ ] EC2 instance is running
- [ ] Application directory exists at `/rehman-travels/backen-alrehman` on EC2
- [ ] Docker and Docker Compose are installed on EC2

---

## Quick Test Commands

Run these locally to verify your EC2 setup before relying on GitHub Actions:

```bash
# Test SSH connection
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 "echo 'Connection successful'"

# Test directory exists
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 "ls -la /rehman-travels/backen-alrehman"

# Test Docker is accessible
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 "docker ps"

# Test Git is working
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 "cd /rehman-travels/backen-alrehman && git status"
```

If all these commands succeed, your GitHub Secrets should work!

---

## Alternative: Using SSH Config

For easier local testing, you can add this to `~/.ssh/config`:

```
Host rehman-travels-ec2
    HostName 3.222.113.143
    User ubuntu
    IdentityFile ~/.ssh/rehman-travels-key.pem
    StrictHostKeyChecking no
```

Then you can simply run:
```bash
ssh rehman-travels-ec2
```

---

## Need Help?

If deployment still fails after configuring secrets:

1. **Check GitHub Actions logs:**
   - Go to Actions tab → Click failed workflow → View detailed logs
   - Look for specific error messages

2. **Check EC2 logs:**
   ```bash
   ssh -i rehman-travels-key.pem ubuntu@3.222.113.143
   cd /rehman-travels/backen-alrehman
   docker-compose logs --tail=100
   ```

3. **Verify network connectivity:**
   - Ensure EC2 instance is in a public subnet
   - Check route tables and internet gateway
   - Verify Security Group rules

4. **Review deployment guide:**
   - See `DEPLOYMENT_GUIDE.md` for comprehensive troubleshooting
   - See `QUICK_DEPLOY.md` for quick reference commands

---

## Summary

You need exactly 3 secrets:

1. **EC2_HOST** → Your server IP
2. **EC2_USERNAME** → SSH username
3. **EC2_SSH_KEY** → Your private key file content

Once configured, every push to `main` automatically deploys to your EC2 server.

**Next Steps:**
1. Complete the checklist above
2. Test manual deployment: `git push origin main`
3. Monitor in Actions tab
4. Celebrate successful deployment!

---

**Last Updated:** February 2025
