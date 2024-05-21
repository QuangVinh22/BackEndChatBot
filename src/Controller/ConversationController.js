const createError = require("http-errors");
const {
  createConversationService,
  deleteConversations,
  getListConversationService,
} = require("../Service/ConversationService");
module.exports = {
  createConversationsController: async (req, res, next) => {
    console.log("Received data:", req.body);
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
  deleteConversationsController: async (req, res, next) => {
    try {
      let conversations = await deleteConversations(req.params.id);
      return res.status(201).json({
        EC: 0,
        data: conversations,
      });
    } catch (error) {
      next(error);
    }
    // res.send("ok");
  },
};
