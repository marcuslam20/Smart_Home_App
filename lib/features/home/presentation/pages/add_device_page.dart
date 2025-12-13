// add_device_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'bluetooth_controller.dart';
import 'package:smart_curtain_app/features/home/presentation/pages/bluetooth_controller.dart';

class AddDevicePage extends StatefulWidget {
  const AddDevicePage({Key? key}) : super(key: key);

  @override
  State<AddDevicePage> createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  late BluetoothController _bluetoothController;
  bool _autoStarted = false;

  @override
  void initState() {
    super.initState();
    _bluetoothController = BluetoothController();
    _bluetoothController.initialize();

    // Tự động bắt đầu scan khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScanning();
    });
  }

  Future<void> _startScanning() async {
    if (_autoStarted) return;
    _autoStarted = true;

    final success = await _bluetoothController.startScan();
    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_bluetoothController.errorMessage ?? 'Lỗi khi quét'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _bluetoothController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _bluetoothController,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Add Device',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner, color: Colors.black),
              onPressed: () {
                // TODO: QR code scanner
              },
            ),
          ],
        ),
        body: Consumer<BluetoothController>(
          builder: (context, controller, child) {
            return Column(
              children: [
                // Header thông báo
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: controller.isScanning
                            ? const Padding(
                                padding: EdgeInsets.all(10),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Icon(
                                Icons.bluetooth_searching,
                                color: Colors.blue.shade600,
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'Searching for nearby devices. Make sure your device has entered ',
                              ),
                              TextSpan(
                                text: 'pairing mode',
                                style: TextStyle(
                                  color: Colors.blue.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Danh sách thiết bị
                Expanded(
                  child: controller.scanResults.isEmpty
                      ? _buildEmptyState(controller)
                      : _buildDeviceList(controller),
                ),

                // Bottom info
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Devices will be added automatically. ',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel (${controller.scanResults.length})',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState(BluetoothController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bluetooth_searching, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            controller.isScanning
                ? 'Đang tìm kiếm thiết bị...'
                : 'Không tìm thấy thiết bị',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          if (!controller.isScanning) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _bluetoothController.startScan(),
              icon: const Icon(Icons.refresh),
              label: const Text('Quét lại'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDeviceList(BluetoothController controller) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: controller.scanResults.length,
      itemBuilder: (context, index) {
        final result = controller.scanResults[index];
        final device = result.device;
        final deviceName = controller.getDeviceName(result);
        final rssi = result.rssi;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sensors, size: 32, color: Colors.grey),
            ),
            title: Text(
              deviceName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text(
                  device.remoteId.toString(),
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.signal_cellular_alt,
                      size: 14,
                      color: rssi > -70 ? Colors.green : Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$rssi dBm',
                      style: TextStyle(
                        fontSize: 12,
                        color: rssi > -70 ? Colors.green : Colors.orange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            onTap: () async {
              // Kết nối và chuyển sang bước tiếp theo
              final success = await controller.connectToDevice(device);
              if (success && mounted) {
                // TODO: Chuyển sang trang nhập WiFi
                _showWiFiConfigDialog(device, deviceName);
              } else if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      controller.errorMessage ?? 'Không thể kết nối',
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }

  void _showWiFiConfigDialog(device, String deviceName) {
    final ssidController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Cấu hình WiFi cho $deviceName'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ssidController,
              decoration: const InputDecoration(
                labelText: 'WiFi SSID',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'WiFi Password',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _bluetoothController.disconnect();
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final ssid = ssidController.text;
              final password = passwordController.text;

              if (ssid.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập SSID')),
                );
                return;
              }

              Navigator.pop(context);
              _showLoadingDialog();

              // Gửi WiFi credentials
              final success = await _bluetoothController.sendWiFiCredentials(
                ssid,
                password,
              );

              if (mounted) {
                Navigator.pop(context); // Close loading

                if (success) {
                  // TODO: Tiếp tục với flow claim device
                  final mac = _bluetoothController.getMacAddress();
                  _showSuccessAndClaim(mac, deviceName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _bluetoothController.errorMessage ?? 'Lỗi gửi WiFi',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Gửi'),
          ),
        ],
      ),
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Đang gửi cấu hình WiFi...'),
          ],
        ),
      ),
    );
  }

  void _showSuccessAndClaim(String? mac, String deviceName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('✓ Thành công'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Thiết bị đã nhận cấu hình WiFi'),
            const SizedBox(height: 8),
            Text('MAC: $mac'),
            const SizedBox(height: 16),
            const Text(
              'Bước tiếp theo: Claim device trên ThingsBoard',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close AddDevicePage
            },
            child: const Text('Đóng'),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Navigate to claim flow
              // hoặc gọi API claim ngay tại đây
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close AddDevicePage

              // Example: Claim device
              // await claimDevice(mac, generateSecretKey(mac));
            },
            child: const Text('Claim Device'),
          ),
        ],
      ),
    );
  }
}
