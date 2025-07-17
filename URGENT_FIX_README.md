# 🚨 URGENT FIX - Upload Instructions

## The Problem
Home Assistant is still trying to pull from Docker registry instead of building locally.

## ✅ What I Fixed
1. **Version bumped** to `1.0.1` to force refresh
2. **Completely removed** `image:` line from `config.yaml`
3. **Added proper** `build.yaml` file for local building

## 📋 Critical Files to Upload to GitHub

### **MUST UPDATE THESE FILES:**

1. **`globalping/config.yaml`** - Now version 1.0.1, no image reference
2. **`globalping/build.yaml`** - NEW FILE for build configuration  
3. **`globalping/CHANGELOG.md`** - Updated with fix information

### **Upload Steps:**

1. **Upload ALL files** from `C:\Users\rob\Downloads\ha-globalping-addon\` to GitHub
2. **Pay special attention** to the `globalping/build.yaml` file - this is NEW
3. **Ensure** the `globalping/config.yaml` shows version `1.0.1`

### **After Upload:**

1. Go to Home Assistant → Settings → Add-ons → Add-on Store
2. Click three dots → Repositories
3. Find your repository and click "Reload" or remove/re-add it
4. Try installing again - it should now build locally

## 🎯 Expected Behavior After Fix:

- ✅ No more 403 registry errors
- ✅ Home Assistant will build locally (5-15 minutes)
- ✅ Supervisor logs will show: "Building addon locally..."
- ✅ Installation will complete successfully

## 🔧 Key Changes Made:

**config.yaml:**
```yaml
name: "Globalping Network Diagnostics"
version: "1.0.1"  # <- BUMPED VERSION
# No image: line anymore - forces local build
```

**build.yaml (NEW FILE):**
```yaml
build_from:
  amd64: "ghcr.io/home-assistant/amd64-base:3.19"
  # ... other architectures
```

Upload these files NOW and the installation should work! 🚀
