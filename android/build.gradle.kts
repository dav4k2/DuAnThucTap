// 1. Cấu hình Buildscript (Chuyển từ Groovy sang Kotlin DSL)
buildscript {
    val kotlinVersion = "1.9.10"
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        // Tương đương với classpath 'com.android.tools.build:gradle:8.1.0'
        classpath("com.android.tools.build:gradle:8.1.0")
        // Tương đương với classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
    }
}

// 2. Cấu hình Repositories cho tất cả các project
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// 3. Logic thay đổi đường dẫn thư mục Build (Giữ nguyên từ code gốc của bạn)
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}

// 4. Cấu hình phụ thuộc đánh giá cho subprojects
subprojects {
    project.evaluationDependsOn(":app")
}

// 5. Task dọn dẹp (Clean Task)
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}