import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_delivery_app/src/pages/login/login_controller.dart';
import 'package:flutter_delivery_app/src/utils/my_colors.dart';
import 'package:lottie/lottie.dart';

class  LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  LoginController _con = new LoginController();
  bool _obscureText= true;// esto agg

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              top: -80,
                left: -100,
                child: _circleLogin()
            ),
            Positioned(
                child: _textLogin(),
              top: 60,
              left: 25,
            ),
            // Scrollview
            SingleChildScrollView(
              child: Column(
                children: [
                  //_imageBanner(),
                  _lottiesAnimation(),
                  _textFieldEmail(),
                  _textFieldPassword(),
                  _buttonLogin(),
                  _textDontHaveAccount(),
                ],
              ),
            ),
          ],
        ),
      )
    );
  }

  //Gift
  Widget _lottiesAnimation(){
    return Container(
      margin: EdgeInsets.only(
          top: 155,
          //top: 15,
          bottom: MediaQuery.of(context).size.height * 0.10
      ),
      child: Lottie.asset(
          'assets/json/deliveryL.json',
        width:350,
        height: 350,
        fit: BoxFit.fill
      ),
    );

  }

  //texto
  Widget _textLogin(){
    return Text(
        'Login',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 22,
        //fontFamily: 'NimbusSans',
      ),
    );
  }

  // circulo + texto metodo
  Widget _circleLogin(){
    return Container(
      width: 240,
      height: 230,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: MyColors.primaryColor
      ),
    );
  }

  //Imagen
  Widget _imageBanner(){
    return Container(
      margin: EdgeInsets.only(
          top: 100,
          bottom: MediaQuery.of(context).size.height * 0.15
      ),
      child: Image.asset(
        'assets/img/Logo.png',
        width: 200,
        height: 200,

      ),
    );
  }

  //texto mail
  Widget _textFieldEmail(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.emailController,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            hintText: 'Correo Eletrónico',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
          hintStyle: TextStyle(
            color: MyColors.primaryColorDark
          ),
          prefixIcon: Icon(
            Icons.email
            ,color: MyColors.primaryColor,
          )
        ),
      ),
    );
  }

  //Texto Contraseña
  Widget _textFieldPassword(){
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 50, vertical: 5),
      decoration: BoxDecoration(
          color: MyColors.primaryOpacityColor,
          borderRadius: BorderRadius.circular(30)
      ),
      child: TextField(
        controller: _con.passwordController,
        obscureText: _obscureText, // aqui iba true
        decoration: InputDecoration(
            hintText: 'Contraseña',
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(15),
            hintStyle: TextStyle(
                color: MyColors.primaryColorDark
            ),
            prefixIcon: Icon(
              Icons.lock,
              color: MyColors.primaryColor,
            ),
          suffixIcon: GestureDetector( // esto agg para el ojito
            onTap: (){
              setState(() {
                _obscureText=! _obscureText;
              });
            },
            child: Icon(_obscureText
                ?Icons.visibility
                :Icons.visibility_off
            ),
          )
        ),
      ),
    );
  }

  //Boton Iniciar sesion
  Widget _buttonLogin(){
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 50,vertical: 30),
      child: ElevatedButton(
        onPressed:_con.login,
        child: Text('Ingresar'),
        style: ElevatedButton.styleFrom(
          primary: MyColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30)
          ),
          padding: EdgeInsets.symmetric(vertical: 15)
        ),
      ),
    );
  }


  Widget _textDontHaveAccount(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
            '¿No tienes cuenta?',
            style: TextStyle(
                color: MyColors.primaryColor,
                fontSize: 17
            )
        ),
        SizedBox(width: 7),
        GestureDetector(
          onTap: _con.goToRegisterPage,
          child: Text(
            'REGISTRATE',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.primaryColor,
              fontSize: 17
            ),
          ),
        ),
      ],
    );
  }
}
