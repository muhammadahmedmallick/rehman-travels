# Fixing GitHub Actions SSH Connection Timeout

## Problem
GitHub Actions workflow fails with: `dial tcp ***:22: i/o timeout`

This means GitHub Actions cannot connect to your EC2 instance because the Security Group doesn't allow SSH from GitHub's IP ranges.

## Solution Options

### Option 1: Allow SSH from Anywhere (Quick & Easy)

⚠️ **Security Note**: This opens SSH to the internet. Make sure you have strong authentication (key-based only, no password).

**Steps:**
1. Go to AWS Console → EC2 → Security Groups
2. Find your EC2 instance's security group
3. Edit inbound rules
4. Find the SSH rule (port 22)
5. Change source from "My IP" to "0.0.0.0/0" (IPv4) and "::/0" (IPv6)
6. Save rules

**Security Group Rule:**
```
Type: SSH
Protocol: TCP
Port: 22
Source: 0.0.0.0/0 (Anywhere IPv4)
Description: Allow SSH from anywhere including GitHub Actions
```

✅ **Pros**: Simple, always works
❌ **Cons**: Less secure (but still requires SSH key authentication)

---

### Option 2: Use GitHub's Published IP Ranges (More Secure)

GitHub publishes their IP ranges that you can allowlist.

**Steps:**
1. Get GitHub's current IP ranges:
   ```bash
   curl https://api.github.com/meta | jq -r '.actions[]'
   ```

2. Add each IP range to your Security Group as a separate SSH rule

**Example IPs (as of 2025):**
```
13.64.0.0/16
13.65.0.0/16
13.66.0.0/16
... (many more)
```

⚠️ **Important**: GitHub's IP ranges change periodically. You'll need to update them.

✅ **Pros**: More secure, only GitHub Actions can connect
❌ **Cons**: Requires maintenance, many rules to add

**Automated Script:**
```bash
#!/bin/bash
# This would need to run periodically to update rules
SECURITY_GROUP_ID="sg-xxxxxxxxx"
GITHUB_IPS=$(curl -s https://api.github.com/meta | jq -r '.actions[]')

for IP in $GITHUB_IPS; do
    aws ec2 authorize-security-group-ingress \
        --group-id $SECURITY_GROUP_ID \
        --protocol tcp \
        --port 22 \
        --cidr $IP \
        --description "GitHub Actions"
done
```

---

### Option 3: Use AWS Systems Manager (No SSH Needed)

Use AWS Systems Manager Session Manager instead of SSH. No open ports required!

**Requirements:**
1. Install SSM Agent on EC2 (usually pre-installed on Amazon Linux/Ubuntu AMIs)
2. Attach IAM role to EC2 with `AmazonSSMManagedInstanceCore` policy
3. Update workflow to use `aws ssm send-command` instead of SSH

**Modified Workflow:**
```yaml
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v2
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: us-east-1

- name: Deploy via SSM
  run: |
    aws ssm send-command \
      --instance-ids i-xxxxxxxxx \
      --document-name "AWS-RunShellScript" \
      --parameters 'commands=[
        "cd /rehman-travels/backen-alrehman",
        "git pull origin main",
        "docker-compose up -d --build"
      ]' \
      --output text
```

✅ **Pros**: Most secure, no open ports, audited by AWS
❌ **Cons**: More complex setup, requires AWS IAM configuration

---

### Option 4: Self-Hosted GitHub Actions Runner (Advanced)

Run a GitHub Actions runner on your EC2 instance itself.

**Setup:**
1. On your EC2 instance:
   ```bash
   # Download runner
   mkdir actions-runner && cd actions-runner
   curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
   tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz

   # Configure (get token from GitHub repo settings)
   ./config.sh --url https://github.com/YOUR_USERNAME/rehman-travels --token YOUR_TOKEN

   # Run as service
   sudo ./svc.sh install
   sudo ./svc.sh start
   ```

2. Update workflow to use self-hosted runner:
   ```yaml
   jobs:
     deploy:
       runs-on: self-hosted  # Instead of ubuntu-latest
   ```

