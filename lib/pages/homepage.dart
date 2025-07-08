// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:saver_gallery/saver_gallery.dart' show SaverGallery, MediaType;


// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _urlController = TextEditingController();
//   String _statusMessage = '';
//   bool _isLoading = false;

//   String fileNameFromPath(String path) {
//     return path.split('/').last;
//   }

//   Future<void> _downloadVideo() async {
//     final url = _urlController.text.trim();

//     if (url.isEmpty) {
//       setState(() {
//         _statusMessage = 'Please enter a valid YouTube URL.';
//       });
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//       _statusMessage = 'Sending download request...';
//     });

//     try {
//       final response = await http.post(
//         Uri.parse('http://192.168.100.68:5000/download'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode({'url': url}),
//       );

//       final data = jsonDecode(response.body);

//       if (data['status'] == 'success') {
//         final fileName = data['file'];
//         final fileUrl = 'http://192.168.100.68:5000/video/$fileName';

//         setState(() {
//           _statusMessage = 'Downloading video file...';
//         });

//         // Download video file
//         final videoResponse = await http.get(Uri.parse(fileUrl));
//         final tempDir = await getTemporaryDirectory();
//         final tempPath = '${tempDir.path}/$fileName';
//         final file = File(tempPath);
//         await file.writeAsBytes(videoResponse.bodyBytes);

//         // Save to gallery
//      await SaverGallery.saveFile(
//           filePath: file.path,
//           fileName: fileNameFromPath(file.path),
//           skipIfExists: false,
//         );
//         setState(() {
//           _isLoading = false;
//           _statusMessage = '✅ Video saved to gallery!';
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _statusMessage = '❌ Error: ${data['message']}';
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _statusMessage = '❌ Could not connect to server.';
//       });
//       debugPrint('Network or server error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("YTGrabber")),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "Paste the YouTube video URL below:",
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _urlController,
//               decoration: const InputDecoration(
//                 labelText: "YouTube URL",
//                 border: OutlineInputBorder(),
//                 prefixIcon: Icon(Icons.link),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _isLoading ? null : _downloadVideo,
//               icon: const Icon(Icons.download),
//               label: const Text("Download"),
//             ),
//             const SizedBox(height: 20),
//             if (_isLoading) const CircularProgressIndicator(),
//             const SizedBox(height: 10),
//             Text(
//               _statusMessage,
//               style: TextStyle(
//                 color:
//                     _statusMessage.startsWith('✅') ? Colors.green : Colors.red,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart' show SaverGallery;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String _statusMessage = '';
  bool _isLoading = false;
  double _downloadProgress = 0;

  String fileNameFromPath(String path) {
    return path.split('/').last;
  }

  Future<void> _downloadVideo() async {
    final url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() {
        _statusMessage = 'Please enter a valid YouTube URL.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = 'Preparing download...';
      _downloadProgress = 0;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.68:5000/download'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      final data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        final fileName = data['file'];
        final fileUrl = 'http://192.168.100.68:5000/video/$fileName';

        final tempDir = await getTemporaryDirectory();
        final tempPath = '${tempDir.path}/$fileName';
        final file = File(tempPath);

        final request = await HttpClient().getUrl(Uri.parse(fileUrl));
        final responseStream = await request.close();

        final totalBytes = responseStream.contentLength;
        List<int> bytes = [];
        int receivedBytes = 0;

        await for (var chunk in responseStream) {
          bytes.addAll(chunk);
          receivedBytes += chunk.length;
          setState(() {
            _downloadProgress = receivedBytes / totalBytes;
            _statusMessage =
                'Downloading: ${(_downloadProgress * 100).toStringAsFixed(1)}% '
                '(${(receivedBytes / 1024 / 1024).toStringAsFixed(2)} MB)';
          });
        }

        await file.writeAsBytes(bytes);

        // Save to gallery
        await SaverGallery.saveFile(
          filePath: file.path,
          fileName: fileNameFromPath(file.path),
          skipIfExists: false,
        );

        final downloadedSizeMB =
            (await file.length()) / (1024 * 1024); // Convert to MB

        setState(() {
          _isLoading = false;
          _downloadProgress = 0;
          _statusMessage =
              '✅ Video saved to gallery!\nTotal size: ${downloadedSizeMB.toStringAsFixed(2)} MB';
        });
      } else {
        setState(() {
          _isLoading = false;
          _statusMessage = '❌ Error: ${data['message']}';
          _downloadProgress = 0;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = '❌ Could not connect to server.';
        _downloadProgress = 0;
      });
      debugPrint('Network or server error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("YTGrabber")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Paste the YouTube video URL below:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              decoration: const InputDecoration(
                labelText: "YouTube URL",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.link),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _downloadVideo,
              icon: const Icon(Icons.download),
              label: const Text("Download"),
            ),
            const SizedBox(height: 20),
            if (_isLoading)
              Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text(
                    (_downloadProgress > 0)
                        ? 'Progress: ${(_downloadProgress * 100).toStringAsFixed(1)}%'
                        : 'Starting download...',
                    style: const TextStyle(color: Colors.orange),
                  ),
                ],
              ),
            const SizedBox(height: 10),
            Text(
              _statusMessage,
              style: TextStyle(
                color:
                    _statusMessage.startsWith('✅')
                        ? Colors.green
                        : _statusMessage.startsWith('❌')
                        ? Colors.red
                        : Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
