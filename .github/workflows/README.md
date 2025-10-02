# CI/CD Pipeline Setup

This document explains how to set up and use the GitHub Actions CI/CD pipeline for the Heavek Mobile project.

## Pipeline Features

The CI pipeline automatically runs on:
- Push events to `main` and `develop` branches
- Pull requests targeting `main` and `develop` branches

### Current Jobs

1. **Android Build Job**
   - Runs on Ubuntu Latest
   - Sets up Java 17 and Flutter 3.35.4
   - Runs code analysis, tests, and builds debug APK
   - Uploads APK as downloadable artifact (7-day retention)

2. **iOS Build Job** (Commented out, ready for future use)
   - Runs on macOS Latest
   - Builds iOS app without code signing
   - Uploads iOS build as artifact

## Required Setup

### GitHub Repository Secrets

You need to configure the following secrets in your GitHub repository:

1. Go to your repository Settings
2. Navigate to Secrets and variables → Actions
3. Add the following repository secrets:

   - `APP_USERNAME`: Your application username/API key
   - `APP_SECRET`: Your application secret/password

### How to Add Secrets

1. In GitHub, go to: Repository → Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add each required secret with its corresponding value

## Pipeline Workflow

When triggered, the pipeline will:

1. **Checkout Code**: Downloads the latest code
2. **Setup Environment**: Installs Java 17 and Flutter 3.35.4
3. **Create Environment File**: Generates .env file from GitHub secrets
4. **Install Dependencies**: Runs `flutter pub get`
5. **Code Analysis**: Runs `flutter analyze` to check code quality
6. **Run Tests**: Executes `flutter test` to verify functionality
7. **Build APK**: Creates debug APK for Android
8. **Upload Artifacts**: Makes build available for download

## Accessing Build Artifacts

After a successful pipeline run:

1. Go to the Actions tab in your GitHub repository
2. Click on the completed workflow run
3. Scroll down to "Artifacts" section
4. Download the `debug-apk` file
5. Extract and install the APK on your Android device

## Future Enhancements

### iOS Builds
To enable iOS builds:
1. Uncomment the `ios-build` job in `.github/workflows/ci.yml`
2. The pipeline will then build for both Android and iOS

### Additional Features
- Add release APK builds with signing
- Integrate with app distribution services
- Add code coverage reporting
- Set up automated testing on multiple Flutter versions

## Troubleshooting

### Common Issues

1. **Missing Secrets**: Ensure `APP_USERNAME` and `APP_SECRET` are configured
2. **Build Failures**: Check the Actions logs for detailed error messages
3. **Dependency Issues**: Update Flutter version in workflow if needed

### Getting Help

If you encounter issues:
1. Check the Actions tab for detailed logs
2. Verify all secrets are properly configured
3. Ensure your code passes local `flutter analyze` and `flutter test`

## Pipeline Status

You can check the status of your builds by looking at:
- The green/red checkmark on commits
- The Actions tab in your repository
- Pull request status checks