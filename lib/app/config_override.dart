/// Key of APP ID
//const keyAppId = '3c0adef573f54493967ef264362cb6ad';
const keyAppId = '3b41a7057d2f449ea80cc26c59f98573';
/// Key of Channel ID
//const keyChannelId = '84';
const keyChannelId = 'appvteach111';
/// Key of token
//const keyToken = '007eJxTYHBIdtJZpP1gJ8+fp7lcx3jXdd5MTp2esKAwsk3jVHSBW54Cg3GyQWJKapqpuXGaqYmJpbGlmXlqmpGZibGZUXKSWWKKHkNvWkMgI8Nr52xGRgYIBPHZGMpKUhOTMxgYADh8Hs8=';
//const keyToken = '007eJxTYEg6cenePnuptOOG6eLZG7O/Tv67PGLNbZ57FVon7oqzPNJTYDBONkhMSU0zNTdOMzUxsTS2NDNPTTMyMzE2M0pOMktMuRuzOq0hkJFhZf8/RkYGCATx2RjKSlITkzMYGAAVKCJy';
//const keyToken = '007eJxTYHB7on7gx+R0och1d3R+8ojdLXv+xHHNHp/VE6RfLZiqvN1CgcE42SAxJTXN1Nw4zdTExNLY0sw8Nc3IzMTYzCg5ySwxZXXRmrSGQEaGS8WTWBgZIBDEZ2MoK0lNTM5gYAAADLAiGQ==';
//const keyToken = '007eJxTYHjL7Lvh4W724+x2O7fyP4xYJ3VCz1J4nqeuAVuA5fR1Pd8UGIyTDRJTUtNMzY3TTE1MLI0tzcxT04zMTIzNjJKTzBJT5Bg3pTUEMjKsmMfEwAiFID4Tg4UpAwMAde8bmQ==';
//const keyToken = '007eJxTYKh09uN7LZIkxu+30YDlt1yEuvM3yUqXKsFbosnXP/2KDlBgME4yMUw0NzA1TzFKMzGxTE20MEhONjJLNrVMs7QwNTdm2nIsrSGQkaEgtImJkQECQXw2hrKS1MTkDAYGAGvpHMY=';
const keyToken = '007eJxTYDBr0svLuxftyLbXnpFJYY+AzQ85kZ1Z6+d9qN0aXBebVK/AYJxkYphobmBqnmKUZmJimZpoYZCcbGSWbGqZZmlham4smXEiTbPsRNrnuPesjAyMDCxADAJMYJIZTLKASR6GxIKCspLUxOQMQ0NDBgYAbS8gDw==';

/*static const appId = "3c0adef573f54493967ef264362cb6ad";
static const token = " 68920e3d195d4064a1152c9875610ee2";
static const channel = "vteach";*/

ExampleConfigOverride? _gConfigOverride;

/// This class allow override the config(appId/channelId/token) in the example.
class ExampleConfigOverride {
  ExampleConfigOverride._();

  factory ExampleConfigOverride() {
    _gConfigOverride = _gConfigOverride ?? ExampleConfigOverride._();
    return _gConfigOverride!;
  }
  final Map<String, String> _overridedConfig = {};

  /// Get the expected APP ID
  String getAppId() {
    return _overridedConfig[keyAppId] ??
        // Allow pass an `appId` as an environment variable with name `TEST_APP_ID` by using --dart-define
        const String.fromEnvironment(keyAppId, defaultValue: keyAppId);
  }

  /// Get the expected Channel ID
  String getChannelId() {
    return _overridedConfig[keyChannelId] ??
        // Allow pass a `token` as an environment variable with name `TEST_TOKEN` by using --dart-define
        const String.fromEnvironment(keyChannelId,
            defaultValue: '84');
  }

  /// Get the expected Token
  String getToken() {
    return _overridedConfig[keyToken] ??
        // Allow pass a `channelId` as an environment variable with name `TEST_CHANNEL_ID` by using --dart-define
        const String.fromEnvironment(keyToken, defaultValue: keyToken);
  }

  /// Override the config(appId/channelId/token)
  void set(String name, String value) {
    _overridedConfig[name] = value;
  }

  /// Internal testing flag
  bool get isInternalTesting =>
      const bool.fromEnvironment('INTERNAL_TESTING', defaultValue: false);
}