✅ **Pros**: No network issues, faster deployments, can access local resources
❌ **Cons**: Requires runner maintenance, uses EC2 resources

---

## Recommended Approach

**For Development/Testing:**
- Use **Option 1** (Allow from anywhere) - Quick and easy

**For Production:**
- Use **Option 3** (AWS Systems Manager) - Most secure, no open ports
- Or **Option 2** (GitHub IP ranges) - Good middle ground

---

## Quick Fix (Option 1) - Step-by-Step

### 1. Open AWS Console
Go to: https://console.aws.amazon.com/ec2/

### 2. Navigate to Security Groups
- Click "Security Groups" in the left sidebar (under "Network & Security")
- Find the security group attached to your EC2 instance (IP: 3.222.113.143)

### 3. Edit Inbound Rules
- Select the security group
- Click "Edit inbound rules" button
- Find the SSH rule (Type: SSH, Port: 22)

### 4. Modify SSH Rule
- Change "Source" from "My IP" or specific IP to: **0.0.0.0/0**
- Optionally add another rule for IPv6: **::/0**
- Update description: "SSH access for GitHub Actions"

### 5. Save Rules
- Click "Save rules"
- Wait ~30 seconds for changes to propagate

### 6. Test Deployment
- Go to GitHub Actions
- Re-run the failed workflow
- It should now connect successfully!

---

## Verification

After updating Security Group, verify the rule:

```bash
# From your local machine, check if port is open
nc -zv 3.222.113.143 22
```

Should show: `Connection to 3.222.113.143 22 port [tcp/ssh] succeeded!`

---

## Troubleshooting

### Still timing out after opening port?

1. **Check Network ACLs**:
   - EC2 → Network ACLs
   - Ensure inbound rule allows SSH (port 22)

2. **Check EC2 is in public subnet**:
   - EC2 → Instances → Networking tab
   - Should have a public IP/DNS

3. **Check Route Table**:
   - Should have route to Internet Gateway (0.0.0.0/0 → igw-xxxxx)

4. **Verify GitHub Secrets**:
   - Go to: Settings → Secrets and variables → Actions
   - Verify EC2_HOST is exactly: `3.222.113.143`
   - Verify EC2_USERNAME is exactly: `ubuntu`
   - Verify EC2_SSH_KEY has complete key content

5. **Check EC2 SSH service**:
   ```bash
   ssh -i rehman-travels-key.pem ubuntu@3.222.113.143
   sudo systemctl status ssh
   ```

---

## Security Best Practices

If using Option 1 (allow from anywhere):

1. ✅ **Disable password authentication** (key-only):
   ```bash
   sudo sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
   sudo systemctl restart ssh
   ```

2. ✅ **Use fail2ban** to block brute force attempts:
   ```bash
   sudo apt install fail2ban -y
   sudo systemctl enable fail2ban
   sudo systemctl start fail2ban
   ```

3. ✅ **Change SSH port** (optional but adds security through obscurity):
   ```bash
   # Edit SSH config
   sudo nano /etc/ssh/sshd_config
   # Change: Port 22 to Port 2222

   # Update Security Group to allow port 2222 instead of 22
   # Update workflow to use port: 2222
   ```

4. ✅ **Enable CloudWatch logging** to monitor access

5. ✅ **Regularly rotate SSH keys**

---

## Need Help?

If you're still having issues:
1. Check GitHub Actions logs for exact error
2. Try SSH from your local machine to confirm it works
3. Check AWS CloudTrail for security group changes
4. Verify EC2 instance state (running, not stopped)

---

**Quick Command Reference:**

```bash
# Test SSH locally
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 "echo 'Connected!'"

# Check EC2 security groups (requires AWS CLI)
aws ec2 describe-security-groups --group-ids sg-xxxxx

# Get GitHub Actions IP ranges
curl https://api.github.com/meta | jq '.actions'

# Check EC2 instance SSH service
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'sudo systemctl status ssh'
```

---

**Last Updated:** February 2025
