import 'package:alfred_app/common/loading_dialog.dart';
import 'package:alfred_app/flow/login/providers/login_provider.dart';
import 'package:alfred_app/generated/colors.gen.dart';
import 'package:alfred_app/hooks/async_callback.dart';
import 'package:alfred_app/hooks/form_hook.dart';
import 'package:alfred_app/hooks/translation_hook.dart';
import 'package:alfred_app/navigation/app_router.dart';
import 'package:alfred_app/util/env.dart';
import 'package:auto_route/auto_route.dart';
import 'package:dio/dio.dart';
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
    final t = useTranslations();
    final obscurePassword = useState(true);

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

    final handleLogin = useAsyncCallback(
      () async {
        await ref.read(loginProvider.notifier).login(
              form.control('email').value,
              form.control('password').value,
            );
      },
      keys: [form],
      onLoading: () => LoadingDialog.show(),
      onError: (e) {
        LoadingDialog.dismiss();
        final message = e as DioError;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message.response?.data['error']['message'].toString() ?? '',
            ),
            backgroundColor: AppColors.colorSemanticRed,
          ),
        );
      },
      onDone: () {
        LoadingDialog.dismiss();
        return context.router.replaceAll([const HomeRoute()]);
      },
    );

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.colorPrimary,
        onPressed: handleLogin,
        icon: const Icon(Icons.login),
        label: Text(t.login),
      ),
      body: ReactiveForm(
        formGroup: form,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: Text(
              t.welcomeToAlfred,
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
          body: CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: MultiSliver(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ReactiveTextField(
                        decoration: InputDecoration(
                          labelText: t.email,
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.colorPrimary,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.colorPrimary,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        ),
                        formControlName: 'email',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ReactiveTextField(
                        formControlName: 'password',
                        obscureText: obscurePassword.value,
                        decoration: InputDecoration(
                          suffix: IconButton(
                            onPressed: () {
                              obscurePassword.value = !obscurePassword.value;
                            },
                            icon: Icon(
                              obscurePassword.value
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                          labelText: t.password,
                          border: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.colorPrimary,
                            ),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.colorPrimary,
                            ),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.colorPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: TextButton(
                        onPressed: () {
                          AutoRouter.of(context).push(const RegisterRoute());
                        },
                        child: RichText(
                          text: TextSpan(
                            text: t.registerButtonPartOne,
                            children: [
                              TextSpan(
                                text: t.registerButtonPartTwo,
                                style: const TextStyle(
                                  color: AppColors.colorPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
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
