const mongoose = require('mongoose');

const orderSchema = new mongoose.Schema({
  items: [
    {
      productId: { type: mongoose.Schema.Types.ObjectId, ref: 'Product' },
      name: String,
      quantity: Number,
      price: Number,
      image: String,
    },
  ],
  customer: { type: mongoose.Schema.Types.ObjectId, ref: 'Customer' },
  address: {
    fullName: String,
    street: String,
    district: String,
    city: String,
    province: String,
    postalCode: String,
    phoneNumber: String,
  },
  shippingMethod: String,
  paymentMethod: String,
  discountCode: String,
  total: Number,
  status: { type: String, default: 'Pending' },
  orderDate: { type: Date, default: Date.now },
  shippingDate: Date,
  trackingNumber: String,
  notes: String,
});

const Order = mongoose.model('Order', orderSchema);

module.exports = Order;