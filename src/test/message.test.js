const request = require("supertest");
const express = require("express");
const createError = require("http-errors");
const Message = require("../Models/Message_model");
const Conversation = require("../Models/Conversations_model");
const messageRoutesApi = require("../Routes/Message_routes");
const {
  createMessageService,
  getListMessageService,
} = require("../Service/MessageService");
const conversationsRoutesApi = require("../Routes/Conversations_routes");
jest.mock("../Models/Message_model");
jest.mock("../Models/Conversations_model");
jest.mock("../helpers/connect-redis", () => ({
  isOpen: false,
  connect: jest.fn(),
  quit: jest.fn(),
}));
jest.mock("redis", () => ({
  createClient: jest.fn().mockReturnThis(),
  connect: jest.fn().mockResolvedValue("OK"),
  get: jest
    .fn()
    .mockImplementation((key, callback) => callback(null, "mockedValue")),
  set: jest.fn(),
  on: jest.fn(),
  ping: jest.fn().mockResolvedValue("PONG"),
}));
const app = express();
app.use(express.json());

app.use("/v1/Messages", messageRoutesApi);
app.use("/v1/Conversations", conversationsRoutesApi);

describe("Message Service", () => {
  describe("createMessageService", () => {
    it("should throw an error if the conversation does not exist", async () => {
      const newMessage = {
        text: "Hello",
        conversationId: "nonExistingId",
        senderType: "user",
      };

      Conversation.findById.mockResolvedValue(null);

      await expect(createMessageService(newMessage)).rejects.toThrow(
        "Conversation not found"
      );
    });

    it("should create a message in an existing conversation", async () => {
      const newMessage = {
        text: "Hello",
        conversationId: "existingConversationId",
        senderType: "user",
      };
      const createdMessage = {
        _id: "messageId",
        ...newMessage,
      };

      Conversation.findById.mockResolvedValue(true);
      Message.create.mockResolvedValue(createdMessage);
      Conversation.findByIdAndUpdate.mockResolvedValue({
        _id: newMessage.conversationId,
        messages: [createdMessage._id],
      });

      const result = await createMessageService(newMessage);

      expect(Message.create).toHaveBeenCalledWith(newMessage);
      expect(result).toBe(createdMessage);
    });

    it("should handle unexpected errors during message creation", async () => {
      const newMessage = {
        text: "Test",
        conversationId: "faultyConversationId",
        senderType: "user",
      };

      Conversation.findById.mockResolvedValue(true); // Simulate an existing conversation
      Message.create.mockRejectedValue(new Error("Database error")); // Force a database error during message creation

      await expect(createMessageService(newMessage)).rejects.toThrow(
        "Database error"
      );
    });
  });
});
