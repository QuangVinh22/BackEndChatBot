const createError = require("http-errors");
const { createConversationService } = require("../Service/ConversationService");
module.exports = {
  createConversationsController: async (req, res, next) => {
    try {
      let conversations = await createConversationService(req.body);
      return res.status(200).json({
        EC: 0,
        data: conversations,
      });
    } catch (error) {
      next(error);
    }
    // res.send("ok");
  },
};
