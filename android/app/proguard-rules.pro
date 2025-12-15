# Fyllens ProGuard Rules
# Keep rules for release builds to prevent R8 from removing required classes

# TensorFlow Lite - Keep all TFLite classes for ML model inference
-keep class org.tensorflow.lite.** { *; }
-keep class org.tensorflow.lite.gpu.** { *; }
-dontwarn org.tensorflow.lite.gpu.GpuDelegateFactory$Options

# Keep tflite_flutter plugin classes
-keep class sq.flutter.tflite_flutter.** { *; }

# Prevent obfuscation of model classes
-keepclassmembers class * {
  @org.tensorflow.lite.annotations.* <methods>;
}

# Keep native methods (JNI)
-keepclasseswithmembernames class * {
  native <methods>;
}

# Keep Flutter wrapper classes
-keep class io.flutter.** { *; }
-keep class io.flutter.plugin.** { *; }

# Google Play Core - Don't warn about missing classes (we don't use deferred components)
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.**
-dontwarn com.google.android.play.core.tasks.**

# Supabase
-keep class io.supabase.** { *; }
-dontwarn io.supabase.**

# Preserve line numbers for debugging
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile
