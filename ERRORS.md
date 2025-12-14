Launching lib\main.dart on Infinix X6853 in debug mode...
lib/screens/chat/chat_screen.dart:164:36: Error: The method 'go' isn't defined for the class 'BuildContext'.
 - 'BuildContext' is from 'package:flutter/src/widgets/framework.dart' ('/C:/flutter/packages/flutter/lib/src/widgets/framework.dart').
Try correcting the name to the name of an existing method, or defining a method named 'go'.
          onPressed: () => context.go(AppRoutes.home),
                                   ^^
lib/screens/chat/chat_screen.dart:164:39: Error: The getter 'AppRoutes' isn't defined for the class '_ChatScreenState'.
 - '_ChatScreenState' is from 'package:fyllens/screens/chat/chat_screen.dart' ('lib/screens/chat/chat_screen.dart').
Try correcting the name to the name of an existing getter, or defining a getter or field named 'AppRoutes'.
          onPressed: () => context.go(AppRoutes.home),
                                      ^^^^^^^^^
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