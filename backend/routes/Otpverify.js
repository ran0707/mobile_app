// const express = require('express');
// const router = express.Router();
// const app = express();


// const port = 3001;


// router.post('/verify-otp', (req, res)=>{
//     const {otp} = req.body;

//     if(!otp){
//         return res.status(400).json({msg:'Otp is required'});
//     }

//     if(otp == sampleOtp){
//         return res.status(200).json({msg: 'otp verified'});
//     }else{
//         return res.status(400).json({msg: 'invalid otp'});
//     }
    
// });


// app.use(express.json());
// app.use(router);



// app.listen(port,()=>{
//     console.log(`server is running this port ${port}`);
// });