# Keep WorkManager's internal Room database and its generated impl classes
-keep class * extends androidx.room.RoomDatabase
-keep class androidx.work.impl.** { *; }
-keepclassmembers class androidx.work.impl.WorkDatabase_Impl {
    public <init>();
}

# Keep Room-generated *_Impl classes in general
-keep class **_Impl { *; }
-keepclassmembers class **_Impl {
    public <init>(...);
}