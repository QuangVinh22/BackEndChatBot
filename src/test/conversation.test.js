const {
  createConversationService,
  getListConversationService,
} = require("../Service/ConversationService");
const Conversation = require("../Models/Conversations_model");
const redisClient = require("../helpers/connect-redis");
const express = require("express");
const request = require("supertest");
const conversationsRoutesApi = require("../Routes/Conversations_routes");
// Đường dẫn đến Conversation model của bạn
jest.mock("../Models/Conversations_model.js");
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
//

const app = express();
app.use(express.json());
app.use("/v1/Conversations", conversationsRoutesApi);
const mockConversationData = {
  name: "Test Conversation",
  userInfor: "user123",
  type: "EMPTY-PROJECTS",
};
describe("Conversation Service", () => {
  describe("createConversationService", () => {
    it("should throw an error if conversation is not provided", async () => {
      await expect(createConversationService(null)).rejects.toThrow(
        "message is required"
      );
    });
    it("should create a new conversation for 'EMPTY-PROJECTS' type", async () => {
      const mockConversation = {
        name: "Project Discussion",
        userInfor: "5f7679702b5f5c002f5a3efd",
        type: "EMPTY-PROJECTS",
        messages: [],
      };

      const response = await request(app)
        .post("/v1/Conversations/create")
        .send(mockConversation);

      expect(response.status).toBe(200);
      expect(response.body.name).toEqual("Project Discussion");
    });
    it("should add messages to an existing conversation for 'ADD-MESSAGES' type", async () => {
      const mockConversation = {
        _id: "conversation123",
        name: "",
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
    it("should retrieve a list of conversations", async () => {
      const mockConversationsList = [
        { name: "Conversation 1", messages: [] },
        { name: "Conversation 2", messages: [] },
      ];

      Conversation.find.mockReturnThis();
      Conversation.populate.mockResolvedValue(mockConversationsList);

      const result = await getListConversationService();

      expect(Conversation.find).toHaveBeenCalledWith({});
      // If you're using .populate() in your service, ensure to mock and assert it as well
      // expect(Conversation.populate).toHaveBeenCalledWith('messages');
      expect(result).toEqual(mockConversationsList);
    });
    it("should throw an error if user information is not provided in the conversation", async () => {
      const conversationWithoutUserInfo = {
        name: "New Project",
        type: "EMPTY-PROJECTS",
      };
      await expect(
        createConversationService(conversationWithoutUserInfo)
      ).rejects.toThrow("User information is required");
    });
    it("should throw an error if conversation to add messages is not found", async () => {
      const conversationToAddMessage = {
        _id: "unknownID",
        type: "ADD-MESSAGES",
        messages: ["hello"],
        userInfor: "user123",
      };
      Conversation.findById.mockResolvedValue(null);

      await expect(
        createConversationService(conversationToAddMessage)
      ).rejects.toThrow(new Error("Conversation not found"));
    });
    it("should handle unexpected errors during conversation creation", async () => {
      const faultyConversation = {
        name: "Faulty Project",
        _id: "userFaulty",
        userInfor: "userFaulty",
        type: "EMPTY-PROJECTS",
      };

      Conversation.create.mockRejectedValue(new Error("Database error"));

      await expect(
        createConversationService(faultyConversation)
      ).rejects.toThrow("Database error");
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
    it("should rate limit excessive conversation creation requests", async () => {
      const agent = request(app);
      let results = [];

      // Send 101 requests, where the 101st should be blocked
      for (let i = 0; i < 11; i++) {
        results.push(
          agent.post("/v1/Conversations/create").send({ userId: "user123" })
        );
      }

      // Wait for all promises to resolve
      results = await Promise.all(results);

      // Filter out responses that have a 429 status code
      const rateLimitedResponses = results.filter(
        (response) => response.status === 429
      );

      // Log all results for debugging
      results.forEach((result, index) => {
        console.log(`Request ${index + 1}: Status ${result.status}`);
      });

      // Check if there are any rate limited responses
      expect(rateLimitedResponses.length).toBeGreaterThan(0);
      // Ensure the first rate limited response contains the expected text
    });
    //

    //
    beforeAll(() => {
      jest.clearAllMocks(); // Reset all mocks before starting tests
    });

    afterEach(() => {
      jest.resetAllMocks(); // Ensure mocks are clean between tests
    });
    beforeAll(async () => {
      // Đảm bảo rằng kết nối Redis được thiết lập trước khi bất kỳ tests nào được chạy
      if (!redisClient.isOpen) {
        await redisClient.connect();
      }
    });

    afterAll(async () => {
      // Đóng kết nối Redis sau khi tất cả tests đã hoàn thành
      await redisClient.quit();
    });

    // Các test cho getListConversationService
  });
});
