import 'package:chatbot/Models/usermodels.dart';
import 'package:chatbot/Screen/AuthScreen.dart/registerscreen.dart';
import 'package:chatbot/Screen/startscreen.dart';
import 'package:chatbot/Service/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  Future<void> _login(String email, String password) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Gọi API và nhận dữ liệu người dùng
      User user = await AuthServiceApi().loginService(email, password);

      // Kiểm tra xem state có mounted không trước khi cập nhật UI
      if (!mounted) return;

      // Hiển thị thông báo thành công và có thể làm gì đó với `user`
      _showSuccessDialog(email, user); // Thêm user vào hàm để xử lý
    } on InvalidatedEmailorPassword catch (e) {
      // Bắt và xử lý UserAlreadyExistsException
      _showErrorDialog(e.toString());
    } on NotFoundException catch (e) {
      // Bắt và xử lý NotFoundException
      _showErrorDialog(e.toString());
    } catch (e) {
      if (!mounted) return;
      // Hiển thị thông báo lỗi nếu có
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color.fromARGB(255, 52, 53, 65),
        title: const Text(
          'Lỗi',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Đóng',
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.w600),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String email, User user) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 52, 53, 65),
          title: const Text(
            'Đăng Nhập thành công',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Ok',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GetStartedScreen()),
                );
                // Thêm logic ở đây nếu bạn muốn sử dụng dữ liệu `user`
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/cc3.png", height: 200, color: Colors.white),
              const SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.email,
                    color: Colors.white,
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
                obscureText: true, // Che giấu mật khẩu
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(
                          // Style chung cho toàn bộ TextSpan
                          fontSize: 16,
                          color: Color.fromARGB(255, 148, 143, 143),
                        ),
                        children: [
                          TextSpan(
                            text: "Chưa có tài khoản ? ",
                          ),
                          TextSpan(
                            text: "Đăng Ký",
                            style: TextStyle(
                              color: Color.fromARGB(255, 232, 121,
                                  178), // Màu sắc cho phần "Đăng Nhập"
                              fontWeight: FontWeight
                                  .bold, // Độ đậm cho phần "Đăng Nhập"
                              // Bạn có thể thêm các style khác tại đây
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _login(
                              _emailController.text, _passwordController.text);
                        },
                        child: const Text('Đăng nhập'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
