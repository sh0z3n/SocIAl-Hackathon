import 'package:flutter/material.dart';
import 'package:safe_bump/services/ai_chat_service.dart';
import 'package:sizer/sizer.dart';

class AIChatView extends StatefulWidget {
  const AIChatView({Key? key}) : super(key: key);

  @override
  State<AIChatView> createState() => _AIChatViewState();
}

class _AIChatViewState extends State<AIChatView> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _addBotMessage(
      'Hello! 👋 I\'m your AI health assistant. I can help answer questions about pregnancy, menstrual health, nutrition, exercise, and more. What would you like to know?',
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add({
        'text': text,
        'isUser': false,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add({
        'text': text,
        'isUser': true,
        'timestamp': DateTime.now(),
      });
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = _messageController.text.trim();
    _addUserMessage(userMessage);
    _messageController.clear();

    // Simulate AI thinking delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final response = AIChatService.getResponse(userMessage);
      _addBotMessage(response);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.pink.shade400,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                color: Colors.pink.shade700,
                size: 20.sp,
              ),
            ),
            SizedBox(width: 2.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI Health Assistant',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Always here to help',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(3.w),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
          _buildQuickTips(),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;
    final text = message['text'] as String;

    return Padding(
      padding: EdgeInsets.only(bottom: 2.h),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: Colors.pink.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.smart_toy,
                color: Colors.pink.shade700,
                size: 4.w,
              ),
            ),
            SizedBox(width: 2.w),
          ],
          Flexible(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: isUser ? Colors.pink.shade400 : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: isUser ? Colors.white : Colors.black87,
                  height: 1.4,
                ),
              ),
            ),
          ),
          if (isUser) ...[
            SizedBox(width: 2.w),
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: Colors.pink.shade200,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.pink.shade700,
                size: 4.w,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickTips() {
    final tips = AIChatService.getQuickTips();
    return Container(
      height: 12.h,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        itemCount: tips.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: GestureDetector(
              onTap: () {
                _addUserMessage(tips[index]);
                Future.delayed(const Duration(milliseconds: 500), () {
                  _addBotMessage(
                    'That\'s a great tip! Would you like to know more about this topic?',
                  );
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.pink.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.pink.shade100.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    tips[index],
                    style: TextStyle(
                      fontSize: 10.sp,
                      color: Colors.pink.shade700,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide(color: Colors.pink.shade400, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4.w,
                  vertical: 2.h,
                ),
              ),
              maxLines: null,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 2.w),
          Container(
            decoration: BoxDecoration(
              color: Colors.pink.shade400,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: Icon(Icons.send, color: Colors.white),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

