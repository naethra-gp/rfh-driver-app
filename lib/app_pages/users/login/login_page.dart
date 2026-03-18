import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observe_internet_connectivity/observe_internet_connectivity.dart';
import 'package:rfh/app_services/user_service.dart';
import '../../../app_storage/secure_storage.dart';
import '../../../app_utils/index_app_util.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  bool _rememberMe = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _password = TextEditingController();

  final AlertService alertService = AlertService();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _loadUserCredentials();
  }

  @override
  void dispose() {
    _userName.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _loadUserCredentials() async {
    BoxStorage storage = BoxStorage();
    var logInfo = storage.getLoginInfo();
    if (logInfo != null && logInfo['rememberMe'] == true) {
      setState(() {
        _userName.text = logInfo['username']!;
        _password.text = logInfo['password']!;
        _rememberMe = logInfo['rememberMe'];
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunction.isDarkMode(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(RSizes.lg),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage(
                    dark ? RImages.darkAppLogo : RImages.lightAppLogo,
                  ),
                ),
                const SizedBox(
                  height: RSizes.spaceBtwSections,
                ),
                Text(
                  'LOGIN',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(
                  height: RSizes.spaceBtwItems,
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    // Calculate the maximum width based on screen orientation
                    double maxWidth = constraints.maxWidth;
                    if (MediaQuery.of(context).orientation ==
                        Orientation.landscape) {
                      maxWidth = maxWidth *
                          0.6; // Use 60% of the screen width in landscape mode
                    }

                    return Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20.0), // Use appropriate padding value
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: maxWidth,
                              child: TextFormField(
                                  controller: _userName,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.people),
                                    labelText: "Vehicle No",
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(
                                        r'[a-zA-Z0-9]')), // Allows only alphanumeric characters
                                    UpperCaseTextFormatter(), // Converts characters to uppercase
                                  ],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Vehicle No is required';
                                    }
                                    return null;
                                  }),
                            ),
                            const SizedBox(
                                height: 16.0), // Use appropriate spacing value
                            SizedBox(
                              width: maxWidth,
                              child: TextFormField(
                                controller: _password,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                obscureText: !_passwordVisible,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisible = !_passwordVisible;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Password required';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                                height: 8.0), // Use appropriate spacing value
                            SizedBox(
                              width: maxWidth,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value ?? false;
                                          });
                                        },
                                      ),
                                      Text(
                                        'Remember me',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                    ],
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle forgot password
                                      Navigator.pushNamed(
                                          context, 'forgotPassword');
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                              color: Theme.of(context)
                                                  .primaryColor),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                                height: 20.0), // Use appropriate spacing value
                            SizedBox(
                              width: maxWidth,
                              child: ElevatedButton(
                                onPressed: () => formSubmit(),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15),
                                  child: Text('Login Now'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> formSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      bool hasInternet = await InternetConnectivity().hasInternetConnection;
      if (hasInternet) {
        try {
          alertService.showLoading();
          final response = await UserService().loginService(context, {
            "username": _userName.text,
            "password": _password.text,
          });
          await handleResponse(response);
        } catch (e) {
          alertService.hideLoading();
          alertService.errorToast('An error occurred: $e');
        }
      } else {
        alertService.errorToast('Please check your internet connection');
      }
    }
  }

  Future<void> handleResponse(Map<String, dynamic>? response) async {
    if (response != null) {
      switch (response['message']) {
        case 'Success':
          afterSuccessFetch(response);
          break;
        case 'Password Not Match':
          alertService.errorToast('Password not matched.Please check');
          break;
        case 'vehicle Number Not Found':
          alertService.errorToast('Vehicle No not matched.Please check');
          break;
        default:
          alertService
              .errorToast('Vehicle Number Not Found.Please Check details');
          break;
      }
    } else {
      alertService.errorToast('Error occurred - Null response');
    }
    alertService.hideLoading();
  }

  afterSuccessFetch(Map<String, dynamic> response) async {
    alertService.successToast('Login successful');
    await BoxStorage().saveUserDetails(response['userdetails']);
    if (_rememberMe) {
      await BoxStorage()
          .saveLoginInfo(_userName.text, _password.text, _rememberMe);
    } else {
      await BoxStorage().deleteLoginInfo();
    }
    if (response['userdetails'][0]['usertypes'] == 'Delivery') {
      Navigator.pushNamedAndRemoveUntil(
          context, 'deliveryDashboard', (route) => false);
    } else if (response['userdetails'][0]['usertypes'] == 'Exchange') {
      Navigator.pushNamedAndRemoveUntil(
          context, 'deliveryDashboard', (route) => false);
    }
  }
}
