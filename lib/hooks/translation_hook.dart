import 'package:alfred_app/generated/l10n.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Translations useTranslations() {
  final context = useContext();
  return Translations.of(context);
}
