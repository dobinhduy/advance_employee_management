import 'dart:async';

import 'package:advance_employee_management/service/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';

class PhoneAuth extends StatefulWidget {
  const PhoneAuth({Key? key}) : super(key: key);

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<PhoneAuth> {
  int start = 5;
  bool wait = false;
  String buttonName = "Send";
  TextEditingController phoneController = TextEditingController();
  AuthClass authclass = AuthClass();
  String verificationIdFinal = "";
  String smsCode = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: const Text(
          "Sign Up",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 40,
              ),
              textField(),
              SizedBox(
                width: MediaQuery.of(context).size.width - 30,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      height: 1,
                      color: Colors.grey,
                    )),
                    const Text(
                      "Enter 6 digit OTP",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    Expanded(
                        child: Container(
                      height: 1,
                      color: Colors.grey,
                    )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 30,
              ),
              optField(),
              const SizedBox(
                height: 40,
              ),
              RichText(
                  text: TextSpan(children: [
                const TextSpan(
                  text: "Send OTP again in ",
                  style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
                ),
                TextSpan(
                  text: "00:$start",
                  style:
                      const TextStyle(fontSize: 16, color: Colors.pinkAccent),
                ),
                const TextSpan(
                  text: " seconds",
                  style: TextStyle(fontSize: 16, color: Colors.yellowAccent),
                )
              ])),
              const SizedBox(
                height: 140,
              ),
              InkWell(
                onTap: () async {
                  authclass.signWithPhoneNumber(
                      verificationIdFinal, smsCode, context);
                },
                child: Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width - 60,
                  decoration: BoxDecoration(
                    color: const Color(0xffff9601),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Center(
                    child: Text(
                      "Let's go",
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xfffbe2ae),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textField() {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xff1d1d1d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
          controller: phoneController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Colors.white,
              hintText: "Enter your phone Number",
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 17),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 19, horizontal: 8),
              prefixIcon: const Padding(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                child: Text(
                  "(+91)",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              suffixIcon: InkWell(
                onTap: wait
                    ? null
                    : () async {
                        startTime();
                        setState(() {
                          start = 5;
                          wait = true;
                          buttonName = "Resend";
                        });
                        await authclass.verifyPhoneNumber(
                            "+84 ${phoneController.text}", context, setData);
                      },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 15),
                  child: Text(
                    buttonName,
                    style: TextStyle(
                      color: wait ? Colors.grey : Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ))),
    );
  }

  void startTime() {
    const onsec = Duration(seconds: 1);
    Timer.periodic(onsec, (timer) {
      if (start == 0) {
        timer.cancel();
        wait = false;
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  Widget optField() {
    return OTPTextField(
      length: 6,
      width: MediaQuery.of(context).size.width - 4,
      fieldWidth: 58,
      otpFieldStyle: OtpFieldStyle(
        backgroundColor: const Color(0xff1d1d1d),
        borderColor: Colors.white,
      ),
      style: const TextStyle(fontSize: 17, color: Colors.white),
      textFieldAlignment: MainAxisAlignment.spaceAround,
      fieldStyle: FieldStyle.underline,
      onCompleted: (pin) {
        setState(() {
          smsCode = pin;
        });
      },
    );
  }

  void setData(String verificationId) {
    setState(() {
      verificationIdFinal = verificationId;
    });
    startTime();
  }
}
