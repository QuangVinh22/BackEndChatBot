// Import dependencies
const mongoose = require("mongoose");
jest.mock("../Models/Conversations_model", () => ({
  findById: jest.fn(),
  findByIdAndUpdate: jest.fn(),
}));
jest.mock("../Models/Message_model", () => ({
  create: jest.fn(),
}));

// CreateError mock
jest.mock("http-errors", () => ({
  NotFound: jest.fn((msg) => new Error(msg)),
  InternalServerError: jest.fn((msg) => new Error(msg)),
}));
const redis = require("redis-mock"); // Import redis-mock library

jest.mock("../helpers/connect-redis", () => ({
  set: jest.fn(),
  get: jest.fn(),
}));

// Importing service after mocking
const { createMessageService } = require("../Service/MessageService");
const Message = require("../Models/Message_model");
const Conversation = require("../Models/Conversations_model");
const createError = require("http-errors");
describe("createMessageService", () => {
  beforeEach(() => {
    // Clear all mocks before each test
    jest.clearAllMocks();
  });
  it("should handle errors when message creation fails", async () => {
    const newMessage = {
      conversationId: "123",
      text: "Hello",
      senderType: "user",
    };
    Conversation.findById.mockResolvedValue({ _id: "123" });
    Message.create.mockRejectedValue(new Error("Database error"));

    await expect(createMessageService(newMessage)).rejects.toThrow(
      "Database error"
    );
  });
  it("should throw an error if conversation does not exist", async () => {
    // Setup
    const newMessage = {
      conversationId: "123",
      text: "Hello",
      senderType: "user",
    };
    Conversation.findById.mockResolvedValue(null);

    // Assert
    await expect(createMessageService(newMessage)).rejects.toThrow(
      "Conversation not found"
    );
  });
  it("should throw an error if updating the conversation fails", async () => {
    const newMessage = {
      conversationId: "123",
      text: "Hello",
      senderType: "user",
    };
    const mockMessage = {
      _id: "message123",
      text: "Hello",
      conversationId: "123",
      senderType: "user",
    };
    Conversation.findById.mockResolvedValue({ _id: "123" });
    Message.create.mockResolvedValue(mockMessage);
    Conversation.findByIdAndUpdate.mockResolvedValue(null);

    await expect(createMessageService(newMessage)).rejects.toThrow(
      "Failed to update conversation"
    );
  });
  it("should create a message and update conversation successfully", async () => {
    // Setup
    const newMessage = {
      conversationId: "123",
      text: "Hello",
      senderType: "user",
    };
    const mockMessage = {
      _id: "message123",
      text: "Hello",
      conversationId: "123",
      senderType: "user",
    };
    Conversation.findById.mockResolvedValue({ _id: "123", messages: [] });
    Message.create.mockResolvedValue(mockMessage);
    Conversation.findByIdAndUpdate.mockResolvedValue({
      _id: "123",
      messages: ["message123"],
    });

    // Act
    const result = await createMessageService(newMessage);

    // Assert
    expect(result).toEqual(mockMessage);
    expect(Conversation.findByIdAndUpdate).toHaveBeenCalledWith(
      "123",
      { $push: { messages: "message123" } },
      { new: true }
    );
  });

  // More test cases for different scenarios
});
