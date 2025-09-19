

import 'package:flutter/foundation.dart';

class SystemHelper {
 static Brightness getSystemBrightness() {
return PlatformDispatcher.instance.platformBrightness;
}
}