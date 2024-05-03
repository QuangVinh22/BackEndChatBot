const Message = require("../Models/Message_model");
const Conversation = require("../Models/Conversations_model");
const createError = require("http-errors");
const { userValidate } = require("../helpers/validation");
const client = require("../helpers/connect-redis");

const {
  SignAccessToken,
  verifyRefreshToken,
  signRefreshToken,
} = require("./JwtService");

module.exports = {
  createMessageService: async (newMessage) => {
    try {
      // First, check if the conversation exists
      const conversationExists = await Conversation.findById(
        newMessage.conversationId
      );
      if (!conversationExists) {
        throw createError.NotFound("Conversation not found");
      }

      // If the conversation exists, create the message
      const createdMessage = await Message.create({
        text: newMessage.text,
        conversationId: newMessage.conversationId, // Ensure field names match schema
        senderType: newMessage.senderType, // Ensure you have this field from the request
      });

      // Then, update the conversation to add the new message's ID
      const updatedConversation = await Conversation.findByIdAndUpdate(
        newMessage.conversationId,
        { $push: { messages: createdMessage._id } },
        { new: true }
      );

      // Check if the conversation update was successful
      if (!updatedConversation) {
        throw createError.InternalServerError("Failed to update conversation");
      }

      return createdMessage;
    } catch (error) {
      // This captures any errors including not found and internal server errors
      throw createError.InternalServerError(error.message);
    }
  },
  getListConversationService: async (queryParams) => {
    if (!queryParams || !queryParams.conversationId) {
      throw createError.BadRequest("Conversation ID is required");
    }
    try {
      // Sử dụng conversation hoặc conversationId tùy thuộc vào cách bạn đặt tên trường trong schema của Message
      const listMessage = await Message.find({
        conversationId: queryParams.conversationId,
      });
      if (!listMessage) {
        throw createError.BadRequest("Not Found conversations");
      }
      if (listMessage) return listMessage;
    } catch (error) {
      // Xử lý lỗi tại đây, ví dụ: throw new Error(error.message);
      throw createError.InternalServerError(error.message); // Hoặc bạn có thể quyết định throw một lỗi cụ thể tùy thuộc vào logic ứng dụng của bạn
    }
  },
};
