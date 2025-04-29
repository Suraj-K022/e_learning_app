# Razorpay SDK
-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# Fix missing annotation classes used by Razorpay
-keep class proguard.annotation.Keep { *; }
-keep class proguard.annotation.KeepClassMembers { *; }

# Required for JS interfaces
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}
-keepattributes JavascriptInterface
-keepattributes *Annotation*

# Keep payment callbacks (e.g., onPaymentSuccess, onPaymentError)
-keepclasseswithmembers class * {
    public void onPayment*(...);
}

# Optional: prevent R8 from inlining methods (conservative optimization)
-optimizations !method/inlining/*
