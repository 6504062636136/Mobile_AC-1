const mongoose = require('mongoose');

const favoriteSchema = new mongoose.Schema({
  name: { type: String, required: true },
  price: { type: Number },
  type: { type: String },
  image: { type: String },
  details: { type: String },
  rating: { type: Number },
  reviews: { type: Number }, 
}, { timestamps: true });

module.exports = mongoose.model('Favorite', favoriteSchema);