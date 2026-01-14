plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") version "4.4.4" apply false
}

android {
    namespace = "com.example.fontend"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.1.12297006" // Giữ nguyên NDK cụ thể của bạn

    compileOptions {
        // [MỚI] Bật Desugaring để hỗ trợ các tính năng Java mới trên Android cũ
        isCoreLibraryDesugaringEnabled = true

        // Sử dụng Java 11 (tốt hơn 1.8 cho các bản Flutter/Firebase mới)
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.datt.cooking"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    // Giữ nguyên phần fix lỗi xung đột thư viện của bạn
    configurations.all {
        resolutionStrategy {
            force("androidx.browser:browser:1.8.0")
            force("androidx.core:core-ktx:1.13.1")
            force("androidx.core:core:1.13.1")
        }
    }
}

dependencies {
    // [MỚI] Thư viện hỗ trợ Desugaring
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // Firebase BoM và Analytics (Giữ nguyên)
    implementation(platform("com.google.firebase:firebase-bom:34.4.0"))
    implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}
