const createError = require("http-errors");
const {
  LoginUserService,
  RegisterUserService,
  getListUsersService,
  refreshTokenService,
  logoutUserService,
} = require("../Service/AuthService");
module.exports = {
  postLoginUser: async (req, res, next) => {
    try {
      let user = await LoginUserService(req.body);
      return res.status(200).json({
        EC: 0,
        data: user,
      });
    } catch (error) {
      next(error);
    }
    // res.send("ok");
  },

  postRegisterUser: async (req, res, next) => {
    try {
      let registerUser = await RegisterUserService(req.body);

      return res.status(200).json({
        EC: 0,
        data: registerUser,
      });
    } catch (error) {
      next(error);
    }
  },
  getListUsers: async (req, res, next) => {
    try {
      const authToken = req.headers.authorization;
      let listUser = await getListUsersService({
        token: authToken,
        ...req.body,
      });

      return res.status(200).json({
        EC: 0,
        data: listUser,
      });
    } catch (error) {
      // Lỗi từ service sẽ được bắt ở đây và chuyển đến middleware xử lý lỗi tiếp theo
      next(error);
    }
  },
  refreshTokenController: async (req, res, next) => {
    try {
      const { refreshToken } = req.body;

      if (!refreshToken)
        throw createError.BadRequest("Refresh token is required");

      const tokens = await refreshTokenService(refreshToken);
      res.json(tokens);
    } catch (error) {
      // Lỗi từ service sẽ được bắt ở đây và chuyển đến middleware xử lý lỗi tiếp theo
      next(error);
    }
  },
  logoutUser: async (req, res, next) => {
    try {
      const { refreshToken } = req.body;

      if (!refreshToken)
        throw createError.BadRequest("Refresh token is required");

      const tokens = await logoutUserService(refreshToken);
      res.json(tokens);
    } catch (error) {
      // Lỗi từ service sẽ được bắt ở đây và chuyển đến middleware xử lý lỗi tiếp theo
      next(error);
    }
  },
};
