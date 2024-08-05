import 'package:flutter/material.dart';
import 'package:restart_app/restart_app.dart';

class NetworkErrorPage extends StatelessWidget {
  const NetworkErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/imgs/network_error.png",
                  height: 180,
                  width: 180,
                ),
                const Text(
                  "You need an Internet Connection",
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                const Text(
                  "to use CashFlow",
                  style: TextStyle(
                      fontSize: 18
                  ),
                ),
                const SizedBox(height: 30),
                MaterialButton(
                  onPressed: (){
                    Restart.restartApp();
                  },
                  color: const Color(0xff235AE8),
                  minWidth: 150,
                  height: 50,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.black)
                  ),
                  child: const Text(
                    'Try Again',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.normal
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
