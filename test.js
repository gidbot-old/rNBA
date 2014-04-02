var fs = require('fs'); 

var set = {};
var set2 = {};
var searchesPending = 1; 
 
var max = 0; 
var string = "";

var findLongest = function(set){
  for (key in set){
  	var word = key;
  	if (key.length >2){
  		for (var i = 2; i < key.length; i++){
  			for (var j = 0; j < key.length -i+1; j++){
  				var substring = key.substring(j, j+i)
  				if(substring in set && substring != key){
  					set[key]["substrings"].push(substring);
  				}
  			}
  		}
  	}
  
  	if (set[key]["substrings"].length != 0){
      console.log(set[key]["substrings"].length);
  		for (var i = 0; i < set[key]["substrings"].length; i++){
  			//var string = set[key]["substrings"][i];
        //console.log(string);
  		}
  	}
  }
}

var test = function(){
	findLongest(set);
	console.log(max);
	
}
var array = fs.readFileSync('./words.txt').toString().split("\n");
var leftToPop = -1;
var populate = function (callback) {
  leftToPop = array.length;
	for (var i =0; i < array.length; i++){
		var toString = array[i].substring(0, array[i].length - 1);
		if (i < array.length){
			var array = toString.split('');
			set[toString] = {"copy": set[toString], "substrings":[], "letters":array}; 
		} else {
			set2[toString] = {}; 
		}
		leftToPop--; 
    console.log("TEST")
		if (leftToPop == 0){
			callback(); 
      console.log("here");
		}
	}
}
populate(test); 