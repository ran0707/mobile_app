import 'dart:io';
import 'dart:typed_data';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testapp01/chatbot/chatbot_main.dart';
import 'package:testapp01/screens/community/community_main.dart';
import 'package:testapp01/screens/dashboard/card2_report.dart';
import 'package:testapp01/screens/dashboard/profile.dart';
import 'package:testapp01/screens/objectdetection/resultPage.dart';
import 'package:testapp01/screens/userAuth/phoneVerify.dart';
import 'package:testapp01/screens/vendors/vendors_main.dart';
import 'package:testapp01/widgets/bottomButton.dart';
import 'package:testapp01/widgets/date_season_card.dart';
import 'package:testapp01/widgets/recents_reports.dart';
import 'package:testapp01/widgets/weatherCard.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_v2/tflite_v2.dart';
import '../../result/recommendation.dart';
import '../cultivation/cultivation_main.dart';
import 'package:testapp01/models/detected_object.dart';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:path_provider/path_provider.dart';

import 'dart:developer' as devtools;

class Home extends StatefulWidget {
  final String locality;
  const Home({super.key, required this.locality});

  @override
  State<Home> createState() => _Page0State();
}

class _Page0State extends State<Home> {
  int _selectIndex = 0;
  final ImagePicker _picker = ImagePicker();
  final PageController _pageController = PageController();
  File? filePath;
  String label = '';
  double confidence = 0.0;
  List? _recognitions;
  List<DetectedObject>? _detectedObjects;
  int _votes = 0;
  bool _isIncrease = true;

  Future<List<Vendor>> _fetchVendors() async {
    return [
      Vendor(
          name: 'Green Groceries',
          imageUrl:
              'https://5.imimg.com/data5/UP/NG/GLADMIN-24835254/seed-fertilizer-and-pesticides-500x500.jpg', // Replace with your image URLs
          description: 'Fresh and organic produce delivered to your doorstep.',
          rating: 4.8),
      Vendor(
          name: 'Organic Paradise',
          imageUrl:
              'https://5.imimg.com/data5/SELLER/Default/2023/12/368991270/JH/RM/QZ/151205291/agriculture-npk-fertilizers-250x250.jpg', // Replace with your image URLs
          description: 'Organic produce and sustainable practices',
          rating: 4.5),
      Vendor(
          name: 'Green Groceries',
          imageUrl:
              'https://5.imimg.com/data5/UP/NG/GLADMIN-24835254/seed-fertilizer-and-pesticides-500x500.jpg', // Replace with your image URLs
          description: 'Fresh and organic produce delivered to your doorstep.',
          rating: 4.8),
      Vendor(
          name: 'Organic Paradise',
          imageUrl:
              'https://5.imimg.com/data5/SELLER/Default/2023/12/368991270/JH/RM/QZ/151205291/agriculture-npk-fertilizers-250x250.jpg', // Replace with your image URLs
          description: 'Organic produce and sustainable practices',
          rating: 4.5),
    ];
  }

  //load model
  Future<void> _loadModel() async {
    try {
      String? result = await Tflite.loadModel(
        model: "assets/model/model_unquant.tflite",
        labels: "assets/model/labels.txt",
        numThreads: 1,
        useGpuDelegate: false,
        isAsset: true,
      );
      print("model loaded: $result");
    } catch (e) {
      print("failed to load model: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _loadModel();
  }

  Future<void> pickImage() async {
    //final ImagePicker picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
        path: image.path,
        imageMean: 0.0,
        imageStd: 255.0,
        numResults: 2,
        threshold: 0.2,
        asynch: true);

    if (recognitions == null) {
      devtools.log("recognitions is null");
      return;
    }
    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
    });
  }

  Future<void> clickImage() async {
    // final ImagePicker picker = ImagePicker();

    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    var imageMap = File(image.path);

    setState(() {
      filePath = imageMap;
    });

    var recognitions = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.2,
      asynch: true,
    );

    if (recognitions == null) {
      devtools.log("recognition is null");
      return;
    }
    devtools.log(recognitions.toString());
    setState(() {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['label'].toString();
    });
    String symptoms = '';
    String recommendation = '';
    if(label == "Gall Midge"){
      symptoms = 'The symptoms appear predominantly on the leaves, but occasionally also on the buds, inflorescences and young fruits of mango trees';
      recommendation = 'Dipping germinated seed in 0.2% chlorpyrifos solution for 3 hours before sowing give protection up to 30 days. In transplanted crop the root of seedlings may be dipped in 0.02% chlorpyrifos suspension for 12 hours prior to planting.';
    }else if(label == "Sooty Mould"){
      symptoms = 'The disease in the field is recognized by the presence of a black velvety coating, i.e., sooty mould on the leaf surface. In severe cases the trees turn completely black due to the presence of mould over the entire surface of twigs and leaves.';
      recommendation = 'Spraying the leaves with insecticidal soap can help soften the sooty coating. Spray late in the day so the soap remains moist for as long as possible. If you can spray a few hours before a heavy rain is forecast the rain will be better able to remove the sooty mold';
    }else{
      symptoms = ' is this healthy leaf ';
      recommendation= 'Healthy leaf detected. Improve yield by ensuring proper watering and nutrient supply.';
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendationPage(
          image: filePath!,
          label: label,
          accuracy: confidence,
          symptoms: symptoms,
          recommendation: recommendation,
        ),
      ),
    );

  }

  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

