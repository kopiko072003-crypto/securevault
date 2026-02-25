plugins {
    // use same AGP/Kotlin versions as declared in settings.gradle.kts
    id("com.android.application") version "8.11.1" apply false
    // `com.android.library` is already provided by the Flutter plugin loader at runtime,
    // defining it here can cause an unknown-version conflict, so leave it off.
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Google Services plugin for Firebase
        classpath("com.google.gms:google-services:4.4.4")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// ---------------------
// Custom build directories
// ---------------------
val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.set(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.set(newSubprojectBuildDir)
    project.evaluationDependsOn(":app")
}

// ---------------------
// Clean task
// ---------------------
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}