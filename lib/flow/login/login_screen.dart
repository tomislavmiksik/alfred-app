import 'package:alfred_app/flow/login/providers/login_provider.dart';
import 'package:alfred_app/hooks/form_hook.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handleLogin = useCallback(
      (String email, String password) async {
        await ref.read(loginProvider).login(email, password);
      },
      [],
    );

    final form = useForm(
      {
        'email': FormControl<String>(validators: [
          Validators.required,
          Validators.email,
        ]),
        'password': FormControl<String>(validators: [
          Validators.required,
          Validators.minLength(6),
        ]),
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('LoginRoute'),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: Column(
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
    );
  }
}
