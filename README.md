# Medilens

### Change the App Name and Bundle Id in project

```sh
flutter pub get
```

```sh
flutter pub global activate rename
```

```sh
rename getAppName --targets ios,android
```

```sh
rename setAppName --targets ios,android --value "appname"
```

```sh
rename getBundleId --targets ios,android
```

```sh
rename setBundleId --targets ios,android --value "com.example.appname"
```

#### AdMob config
Change this file [AndroidManifest.xml](android/app/src/main/AndroidManifest.xml#L33)
```xml
<application>
    <!-- ... -->
    
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
-        android:value="ca-app-pub-3940256099942544~3347511713"/>
+        android:value="your_key>"/>
</application>
 ```