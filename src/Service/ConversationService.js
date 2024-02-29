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
  createConversationService: async (conversation) => {
    if (!conversation) {
      throw createError.BadRequest("message is required");
    }

    try {
      const isCreatedconversations = await Conversation.create({
        name: conversation.name,
        userInfor: conversation._id,
        messages: conversation.messages,
      });
      return isCreatedconversations;
    } catch (error) {
      console.log(error);
      throw createError.InternalServerError(error.message);
    }
  },
  getListConversationService: async (conversation) => {
    const listConversation = Conversation.find({});
    return listConversation;
  },
};
