import 'package:flutter/material.dart';

import '../models/weather.dart';
import '../services/ai_product_service.dart';
import '../services/demo_post_service.dart';
import '../services/weather_service.dart';
import '../services/weather_service_dio.dart';

enum _ViewStatus {
  idle,
  loading,
  success,
  error,
}

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({super.key});

  @override
  State<WeatherSearchPage> createState() =>
      _WeatherSearchPageState();
}

class _WeatherSearchPageState
    extends State<WeatherSearchPage> {
  final _weatherService = WeatherService();

  final _cityController = TextEditingController(
    text: 'Bangkok',
  );

  _ViewStatus _status = _ViewStatus.idle;
  Weather? _weather;
  String? _errorMessage;

  String _friendlyError(Object error) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  Future<void> _search() async {
    setState(() {
      _status = _ViewStatus.loading;
      _errorMessage = null;
    });

    try {
      final weather = await _weatherService.fetchWeather(
        _cityController.text,
      );

      if (!mounted) return;

      setState(() {
        _weather = weather;
        _status = _ViewStatus.success;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _status = _ViewStatus.error;
        _errorMessage = _friendlyError(error);
      });
    }
  }

  Future<void> _run(
    String label,
    Future<Object> Function() action,
  ) async {
    try {
      final result = await action();

      if (!mounted) return;

      final resultText = result.toString();
      final preview = resultText.length > 100
          ? '${resultText.substring(0, 100)}…'
          : resultText;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$label สำเร็จ: $preview'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_friendlyError(error)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Object> _loadAiProducts() async {
    final products = await fetchAiProducts();

    debugPrint('====================================');
    debugPrint('ผลลัพธ์จริงจาก Fake Store API');
    debugPrint(
      'จำนวนสินค้าทั้งหมด: ${products.length} รายการ',
    );
    debugPrint('====================================');

    for (final product in products) {
      debugPrint(
        'ID: ${product.id} | '
        'ชื่อ: ${product.title} | '
        'ราคา: \$${product.price.toStringAsFixed(2)} | '
        'หมวดหมู่: ${product.category}',
      );
    }

    debugPrint('====================================');

    return 'พบสินค้า ${products.length} รายการ';
  }

  Future<Object> _searchWithDio() async {
    final weather = await fetchWeatherWithDio(
      _cityController.text,
    );

    debugPrint('====================================');
    debugPrint('ผลลัพธ์จาก Dio');
    debugPrint('เมือง: ${weather.cityName}');
    debugPrint('อุณหภูมิ: ${weather.temperature}°C');
    debugPrint('รายละเอียด: ${weather.description}');
    debugPrint('รู้สึกเหมือน: ${weather.feelsLike}°C');
    debugPrint('====================================');

    return '${weather.cityName} '
        '${weather.temperature.toStringAsFixed(1)}°C';
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Week 6 API Lab'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _cityController,
            decoration: const InputDecoration(
              labelText: 'ชื่อเมือง',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),

          FilledButton(
            onPressed: _status == _ViewStatus.loading
                ? null
                : _search,
            child: const Text(
              'ค้นหาสภาพอากาศ (http)',
            ),
          ),

          const SizedBox(height: 16),

          if (_status == _ViewStatus.loading)
            const Center(
              child: CircularProgressIndicator(),
            ),

          if (_status == _ViewStatus.success &&
              _weather != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(
                      '${_weather!.cityName}: '
                      '${_weather!.temperature.toStringAsFixed(1)}°C',
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(_weather!.description),
                    Text(
                      'รู้สึกเหมือน '
                      '${_weather!.feelsLike.toStringAsFixed(1)}°C',
                    ),
                  ],
                ),
              ),
            ),

          if (_status == _ViewStatus.error)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _errorMessage ?? 'เกิดข้อผิดพลาด',
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const Divider(height: 32),

          const Text(
            'การทดลอง API เพิ่มเติม',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => _run(
                  'POST',
                  createDemoPost,
                ),
                child: const Text('ทดลอง POST'),
              ),

              OutlinedButton(
                onPressed: () => _run(
                  'PUT',
                  updateDemoPost,
                ),
                child: const Text('ทดลอง PUT'),
              ),

              OutlinedButton(
                onPressed: () => _run(
                  'AI Products',
                  _loadAiProducts,
                ),
                child: const Text(
                  'โหลดสินค้า AI Client',
                ),
              ),

              OutlinedButton(
                onPressed: () => _run(
                  'Dio',
                  _searchWithDio,
                ),
                child: const Text(
                  'ค้นหาด้วย Dio',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}