// ConversationService.test.js
const {
  createConversationService,
  getListConversationService,
} = require("../Service/ConversationService");
const Conversation = require("../Models/Conversations_model");

jest.mock("../Models/Conversations_model");
const redis = require("redis-mock"); // Import redis-mock library
const { ObjectId } = require("mongodb");
jest.mock("../helpers/connect-redis", () => ({
  set: jest.fn(),
  get: jest.fn(),
}));

describe("Conversation Service", () => {
  beforeEach(() => {
    jest.clearAllMocks(); // Clear all mocks before each test
  });
  describe("createConversationService", () => {
    it("should throw an error if conversation data is not provided", async () => {
      await expect(createConversationService(null)).rejects.toThrow(
        "Conversation data is required"
      );
    });

    it("should throw an error if user information is not provided", async () => {
      const newConversation = { name: "New Project", type: "EMPTY-PROJECTS" };
      await expect(createConversationService(newConversation)).rejects.toThrow(
        "User information is required"
      );
    });

    it("should add messages to an existing conversation for 'ADD-MESSAGES' type", async () => {
      const mockConversation = {
        _id: "conversation123",
        type: "ADD-MESSAGES",
        messages: ["message1", "message2"],
        userInfor: "user123",
      };

      const existingConversation = {
        _id: "conversation123",
        name: "Existing Conversation",
        messages: [],
        save: jest.fn().mockResolvedValue("updatedConversation"),
      };

      Conversation.findById.mockResolvedValue(existingConversation);

      const result = await createConversationService(mockConversation);
      expect(result).toBe("updatedConversation");
      expect(existingConversation.messages).toEqual(
        expect.arrayContaining(mockConversation.messages)
      );
    });

    it("should create a new conversation if it does not exist", async () => {
      const newConversation = {
        name: "New Project",
        userInfor: "5f7679702b5f5c002f5a3efd",
        type: "NEW-PROJECT",
        messages: [],
      };
      Conversation.findById.mockResolvedValue(null);
      Conversation.create.mockResolvedValue(newConversation);

      const result = await createConversationService(newConversation);
      expect(result).toEqual(newConversation);
    });

    it("should handle unexpected errors during conversation creation", async () => {
      const faultyConversation = {
        name: "Faulty Project",
        type: "EMPTY-PROJECTS",
        userInfor: "userFaulty",
      };
      Conversation.create.mockRejectedValue(new Error("Database error"));
      await expect(
        createConversationService(faultyConversation)
      ).rejects.toThrow("Database error");
    });
  });

  describe("getListConversationService", () => {
    it("should retrieve a list of conversations", async () => {
      const mockConversationsList = [
        { name: "Conversation 1", messages: [] },
        { name: "Conversation 2", messages: [] },
      ];
      Conversation.find.mockReturnThis();
      Conversation.populate.mockResolvedValue(mockConversationsList);

      const result = await getListConversationService();
      expect(result).toEqual(mockConversationsList);
    });

    it("should handle empty conversation list correctly", async () => {
      Conversation.find.mockReturnThis();
      Conversation.populate.mockResolvedValue([]);

      const result = await getListConversationService();
      expect(result).toEqual([]);
    });

    it("should handle errors when fetching conversations", async () => {
      Conversation.find.mockReturnThis();
      Conversation.populate.mockRejectedValue(
        new Error("Database fetch error")
      );

      await expect(getListConversationService()).rejects.toThrow(
        "Database fetch error"
      );
    });
  });
});
