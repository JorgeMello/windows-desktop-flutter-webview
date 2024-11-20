import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter URL Launcher',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const BrowserPage(),
    );
  }
}

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  final TextEditingController _urlController = TextEditingController(
    text: 'https://flutter.dev',
  );

  Future<void> _launchUrl(String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      if (!await launchUrl(url)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Não foi possível abrir: $urlString'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao abrir URL: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Browser'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                labelText: 'Digite a URL',
                hintText: 'https://exemplo.com',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _urlController.clear(),
                ),
              ),
              onSubmitted: (url) => _launchUrl(url),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _launchUrl(_urlController.text),
              icon: const Icon(Icons.launch),
              label: const Text('Abrir no Navegador'),
            ),
            const SizedBox(height: 32),
            const Text(
              'Sites Populares',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _QuickLinkButton(
                  title: 'Google',
                  url: 'https://google.com',
                  onTap: _launchUrl,
                ),
                _QuickLinkButton(
                  title: 'Flutter',
                  url: 'https://flutter.dev',
                  onTap: _launchUrl,
                ),
                _QuickLinkButton(
                  title: 'GitHub',
                  url: 'https://github.com',
                  onTap: _launchUrl,
                ),
                _QuickLinkButton(
                  title: 'YouTube',
                  url: 'https://youtube.com',
                  onTap: _launchUrl,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }
}

class _QuickLinkButton extends StatelessWidget {
  final String title;
  final String url;
  final Function(String) onTap;

  const _QuickLinkButton({
    required this.title,
    required this.url,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onTap(url),
      child: Text(title),
    );
  }
}
