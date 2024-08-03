import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:gemini_with_hive/core/constants.dart';
import 'package:gemini_with_hive/hive/boxes.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:uuid/uuid.dart';

import '../hive/chat_history.dart';
import '../hive/settings.dart';
import '../hive/user_model.dart';
import '../models/messages.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatProvider extends ChangeNotifier {
  //list of messages
  final List<Message> _inChatMessages = [];

  // page controller
  final PageController _pageController = PageController();

  // current index
  int _currentIndex = 0;

  // List of images file
  List<XFile>? _imagesFileList = [];

  // current chatId
  String _currentChatId = '';

  // initialeze generative model
  GenerativeModel? _model;

  // initialze text model
  GenerativeModel? _textModel;

  // initialize vision model
  GenerativeModel? _visionModel;

  // type of model
  String _modelType = 'gemini-pro';

  // loading bool
  bool _isLoading = false;

  // getters
  List<Message> get inChatMessages => _inChatMessages;
  PageController get pageController => _pageController;
  int get currentIndex => _currentIndex;
  List<XFile>? get imagesFileList => _imagesFileList;
  String get currentChatId => _currentChatId;
  GenerativeModel? get generativeModel => _model;
  GenerativeModel? get textModel => _textModel;
  GenerativeModel? get visionModel => _visionModel;
  String get modelType => _modelType;
  bool get setLoading => _isLoading;

  // setters

  // set inChatMessages
  Future<void> setInChatMessages({required String chatId}) async {
    // get messages from hive database
    final messagesFromDB = await loadMessagesFromDB(chatId: chatId);
    for (var message in messagesFromDB) {
      if (_inChatMessages.contains(message)) {
        log('message already exists');
        continue;
      }
      _inChatMessages.add(message);
    }
    notifyListeners();
  }

  // load th messages from db
  Future<List<Message>> loadMessagesFromDB({required String chatId}) async {
    // open the box of this chatID
    await Hive.openBox("${Constants.chatMessagesBox}$chatId");

    final messageBox = Hive.box("${Constants.chatMessagesBox}$chatId");

    final newData = messageBox.keys.map((e) {
      final message = messageBox.get(e);
      final messageData = Message.fromMap(Map<String, dynamic>.from(message));
      return messageData;
    }).toList();
    notifyListeners();
    return newData;
  }

  // set file list
  void setImagesFileList({required List<XFile> listImage}) {
    _imagesFileList = listImage;
    notifyListeners();
  }

  // set current model
  String setCurrentModel({required String newModel}) {
    _modelType = newModel;
    notifyListeners();
    return newModel;
  }

  String getApiKey() {
    return dotenv.env['GEMINI_API_KEY']!;
  }

  // function to set the model based on bool isTextOnly
  Future<void> setModel({required bool isTextOnly}) async {
    if (isTextOnly) {
      _model = _textModel ??
          GenerativeModel(
              model: setCurrentModel(newModel: 'gemini-1.0-pro'),
              apiKey: dotenv.env['GOOGLE_API_KEY']!,
              generationConfig: GenerationConfig(
                temperature: 0.4,
                topK: 32,
                topP: 1,
                maxOutputTokens: 4096,
              ),
              safetySettings: [
                SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
                SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
              ]);
    } else {
      _model = _visionModel ??
          GenerativeModel(
              model: setCurrentModel(newModel: 'gemini-1.5-flash'),
              apiKey: dotenv.env['GOOGLE_API_KEY']!,
              generationConfig: GenerationConfig(
                temperature: 0.4,
                topK: 32,
                topP: 1,
                maxOutputTokens: 4096,
              ),
              safetySettings: [
                SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
                SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
              ]);
    }
    notifyListeners();
  }

  // set current index
  void setCurrentIndex({required int index}) {
    _currentIndex = index;
    notifyListeners();
  }

  // set current chatId
  void setCurrentChatId({required String newChatId}) {
    _currentChatId = newChatId;
    notifyListeners();
  }

  // set isLoading
  set setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // send message to gemini and get the Streaned responses from gemini
  Future<void> sendMessage(
      {required String message, required bool isTextOnly}) async {
    // set the model
    await setModel(isTextOnly: isTextOnly);

    // set loading
    setLoading = true;

    // get the chatId
    String chatId = getChatId();

    // list of history messages
    List<Content> historyMessages = [];

    // get the  history messages
    historyMessages = await getHistory(chatId: chatId);

    // get the imagesUrls
    List<String> imagesUrls = getImagesUrls(isTextOnly: isTextOnly);

    // user message id
    final userMessageId = const Uuid().v4();

    // user message
    final userMessages = Message(
      chatId: chatId,
      messageId: userMessageId,
      role: Role.user,
      message: StringBuffer(message),
      imagesUrls: imagesUrls,
      timeSend: DateTime.now(),
    );

    // add the user message to the list on inChatMessages
    _inChatMessages.add(userMessages);
    notifyListeners();

    if (currentChatId.isEmpty) {
      setCurrentChatId(newChatId: chatId);
    }

    // send the message to the model and wait for the respose
    await sendMessageAndWaitForRespons(
      message: message,
      chatId: chatId,
      isTextOnly: isTextOnly,
      historyMessages: historyMessages,
      userMessages: userMessages,
    );
  }

  // get the imagesUrls
  List<String> getImagesUrls({required bool isTextOnly}) {
    List<String> imagesUrls = [];
    if (imagesFileList != null && imagesFileList!.isNotEmpty && !isTextOnly) {
      for (var image in imagesFileList!) {
        imagesUrls.add(image.path);
      }
    }
    return imagesUrls;
  }

  // get history messages
  Future<List<Content>> getHistory({required String chatId}) async {
    List<Content> historyMessages = [];
    if (currentChatId.isNotEmpty) {
      await setInChatMessages(chatId: chatId);
      for (var message in inChatMessages) {
        if (message.role == Role.user) {
          historyMessages.add(Content.text(message.message.toString()));
        } else {
          historyMessages.add(Content.text(message.message.toString()));
        }
      }
    }
    return historyMessages;
  }
  // get profile

  // get chatId
  String getChatId() {
    if (currentChatId.isEmpty) {
      return const Uuid().v4();
    } else {
      return currentChatId;
    }
  }

  // init Hive Box
  static initHive() async {
    final dir = await path.getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    Hive.initFlutter(Constants.geminiDb);

    // register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(ChatHistoryAdapter());

      await Hive.openBox<ChatHistory>(Constants.chatHistoryBox);
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(UserModelAdapter());

      await Hive.openBox<UserModel>(Constants.userBox);
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(SettingsAdapter());
      await Hive.openBox<Settings>(Constants.settingsBox);
    }
  }

  // send message and wait for response
  Future<void> sendMessageAndWaitForRespons({
    required String message,
    required String chatId,
    required bool isTextOnly,
    required List<Content> historyMessages,
    required Message userMessages,
  }) async {
    //start the chat session - only send history is its text-only
    final chatSession = _model!.startChat(
      history: historyMessages.isEmpty || !isTextOnly ? null : historyMessages,
    );

    // get content
    final content = await getContent(
      message: message,
      isTextOnly: isTextOnly,
    );

    // assistant message id
    final userMessageId = const Uuid().v4();

    // assistant message
    final assistantMessage = userMessages.copyWith(
      messageId: userMessageId,
      role: Role.assistant,
      message: StringBuffer(),
      timeSend: DateTime.now(),
    );

    // add the assistant message to the list on inChatMessages
    _inChatMessages.add(assistantMessage);
    notifyListeners();

    // wait for response
    chatSession.sendMessageStream(content).asyncMap((event) {
      return event;
    }).listen(
      (event) {
        _inChatMessages
            .firstWhere((element) =>
                element.messageId == assistantMessage.messageId &&
                element.role == Role.assistant)
            .message
            .write(event.text);
        notifyListeners();
      },
      onDone: () async {
        // save message to hive database
        await saveMessageToDB(
            chatID: chatId,
            userMessage: userMessages,
            assistantMessage: assistantMessage);
        // set loading to false
        setLoading = false;
      },
    ).onError((error, stackTrac) {
      // set loading
      setLoading = false;
    });
  }

  // save messages to hive
  Future<void> saveMessageToDB({
    required String chatID,
    required Message userMessage,
    required Message assistantMessage,
  }) async {
    // open the messages box
    final messagesBox =
        await Hive.openBox('${Constants.chatMessagesBox}$chatID');

    // save User messages
    await messagesBox.put(userMessage.messageId, userMessage.toMap());

    // save Assistant message
    await messagesBox.put(assistantMessage.messageId, assistantMessage.toMap());

    // save chat history with the same chatid
    // if its already ther update it
    // if not create a new
    final chatHistoryBox = Boxes.getChatHistory();
    final chatHistory = ChatHistory(
      chatId: chatID,
      prompt: userMessage.message.toString(),
      response: assistantMessage.message.toString(),
      imagesUrls: userMessage.imagesUrls,
      timestamp: DateTime.now(),
    );

    await chatHistoryBox.put(chatID, chatHistory);
    // close the message box
    await messagesBox.clear();
  }

  // get content
  Future<Content> getContent({
    required String message,
    required bool isTextOnly,
  }) async {
    if (isTextOnly) {
      // generate text from text-only input
      return Content.text(message);
    } else {
      // generate image from text and image input
      final imageFutures =
          _imagesFileList?.map((imageFile) => imageFile.readAsBytes()).toList();
      final imageByte = await Future.wait(imageFutures!);
      final prompt = TextPart(message);
      final imageParts = imageByte
          .map((bytes) => DataPart('image/jpeg', Uint8List.fromList(bytes)))
          .toList();

      return Content.multi([prompt, ...imageParts]);
    }
  }
}
