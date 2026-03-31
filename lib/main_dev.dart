import 'src/app/app_bootstrap.dart';
import 'src/core/config/app_environment.dart';

Future<void> main() async {
  await bootstrapApp(AppEnvironment.dev);
}
