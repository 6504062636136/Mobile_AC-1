const express = require('express')


const morgan = require('morgan')
const cors = require('cors')
const bodyParser = require('body-parser')

//const connectDB = require('./Config/db')
const mongoose = require('mongoose')

const{readdirSync, read} = require('fs')

const productRouters = require('./Routes/product')
const authRouters = require('./Routes/auth')
const skincareRouters = require('./Routes/skincare')
const bestsellerRouters = require('./Routes/bestseller')
const tipsRouters = require('./Routes/tips')
const cartRouters = require('./Routes/cart') 
const favoriteRouters = require('./Routes/favorite') 

//const userRouters = require('./Routes/user')
//const orderRouters = require('./Routes/order')

const app = express();


app.use(morgan('dev'))
app.use(cors())
app.use(bodyParser.json({ limit: '10mb'}))

//route1
//app.get('/product', (req, res) => {
//    res.send('Hello Cin ii')})


//route2
app.use('/api/product', productRouters)
app.use('/api', authRouters)
app.use('/api/skincare', skincareRouters)
app.use('/api/bestseller', bestsellerRouters)
app.use('/api/tips', tipsRouters)
app.use('/api/cart', cartRouters)
app.use('/api/product', (req, res, next) => { // ตรวจสอบว่า route ถูกต้อง
  console.log(" Route /api/product is being accessed!");
  next();
}, productRouters);
app.use('/api', authRouters);
app.use('/api/skincare', skincareRouters);
app.use('/api/favorite', favoriteRouters);

console.log(" All routes loaded successfully");



//route3
//readdirSync('./Routes').map((r) => app.use ('/api', require(`./Routes/${r}`)))
mongoose.connect('mongodb+srv://s6504062636136:EFxLw1B7PJZnm6tv@cluster0.cu6l1.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0')
  .then(() => console.log('MongoDB Connected'))
  .catch(err => console.log(err));
app.listen(5002, () => console.log('server is  listening on port 5002'))