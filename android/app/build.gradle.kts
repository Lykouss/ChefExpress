// Importa as classes necessárias no topo do ficheiro
import java.util.Properties
import java.io.FileInputStream

// Código em Kotlin para ler o seu ficheiro key.properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
keystoreProperties.load(FileInputStream(keystorePropertiesFile))

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("org.jetbrains.kotlin.android") // Usa o ID correto para kotlin-android em .kts
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.chef_express"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = "1.8"
    }

    // --- CÓDIGO DE ASSINATURA CORRIGIDO PARA KOTLIN DSL ---
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
        release {
            // Diz ao Gradle para usar a nossa configuração de assinatura.
            signingConfig = signingConfigs.getByName("release")
        }
    }
    // --- FIM DA CORREÇÃO ---

    defaultConfig {
        applicationId = "com.example.chef_express"
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = 1
        versionName = "1.0.0"
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.2.0"))
}
