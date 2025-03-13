const express = require('express');
const router = express.Router();
const Favorite = require('../Model/favorite'); // ใช้โมเดล Favorite ของคุณ

// ดึงรายการโปรดทั้งหมด
router.get('/', async (req, res) => {
  try {
    const favoriteItems = await Favorite.find();
    res.status(200).json(favoriteItems);
  } catch (error) {
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลรายการโปรด', error });
  }
});

// เพิ่มสินค้าในรายการโปรด
router.post('/create', async (req, res) => {
    try {
      console.log("⭐ Data Received:", req.body);
  
      const newFavoriteItem = new Favorite({
        name: req.body.name,
        price: req.body.price,
        type: req.body.type,
        image: req.body.image,
        details: req.body.description,
        rating: req.body.rating, // รับค่า rating
        reviews: req.body.reviews, // รับค่า reviews
      });
      await newFavoriteItem.save();
      res.status(201).json(newFavoriteItem);
    } catch (error) {
      res.status(500).json({ message: 'เกิดข้อผิดพลาดในการเพิ่มสินค้าในรายการโปรด', error });
    }
  });

// อัปเดตสินค้าในรายการโปรด
router.put('/:id', async (req, res) => {
    try {
      const updatedFavoriteItem = await Favorite.findByIdAndUpdate(req.params.id, {
        name: req.body.name,
        price: req.body.price,
        type: req.body.type,
        image: req.body.image,
        details: req.body.details,
        rating: req.body.rating, // อัปเดต rating
        reviews: req.body.reviews, // อัปเดต reviews
      }, { new: true });
  
      if (!updatedFavoriteItem) {
        return res.status(404).json({ message: 'ไม่พบสินค้าที่ต้องการอัปเดตในรายการโปรด' });
      }
      res.status(200).json(updatedFavoriteItem);
    } catch (error) {
      res.status(500).json({ message: 'เกิดข้อผิดพลาดในการอัปเดตสินค้าในรายการโปรด', error });
    }
  });

  
// ลบสินค้าออกจากรายการโปรด
router.delete('/:id', async (req, res) => {
  try {
    const deletedFavoriteItem = await Favorite.findByIdAndDelete(req.params.id);
    if (!deletedFavoriteItem) {
      return res.status(404).json({ message: 'ไม่พบสินค้าที่ต้องการลบในรายการโปรด' });
    }
    res.status(200).json({ message: 'ลบสินค้าออกจากรายการโปรดเรียบร้อยแล้ว' });
  } catch (error) {
    res.status(500).json({ message: 'เกิดข้อผิดพลาดในการลบสินค้าออกจากรายการโปรด', error });
  }
});

module.exports = router;