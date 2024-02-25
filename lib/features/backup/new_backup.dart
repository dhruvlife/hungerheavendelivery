// late LocationSettings locationSettings;

// if (defaultTargetPlatform == TargetPlatform.android) {
//   locationSettings = AndroidSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 100,
//     forceLocationManager: true,
//     intervalDuration: const Duration(seconds: 10),
//     //(Optional) Set foreground notification config to keep the app alive
//     //when going to the background
//     foregroundNotificationConfig: const ForegroundNotificationConfig(
//         notificationText:
//         "Example app will continue to receive your location even when you aren't using it",
//         notificationTitle: "Running in Background",
//         enableWakeLock: true,
//     )
//   );
// } else {
//     locationSettings = LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 100,
//   );
// }

// StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: locationSettings).listen(
//     (Position? position) {
//         print(position == null ? 'Unknown' : '${position.latitude.toString()}, ${position.longitude.toString()}');
//     });
