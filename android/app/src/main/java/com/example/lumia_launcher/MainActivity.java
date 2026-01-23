package com.example.lumia_launcher;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "lumia_launcher/apps";

    @Override
    public void configureFlutterEngine(FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL);
        channel.setMethodCallHandler(
            new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, Result result) {
                    if (call.method.equals("launchApp")) {
                        String packageName = call.argument("package");
                        if (packageName != null) {
                            launchApp(packageName, result);
                        } else {
                            result.error("INVALID_ARGUMENT", "Package name cannot be null", null);
                        }
                    } else {
                        result.notImplemented();
                    }
                }
            });
    }

    private void launchApp(String packageName, Result result) {
        try {
            PackageManager packageManager = getPackageManager();
            Intent intent = packageManager.getLaunchIntentForPackage(packageName);
            if (intent != null) {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                startActivity(intent);
                result.success(true);
            } else {
                result.error("APP_NOT_FOUND", "App with package name " + packageName + " not found", null);
            }
        } catch (Exception e) {
            result.error("LAUNCH_FAILED", "Failed to launch app: " + e.getMessage(), null);
        }
    }
}