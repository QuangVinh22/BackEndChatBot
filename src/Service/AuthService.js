const User = require("../Models/User_model");
const createError = require("http-errors");
const { userValidate } = require("../helpers/validation");
const client = require("../helpers/connect-redis");

const {
  SignAccessToken,
  verifyRefreshToken,
  signRefreshToken,
} = require("../Service/JwtService");
module.exports = {
  logoutUserService: async (refreshToken) => {
    if (!refreshToken) {
      throw createError.BadRequest("Refresh Token is required");
    }
    const payload = await verifyRefreshToken(refreshToken);

    const userId = payload.userId;
    client.del(userId.toString(), (err, reply) => {
      if (err) {
        throw createError.InternalServerError("Ko tồn tại");
      }
    });
    return { success: true, message: "Log Out successful" };
  },
  LoginUserService: async (user) => {
    const { error } = userValidate(user);
    if (error) {
      throw createError.BadRequest("Email must be from gmail.com domain");
    }
    const isExist = await User.findOne({ username: user.email });
    if (!isExist) {
      throw createError.NotFound("User have not register ");
    }
    const isValid = await isExist.isCheckPassword(user.password);
    if (!isValid) {
      throw createError.Unauthorized();
    }
    const accessToken = await SignAccessToken(isExist._id);

    const refreshToken = await signRefreshToken(isExist._id);
    // return { accessToken, refreshToken };

    return { accessToken, refreshToken };
  },
  RegisterUserService: async (user) => {
    const { error } = userValidate(user);
    if (error) {
      throw createError.BadRequest("Email must be from gmail.com domain");
    }
    const isExist = await User.findOne({
      email: user.email,
    });
    if (isExist) {
      throw createError.Conflict(`ConflictError Emai is ready been register`);
    }
    const isCreate = await User.create({
      username: user.email,
      password: user.password,
    });
    return isCreate;
  },
  refreshTokenService: async (refreshToken) => {
    const payload = await verifyRefreshToken(refreshToken); // Giả sử nó resolve với payload chứa userId
    const userId = payload.userId;

    const accessToken = await SignAccessToken(userId);
    const newRefreshToken = await signRefreshToken(userId); // Tùy chọn: cấp lại refresh token mới
    return { accessToken, newRefreshToken };
  },
  getListUsersService: async (Token, abc) => {
    console.log(Token);
    const listuser = User.find({});
    return listuser;
  },
};
