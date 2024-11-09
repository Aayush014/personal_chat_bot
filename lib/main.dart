import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(
    GetMaterialApp(
      theme: ThemeData.dark().copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchFieldController = TextEditingController();
  final RxList<Map<String, dynamic>> responses = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> previousChats =
      <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isButtonEnabled = false.obs;

  HomeController() {
    searchFieldController.addListener(() {
      isButtonEnabled.value = searchFieldController.text.isNotEmpty;
    });
  }

  Future<void> generateResponse() async {
    const String apiKey = "YOUR_API_KEY";
    final model = GenerativeModel(model: 'gemini-pro', apiKey: apiKey);
    final prompt = searchFieldController.text;

    isLoading.value = true;
    try {
      final response = await model.generateContent([Content.text(prompt)]);
      if (response.text != null) {
        final responseText = response.text!;
        responses.add({
          "title": prompt,
          "userText": prompt,
          "aiText": responseText,
          "displayText": "".obs,
        });
        searchFieldController.clear();
        animateText(responseText, responses.length - 1);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (scrollController.hasClients) {
            scrollController.animateTo(
              scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.linear,
            );
          }
        });
      }
    } finally {
      isLoading.value = false;
    }
  }

  void animateText(String fullText, int index) {
    final displayText = responses[index]["displayText"] as RxString;
    displayText.value = "";

    int currentIndex = 0;
    Timer.periodic(const Duration(milliseconds: 25), (timer) {
      if (currentIndex < fullText.length) {
        displayText.value += fullText[currentIndex];
        currentIndex++;
      } else {
        timer.cancel();
      }
    });
  }

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  void storeLastChat() {
    if (responses.isNotEmpty) {
      final lastChatTitle = responses.last["userText"];
      final lastChatResponse = responses.last["aiText"];
      final currentDate = DateTime.now();

      final existingChatIndex = previousChats.indexWhere((chat) =>
          chat["responses"].isNotEmpty &&
          chat["responses"][0]["userText"] == lastChatTitle);

      if (existingChatIndex != -1) {
        final existingChat = previousChats[existingChatIndex];
        final existingChatResponse = existingChat["responses"][0]["aiText"];

        if (existingChatResponse != lastChatResponse) {
          previousChats[existingChatIndex]["responses"] =
              List<Map<String, dynamic>>.from(responses);
        }
      } else {
        previousChats.add({
          "date": currentDate,
          "responses": List<Map<String, dynamic>>.from(responses),
        });
      }

      previousChats.sort((a, b) => b["date"].compareTo(a["date"]));
    }
  }

  void clearChat() {
    responses.clear();
  }

  void loadPreviousChat(int index) {
    responses.assignAll(previousChats[index]["responses"]);
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: const Color(0xff131313),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'ZenAI',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFFEFD9B0),
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              controller.storeLastChat();
              controller.clearChat();
            },
            child: const Icon(
              Icons.add_box_outlined,
              size: 30,
              color: Color(0xFFEFD9B0),
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 15)),
        ],
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFFEFD9B0)),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1E1E1E),
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                accountName: Text(
                  "Aayush Patel",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                accountEmail: Text(
                  "Your AI Assistant",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white70,
                  ),
                ),
                currentAccountPicture: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.person,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF242424),
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
              ),
              const Divider(color: Colors.white30),
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: controller.previousChats.length,
                    itemBuilder: (context, index) {
                      final chat = controller.previousChats[index];
                      final chatDate = chat["date"] as DateTime;
                      final formattedDate =
                          "${chatDate.year}-${chatDate.month}-${chatDate.day}";

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                        color: const Color(0xFF3C3C3C),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        child: ListTile(
                          leading: const Icon(
                            Icons.history,
                            color: Colors.white,
                          ),
                          title: Text(
                            "${controller.previousChats[index]["responses"][0]["userText"] ?? 'No Title'}",
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            formattedDate,
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          onTap: () {
                            controller.loadPreviousChat(index);
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  controller: controller.scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: controller.responses.length,
                  itemBuilder: (context, i) {
                    final userText = controller.responses[i]['userText'];
                    final displayText =
                        controller.responses[i]['displayText'] as RxString;

                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.centerRight,
                                child: Card(
                                  color: const Color(0xFF242424),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                        .copyWith(
                                            topRight: const Radius.circular(0)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      userText,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const CircleAvatar(
                              backgroundColor: Color(0xFFEFD9B0),
                              radius: 20,
                              child: Icon(Icons.person, color: Colors.black),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Color(0xFFEFD9B0),
                              radius: 20,
                              child: Icon(Icons.smart_toy, color: Colors.black),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Card(
                                color: const Color(0xFF363636),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)
                                      .copyWith(
                                          topLeft: const Radius.circular(0)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Obx(
                                    () => MarkdownBody(
                                      data: displayText.value,
                                      selectable: true,
                                      styleSheet: MarkdownStyleSheet(
                                        p: const TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                controller.copyToClipboard(displayText.value);
                              },
                              icon: const Icon(Icons.copy,
                                  color: Color(0xFFEFD9B0)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: CupertinoTextField(
                      controller: controller.searchFieldController,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 15),
                      placeholder: 'Ask me anything...',
                      style: const TextStyle(color: Colors.white),
                      decoration: BoxDecoration(
                        color: const Color(0xFF242424),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => CupertinoButton(
                      color: const Color(0xFFEFD9B0),
                      onPressed: controller.isButtonEnabled.value
                          ? controller.generateResponse
                          : null,
                      padding: const EdgeInsets.all(12),
                      borderRadius: BorderRadius.circular(20),
                      child: controller.isLoading.value
                          ? const CupertinoActivityIndicator(
                              color: Colors.black)
                          : const Icon(Icons.send, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}