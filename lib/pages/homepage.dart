// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:saver_gallery/saver_gallery.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _urlController = TextEditingController();
//   String _statusMessage = '';
//   bool _isLoading = false;
//   double _downloadProgress = 0;

//   @override
//   void initState() {
//     super.initState();
//     _askPermissions();
//   }

//   Future<void> _askPermissions() async {
//     await [
//       Permission.storage,
//       Permission.photos, // iOS only
//     ].request();
//   }

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
//       _statusMessage = 'Preparing download...';
//       _downloadProgress = 0;
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
//         final fileUrl = 'http://192.168.100.68:5000/GTGrabber/$fileName';

//         final tempDir = await getTemporaryDirectory();
//         final tempPath = '${tempDir.path}/$fileName';
//         final file = File(tempPath);

//         final request = await HttpClient().getUrl(Uri.parse(fileUrl));
//         final responseStream = await request.close();

//         final totalBytes = responseStream.contentLength;
//         List<int> bytes = [];
//         int receivedBytes = 0;

//         await for (var chunk in responseStream) {
//           bytes.addAll(chunk);
//           receivedBytes += chunk.length;
//           setState(() {
//             _downloadProgress = receivedBytes / totalBytes;
//             _statusMessage =
//                 'Downloading: ${(_downloadProgress * 100).toStringAsFixed(1)}% '
//                 '(${(receivedBytes / 1024 / 1024).toStringAsFixed(2)} MB)';
//           });
//         }

//         await file.writeAsBytes(bytes);

//         // Save to gallery
//         await SaverGallery.saveFile(
//           filePath: file.path,
//           fileName: fileNameFromPath(file.path),
//           skipIfExists: false,
//         );

//         final downloadedSizeMB =
//             (await file.length()) / (1024 * 1024); // Convert to MB

//         setState(() {
//           _isLoading = false;
//           _downloadProgress = 0;
//           _statusMessage =
//               '✅ Video saved to gallery!\nTotal size: ${downloadedSizeMB.toStringAsFixed(2)} MB';
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _statusMessage = '❌ Error: ${data['message']}';
//           _downloadProgress = 0;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _isLoading = false;
//         _statusMessage = '❌ Could not connect to server.';
//         _downloadProgress = 0;
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
//             if (_isLoading)
//               Column(
//                 children: [
//                   const CircularProgressIndicator(),
//                   const SizedBox(height: 10),
//                   Text(
//                     (_downloadProgress > 0)
//                         ? 'Progress: ${(_downloadProgress * 100).toStringAsFixed(1)}%'
//                         : 'Starting download...',
//                     style: const TextStyle(color: Colors.orange),
//                   ),
//                 ],
//               ),
//             const SizedBox(height: 10),
//             Text(
//               _statusMessage,
//               style: TextStyle(
//                 color:
//                     _statusMessage.startsWith('✅')
//                         ? Colors.green
//                         : _statusMessage.startsWith('❌')
//                         ? Colors.red
//                         : Colors.black,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }



// yaui code bilkul shi chal raha hai lkn cmd k through live nhi

// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'dart:io';
// import 'package:lottie/lottie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:saver_gallery/saver_gallery.dart';
// import 'package:permission_handler/permission_handler.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   final TextEditingController _urlController = TextEditingController();
//   String _statusMessage = '';
//   bool _isLoading = false;
//   bool _isDownloaded = false;
//   double _downloadProgress = 0;

//   @override
//   void initState() {
//     super.initState();
//     _askPermissions();
//   }

//   Future<void> _askPermissions() async {
//     await [Permission.storage, Permission.photos].request();
//   }

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
//       _isDownloaded = false;
//       _statusMessage = 'Preparing download...';
//       _downloadProgress = 0;
//     });

//       try {
//         final response = await http.post(
//           Uri.parse('http://192.168.100.68:5000/download'),
//           headers: {'Content-Type': 'application/json'},
//           body: jsonEncode({'url': url}),
//         );

//         final data = jsonDecode(response.body);

//         if (data['status'] == '200') {
//           final fileName = data['file'];
//           final fileUrl = 'http://192.168.100.68:5000/$fileName';

//           final tempDir = await getTemporaryDirectory();
//           final tempPath = '${tempDir.path}/$fileName';
//           final file = File(tempPath);

//           final request = await HttpClient().getUrl(Uri.parse(fileUrl));
//           final responseStream = await request.close();

//           final totalBytes = responseStream.contentLength;
//           List<int> bytes = [];
//           int receivedBytes = 0;

//           await for (var chunk in responseStream) {
//             bytes.addAll(chunk);
//             receivedBytes += chunk.length;
//             setState(() {
//               _downloadProgress = receivedBytes / totalBytes;
//               _statusMessage =
//                   'Downloading: ${(_downloadProgress * 100).toStringAsFixed(1)}% '
//                   '(${(receivedBytes / 1024 / 1024).toStringAsFixed(2)} MB)';
//             });
//           }

//         await file.writeAsBytes(bytes);

//         await SaverGallery.saveFile(
//           filePath: file.path,
//           fileName: fileNameFromPath(file.path),
//           skipIfExists: false,
//         );

//         final downloadedSizeMB = (await file.length()) / (1024 * 1024);

