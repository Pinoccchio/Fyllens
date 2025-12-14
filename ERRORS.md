lib/services/ml_service.dart:222:32: Error: The operator '>>' isn't defined for the class 'Pixel'.
 - 'Pixel' is from 'package:image/src/image/pixel.dart' ('../../../../../../AppData/Local/Pub/Cache/hosted/pub.dev/image-4.6.0/lib/src/image/pixel.dart').
Try correcting the operator to an existing operator, or defining a '>>' operator.
              final r = (pixel >> 16) & 0xFF;
                               ^^
lib/services/ml_service.dart:223:32: Error: The operator '>>' isn't defined for the class 'Pixel'.
 - 'Pixel' is from 'package:image/src/image/pixel.dart' ('../../../../../../AppData/Local/Pub/Cache/hosted/pub.dev/image-4.6.0/lib/src/image/pixel.dart').
Try correcting the operator to an existing operator, or defining a '>>' operator.
              final g = (pixel >> 8) & 0xFF;
                               ^^
lib/services/ml_service.dart:224:31: Error: The operator '&' isn't defined for the class 'Pixel'.
 - 'Pixel' is from 'package:image/src/image/pixel.dart' ('../../../../../../AppData/Local/Pub/Cache/hosted/pub.dev/image-4.6.0/lib/src/image/pixel.dart').
Try correcting the operator to an existing operator, or defining a '&' operator.
              final b = pixel & 0xFF;
                              ^
lib/services/ml_service.dart:237:14: Error: A value of type 'List<List<List<List<dynamic>>>>' can't be returned from an async function with return type 'Future<List<List<List<List<double>>>>>'.
 - 'List' is from 'dart:core'.
 - 'Future' is from 'dart:async'.
      return input;
             ^
Target kernel_snapshot_program failed: Exception


FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':app:compileFlutterBuildDebug'.
> Process 'command 'C:\flutter\bin\flutter.bat'' finished with non-zero exit value 1

* Try:
> Run with --stacktrace option to get the stack trace.
> Run with --info or --debug option to get more log output.
> Run with --scan to get full insights.
> Get more help at https://help.gradle.org.