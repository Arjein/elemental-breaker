import 'package:get_it/get_it.dart';
import 'package:elemental_breaker/elemental_breaker.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerSingleton<ElementalBreaker>(ElementalBreaker());
}
