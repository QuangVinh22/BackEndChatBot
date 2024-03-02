const createError = require("http-errors");
const {
  createMessageService,
  getListConversationService,
} = require("../Service/MessageService");
module.exports = {
  createMessageController: async (req, res, next) => {
    try {
      let conversations = await createMessageService(req.body);
      return res.status(200).json({
        EC: 0,
        data: conversations,
      });
    } catch (error) {
      next(error);
    }
    // res.send("ok");
  },
  getListConversationsController: async (req, res, next) => {
    try {
      let conversations = await getListConversationService(req.body);
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
