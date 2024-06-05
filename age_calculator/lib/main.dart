import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AGE CALCULATOR',
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  String myAge = '';
  String nextBirthday = '';
  String ageCategory = '';
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller and the animation
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AGE CALCULATOR"),
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Theme.of(context).primaryColorDark),
      ),
      backgroundColor: Colors.red[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your age is !',
              style: TextStyle(fontSize: 40),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(myAge, style: const TextStyle(fontSize: 24)),
            const SizedBox(
              height: 20,
            ),
            FadeTransition(
              opacity: _animation,
              child: Text(
                nextBirthday,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.green[900], // Dark green color
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),

            const SizedBox(
              height: 60,
            ),
            ElevatedButton(
              onPressed: () => pickDob(context),
              child: const Text('Pick Date of Birth'),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              ageCategory,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  pickDob(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate != null) {
        calculateAge(pickedDate);
        calculateNextBirthday(pickedDate);
      }
    });
  }

  calculateAge(DateTime birth) {
    DateTime now = DateTime.now();
    Duration age = now.difference(birth);
    int years = age.inDays ~/ 365;
    int months = (age.inDays % 365) ~/ 30;
    int days = ((age.inDays % 365) % 30);
    setState(() {
      myAge = '$years years, $months months, and $days days';
      if (years < 15) {
        ageCategory = "You're a child";
      } else if (years >= 15 && years <= 30) {
        ageCategory = "You're an adult";
      } else if (years > 40) {
        ageCategory = "You're a senior citizen";
      } else {
        ageCategory = "";
      }
    });
  }

  calculateNextBirthday(DateTime birth) {
    DateTime now = DateTime.now();
    DateTime nextBirthday = DateTime(now.year, birth.month, birth.day);
    // Check if the next birthday is in a leap year
    if (nextBirthday.isBefore(now)) {
      nextBirthday = DateTime(now.year + 1, birth.month, birth.day);
      // Adjust for leap year
      if (isLeapYear(nextBirthday.year) && birth.month == 2 && birth.day == 29) {
        nextBirthday = DateTime(nextBirthday.year, 3, 1);
      }
    } else if (isLeapYear(nextBirthday.year) && birth.month == 2 && birth.day == 29) {
      nextBirthday = DateTime(nextBirthday.year, 3, 1);
    }
    Duration difference = nextBirthday.difference(now);
    setState(() {
      this.nextBirthday = 'Days until next birthday: ${difference.inDays}';
      _controller.forward(from: 0.0); // Start the animation
    });
  }

  bool isLeapYear(int year) {
    // Leap year calculation
    if (year % 4 != 0) return false;
    if (year % 100 == 0 && year % 400 != 0) return false;
    return true;
  }
}
