import 'package:flutter/material.dart';
import 'payment_page.dart';

void main() {
  runApp(const MyApp());
}

const green = Color(0xFF218C52);
const blue = Color(0xFF4169E1);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Subscription Management',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFE8F5E9),
        colorScheme: ColorScheme.fromSeed(seedColor: green),
      ),
      home: const AuthPage(),
    );
  }
}

// =====================================================
//                    AUTHENTICATION
// =====================================================

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  String page = 'home';
  bool isSignup = false;
  bool obscure = true;
  bool obscureConfirm = true;

  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  void goBack() {
    setState(() {
      page = 'home';
      isSignup = false;
      passwordController.clear();
      confirmController.clear();
    });
  }

  void selectClient(bool signup) {
    setState(() {
      page = 'client';
      isSignup = signup;
    });
  }

  void selectProvider() {
    setState(() {
      page = 'provider';
      isSignup = false;
    });
  }

  // LOGIN SUCCESS -> DASHBOARD

  void submit() {
    if (formKey.currentState!.validate()) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SubscriptionDashboard(
            name: page == 'provider'
                ? 'Service Provider'
                : isSignup
                ? nameController.text.trim()
                : 'Client',
            email: emailController.text.trim(),
            role: page == 'provider' ? 'Provider' : 'Client',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: page == 'home' ? homePage() : authPage(),
            ),
          ),
        ),
      ),
    );
  }

  // ---------------- HOME PAGE ----------------

  Widget homePage() {
    return Container(
      key: const ValueKey('home'),
      constraints: const BoxConstraints(maxWidth: 440),
      child: Column(
        children: [
          const SizedBox(height: 25),

          Container(
            height: 85,
            width: 85,
            decoration: BoxDecoration(
              color: green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(25),
            ),
            child: const Icon(
              Icons.subscriptions_outlined,
              size: 45,
              color: green,
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Welcome!',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          const Text(
            'Subscription Management System',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),

          const SizedBox(height: 45),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Continue as',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),

          const SizedBox(height: 18),

          roleCard(
            title: 'Client',
            subtitle: 'Manage your subscriptions and accounts',
            icon: Icons.person_outline,
            color: green,
            onTap: () => selectClient(false),
          ),

          const SizedBox(height: 18),

          roleCard(
            title: 'Service Provider',
            subtitle: 'Access your provider dashboard',
            icon: Icons.business_center_outlined,
            color: blue,
            onTap: selectProvider,
          ),

          const SizedBox(height: 35),

          const Text(
            'Secure • Simple • Reliable',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ---------------- ROLE CARD ----------------

  Widget roleCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: color, size: 32),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ),

            Icon(Icons.arrow_forward_ios, size: 18, color: color),
          ],
        ),
      ),
    );
  }

  // ---------------- AUTH PAGE ----------------

  Widget authPage() {
    bool provider = page == 'provider';
    Color themeColor = provider ? blue : green;

    return Container(
      key: ValueKey(page),
      constraints: const BoxConstraints(maxWidth: 440),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                onPressed: goBack,
                icon: const Icon(Icons.arrow_back),
              ),
            ),

            const SizedBox(height: 10),

            Icon(
              provider ? Icons.business_center_outlined : Icons.person_outline,
              size: 55,
              color: themeColor,
            ),

            const SizedBox(height: 20),

            Text(
              provider
                  ? 'Provider Login'
                  : isSignup
                  ? 'Create Client Account'
                  : 'Client Login',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Text(
              provider
                  ? 'Welcome back, service provider!'
                  : isSignup
                  ? 'Create your account to get started'
                  : 'Login to continue',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 30),

            // FULL NAME
            if (!provider && isSignup) ...[
              buildField(
                controller: nameController,
                label: 'Full Name',
                icon: Icons.person_outline,
                color: themeColor,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
            ],

            // EMAIL
            buildField(
              controller: emailController,
              label: 'Email Address',
              icon: Icons.email_outlined,
              color: themeColor,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter your email';
                }

                if (!RegExp(
                  r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                ).hasMatch(value.trim())) {
                  return 'Enter a valid email';
                }

                return null;
              },
            ),

            const SizedBox(height: 18),

            // PASSWORD
            buildField(
              controller: passwordController,
              label: 'Password',
              icon: Icons.lock_outline,
              color: themeColor,
              obscure: obscure,
              suffix: IconButton(
                onPressed: () {
                  setState(() {
                    obscure = !obscure;
                  });
                },
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
              ),
              validator: (value) {
                if (value == null || value.length < 6) {
                  return 'Minimum 6 characters required';
                }
                return null;
              },
            ),

            // CONFIRM PASSWORD
            if (!provider && isSignup) ...[
              const SizedBox(height: 18),

              buildField(
                controller: confirmController,
                label: 'Confirm Password',
                icon: Icons.lock_outline,
                color: themeColor,
                obscure: obscureConfirm,
                suffix: IconButton(
                  onPressed: () {
                    setState(() {
                      obscureConfirm = !obscureConfirm;
                    });
                  },
                  icon: Icon(
                    obscureConfirm ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                validator: (value) {
                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
            ],

            // FORGOT PASSWORD
            if (!isSignup) ...[
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Password recovery coming soon'),
                      ),
                    );
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: themeColor),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // SUBMIT BUTTON
            SizedBox(
              height: 55,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  provider
                      ? 'Provider Login'
                      : isSignup
                      ? 'Create Account'
                      : 'Sign In',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // SIGN IN / SIGN UP TOGGLE
            if (!provider) ...[
              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isSignup
                        ? 'Already have an account? '
                        : "Don't have an account? ",
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),

                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isSignup = !isSignup;
                        obscure = true;
                        obscureConfirm = true;
                      });
                    },
                    child: Text(
                      isSignup ? 'Sign In' : 'Sign Up',
                      style: const TextStyle(
                        color: green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 15),

            if (provider)
              const Center(
                child: Text(
                  'Authorized service providers only',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ---------------- REUSABLE TEXT FIELD ----------------

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: color),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF8F9FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: color, width: 1.5),
        ),
      ),
    );
  }
}

