import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_insta_app/provider/user_provider.dart';
import 'package:flutter_insta_app/resources/firestore_methods.dart';
import 'package:flutter_insta_app/utiles/color.dart';
import 'package:flutter_insta_app/utiles/utile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_insta_app/model/user.dart' as model;

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void postImage(String uid, String userName, String profileImg) async {
    setState(() {
      _isLoading = true;
    });

    try {
      String res = await FireStoreMetods().uploadPost(
          _descriptionController.text, _file!, uid, userName, profileImg);
      if (res == 'success') {
        setState(() {
          _isLoading = false;
          _file = null;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (err) {
      showSnackBar(err.toString(), context, Colors.red, Colors.white);
      _isLoading = false;
    }
  }

  Uint8List? _file;

  _selectImage(BuildContext context) async {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);
                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Chose frome a gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);
                setState(
                  () {
                    _file = file;
                  },
                );
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: size.height / 30),
              child: Center(
                child: SimpleDialogOption(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    model.User user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? SafeArea(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                backgroundColor: mobileBackgroundColor,
                title: const Text('New Post'),
              ),
              body: Center(
                child: IconButton(
                  icon: Icon(
                    size: size.width/10,
                    Icons.upload,
                  ),
                  onPressed: () async {
                    await _selectImage(context);
                  },
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: true,
              leading: InkWell(
                onTap: () {
                  setState(() {
                    _file = null;
                  });
                },
                child: const Icon(
                  Icons.arrow_back,
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {
                    postImage(user.uid, user.userName, user.photoUrl);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: size.width / 25, right: size.width / 25),
                    child: Text(
                      'Post',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w800,
                        fontSize: size.width / 20,
                      ),
                    ),
                  ),
                ),
              ],
              backgroundColor: mobileBackgroundColor,
              title: Text(
                'Post To',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width / 20,
                ),
              ),
              centerTitle: false,
            ),
            body: _isLoading
                ? const LinearProgressIndicator()
                : Center(
                    child: Column(
                      children: [
                        SizedBox(
                          width: size.width,
                          height: size.height / 20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(user.photoUrl),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: size.width / 5),
                                  child: TextField(
                                    controller: _descriptionController,
                                    maxLines: 8,
                                    decoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Write a caption...',
                                      hintStyle: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: MemoryImage(_file!),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        size.width / 50,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          );
  }
}
