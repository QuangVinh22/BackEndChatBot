const express = require("express");
const conversationsRoutesApi = express.Router();
const {
  createConversationsController,
} = require("../Controller/ConversationController");
const { verifyAccessToken } = require("../Service/JwtService");

conversationsRoutesApi.post("/create", createConversationsController);

module.exports = conversationsRoutesApi;
