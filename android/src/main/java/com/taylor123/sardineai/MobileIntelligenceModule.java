package com.taylor123.sardineai;

import android.app.Activity;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.EditText;
import android.widget.LinearLayout;

import com.facebook.react.ReactRootView;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.google.gson.Gson;
import com.sardine.ai.mdisdk.MobileIntelligence;
import com.sardine.ai.mdisdk.Options;
import com.sardine.ai.mdisdk.UpdateOptions;

import java.util.LinkedList;
import java.util.Queue;

public class MobileIntelligenceModule extends ReactContextBaseJavaModule {

    MobileIntelligenceModule(ReactApplicationContext context) {
        super(context);
    }

    @Override
    public String getName() {
        return "MobileIntelligenceModule";
    }

    @ReactMethod
    public void trackCustomData(ReadableMap stateData, Promise promise){
        MobileIntelligence.trackCustomData(new Gson().toJson(stateData));
    }

    @ReactMethod
    public void trackTextChange(String viewId, String text){
        MobileIntelligence.trackTextChange(viewId, text);
    }

    @ReactMethod
    public void trackFocusChange(String viewId, boolean isFocus){
        MobileIntelligence.trackFocusChange(viewId, isFocus);
    }

    @ReactMethod
    public void setupSDK(ReadableMap additionalData, Promise promise) {

        if (!additionalData.hasKey("clientId") || !additionalData.hasKey("sessionKey")) {
            promise.resolve(new Response(false, "Failed to initialize").getGson());
            return;
        }

        Options.Builder optionBuilder = new Options.Builder()
                .setClientID(additionalData.getString("clientId"))
                .setSessionKey(additionalData.getString("sessionKey"));
        if (additionalData.hasKey("environment")) {
            optionBuilder = optionBuilder.setEnvironment(additionalData.getString("environment"));
        }
        if (additionalData.hasKey("userIdHash")) {
            optionBuilder = optionBuilder.setUserIDHash(additionalData.getString("userIdHash"));
        }
        if (additionalData.hasKey("flow")) {
            optionBuilder = optionBuilder.setFlow(additionalData.getString("flow"));
        }

        try {
            MobileIntelligence.init(this.getReactApplicationContext(), optionBuilder.build());
            promise.resolve(new Response(true, "Initialized successfully").getGson());
        } catch (Throwable e) {
            promise.reject(e);
        }
    }

    @ReactMethod
    public void updateOptions(ReadableMap additionalData, Promise promise) {
        String flow = additionalData.getString("flow");
        String sessionKey = additionalData.getString("sessionKey");
        String userIdHash = additionalData.getString("userIdHash");

        if (userIdHash == null && sessionKey == null && flow == null) {
            promise.resolve(new Response(false, "Failed to update options").getGson());
            return;
        }

        UpdateOptions.Builder optionBuilder = new UpdateOptions.Builder();
        if (sessionKey != null) {
            optionBuilder.setSessionKey(sessionKey);
        }
        if (flow != null) {
            optionBuilder.setFlow(flow);
        }
        if (userIdHash != null) {
            optionBuilder.setUserIDHash(userIdHash);
        }

        MobileIntelligence.updateOptions(optionBuilder.build());
        promise.resolve(new Response(true, "Options updated successfully").getGson());
    }

    @ReactMethod
    public void submitData(final Promise promise) {
        MobileIntelligence.submitData(new MobileIntelligence.Callback<MobileIntelligence.SubmitResponse>() {
            @Override
            public void onSuccess(MobileIntelligence.SubmitResponse response) {
                promise.resolve(new Response(true, "Event logged successfully").getGson());
            }

            @Override
            public void onError(Exception e) {
                promise.resolve(new Response(false, "Failed to log event").getGson());

            }
        });
    }

    @ReactMethod
    public void silentAuth(ReadableMap additionalData, final Promise promise) {
        String number = additionalData.getString("number");
        MobileIntelligence.silentAuth(number, new MobileIntelligence.Callback<MobileIntelligence.SilentAuthResponse>() {
            @Override
            public void onSuccess(MobileIntelligence.SilentAuthResponse response) {
                promise.resolve(new Response(true, "Authorized successfully").getGson());
            }

            @Override
            public void onError(Exception e) {
                promise.resolve(new Response(false, "Failed to authorize").getGson());
            }
        });
    }
}

class Response {
    private boolean status;
    private String message;
    public Response(boolean status, String message) {
        this.status = status;
        this.message = message;
    }

    public String getGson() {
        Gson gson = new Gson();
        return gson.toJson(this);
    }
}