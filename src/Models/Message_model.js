const mongoose_delete = require("mongoose-delete");
const mongoose = require("mongoose");

const massageSchema = new mongoose.Schema(
  {
    text: {
      type: String,
      required: true,
    },
    sender: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
    },
  },
  {
    timestamps: true,
  }
);
const Message = mongoose.model("Message", massageSchema);

module.exports = Message;