//         setState(() {
//           _isLoading = false;
//           _isDownloaded = true;
//           _downloadProgress = 0;
//           _statusMessage =
//               '✅ Video saved to gallery!\nTotal size: ${downloadedSizeMB.toStringAsFixed(2)} MB';
//         });
//       } else {
//         setState(() {
//           _isLoading = false;
//           _isDownloaded = false;
//           _statusMessage = '❌ Error: ${data['message']}';
//           _downloadProgress = 0;
//         });
//       }
//     } catch (e) {
//      setState(() {
//         _isLoading = false;
//         _isDownloaded = false;
//         _statusMessage =
//             '❌ Could not connect to server. Error: ${e.toString()}';
//         _downloadProgress = 0;
//       });
//       debugPrint('Network or server error: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0B0F2B),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFF0B0F2B),
//         elevation: 0,
//         title: const Text("YTGrabber", style: TextStyle(color: Colors.white)),
//         centerTitle: false,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const Text(
//               "Paste the YouTube video URL below:",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: _urlController,
//               style: const TextStyle(color: Colors.white),
//               decoration: InputDecoration(
//                 labelText: "YouTube URL",
//                 labelStyle: const TextStyle(color: Colors.white70),
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 prefixIcon: const Icon(Icons.link, color: Colors.white),
//                 enabledBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Colors.white24),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 focusedBorder: OutlineInputBorder(
//                   borderSide: const BorderSide(color: Color(0xFF00BFFF)),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: _isLoading ? null : _downloadVideo,
//               icon:
//                   _isDownloaded
//                       ? const Icon(Icons.check_circle_outline)
//                       : const Icon(Icons.download),
//               label: const Text("Download"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF00BFFF),
//                 foregroundColor: Colors.black,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 30,
//                   vertical: 15,
//                 ),
//                 textStyle: const TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//           if (_isLoading)
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: const Color(
//                     0xFF0B0F2B,
//                   ), // <-- Your desired background color
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Column(
//                   children: [
//                     Lottie.asset(
//                       'assets/animations/thinkking.json',
//                       width: 120,
//                       height: 120,
//                       fit: BoxFit.contain,
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       (_downloadProgress > 0)
//                           ? 'Progress: ${(_downloadProgress * 100).toStringAsFixed(1)}%'
//                           : 'Starting download...',
//                       style: const TextStyle(color: Color(0xFF00BFFF)),
//                     ),
//                   ],  
//                 ),
//               ),

//             const SizedBox(height: 20),
//             Text(
//               _statusMessage,
//               style: TextStyle(
//                 color:
//                     _statusMessage.startsWith('✅')
//                         ? Colors.greenAccent
//                         : _statusMessage.startsWith('❌')
//                         ? Colors.redAccent
//                         : Colors.white,
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
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:saver_gallery/saver_gallery.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  String _statusMessage = '';
  bool _isLoading = false;
  bool _isDownloaded = false;
  double _downloadProgress = 0;

  @override
  void initState() {
    super.initState();
    _askPermissions();
  }

  Future<void> _askPermissions() async {
    await [Permission.storage, Permission.photos].request();
  }

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
      _isDownloaded = false;
      _statusMessage = 'Preparing download...';
      _downloadProgress = 0;
    });

    try {
      final response = await http.post(
        Uri.parse('https://hateem954.pythonanywhere.com/download'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'url': url}),
      );

      final data = jsonDecode(response.body);
      debugPrint('🔄 API Response: $data');

      if (response.statusCode == 200 && data['status'] == 'success') {
        final fileName = data['file'];
        final fileUrl =
            'https://hateem954.pythonanywhere.com/GTGrabber/$fileName';

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

        await SaverGallery.saveFile(
          filePath: file.path,
          fileName: fileNameFromPath(file.path),
          skipIfExists: false,
        );

        final downloadedSizeMB = (await file.length()) / (1024 * 1024);

        setState(() {
          _isLoading = false;
          _isDownloaded = true;
          _downloadProgress = 0;
          _statusMessage =
              '✅ Video saved to gallery!\nTotal size: ${downloadedSizeMB.toStringAsFixed(2)} MB';
        });
      } else {
        setState(() {
          _isLoading = false;
          _isDownloaded = false;
          _statusMessage =
              '❌ Server error: ${data['message'] ?? 'Unknown error'}';
          _downloadProgress = 0;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isDownloaded = false;
        _statusMessage = '❌ Could not connect to server.\nError: $e';
        _downloadProgress = 0;
      });
      debugPrint('❌ Exception: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F2B),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F2B),
        elevation: 0,
        title: const Text("YTGrabber", style: TextStyle(color: Colors.white)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Paste the YouTube video URL below:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _urlController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "YouTube URL",
                labelStyle: const TextStyle(color: Colors.white70),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: const Icon(Icons.link, color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white24),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF00BFFF)),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _downloadVideo,
              icon:
                  _isDownloaded
                      ? const Icon(Icons.check_circle_outline)
                      : const Icon(Icons.download),
              label: const Text("Download"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00BFFF),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            if (_isLoading)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0F2B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Lottie.asset(
                      'assets/animations/thinkking.json',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      (_downloadProgress > 0)
                          ? 'Progress: ${(_downloadProgress * 100).toStringAsFixed(1)}%'
                          : 'Starting download...',
                      style: const TextStyle(color: Color(0xFF00BFFF)),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            Text(
              _statusMessage,
              style: TextStyle(
                color:
                    _statusMessage.startsWith('✅')
                        ? Colors.greenAccent
                        : _statusMessage.startsWith('❌')
                        ? Colors.redAccent
                        : Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
