import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../controllers/auth_controller.dart';
import '../providers/update_profile_provider.dart';
import '../widgets/CenteredCircularProgress.dart';
import '../widgets/photo_picker.dart';
import '../widgets/screen_background.dart';
import '../widgets/snack_bar_message.dart';
import '../widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatelessWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => UpdateProfileProvider(),
      child: const _UpdateProfileView(),
    );
  }
}

class _UpdateProfileView extends StatefulWidget {
  const _UpdateProfileView();

  @override
  State<_UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<_UpdateProfileView> {
  final _emailTE = TextEditingController();
  final _firstNameTE = TextEditingController();
  final _lastNameTE = TextEditingController();
  final _mobileTE = TextEditingController();
  final _passwordTE = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = false;

  @override
  void initState() {
    super.initState();
    final user = AuthController.user!;
    _emailTE.text = user.email;
    _firstNameTE.text = user.firstName;
    _lastNameTE.text = user.lastName;
    _mobileTE.text = user.mobile;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UpdateProfileProvider>();

    return Scaffold(
      appBar: TMAppBar(fromUpdateProfile: true),
      body: ScreenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 36),
                Text('Update Profile',
                    style: Theme.of(context).textTheme.titleLarge),

                GestureDetector(
                  onTap: () async {
                    final image = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      provider.setImage(image);
                    }
                  },
                  child: PhotoPicker(pickedImage: provider.pickedImage),
                ),

                TextFormField(
                  enabled: false,
                  controller: _emailTE,
                  decoration: const InputDecoration(hintText: 'Email'),
                ),
                _field(_firstNameTE, 'First name'),
                _field(_lastNameTE, 'Last name'),
                _field(_mobileTE, 'Mobile'),
                _passwordField(),

                const SizedBox(height: 8),

                Visibility(
                  visible: !provider.updating,
                  replacement: const CenteredCircularProgress(),
                  child: FilledButton(
                    onPressed: _onTapUpdate,
                    child: const Icon(Icons.arrow_circle_right_outlined),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint) {
    return TextFormField(
      controller: c,
      decoration: InputDecoration(hintText: hint),
      validator: (v) => v!.isEmpty ? 'Required' : null,
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: _passwordTE,
      obscureText: !_passwordVisible,
      decoration: InputDecoration(
        hintText: 'Password',
        suffixIcon: IconButton(
          icon: Icon(
              _passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () =>
              setState(() => _passwordVisible = !_passwordVisible),
        ),
      ),
    );
  }

  Future<void> _onTapUpdate() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UpdateProfileProvider>();

    final success = await provider.updateProfile(
      email: _emailTE.text,
      firstName: _firstNameTE.text.trim(),
      lastName: _lastNameTE.text.trim(),
      mobile: _mobileTE.text.trim(),
      password: _passwordTE.text,
    );

    if (success) {
      showSnackBarMessage(context, 'Profile updated!');
    } else {
      showSnackBarMessage(context, provider.errorMessage!);
    }
  }
}
