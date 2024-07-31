//const http = require('http');
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const authRoutes = require('./routes/authDetails');
const weatherRoutes = require('./routes/weather'); 
const report = require('./routes/recentsReport');


const app = express();
const port = 3000;

//for check the configure

app.use(cors());

//middleware to parse json

app.use(express.json());

//mongodb connection string

//const mongoURI = 'mongodb+srv://DevRk_007:KtSDHNvQp6N6VgAI@devrk.c7iknfg.mongodb.net/?retryWrites=true&w=majority&appName=DevRk';
const mongoURI = 'mongodb://0.0.0.0:27017/DevRk'

//connect to mongodb 

mongoose.connect(mongoURI,
    {useNewUrlParser: true, useUnifiedTopology: true}
)
.then(()=> console.log('mongodb connected.....'))
.catch(err => {
    console.log('mongodb connection error:',err);
    process.exit(1);
});


app.get('/',(req, res)=>{
    res.send('<h1>server is running using express</h1>');
});

//use route

app.use('/api/users', authRoutes);//username and phone
//app.use('/api/reports', report);//reports (vote type)

app.use('/api/weather', weatherRoutes);//weather


// app.use('/api/userDetails', userRoutes);

//define the simple route

// app.get('/',(req, res)=>{
//     res.send('this is worked');
// });


//route files here

// const userRoute = require('./routes/users');
// const reportRoute = require('./routes/recentsReport');
// const { default: mongoose } = require('mongoose');




//const port = process.env.PORt || 3000;


app.listen(port,()=>{
    console.log(`server is running this port ${port}`);
});