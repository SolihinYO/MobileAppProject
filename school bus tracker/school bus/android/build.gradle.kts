// 1. Plugins block with updated versions to match your system requirements
plugins {
    // Gunakan versi 8.9.1 yang berjaya tadi
    id("com.android.application") version "8.9.1" apply false
    
    // TUKAR VERSI INI KEPADA 2.1.0
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
    
    id("com.google.gms.google-services") version "4.4.2" apply false
}
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

// Configuration for subprojects
subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Clean task for build management
tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}