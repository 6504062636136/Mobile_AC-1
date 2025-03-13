//แก้ไข

const express = require('express');
const router = express.Router();
const Cart = require('../Model/cart'); 


router.get('/', async (req, res) => {
    try {
        const cartItems = await Cart.find(); 
        res.status(200).json(cartItems);
    } catch (error) {
        res.status(500).json({ message: 'เกิดข้อผิดพลาดในการดึงข้อมูลตะกร้า', error });
    }
});


router.post('/create', async (req, res) => {
    try {
        console.log("🛒 Data Received:", req.body);  // ✅ Debugging

        // สร้างสินค้าใหม่ในตะกร้า
        const newCartItem = new Cart({
            name: req.body.name,  // ชื่อสินค้า
            quantity: req.body.quantity,  // จำนวนสินค้า
            price: req.body.price,  // ราคา
            type: req.body.type,  // ประเภท
            image: req.body.image  // URL รูปภาพ
        });
        await newCartItem.save();
        res.status(201).json(newCartItem);
    } catch (error) {
        res.status(500).json({ message: 'เกิดข้อผิดพลาดในการเพิ่มสินค้าในตะกร้า', error });
    }
});

router.put('/:id', async (req, res) => {
    try {
        console.log(req.body,"body")

        const updatedCartItem = await Cart.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedCartItem) {
            return res.status(404).json({ message: 'ไม่พบสินค้าที่ต้องการอัปเดต' });
        }
        res.status(200).json(updatedCartItem);
    } catch (error) {
        res.status(500).json({ message: 'เกิดข้อผิดพลาดในการอัปเดตสินค้าในตะกร้า', error });
    }
});


router.delete('/:id', async (req, res) => {
    try {
        const deletedCartItem = await Cart.findByIdAndDelete(req.params.id);
        if (!deletedCartItem) {
            return res.status(404).json({ message: 'ไม่พบสินค้าที่ต้องการลบ' });
        }
        res.status(200).json({ message: 'ลบสินค้าออกจากตะกร้าเรียบร้อยแล้ว' });
    } catch (error) {
        res.status(500).json({ message: 'เกิดข้อผิดพลาดในการลบสินค้าออกจากตะกร้า', error });
    }
});



module.exports = router;
