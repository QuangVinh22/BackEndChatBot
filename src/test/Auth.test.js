// Mocking the User model
jest.mock("../Models/User_model", () => ({
  findOne: jest.fn().mockResolvedValue({
    _id: "user_id",
    isCheckPassword: jest.fn().mockResolvedValue(true), // Mocking isCheckPassword method
  }),
  create: jest.fn().mockResolvedValue({
    _id: "user_id",
    username: "test@example.com",
    password: "hashed_password",
  }),
}));

// Mocking the Redis client
jest.mock("../helpers/connect-redis", () => ({
  del: jest.fn().mockImplementation((userId, callback) => {
    callback(null, "deleted");
  }),
}));

// Mocking the JWT service
jest.mock("../Service/JwtService", () => ({
  SignAccessToken: jest.fn().mockResolvedValue("mocked_access_token"),
  signRefreshToken: jest.fn().mockResolvedValue("mocked_refresh_token"),
  verifyRefreshToken: jest.fn().mockResolvedValue({ userId: "user_id" }),
}));

// Import the AuthService after mocking dependencies
const AuthService = require("../Service/AuthService");
// Import UserModel
const UserModel = require("../Models/User_model");

describe("Auth Service", () => {
  describe("LogoutUserService", () => {
    it("should throw BadRequest if email is not from gmail.com domain", async () => {
      const user = { email: "test@example.com", password: "password" };
      await expect(AuthService.RegisterUserService(user)).rejects.toThrow(
        "Email must be from gmail.com domain"
      );
    });
    it("should logout user successfully", async () => {
      const result = await AuthService.logoutUserService(
        "mocked_refresh_token"
      );
      expect(result.success).toBe(true);
      expect(result.message).toBe("Log Out successful");
    });
    // Add more test cases for error scenarios
  });

  describe("LoginUserService", () => {
    it("should login user successfully", async () => {
      const user = { email: "test123@gmail.com", password: "kochobietdau" };
      const result = await AuthService.LoginUserService(user);
      expect(result.accessToken).toBeDefined();
      expect(result.refreshToken).toBeDefined();
    });
    // Add more test cases for error scenarios
  });

  describe("RegisterUserService", () => {
    it("should throw ConflictError if user already exists", async () => {
      const user = { email: "test@gmail.com", password: "password" };
      // Mocking the scenario where user already exists
      UserModel.findOne.mockResolvedValueOnce({
        email: "test@example.com",
      });

      // Expecting RegisterUserService to throw ConflictError
      await expect(AuthService.RegisterUserService(user)).rejects.toThrow(
        "ConflictError Emai is ready been register"
      );
    });
    it("should register user successfully", async () => {
      const user = { email: "123123123@gmail.com", password: "password" };
      //have been register
      UserModel.findOne.mockResolvedValueOnce(null);
      //
      const result = await AuthService.RegisterUserService(user);
      expect(result._id).toBeDefined();

      expect(result.password).toBe("hashed_password"); // Assuming password is hashed in DB
    });
    // Add more test cases for error scenarios
  });

  describe("refreshTokenService", () => {
    it("should refresh token successfully", async () => {
      const result = await AuthService.refreshTokenService(
        "mocked_refresh_token"
      );
      expect(result.accessToken).toBeDefined();
      expect(result.newRefreshToken).toBeDefined();
    });
    // Add more test cases for error scenarios
  });
});
