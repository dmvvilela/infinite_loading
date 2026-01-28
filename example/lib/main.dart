import 'package:flutter/material.dart';
import 'package:infinite_loading/infinite_loading.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Infinite Loading Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? _completeWithSuccess;
  bool _isLoading = false;

  void _startLoading() {
    setState(() {
      _completeWithSuccess = null;
      _isLoading = true;
    });
  }

  void _completeSuccess() {
    setState(() {
      _completeWithSuccess = true;
    });

    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _completeWithSuccess = null;
        });
      }
    });
  }

  void _completeError() {
    setState(() {
      _completeWithSuccess = false;
    });

    // Reset after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _completeWithSuccess = null;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Infinite Loading Examples'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Interactive Demo
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interactive Demo',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_isLoading)
                      Center(
                        child: InfiniteLoading(
                          width: 250,
                          height: 10,
                          completeWithSuccess: _completeWithSuccess,
                          trackColor: const Color(0xFF4E4E4E),
                          progressColor: const Color(0xFFFFD421),
                          borderColor: const Color(0xFF4E4E4E),
                          borderWidth: 2,
                        ),
                      )
                    else
                      const Center(
                        child: Text('Click "Start Loading" to begin'),
                      ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _startLoading,
                        child: const Text('Start Loading'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed:
                              (_isLoading && _completeWithSuccess == null)
                                  ? _completeSuccess
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Success'),
                        ),
                        ElevatedButton(
                          onPressed:
                              (_isLoading && _completeWithSuccess == null)
                                  ? _completeError
                                  : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Error'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Style Examples
            const Text(
              'Style Variations',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _buildExample(
              'Default Style',
              const InfiniteLoading(
                width: 200,
                height: 8,
              ),
            ),

            _buildExample(
              'Custom Colors',
              const InfiniteLoading(
                width: 220,
                height: 10,
                trackColor: Color(0xFF2C3E50),
                progressColor: Color(0xFF3498DB),
                borderColor: Color(0xFF3498DB),
                borderWidth: 3,
              ),
            ),

            _buildExample(
              'Fast Animation',
              const InfiniteLoading(
                width: 200,
                height: 8,
                oscillationDuration: Duration(milliseconds: 600),
                progressColor: Color(0xFFE91E63),
                borderColor: Color(0xFFE91E63),
              ),
            ),

            _buildExample(
              'Slow Animation',
              const InfiniteLoading(
                width: 200,
                height: 8,
                oscillationDuration: Duration(milliseconds: 2400),
                progressColor: Color(0xFF9C27B0),
                borderColor: Color(0xFF9C27B0),
              ),
            ),

            _buildExample(
              'Thick Border',
              const InfiniteLoading(
                width: 200,
                height: 12,
                borderWidth: 4,
                borderRadius: 20,
                progressColor: Color(0xFFFF5722),
                borderColor: Color(0xFFFF5722),
              ),
            ),

            _buildExample(
              'Wide Progress Bar',
              const InfiniteLoading(
                width: 240,
                height: 10,
                progressBarWidth: 80,
                progressColor: Color(0xFF00BCD4),
                borderColor: Color(0xFF00BCD4),
              ),
            ),

            _buildExample(
              'Large Widget',
              const InfiniteLoading(
                width: 300,
                height: 16,
                progressBarWidth: 60,
                borderWidth: 3,
                progressColor: Color(0xFF4CAF50),
                borderColor: Color(0xFF4CAF50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExample(String title, Widget widget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(child: widget),
          ),
        ],
      ),
    );
  }
}
