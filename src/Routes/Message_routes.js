const express = require("express");
const messageRoutesApi = express.Router();
const {
  createMessageController,
  getListConversationsController,
} = require("../Controller/MessageController");
const { verifyAccessToken } = require("../Service/JwtService");

messageRoutesApi.post("/create", createMessageController);
messageRoutesApi.get("/getList", getListConversationsController);

module.exports = messageRoutesApi;
