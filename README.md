# Car Rental Dev Environment - Ubuntu 22.04 LTS

Rock-solid dev container for Java 21 backend development.

## ✨ Why Ubuntu 22.04?

- ✅ **Most Popular**: Huge community, tons of resources
- ✅ **Rock Solid**: Extremely stable, reliable builds
- ✅ **APT Package Manager**: Simple, just works
- ✅ **Long-term Support**: Until April 2027
- ✅ **Works on AWS EC2**: Very popular on AWS
- ✅ **Best Documentation**: Easy to find help

## 🚀 Quick Start

### 1. Setup
```bash
# Clone this repo
git clone <repo-url>
cd car-rental-dev-environment

# Configure
cp config/.env.example .env
nano .env  # Add your repo URL
```

### 2. Open in VS Code
```bash
code .
```

### 3. Start Container
- Press `F1`
- Select: "Dev Containers: Reopen in Container"
- Wait 2-3 minutes

### 4. Verify
```bash
java -version  # Temurin 21
cd backend
./gradlew build
```

## 📁 Structure

/workspace/
├── backend/     # Your backend code
├── frontend/    # Your frontend code
├── docs/        # Documentation
└── logs/        # Application logs

## 🔧 Usage

### Build
```bash
cd /workspace/backend

# Gradle
./gradlew clean build

# Maven
./mvnw clean install
```

### Run
```bash
# Gradle
./gradlew bootRun

# Maven
./mvnw spring-boot:run

# Access: http://localhost:8080
```

### Test
```bash
./gradlew test     # Gradle
./mvnw test        # Maven
```

## 📦 Package Management

Ubuntu uses **APT**:
```bash
# Install package
sudo apt install package-name

# Update packages
sudo apt update
sudo apt upgrade

# Search
apt search package-name
```

## 🐛 Troubleshooting

### Container won't start
```bash
docker ps
docker logs java-backend-dev-ubuntu
```

### Rebuild
F1 → "Dev Containers: Rebuild Container"

### SSH issues
```bash
# Check keys
ls -la ~/.ssh/

# Test GitHub
ssh -T git@github.com
```

### Port conflict
Edit `.env`, change `BACKEND_PORT=8081`

## 🚀 Deploy to AWS EC2

### 1. Build JAR
```bash
./gradlew bootJar
# Output: build/libs/app.jar
```

### 2. Copy to EC2
```bash
scp build/libs/app.jar ubuntu@your-ec2:/home/ubuntu/
```

### 3. Run on EC2
```bash
ssh ubuntu@your-ec2
java -jar app.jar
```

## ✅ Validation
```bash
bash /workspace/scripts/validate.sh
```