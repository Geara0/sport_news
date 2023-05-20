import 'package:device_info/device_info.dart';

Future<bool> checkIsEmu() async {
  var deviceInfo = DeviceInfoPlugin();
  return await _checkIsAndroidEmu(deviceInfo) ||
      await _checkIsIosEmu(deviceInfo);
}

Future<bool> _checkIsAndroidEmu(DeviceInfoPlugin deviceInfo) async {
  final em = await deviceInfo.androidInfo;
  var phoneModel = em.model;
  var buildProduct = em.product;
  var buildHardware = em.hardware;
  var result = (em.fingerprint.startsWith("generic") ||
      phoneModel.contains("google_sdk") ||
      phoneModel.contains("droid4x") ||
      phoneModel.contains("Emulator") ||
      phoneModel.contains("Android SDK built for x86") ||
      em.manufacturer.contains("Genymotion") ||
      buildHardware == "goldfish" ||
      buildHardware == "vbox86" ||
      buildProduct == "sdk" ||
      buildProduct == "google_sdk" ||
      buildProduct == "sdk_x86" ||
      buildProduct == "vbox86p" ||
      em.brand.contains('google') ||
      em.board.toLowerCase().contains("nox") ||
      em.bootloader.toLowerCase().contains("nox") ||
      buildHardware.toLowerCase().contains("nox") ||
      !em.isPhysicalDevice ||
      buildProduct.toLowerCase().contains("nox"));

  if (result) {
    return true;
  }

  result = em.brand.startsWith("generic") && em.device.startsWith("generic");

  return result || "google_sdk" == buildProduct;
}

Future<bool> _checkIsIosEmu(DeviceInfoPlugin deviceInfo) async {
  try {
    var iosInfo = await deviceInfo.iosInfo;
    return iosInfo.isPhysicalDevice;
  } catch (_) {
    return false;
  }
}
