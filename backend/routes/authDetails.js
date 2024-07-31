const express = require('express');
const router = express.Router();
const user = require('../models/authdetails'); //model/user
//const userDetails = require('../models/userdetails'); //model/userdetails

var sampleOtp = '220022';



router.post('/phone',(req, res)=>{
   const {phone, name, streetCity, adminLocality, country, postalCode, } = req.body;

   if(!phone || !name){
    return res.status(400).json({msg: ' please enter name and phone no'});
   }
   const newUser = new user({
    phone,
    name,
    streetCity,
    adminLocality,
    country,
    postalCode
   });

   newUser.save()
    .then(user => res.json(user))
    .catch(err => res.status(500).json({error: err.message}));
});


router.post('/verify-otp', (req, res)=>{
    const {otp} = req.body;

    if(!otp){
        return res.status(400).json({msg:'Otp is required'});
    }

    if(otp == sampleOtp){
        return res.status(200).json({msg: 'otp verified'});
    }else{
        return res.status(400).json({msg: 'invalid otp'});
    }
    
});

// router.put('/userAddr', (req, res)=>{
// const {address, city, state, country} = req.body;

// if(!address || !city || !state || !country){
//     return res.status(400).json({msg:'fill required fields'});
// }

// user.findOneAndUpdate(
//     {phone},
//     {
//         $set:{
//             address,
//             city,
//             state,
//             country,
//         },
//     },
//     {new: true, runValidators: true}
// )
// .then(updatedUser =>{
//     if(!updatedUser){
//         return res.status(404).json({msg: 'User not found'});
//     }
//     res.json(updatedUser);
// })
// .catch(err => res.status(500).json({error: err.message}));


// });



module.exports = router;