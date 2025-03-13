const mongoose = require('mongoose');

const cartSchema = new mongoose.Schema({
    name: { type: String, required: true },  // ชื่อสินค้า
    quantity: { type: Number, required: true, min: 1 },  // จำนวน
    price: { type: Number },  // ราคา
    type: { type: String },  // ประเภทสินค้า
    image: { type: String }  // URL รูปภาพ
}, { timestamps: true });

module.exports = mongoose.model('Cart', cartSchema);
