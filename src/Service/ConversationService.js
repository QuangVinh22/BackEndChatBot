const Conversation = require("../Models/Conversations_model");
const createError = require("http-errors");
const { userValidate } = require("../helpers/validation");
const client = require("../helpers/connect-redis");
const { createMessageService } = require("../Service/MessageService");
const {
  SignAccessToken,
  verifyRefreshToken,
  signRefreshToken,
} = require("./JwtService");

module.exports = {
  createConversationService: async (conversationData) => {
    if (!conversationData) {
      throw new Error("Conversation data is required");
    }

    if (!conversationData.userInfor) {
      throw new Error("User information is required");
    }

    try {
      const existingConversation = await Conversation.findById(
        conversationData._id
      );
      if (conversationData.type === "ADD-MESSAGES" && existingConversation) {
        existingConversation.messages.push(...conversationData.messages);
        return await existingConversation.save();
      } else {
        // Đảm bảo rằng kết quả từ việc tạo mới được trả về
        return await Conversation.create(conversationData);
      }
    } catch (error) {
      throw new Error(`Database error: ${error.message}`);
    }
  },

  getListConversationService: async (conversation) => {
    const listConversation = await Conversation.find({}).populate("messages");
    return listConversation;
  },
  deleteConversations: async (id) => {
    // Kiểm tra xem hội thoại có tồn tại không trước khi xóa
    const conversation = await Conversation.findById(id);
    if (!conversation) {
      throw createError(404, "Conversation not found");
    }

    // Nếu tồn tại, tiếp tục xóa
    const deletedConversations = await Conversation.deleteOne({ _id: id });
    if (deletedConversations.deletedCount === 0) {
      throw createError(400, "Failed to delete the conversation");
    }

    return deletedConversations; // Trả về kết quả của việc xóa
  },
};
