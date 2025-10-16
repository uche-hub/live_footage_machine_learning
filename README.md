# Live Footage App Maching Learn

An App to display real time images

## ✨ Features
- Display Live Camera Footage
- Getting Frames of camera
- Labeling libary
- Convert Camera Frames 
- Pass Frames on Image Classification Model
- Show Fram Image on Camera Footage

## 🚀 Quick Start

**We Ensure that plugin services are initialized then Obtain a list of the available cameras on the device (Check main.dart).**

# Displayed Camera Preview

# Package installed:
- **Camera:** A Flutter plugin for iOS, Android and Web allowing access to the device cameras.
-**google_mlkit_image_labeling**: A Flutter plugin to use Google's ML Kit Image Labeling to detect and extract information about entities in an image across a broad group of categories.

# Core changes:
- **Added IOS Camera Permissions**: NSCameraUsageDescription and NSMicrophoneUsageDescription
-**Change Android MinSDK**: change to 21

## Requirement: https://pub.dev/packages/google_mlkit_image_labeling

# IOS:
- Minimum iOS Deployment Target: 15.5
- Xcode 15.3.0 or newer
- Swift 5
- ML Kit does not support 32-bit architectures (i386 and armv7). ML Kit does support 64-bit architectures (x86_64 and arm64). Check this list to see if your device has the required device capabilities. More info here.

# Android:
- minSdkVersion: 21
- targetSdkVersion: 35
- compileSdkVersion: 35



### Installation
```bash
git clone https://github.com/uche-hub/live_footage_machine_learning.git