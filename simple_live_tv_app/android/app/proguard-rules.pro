#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keep class de.prosiebensat1digital.** { *; }
-dontwarn io.flutter.embedding.**
-ignorewarnings

# package_info_plus
-keep class io.flutter.plugins.packageinfo.** { *; }
-keep class dev.fluttercommunity.plus.packageinfo.** { *; }