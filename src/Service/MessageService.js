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
    if (!newmessage) {
      throw createError.BadRequest("message is required");
    }
    console.log(newmessage);
    try {
      const createdMessage = await Message.create({
        text: newmessage.text,
      });
      return createdMessage;
    } catch (error) {
      throw createError.InternalServerError(error.message);
    }
  },
};
