// home_page.dart
import 'package:flutter/material.dart';
import 'package:smart_curtain_app/features/home/presentation/pages/CreateSceneTriggerPage.dart';

void main() => runApp(const MaterialApp(home: HomePage()));

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeTab(),
      const AutomationTab(),
      const SmartTab(),
      const ProfileTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFDBE8FF), Color(0xFFF8FAFC)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===================== HEADER THÔNG MINH =====================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dòng 1: luôn hiển thị ở mọi tab
                    Row(
                      children: [
                        const Icon(Icons.home_outlined, size: 28),
                        const SizedBox(width: 8),
                        const Text(
                          "Nhà của tôi ...",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner, size: 26),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, size: 30),
                          onPressed: () {},
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Dòng 2: CHỈ HIỆN KHI Ở TAB NHÀ (index == 0)
                    if (_currentIndex == 0)
                      Row(
                        children: [
                          const Text(
                            "Favorites",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.dehaze_rounded,
                              size: 28,
                            ), // 3 gạch
                            onPressed: () {},
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // Khoảng cách dưới header
              SizedBox(height: _currentIndex == 0 ? 10 : 20),

              // ===================== NỘI DUNG THEO TAB =====================
              Expanded(
                child: IndexedStack(index: _currentIndex, children: _pages),
              ),
            ],
          ),
        ),
      ),

      // ===================== BOTTOM NAVIGATION BAR =====================
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Nhà',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Thông minh',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Icon(Icons.smart_toy_outlined),
                Positioned(
                  top: 0,
                  right: 0,
                  child: CircleAvatar(radius: 4, backgroundColor: Colors.red),
                ),
              ],
            ),
            label: 'Smart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Tôi',
          ),
        ],
      ),
    );
  }
}

// ===================== TAB NHÀ =====================
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 10),

        // TODO: Thêm card thời tiết, AI note, energy, thiết bị ở đây
        Container(
          height: 160,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              "Card thời tiết sẽ ở đây",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),

        const SizedBox(height: 20),
        // Thêm các widget khác của bạn ở đây...
      ],
    );
  }
}

// ===================== TAB THÔNG MINH – giống hệt ảnh =====================
class AutomationTab extends StatelessWidget {
  const AutomationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          Row(
            children: const [
              Text(
                "Chạm để chạy",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 16),
              Text(
                "Tự động hóa",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Filter All
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text("Filter All", style: TextStyle(fontSize: 16)),
                Icon(Icons.keyboard_arrow_down),
              ],
            ),
          ),

          const Spacer(),

          // Hình minh họa
          Icon(
            Icons.auto_awesome,
            size: 180,
            color: Colors.grey.withOpacity(0.4),
          ),

          const SizedBox(height: 30),

          const Center(
            child: Text(
              "Điều khiển nhiều thiết bị bằng một lần chạm hoặc\nbằng loa hỗ trợ AI thông qua lệnh thoại",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
          ),

          const SizedBox(height: 40),

          Center(
            child: SizedBox(
              width: 220,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF3B30),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const CreateSceneTriggerPage(),
                    ),
                  );
                },
                child: const Text(
                  "Create Scene",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }
}

class SmartTab extends StatelessWidget {
  const SmartTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Smart Tab"));
}

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Tôi"));
}
