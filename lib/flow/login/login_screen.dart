import 'package:alfred_app/flow/login/providers/login_provider.dart';
import 'package:alfred_app/hooks/form_hook.dart';
import 'package:alfred_app/navigation/app_router.dart';
import 'package:alfred_app/util/env.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handleLogin = useCallback(
      (String email, String password) async {
        await ref.read(loginProvider).login(email, password);
        AutoRouter.of(context).replaceAll([const HomeRoute()]);
      },
      [],
    );

    final form = useForm(
      {
        'email': FormControl<String>(value: Env.testEmail, validators: [
          Validators.required,
          Validators.email,
        ]),
        'password': FormControl<String>(value: Env.testPassword, validators: [
          Validators.required,
          Validators.minLength(6),
        ]),
      },
    );

    return SafeArea(
      child: Scaffold(
        body: ReactiveForm(
          formGroup: form,
          child: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: MultiSliver(
                  children: [
                    ReactiveTextField(
                      formControlName: 'email',
                    ),
                    ReactiveTextField(
                      formControlName: 'password',
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (form.valid) {
                          handleLogin(
                            form.control('email').value,
                            form.control('password').value,
                          );
                        }
                      },
                      child: const Text('Login'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
