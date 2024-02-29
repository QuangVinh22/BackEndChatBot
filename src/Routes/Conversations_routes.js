const express = require("express");
const conversationsRoutesApi = express.Router();
const {
  createConversationsController,
  getListConversationsController,
} = require("../Controller/ConversationController");
const { verifyAccessToken } = require("../Service/JwtService");

conversationsRoutesApi.post(
  "/create",
  verifyAccessToken,
  createConversationsController
);
conversationsRoutesApi.get(
  "/getList",
  verifyAccessToken,
  getListConversationsController
);

module.exports = conversationsRoutesApi;
