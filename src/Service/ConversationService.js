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
    if (!conversation.userInfor) {
      throw createError.BadRequest("User information is required");
    }
    try {
      if (conversation.type === "EMPTY-PROJECTS") {
        const createdConversation = await Conversation.create({
          name: conversation.name,
          userInfor: conversation.userInfor,
        });
        return createdConversation;
      }

      if (conversation.type === "ADD-MESSAGES") {
        let existingConversation = await Conversation.findById(
          conversation._id
        );
        if (!existingConversation) {
          throw createError.NotFound("Conversation not found");
        }
        if (conversation.name) {
          existingConversation.name = conversation.name;
        }
        conversation.messages.forEach((message) => {
          existingConversation.messages.push(message);
        });
        let updatedConversation = await existingConversation.save();
        return updatedConversation;
      }
    } catch (error) {
      console.log(error);
      throw createError.InternalServerError(error.message);
    }
  },
  getListConversationService: async (conversation) => {
    const listConversation = await Conversation.find({}).populate("messages");
    return listConversation;
  },
};
