const express = require('express');
const router = express.Router();
const Skincare = require('../Model/skincare'); // ใช้ชื่อโมเดลที่ถูกต้อง

// 📌 สร้างสินค้าใหม่
router.post('/create', async (req, res) => {
    console.log(req.body); // Debugging input

    try {
        const newSkincare = new Skincare(req.body);
        const savedSkincare = await newSkincare.save();
        res.status(201).json(savedSkincare);
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Internal Server Error" });
    }
});

// 📌 ดึงสินค้าทั้งหมด
router.get('/', async (req, res) => {
    try {
        console.log("📡 Fetching skincares...");
        const skincares = await Skincare.find({});
        console.log("✅ Skincares Fetched:", skincares.length);
        res.json(skincares);
    } catch (err) {
        console.error("❌ Error fetching skincares:", err);
        res.status(500).json({ message: "Internal Server Error" });
    }
});

// 📌 ดึงสินค้าตาม ID (แก้ไขให้ถูกต้อง)
router.get('/:id', async (req, res) => {
    try {
        const skincareId = req.params.id;
        console.log(`📡 Fetching skincare with ID: ${skincareId}`);

        const skincare = await Skincare.findById(skincareId);
        if (!skincare) {
            console.log(`❌ Skincare with ID: ${skincareId} not found`);
            return res.status(404).json({ message: 'Skincare not found' });
        }

        console.log(`✅ Skincare with ID: ${skincareId} fetched successfully`);
        res.json(skincare);
    } catch (err) {
        console.error("❌ Error fetching skincare:", err);
        res.status(500).json({ message: "Internal Server Error" });
    }
});

module.exports = router;
