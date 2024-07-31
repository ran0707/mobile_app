const mongoose = require('mongoose');
const Schema = mongoose.Schema;


const UserSchema = new Schema({
    phone:{
        type:Number,
        required:true,
        unique: true,
    },
    name:{
        type:String,
        required: true,
    },
    streetCity:{
        type:String,

    },
    adminLocality:{
        type:String
    },
    country:{
        type:String
    },
    postalCode:{
        type:String
    },
    createdAt:{
        type:Date,
        default:Date.now,
    }
});



module.exports = mongoose.model('user', UserSchema);