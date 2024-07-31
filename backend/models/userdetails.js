const mongoose = require('mongoose');
const Schema = mongoose.Schema;


const UserSchema = new Schema({
    address:{
        type: String,
    },

    country:{
        type:String
    },
    state:{
        type:String
    },
    city:{
        type:String
    },
    
    
})



module.exports = mongoose.model('userDetails', UserSchema);