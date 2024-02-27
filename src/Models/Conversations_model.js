const mongoose_delete = require("mongoose-delete");
const mongoose = require("mongoose");

const MessageSchema = new mongoose.Schema({
  text: String,
});
const conversationsSchema = new mongoose.Schema(
  {
    name: String,
    userInfor: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },

    messages: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Message",
    },
  },
  {
    timestamps: true,
  }
);
const conversations = mongoose.model("Conversation", conversationsSchema);

module.exports = conversations;
