const express = require('express');
const router = express.Router();
const userDetails = require('../models/userdetails');



router.put('/farmerDetails',async (req, res)=>{
    const { address, city, state, country} = req.body;
 
    try{

        if(!address || !city || !state || !country){
            return res.status(400).json({msg: 'fill the required fields'});
        }

        let userdetails = await userdetails.findone({phone: req.body.phone});

        if(userdetails){
            userdetails.address = address;
            userdetails.country = city;
            userdetails.state = state;
            userdetails.city = country;
        }else{
            userdetails = new userdetails({
                address,
                city,
                state,
                country,
                phone: req.body.phone,
            });
        }
        await userdetails.save();
        res.status(200).send({message:'data saved successfully'});
    }catch(error){
        console.error(error);
        res.status(500).send({message:'failed to save'});
    }

  
 });

module.exports =router;