// =====================================================
//                SUBSCRIPTION DASHBOARD
// =====================================================

class SubscriptionDashboard extends StatelessWidget {
  final String name;
  final String email;
  final String role;

  const SubscriptionDashboard({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    final platforms = [
      {
        'name': 'Netflix',
        'color': const Color(0xFF181818),
        'accent': const Color(0xFFE50914),
        'icon': Icons.play_circle_fill,
      },
      {
        'name': 'Prime Video',
        'color': const Color(0xFF142B50),
        'accent': const Color(0xFF35A9FF),
        'icon': Icons.video_library,
      },
      {
        'name': 'YouTube',
        'color': const Color(0xFF282828),
        'accent': const Color(0xFFFF0033),
        'icon': Icons.smart_display,
      },
      {
        'name': 'JioHotstar',
        'color': const Color(0xFF241044),
        'accent': const Color(0xFFC69AFF),
        'icon': Icons.live_tv,
      },
      {
        'name': 'Education',
        'color': const Color(0xFF153D32),
        'accent': const Color(0xFF64DCA0),
        'icon': Icons.school,
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),

      // ---------------- PROFILE DRAWER ----------------
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(25),
                color: green,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 35,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 40, color: green),
                    ),

                    const SizedBox(height: 15),

                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(email, style: const TextStyle(color: Colors.white70)),

                    const SizedBox(height: 5),

                    Text(role, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('My Profile'),
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ProfilePage(name: name, email: email, role: role),
                    ),
                  );
                },
              ),

              ListTile(
                leading: const Icon(Icons.subscriptions_outlined),
                title: const Text('My Subscriptions'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              const Spacer(),

              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const AuthPage()),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 15),
            ],
          ),
        ),
      ),

      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black, size: 28),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),

        title: const Text(
          'Subscription Model',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),

        centerTitle: true,

        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none, color: Colors.black),
          ),
        ],
      ),

      // ---------------- DASHBOARD BODY ----------------
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 7),

            Text(
              'Explore and manage your favourite services.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),

            const SizedBox(height: 30),

            // ---------------- SERVICES HEADING ----------------
            const Text(
              "Your Platform's Services",
              style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(
              'Choose a platform to explore its subscription.',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),

            const SizedBox(height: 20),

            // ---------------- SERVICE CARDS ----------------
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: platforms.length,

              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 1.05,
              ),

              itemBuilder: (context, index) {
                final platform = platforms[index];

                return InkWell(
                  borderRadius: BorderRadius.circular(20),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionPlansPage(
                          platformName: platform['name'] as String,
                        ),
                      ),
                    );
                  },

                  child: Container(
                    padding: const EdgeInsets.all(17),

                    decoration: BoxDecoration(
                      color: platform['color'] as Color,
                      borderRadius: BorderRadius.circular(20),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(
                          platform['icon'] as IconData,
                          color: platform['accent'] as Color,
                          size: 38,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              platform['name'] as String,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 7),

                            const Row(
                              children: [
                                Text(
                                  'Explore Plans',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),

                                SizedBox(width: 5),

                                Icon(
                                  Icons.arrow_forward,
                                  size: 14,
                                  color: Colors.white70,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 25),

            // ---------------- BOTTOM INFORMATION ----------------
            Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),

              child: const Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: green, size: 30),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      'Discover plans and keep your services organized.',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// =====================================================
//                     PROFILE PAGE
// =====================================================

class ProfilePage extends StatelessWidget {
  final String name;
  final String email;
  final String role;

  const ProfilePage({
    super.key,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F5),

      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const CircleAvatar(
              radius: 55,
              backgroundColor: green,
              child: Icon(Icons.person, color: Colors.white, size: 65),
            ),

            const SizedBox(height: 18),

            Text(
              name,
              style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(role, style: const TextStyle(color: green)),

            const SizedBox(height: 35),

            profileItem(Icons.person_outline, 'Full Name', name),

            profileItem(Icons.email_outlined, 'Email Address', email),

            profileItem(Icons.badge_outlined, 'Account Type', role),
          ],
        ),
      ),
    );
  }

  Widget profileItem(IconData icon, String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(17),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),

      child: Row(
        children: [
          Icon(icon, color: green),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================
//                 SUBSCRIPTION PLANS PAGE
// =====================================================

class SubscriptionPlansPage extends StatefulWidget {
  final String platformName;

  const SubscriptionPlansPage({super.key, required this.platformName});

  @override
  State<SubscriptionPlansPage> createState() => _SubscriptionPlansPageState();
}

class _SubscriptionPlansPageState extends State<SubscriptionPlansPage> {
  int selectedPlan = -1;

  List<Map<String, String>> get plans {
    switch (widget.platformName) {
      case 'Netflix':
        return [
          {
            'name': 'Mobile',
            'price': '₹149 / month',
            'description': '480p SD streaming on 1 phone or tablet.',
            'points': '500 Points',
          },
          {
            'name': 'Basic',
            'price': '₹199 / month',
            'description': '720p HD streaming on 1 device.',
            'points': '1,000 Points',
          },
          {
            'name': 'Standard',
            'price': '₹499 / month',
            'description': '1080p Full HD streaming on 2 devices.',
            'points': '1,500 Points',
          },
          {
            'name': 'Premium',
            'price': '₹649 / month',
            'description':
                '4K Ultra HD + HDR and spatial audio on 4 devices. Downloads on up to 6 devices.',
            'points': '2,000 Points',
          },
        ];

      case 'Prime Video':
        return [
          {
            'name': 'Amazon Prime',
            'price': '₹1,499 / year',
            'description':
                'Includes Prime Video, free shipping and Amazon Music.',
            'points': '',
          },
          {
            'name': 'Prime Video Monthly',
            'price': '₹299 / month',
            'description': 'Monthly Prime Video access.',
            'points': '',
          },
          {
            'name': 'Prime Lite',
            'price': '₹799 / year',
            'description': 'HD streaming with ads on one mobile device.',
            'points': '',
          },
          {
            'name': 'Ad-Free Add-On',
            'price': '₹699 / year or ₹129 / month',
            'description': 'Ad-free viewing add-on.',
            'points': '',
          },
        ];

      case 'YouTube':
        return [
          {
            'name': 'Individual (Monthly)',
            'price': '₹149 / month',
            'description': 'Recurring auto-renew subscription for 1 account.',
            'points': '',
          },
          {
            'name': 'Individual (Prepaid)',
            'price': '₹159 / month',
            'description': 'Prepaid individual subscription.',
            'points': '',
          },
          {
            'name': 'Premium Lite',
            'price': '₹89 / month',
            'description':
                'Removes ads on most videos, with background play and downloads. YouTube Music is excluded.',
            'points': '',
          },
          {
            'name': 'Student',
            'price': '₹89 / month',
            'description':
                'Discounted plan for verified full-time higher education students.',
            'points': '',
          },
          {
            'name': 'Two-Person',
            'price': '₹219 / month',
            'description': 'For exactly two people living under the same roof.',
            'points': '',
          },
          {
            'name': 'Family',
            'price': '₹299 / month',
            'description':
                'Share with up to 5 additional household members (6 profiles total).',
            'points': '',
          },
        ];

      case 'JioHotstar':
        return [
          {
            'name': 'Mobile - Monthly',
            'price': '₹79 / month',
            'description': '1 mobile device, 720p HD, with ads.',
            'points': '',
          },
          {
            'name': 'Mobile - 3 Months',
            'price': '₹149 / 3 months',
            'description': '1 mobile device, 720p HD, with ads.',
            'points': '',
          },
          {
            'name': 'Mobile - Annual',
            'price': '₹499 / year',
            'description':
                '1 mobile device, 720p HD, with ads. Hollywood add-on may cost extra.',
            'points': '',
          },
          {
            'name': 'Super - Monthly',
            'price': '₹149 / month',
            'description': '2 devices, 1080p Full HD, with ads.',
            'points': '',
          },
          {
            'name': 'Super - 3 Months',
            'price': '₹299–₹349 / 3 months',
            'description': '2 devices, 1080p Full HD, with ads.',
            'points': '',
          },
          {
            'name': 'Super - Annual',
            'price': '₹899 / year',
            'description': '2 devices, 1080p Full HD, with ads.',
            'points': '',
          },
        ];

      case 'Education':
        return [
          {
            'name': 'Monthly Plan',
            'price': '₹299 / month',
            'description': 'Educational service access for one month.',
            'points': '',
          },
          {
            'name': '6-Month Plan',
            'price': '₹1,500 / 6 months',
            'description': 'Effectively ₹250 per month.',
            'points': '',
          },
          {
            'name': 'Annual Plan',
            'price': '₹2,400 / year',
            'description': 'Effectively ₹200 per month.',
            'points': '',
          },
        ];

      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final availablePlans = plans;

    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: Text(
          '${widget.platformName} Plans',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: green,
        foregroundColor: Colors.white,
      ),
      body: availablePlans.isEmpty
          ? const Center(child: Text('No plans available.'))
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 110),
              children: [
                const Text(
                  'Choose Your Plan',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF14532D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Select the ${widget.platformName} subscription that suits you best.',
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
                const SizedBox(height: 20),
                ...List.generate(availablePlans.length, (index) {
                  final plan = availablePlans[index];
                  final isSelected = selectedPlan == index;

                  return InkWell(
                    onTap: () {
                      setState(() {
                        selectedPlan = index;
                      });
                    },
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 15),
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isSelected ? green : Colors.grey.shade300,
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 9,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  plan['name']!,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: green,
                                size: 25,
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            plan['price']!,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: green,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            plan['description']!,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          if (plan['points']!.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                const Icon(Icons.stars, color: Colors.orange),
                                const SizedBox(width: 7),
                                Text(
                                  plan['points']!,
                                  style: const TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 15),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? green
                                  : const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              isSelected ? 'Selected Plan' : 'Select Plan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: isSelected ? Colors.white : green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: SafeArea(
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedPlan == -1
                  ? null
                  : () {
                      final plan = availablePlans[selectedPlan];

                      final priceText = plan['price']!;
                      final priceMatch = RegExp(
                        r'[\d,]+',
                      ).firstMatch(priceText);

                      if (priceMatch == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid plan price.')),
                        );
                        return;
                      }

                      final price = double.parse(
                        priceMatch.group(0)!.replaceAll(',', ''),
                      );

                      final lowerPrice = priceText.toLowerCase();

                      int validityDays = 30;

                      if (lowerPrice.contains('year')) {
                        validityDays = 365;
                      } else if (lowerPrice.contains('6 months')) {
                        validityDays = 180;
                      } else if (lowerPrice.contains('3 months')) {
                        validityDays = 90;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentPage(
                            planName:
                                '${widget.platformName} - ${plan['name']}',
                            price: price,
                            validityDays: validityDays,
                            description: plan['description']!,
                          ),
                        ),
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Select Plan & Pay',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
