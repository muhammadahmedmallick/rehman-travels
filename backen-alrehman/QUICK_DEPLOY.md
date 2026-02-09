# Quick Deployment Reference

## 🚀 Deploy to EC2

### 1. Setup GitHub Secrets (One-time)

Go to: **GitHub Repo → Settings → Secrets and variables → Actions**

Add these secrets:
- `EC2_HOST` = `3.222.113.143`
- `EC2_USERNAME` = `ubuntu`
- `EC2_SSH_KEY` = (paste contents of `rehman-travels-key.pem`)

### 2. Deploy Automatically

```bash
# Make changes and commit
git add .
git commit -m "Your changes"
git push origin main
```

✅ **GitHub Actions will automatically deploy!**

Watch progress: **GitHub → Actions tab**

---

## 🔧 Manual Commands

### Deploy Now (Manual)
```bash
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 << 'EOF'
cd /rehman-travels/backen-alrehman
git pull origin main
docker-compose down
docker-compose up -d --build
docker-compose exec -T web python manage.py migrate --noinput
docker-compose exec -T web python manage.py collectstatic --noinput
EOF
```

### Check Status
```bash
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && docker-compose ps'
```

### View Logs
```bash
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && docker-compose logs -f web'
```

### Restart App
```bash
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && docker-compose restart web'
```

---

## 🏥 Health Check

```bash
# Test API
curl http://3.222.113.143:8000/swagger/

# Test airport search
curl http://3.222.113.143:8000/api/core/sectors/?search=karachi
```

---

## 🐛 Troubleshooting

### Deployment Failed?
1. Check **GitHub Actions** logs
2. SSH to server and check logs:
   ```bash
   ssh -i rehman-travels-key.pem ubuntu@3.222.113.143
   cd /rehman-travels/backen-alrehman
   docker-compose logs --tail=100 web
   ```

### Reset Everything
```bash
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 << 'EOF'
cd /rehman-travels/backen-alrehman
git fetch origin main
git reset --hard origin/main
docker-compose down -v
docker-compose up -d --build
docker-compose exec -T web python manage.py migrate --noinput
EOF
```

---

## 📋 Deployment Checklist

Before pushing to main:
- [ ] Test locally: `docker-compose up -d`
- [ ] Check no errors in logs
- [ ] Verify `.env` exists on EC2
- [ ] Commit with clear message
- [ ] Push to main
- [ ] Monitor GitHub Actions
- [ ] Test live site after deploy

---

## 🔗 Quick Links

- **Live API**: http://3.222.113.143:8000/swagger/
- **GitHub Actions**: https://github.com/your-repo/actions
- **API Docs**: http://3.222.113.143:8000/redoc/

---

## 📞 Emergency Contact

If something breaks:
```bash
# Stop everything
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && docker-compose down'

# Start everything
ssh -i rehman-travels-key.pem ubuntu@3.222.113.143 'cd /rehman-travels/backen-alrehman && docker-compose up -d'
```
