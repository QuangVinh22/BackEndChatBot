const express = require("express");
const conversationsRoutesApi = express.Router();
const {
  createConversationsController,
  getListConversationsController,
} = require("../Controller/ConversationController");
const { verifyAccessToken } = require("../Service/JwtService");
const rateLimit = require("express-rate-limit");

// Thiết lập rate limit cho tạo conversations
const createConversationLimiter = rateLimit({
  windowMs: 60 * 1000, // 1 phút
  max: 10, // giới hạn mỗi người dùng chỉ được tạo 100 conversations mỗi phút
  message:
    "Quá nhiều yêu cầu tạo mới conversations, vui lòng thử lại sau một phút",
  headers: true,
});
conversationsRoutesApi.post("/create", createConversationsController);
conversationsRoutesApi.get(
  "/getList",
  verifyAccessToken,
  getListConversationsController
);

module.exports = conversationsRoutesApi;
