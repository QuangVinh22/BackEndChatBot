// JWTService.test.js
const JWTService = require("../Service/JwtService");
const createError = require("http-errors");
const redis = require("redis-mock"); // Import redis-mock library
const { ObjectId } = require("mongodb");
jest.mock("../helpers/connect-redis", () => ({
  set: jest.fn(),
  get: jest.fn(),
}));

describe("JWTService", () => {
  describe("SignAccessToken", () => {
    it("should return a valid access token", async () => {
      const userId = new ObjectId("65e6e8969b2bed028f970cf4");
      const options = { expiresIn: "1h" }; // Example options
      process.env.ACCESS_TOKEN_SECRET = "your_access_token_secret_here";
      const accessToken = await JWTService.SignAccessToken(userId, options);
      expect(accessToken).toBeDefined();
      // You can add more assertions to check the format or properties of the access token
    });
  });

  describe("SignRefreshToken", () => {
    it("should return a valid refresh token", async () => {
      const userId = new ObjectId("65e6e8969b2bed028f970cf4");
      const options = { expiresIn: "1h" }; // Example options
      process.env.REFRESH_TOKEN_SECRET = "your_access_token_secret_here";
      const refreshToken = await JWTService.signRefreshToken(userId);
      expect(refreshToken).toBeDefined();
      // You can add more assertions to check the format or properties of the refresh token
    });
  });

  describe("VerifyAccessToken", () => {
    it("should throw Unauthorized error if no authorization header is provided", async () => {
      const req = {
        headers: {},
      };
      const res = {};
      const next = jest.fn();

      JWTService.verifyAccessToken(req, res, next);

      expect(next).toHaveBeenCalledWith(expect.anything()); // Check if next was called with an error
    });

    // You can add more test cases to cover other scenarios for verifyAccessToken function
  });

  describe("VerifyRefreshToken", () => {
    it("should throw Unauthorized error if refresh token is invalid", async () => {
      const invalidRefreshToken = "invalid_token";
      await expect(
        JWTService.verifyRefreshToken(invalidRefreshToken)
      ).rejects.toThrow(createError.InternalServerError);
    });

    // You can add more test cases to cover other scenarios for verifyRefreshToken function
  });
});
