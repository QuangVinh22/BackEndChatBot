const Message = require("../Models/Message_model");
const createError = require("http-errors");
const { userValidate } = require("../helpers/validation");
const client = require("../helpers/connect-redis");

const {
  SignAccessToken,
  verifyRefreshToken,
  signRefreshToken,
} = require("./JwtService");

module.exports = {
  createMessageService: async (newmessage) => {
    if (
      !newmessage ||
      !newmessage.text ||
      !newmessage.conversationId ||
      !newmessage.sender
    ) {
      throw createError.BadRequest(
        "Message text, sender, and conversationId are required"
      );
    }
    console.log(newmessage);
    try {
      const createdMessage = await Message.create({
        text: newmessage.text,
        conversationId: newmessage.conversationId, // Đảm bảo tên trường khớp với schema
        sender: newmessage.sender, // Đảm bảo bạn có trường này từ request
      });
      return createdMessage;
    } catch (error) {
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
