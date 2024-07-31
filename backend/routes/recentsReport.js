const express = require('express');
const router = express.Router();
//const Report = require('../models/reports');
const {addOrUpdateVote} = require('../controllers/reportControl');

// //new entry
// router.post('/todayReport',async (req, res)=>{
//     const {votes, isIncrease} = req.body;
//     console.log('request body ', req.body);

//     try{
//         const newReport = new Report({
//             votes,
//             isIncrease,
//         });
//         const savedReport = await newReport.save();
//         res.status(201).json(savedReport);
//     }
//     catch(e){
//         console.log('error to save', e);
//         res.status(500).json({message:'error to save', e});
//     }
// });
// //fetch all entry
// router .get('/allReport',async (req, res)=>{
//     try{
//         const reports = await Report.find();
//         res.status(200).json(reports);
//     }catch(e){
//         console.log('error to fetch', e);
//         res.status(500).json({message:'error fetching', e});
//     }
// });

router.post('/report', addOrUpdateVote);



module.exports = router;