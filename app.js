const express = require("express");
const cors = require("cors");

require("dotenv").config();
const createError = require(`http-errors`);
const connection = require("./src/Config/database");
const AuthRoutes = require("./src/Routes/Auth_routes");
const conversationsRoutes = require("./src/Routes/Conversations_routes");
const messageRoutesApi = require("./src/Routes/Message_routes");
//Routes

//Redis
// const client = require("./src/helpers/connect-redis");

//
const app = express();
//Cors;
app.use(cors());
app.use((req, res, next) => {
  res.header("Access-Control-Allow-Origin", "*"); // Cho phép tất cả các nguồn gốc
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept, Authorization"
  );
  if (req.method === "OPTIONS") {
    res.header("Access-Control-Allow-Methods", "PUT, POST, PATCH, DELETE, GET");
    return res.status(200).json({});
  }
  next();
});
//
app.use(express.json()); // Used to parse JSON bodies
app.use(express.urlencoded({ extended: true })); //Parse URL-encoded bodies
//Routes
app.use("/v1/Auth", AuthRoutes);
app.use("/v1/Conversations", conversationsRoutes);
app.use("/v1/Messages", messageRoutesApi);

//
app.get("/", (req, res) => {
  res.send("hell world");
});

const port = process.env.PORT || 8888;
const hostname = process.env.HOST_NAME;

//handle error
app.use((req, res, next) => {
  const error = new Error("Not Found");
  error.status = 404;
  next(error);
});

app.use((err, req, res, next) => {
  res.status(err.status || 500).json({
    EC: err.status || 500,
    message: err.message || "Internal Server Error",
  });
});
connection()
  .then(() => {
    app.listen(port, hostname, () => {
      console.log(`Example app listening at http://${hostname}:${port}`);
    });
  })
  .catch((error) => {
    console.error("Failed to connect to DB", error);
  });
module.exports = app;
