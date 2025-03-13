const express = require('express');
const router = express.Router();
const Product = require('../Model/product');  // ตรวจสอบให้แน่ใจว่าไฟล์นี้มีอยู่จริง

// ดึงสินค้าทั้งหมด
router.get('/', async (req, res) => {
  try {
    console.log(" Fetching products...");
    const products = await Product.find({});
    console.log(" Products Fetched:", products.length);
    res.json(products);
  } catch (err) {
    console.error(" Error fetching products:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

// เพิ่ม route สำหรับดึงสินค้าตาม ID
router.get('/:id', async (req, res) => {
  try {
    const productId = req.params.id;
    console.log(` Fetching product with ID: ${productId}`);

    const product = await Product.findById(productId); // ใช้ findById แทน findOne
    if (!product) {
      console.log(` Product with ID: ${productId} not found`);
      return res.status(404).json({ message: 'Product not found' });
    }

    console.log(` Product with ID: ${productId} fetched successfully`);
    res.json(product);
  } catch (err) {
    console.error(" Error fetching product:", err);
    res.status(500).json({ message: "Internal Server Error" });
  }
});

module.exports = router;