const express = require("express");
const messageRoutesApi = express.Router();
const { createMessageController } = require("../Controller/MessageController");
const { verifyAccessToken } = require("../Service/JwtService");

messageRoutesApi.post("/create", createMessageController);

module.exports = messageRoutesApi;
