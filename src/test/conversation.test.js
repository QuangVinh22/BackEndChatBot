// const {
//   createConversationService,
//   getListConversationService,
// } = require("../Service/ConversationService");
// const Conversation = require("../Models/Conversations_model");
// const redisClient = require("../helpers/connect-redis");
// // Đường dẫn đến Conversation model của bạn
// jest.mock("../Models/Conversations_model");

// describe("Conversation Service", () => {
//   describe("createConversationService", () => {
//     it("should throw an error if conversation is not provided", async () => {
//       await expect(createConversationService(null)).rejects.toThrow(
//         "message is required"
//       );
//     });
//     it("should create a new conversation for 'EMPTY-PROJECTS' type", async () => {
//       const mockConversation = {
//         name: "New Project",
//         _id: "user123",
//         type: "EMPTY-PROJECTS",
//       };

//       Conversation.create.mockResolvedValue(mockConversation);

//       const result = await createConversationService(mockConversation);

//       expect(Conversation.create).toHaveBeenCalledWith({
//         name: mockConversation.name,
//         userInfor: mockConversation._id,
//       });
//       expect(result).toBe(mockConversation);
//     });
//     it("should add messages to an existing conversation for 'ADD-MESSAGES' type", async () => {
//       const mockConversation = {
//         _id: "conversation123",
//         type: "ADD-MESSAGES",
//         messages: ["message1", "message2"],
//         userInfor: "user123",
//       };

//       const existingConversation = {
//         _id: "conversation123",
//         name: "Existing Conversation",
//         messages: [],

//         save: jest.fn().mockResolvedValue("updatedConversation"),
//       };

//       Conversation.findById.mockResolvedValue(existingConversation);

//       const result = await createConversationService(mockConversation);

//       expect(result).toBe("updatedConversation");
//       expect(existingConversation.messages).toEqual(
//         expect.arrayContaining(mockConversation.messages)
//       );
//     });
//     it("should retrieve a list of conversations", async () => {
//       const mockConversationsList = [
//         { name: "Conversation 1", messages: [] },
//         { name: "Conversation 2", messages: [] },
//       ];

//       Conversation.find.mockReturnThis();
//       Conversation.populate.mockResolvedValue(mockConversationsList);

//       const result = await getListConversationService();

//       expect(Conversation.find).toHaveBeenCalledWith({});
//       // If you're using .populate() in your service, ensure to mock and assert it as well
//       // expect(Conversation.populate).toHaveBeenCalledWith('messages');
//       expect(result).toEqual(mockConversationsList);
//     });
//     beforeAll(async () => {
//       // Đảm bảo rằng kết nối Redis được thiết lập trước khi bất kỳ tests nào được chạy
//       if (!redisClient.isOpen) {
//         await redisClient.connect();
//       }
//     });

//     afterAll(async () => {
//       // Đóng kết nối Redis sau khi tất cả tests đã hoàn thành
//       await redisClient.quit();
//     });

//     // Các test cho getListConversationService
//   });
// });
