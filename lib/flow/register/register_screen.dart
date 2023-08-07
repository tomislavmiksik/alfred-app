import 'package:alfred_app/common/loading_dialog.dart';
import 'package:alfred_app/common/reactive_forms/app_reactive_text_field.dart';
import 'package:alfred_app/flow/login/providers/login_provider.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/hooks/async_callback.dart';
import 'package:alfred_app/hooks/form_hook.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:alfred_app/navigation/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:sliver_tools/sliver_tools.dart';

@RoutePage()
class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final t = useTranslations();

    final form = useForm({
      'email': FormControl<String>(value: '', validators: [
        Validators.required,
        Validators.email,
      ]),
      'username': FormControl<String>(value: '', validators: [
        Validators.required,
        Validators.minLength(6),
      ]),
      'password': FormControl<String>(value: '', validators: [
        Validators.required,
        Validators.minLength(6),
      ]),
      'firstName': FormControl<String>(value: '', validators: [
        Validators.required,
      ]),
      'lastName': FormControl<String>(value: '', validators: [
        Validators.required,
      ]),
    });

    final handleSubmit = useAsyncCallback(
      () async {
        if (form.valid) {
          await ref.read(loginProvider.notifier).register(
                email: form.control('email').value,
                password: form.control('password').value,
                username: form.control('username').value,
                firstName: form.control('firstName').value,
                lastName: form.control('lastName').value,
              );
        }
      },
      onLoading: () => LoadingDialog.show(),
      onError: (e) {
        LoadingDialog.dismiss();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: AppColors.colorSemanticRed,
          ),
        );
      },
      onDone: () {
        LoadingDialog.dismiss();
        return context.router.replaceAll([const HomeRoute()]);
      },
      keys: [form],
    );
    return ReactiveForm(
      formGroup: form,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            t.registerScreenTitle,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.normal,
            ),
          ),
          shape: const Border(
            bottom: BorderSide(
              color: AppColors.colorPrimary,
              width: 1,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.colorPrimary,
          onPressed: handleSubmit,
          icon: const Icon(Icons.login),
          label: Text(t.register),
        ),
        body: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: MultiSliver(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AppReactiveTextField(
                        formControlName: 'email',
                        label: t.email,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppReactiveTextField(
                      formControlName: 'username',
                      label: t.username,
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: AppReactiveTextField(
                        formControlName: 'password',
                        label: t.password,
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppReactiveTextField(
                      label: t.firstName,
                      formControlName: 'firstName',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: AppReactiveTextField(
                      formControlName: 'lastName',
                      label: t.lastName,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
