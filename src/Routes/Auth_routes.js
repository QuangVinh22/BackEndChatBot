const express = require("express");
const AuthRouteAPI = express.Router();
const {
  postLoginUser,
  postRegisterUser,
  getListUsers,
  refreshTokenController,
  logoutUser
} = require("../Controller/AuthController");
const { verifyAccessToken } = require("../Service/JwtService");
AuthRouteAPI.post("/login", postLoginUser);
AuthRouteAPI.post("/register", postRegisterUser);
AuthRouteAPI.get("/getlistUsers", verifyAccessToken, getListUsers);
AuthRouteAPI.post("/refreshtoken", refreshTokenController);
AuthRouteAPI.delete("/logout", logoutUser);
module.exports = AuthRouteAPI;
