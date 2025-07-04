import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/chat/ChatsScreen/MessageScreen.dart';
import 'package:myapp/chat/Component/const.dart';
import '../auth/Login.dart';
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});
  @override
  State<ChatPage> createState() => _ChatPageState();
}
class _ChatPageState extends State<ChatPage> {
  TextEditingController chatController = TextEditingController();

  // object from CollectionReference ('Messages' )
  FirebaseFirestore firestore = FirebaseFirestore.instance;
        /// create new collection (Messages)
        // get data from Messages
  CollectionReference messages = FirebaseFirestore.instance.collection(kMessagesCollection);
  //const kMessagesCollection = 'Messages' ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                GoogleSignIn google = GoogleSignIn();
                google.disconnect();
                await FirebaseAuth.instance.signOut();
                Get.offAll(() => Login());
              },
              icon: const Icon(Icons.exit_to_app_outlined))
        ],
        backgroundColor: Colors.blue,
        title: const Text(
          'Chat',
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            // QuerySnapshot = all the document that you have = data
            // StreamBuilder ==  realtime changes = change occurs (modification, deleted or added).
          child: StreamBuilder<QuerySnapshot>(
                 /// to Scroll ListView to the end ?
              // 1 /  descending: true
              // 2 /  reverse: true,
              stream: messages.orderBy('messageTime', descending: true).snapshots(),
            // snapshot = place store your data
            builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error loading messages"));
                }
                if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                var docs = snapshot.data!.docs;
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var message = docs[index]['message'];
                    var senderId = docs[index]['senderId'];
                    var messageTime = docs[index]['messageTime'] ?? Timestamp.now();
                    bool isMe = senderId == FirebaseAuth.instance.currentUser!.uid;
                    //  change time from firebase to  DateTime(real)
                    DateTime time = messageTime.toDate();
                    String formattedTime = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
                    if (isMe) {
                      return GestureDetector(
                        onLongPress: () {
                          _showDeleteDialog(docs[index].id);
                        },
                        child: MessageScreen(
                          message: message,
                          isMe: isMe,
                          time: formattedTime,
                        ),
                      );
                    } else {
                      return MessageScreen(
                        message: message,
                        isMe: isMe,
                        time: formattedTime,
                      );
                    }
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: TextField(
              controller: chatController,
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  //  message =  field or Sub collection
                  // add what you want in your collection(messages) like message,time ,id ...etc
                  messages.add({
                    'message': value.trim(),
                    'messageTime': FieldValue.serverTimestamp(),
                    // uid = User ID = every user in Firebase Authentication  has different ID
                    'senderId': FirebaseAuth.instance.currentUser!.uid, // ✅ مهم جدًا
                  });
                  // to remove message from textField after send it
                  chatController.clear();
                }
              },
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.send),
                hintText: 'Send Message',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.blue, width: 3),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: const BorderSide(color: Colors.green),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
  void _showDeleteDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("هل تريد حذف الرسالة؟"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: context), // إلغاء
            child: const Text("لا"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection(kMessagesCollection)
                  .doc(docId)
                  .delete();
              Get.back(result: context); // إغلاق بعد الحذف
            },
            child: const Text("نعم"),
          ),
        ],
      ),
    );
  }

}
