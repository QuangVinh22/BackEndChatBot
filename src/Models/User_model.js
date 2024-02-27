const { string } = require("joi");
const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const mongoose_delete = require("mongoose-delete");

//shape data
const userSchema = new mongoose.Schema(
  {
    username: {
      type: String,
      required: true,
      lowcase: true,
      unique: true,
    },
    password: { type: String, required: true },
  },
  {
    timestamps: true,
  }
);
userSchema.pre("save", async function (next) {
  try {
    const salt = await bcrypt.genSalt(10);
    const hashPassword = await bcrypt.hash(this.password, salt);
    this.password = hashPassword;
  } catch (error) {
    next(error);
  }
});
//tạo 1 method để check password
userSchema.methods.isCheckPassword = async function (password) {
  try {
    return await bcrypt.compare(password, this.password);
  } catch (error) {
    next(error);
  }
};
// Override all methods
userSchema.plugin(mongoose_delete, { overrideMethods: "all" });

const User = mongoose.model("User", userSchema);

module.exports = User;
