allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

subprojects {
    plugins.withId("com.android.library") {
        if (name == "flutter_windowmanager") {
            extensions.configure<com.android.build.gradle.LibraryExtension>("android") {
                namespace = "io.flutter.plugins.flutter_windowmanager"
            }
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
