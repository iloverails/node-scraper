// The Car model

var mongoose = require('mongoose')
  , Schema = mongoose.Schema
  , ObjectId = Schema.ObjectId;

var alphabetoccasionSchema = new Schema({
  img:{ type:String  },
  model:{ type:String  },
  make:{ type:String  },
  price:{ type:String },
  mileage:{ type:String  },
  fuel:{ type:String  },
  year:{ type:String  },
  source:{ type:String  },
  url : { type:String  }
});

module.exports = mongoose.model('Alphabetoccasion', alphabetoccasionSchema);