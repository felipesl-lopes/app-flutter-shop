import 'package:appshop/core/services/preferencies_values.dart';
import 'package:appshop/core/utils/auth_validators.dart';
import 'package:appshop/features/auth/Provider/auth_provider.dart';
import 'package:appshop/shared/Widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum AuthMode { Signup, Login }

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  AuthMode _authMode = AuthMode.Login;
  final _senhaController = TextEditingController();
  final _senhaConfirmController = TextEditingController();
  final _prefs = PreferenciesValues();
  bool _keepLogged = false;

  bool _isSecury = true;
  bool _isLoading = false;

  bool _isLogin() => _authMode == AuthMode.Login;
  bool _isSignup() => _authMode == AuthMode.Signup;

  Map<String, String> _authFormLogin = {'email': '', 'password': ''};
  Map<String, String> _authFormRegister = {
    'name': '',
    'email': '',
    "password": '',
    'passwordConfirm': ''
  };

  @override
  void initState() {
    super.initState();
    _loadKeepLogged();
  }

  void _showErrorDialog(dynamic msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Ocorreu um erro."),
        content:
            Text(msg is Exception ? msg.toString().split(': ').last : 'Erro'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Ok"),
          ),
        ],
      ),
    );
  }

// ------------- SUBMIT -------------
  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    AuthProvider auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        await auth.signIn(
            _authFormLogin['email']!, _authFormLogin['password']!);
      } else {
        await auth.signUp(_authFormRegister['email']!,
            _authFormRegister['password']!, _authFormRegister['name']!);
      }
    } catch (e) {
      _showErrorDialog(e);
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _loadKeepLogged() async {
    _keepLogged = await _prefs.getKeepLogged();
    setState(() {});
  }

  Future<void> _toggleKeepLogged() async {
    setState(() => _keepLogged = !_keepLogged);
    await _prefs.setKeepLogged(_keepLogged);
  }

  void _switchFormMode() {
    setState(() {
      _authMode = _isLogin() ? AuthMode.Signup : AuthMode.Login;
    });
    _formKey.currentState?.reset();
    _senhaController.clear();
    _senhaConfirmController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
      width: deviceSize.width * 0.90,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              _isLogin() ? "Faça o login" : "Registre-se agora",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 36),
            if (_isSignup())
              Column(
                children: [
                  // ------ SIGNUP: nome ------
                  TextFormField(
                      decoration: getInputDecoration("Nome"),
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (name) => _authFormRegister["name"] = name ?? "",
                      validator: _isSignup()
                          ? (value) => isValidName(value ?? "")
                          : null),
                  SizedBox(height: 28),
                ],
              ),
            // ------ E-mail ------
            TextFormField(
              decoration: getInputDecoration("E-mail"),
              keyboardType: TextInputType.emailAddress,
              onSaved: (email) {
                if (_isLogin()) {
                  _authFormLogin["email"] = email ?? "";
                } else {
                  _authFormRegister["email"] = email ?? "";
                }
              },
              validator: (value) => isValidEmail(value ?? ""),
            ),
            SizedBox(height: 28),

            // ------ Senha ------
            TextFormField(
              controller: _isSignup() ? _senhaController : null,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                hintText: "Senha",
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
                errorStyle: TextStyle(
                  fontSize: 14,
                  height: 0,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isSecury
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () {
                    setState(() => _isSecury = !_isSecury);
                  },
                ),
              ),
              keyboardType: TextInputType.visiblePassword,
              obscureText: _isSecury,
              onSaved: (password) {
                if (_isLogin()) {
                  _authFormLogin["password"] = password ?? "";
                } else {
                  _authFormRegister["password"] = password ?? "";
                }
              },
              validator: (value) => isValidPassword(
                  value ?? "", _isSignup(), _senhaConfirmController),
            ),

            // ------ Confirmar senha ------
            if (_isSignup())
              Column(
                children: [
                  SizedBox(height: 28),
                  TextFormField(
                      controller: _isSignup() ? _senhaConfirmController : null,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Confirme a senha",
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        errorStyle: TextStyle(
                          fontSize: 14,
                          height: 0,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isSecury
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                          onPressed: () {
                            setState(() => _isSecury = !_isSecury);
                          },
                        ),
                      ),
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _isSecury,
                      onSaved: (passwordConfirm) =>
                          _authFormRegister["passwordConfirm"] =
                              passwordConfirm ?? "",
                      validator: _isSignup()
                          ? (value) => isValidPasswordConfirm(
                              value ?? "", _isSignup(), _senhaController)
                          : null),
                ],
              ),
            SizedBox(height: 4),

            if (_isLogin())
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _toggleKeepLogged,
                    child: Row(
                      children: [
                        Checkbox(
                            value: _keepLogged,
                            onChanged: (_) => _toggleKeepLogged(),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap),
                        Text("Permanecer conectado"),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      onPressed: () {},
                      child: Text(
                        "Recuperar senha",
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ),
                ],
              ),

            SizedBox(height: _isLogin() ? 12 : 30),

            // ------ Botão principal ------

            SizedBox(
              width: double.infinity,
              child: AbsorbPointer(
                absorbing: _isLoading,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(12),
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _isLoading ? () {} : _submitForm,
                  child: _isLoading
                      ? SizedBox(
                          height: 23,
                          width: 23,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 3),
                        )
                      : Text(
                          _isLogin() ? "Entrar" : "Registrar",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
            ),

            // ------ Alternar modo ------
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_isLogin() ? "Não possui conta?" : "Já possui conta?"),
                SizedBox(
                  width: 8,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                  ),
                  onPressed: _switchFormMode,
                  child: Text(
                    _isLogin() ? "Registre-se" : "Logar",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