//image capture
//   Future<void> _captureImage() async {
//     final XFile? pickedFile =
//         await _picker.pickImage(source: ImageSource.camera);
//
//     if (pickedFile != null) {
//       setState(() {
//         _image = File(pickedFile.path);
//       });
//       _predictImage(_image!);
//       print('Image captured: ${pickedFile.path}');
//     } else {
//       print('No image captured');
//     }
//   }
//
//   // void _closeImage() {
//   //   setState(() {
//   //     _image = null;
//   //     _recognitions = null;
//   //     _isImageVisible = false;
//   //   });
//   // }
//
//
//   Future<void> _predictImage(File image) async {
//     try {
//
//       if(!await image.exists()){
//         print("Image file does not exist");
//         return;
//       }
//
//       final imageBytes = await image.readAsBytes();
//       if(imageBytes.isEmpty){
//         print("Image bytes are empty");
//         return;
//       }
//       final decodedImage = await decodeImageFromList(imageBytes);
//
//       if(decodedImage == null){
//         print("failed to decode image");
//         return;
//       }
//
//       // Resize the image to 244x244
//       final targetWidth = 244;
//       final targetHeight = 244;
//       final resizedImage = await resizeImage(decodedImage, width: targetWidth, height: targetHeight);
//
//       if(resizedImage == null){
//         print("failed to resize image");
//         return;
//       }
//
//       // Save resized image to a temporary file
//       final tempDir = await getTemporaryDirectory();
//       final tempPath = '${tempDir.path}/resized_image.png';
//       final resizedBytes = await resizedImage.toByteData(format: ui.ImageByteFormat.png);
//
//       if(resizedBytes == null){
//         print("Failed to get byte data from resized image");
//         return;
//       }
//
//       final resizedImageData = resizedBytes.buffer.asUint8List();
//       final tempFile = File(tempPath)..writeAsBytesSync(resizedImageData);
//
//       // Detect objects using the resized image file
//       final recognitions = await Tflite.detectObjectOnImage(
//         path: tempPath,
//         model: "CropNet.tflite",
//         numResultsPerClass: 1,
//         threshold: 0.5,
//       );
//
//       if(recognitions == null){
//         print("Failed to get recognition");
//         return;
//       }
//
//         final detectedObjects = recognitions.map((recognition) {
//           final rect = Rect.fromLTRB(
//             recognition['boxes'][0] * targetWidth.toDouble(),
//             recognition['boxes'][1] * targetHeight.toDouble(),
//             recognition['boxes'][2] * targetWidth.toDouble(),
//             recognition['boxes'][3] * targetHeight.toDouble(),
//           );
//           final label = recognition['classes'][0]['id'].toString();
//           final confidence = recognition['classes'][0]['score'];
//           return DetectedObject(rect, label, confidence);
//         }).toList();
//
//         setState(() {
//           _recognitions = recognitions;
//           _detectedObjects = detectedObjects;
//         });
//
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ResultPage(
//               image: image,
//               recognitions: recognitions,
//               detectedObjects: detectedObjects,
//             ),
//           ),
//         );
//
//     } catch (e) {
//       print("Failed to predict image: $e");
//       // Show an error message to the user
//     }
//   }
//
//
//
//
//
//   Future<ui.Image> resizeImage(ui.Image image, {int width = 256, int height = 256}) async {
//     // Convert ui.Image to raw image data
//     try{
//       final ByteData? bytes =
//           await image.toByteData(format: ui.ImageByteFormat.rawRgba);
//
//       if(bytes == null){
//         print("Failed to get byte data from image");
//         return Future.error("byte datais null");
//       }
//       final Uint8List uint8List = bytes.buffer.asUint8List();
//
//       // Decode the raw image data to img.Image
//       final img.Image? imgImage = img.decodeImage(uint8List);
//
//       if(imgImage == null){
//         print("Failed to decode image data");
//         return Future.error("Decoded image is null");
//       }
//
//       // Resize the image
//       final img.Image resizedImage =
//           img.copyResize(imgImage, width: width, height: height);
//
//       // Encode resized image to PNG
//       final Uint8List resizedBytes = img.encodePng(resizedImage);
//
//       // Decode resized image from PNG to ui.Image
//       final Completer<ui.Image> completer = Completer();
//       ui.decodeImageFromList(resizedBytes, (ui.Image img) {
//         completer.complete(img);
//       });
//
//       return completer.future;
//     }catch(e){
//       print("Failed to resize image: $e");
//       return Future.error("Failed to resize the image");
//     }
//   }

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  void signOut() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => PhoneVerification()));
  }

  void _updateVotes(int newVotes) {
    setState(() {
      _votes = newVotes;
      _isIncrease = true;
    });
  }

  void _navigateToVotePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Card2Report(
          initialVotes: _votes,
          onVote: (int vote) {
            _updateVotes(vote);
          },
          // pestNames: _pestNames,
        ),
      ),
    );
  }

  String _getGreetings() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  void _chatbot() {
    print('chat bot btn worked');
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ChatBotMain()));
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    final List<Widget> _pages = [
      SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(child: DateSeasonCard()),
                  const SizedBox(
                    width: 8.0,
                  ),

                  Expanded(
                      child: GestureDetector(
                    onTap: _navigateToVotePage,
                    child: RecentReports(
                      votes: _votes,
                      isIncrease: _isIncrease,
                    ),
                  )),
                  const SizedBox(
                    width: 8.0,
                  ),
                  // const Expanded(child: Card3(
                  //
                  // ),
                  // ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              WeatherCard(
                primaryLocality: widget.locality,
                fallbackLocality: widget.locality,
              ),
              SizedBox(
                height: 20.0,
              ),
              // Container(
              //   height: 280,
              //   width: 280,
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(10),
              //     // image: DecorationImage(
              //     //   image: AssetImage('Images/upload.jpg'),
              //     // ),
              //   ),
              //   child: filePath == null
              //       ? const Text(' ')
              //       : Image.file(
              //           filePath!,
              //           fit: BoxFit.fill,
              //         ),
              // ),
              // const SizedBox(
              //   height: 12.0,
              // ),
              // Padding(
              //   padding: EdgeInsets.all(10),
              //   child: Column(
              //     children: [
              //       Text(
              //         label,
              //         style: TextStyle(
              //           fontSize: 18,
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       const SizedBox(
              //         height: 12,
              //       ),
              //       Text(
              //         "The Accuracy is ${confidence.toStringAsFixed(0)} %",
              //         style: TextStyle(fontSize: 18),
              //       ),
              //       const SizedBox(
              //         height: 12.0,
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
      CultivationMain(),
      CommunityMain(),
      FutureBuilder(
          future: _fetchVendors(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error loading vendors'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No vendors available'),
              );
            } else {
              return VendorMain(vendors: snapshot.data!);
            }
          }),
    ];

    return PopScope(
      canPop: false,
      onPopInvoked:
          (didPop) {}, // remove the back button both software and hardware
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _selectIndex == 0
            ? AppBar(
                automaticallyImplyLeading: false,
                title: Text(_getGreetings()),
                actions: [
                  IconButton(
                    icon: CircleAvatar(
                      backgroundColor: Color(0xffdddddd),
                      child: Icon(CupertinoIcons.person, color: Colors.black),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfilePage()),
                      );
                    },
                  ),
                ],
              )
            : null,
        body: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: _pages,
            ),
            Positioned(
              right: 15.0,
              bottom: 120.0,
              child: SizedBox(
                height: 70.0,
                width: 70.0,
                child: FloatingActionButton(
                  onPressed: _chatbot,
                  tooltip: 'Chatbot',
                  child: Icon(
                    CupertinoIcons.chat_bubble_2,
                    size: 30.0,
                    color: Colors.black,
                  ),
                  backgroundColor: Color(0xffffff00),
                ),
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: isKeyboardVisible
            ? null
            : FloatingActionButton(
                //mini: true,
                onPressed: clickImage,
                tooltip: 'scan image',
                shape: StadiumBorder(),
                child: const Icon(CupertinoIcons.camera),
                backgroundColor: Color(0xff7c5b29),
              ),
        bottomNavigationBar: BottomButton(
          selectedIndex: _selectIndex,
          onItemTapped: _onItemTapped,
          onCameraPressed: () async {
            await clickImage();
            if (filePath != null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ResultPage(
                          image: filePath!,
                          recognitions: _recognitions ?? [],
                          detectedObjects: _detectedObjects ?? [])));
            }
          },
        ),
        extendBody: true,
      ),
    );
  }
}
