const Vote = require('../models/reports');


const addOrUpdateVote = async (req, res) =>{

    const {pestName, votes} = req.body;
    const today = new Date();
    today.setHours(0,0,0,0);


    try{

        if(!pestName || !votes){
            return res.status(400).json({message: 'pest naem and vote are required'});
        }

        let Vote = await Vote.findOneAndUpdate(
            {pestName:pestName, date:today},
            {$inc:{totalvotes: votes}},
            {upsert: true, new: true}
        );
        // if(voteEntry){
        //     voteEntry.votes += votes;
        // }else{
        //     voteEntry = new Vote({pestName, votes, date:today});
        // }
        // await voteEntry.save();

        if(!Vote){
            return res.status(500).json({message:'failed to save'});
        }

        res.status(200).json({message:'vote report recorded'});

    }catch(e){
        res.status(500).json({message:'Error to record'});
    }
};


module.exports = {addOrUpdateVote};