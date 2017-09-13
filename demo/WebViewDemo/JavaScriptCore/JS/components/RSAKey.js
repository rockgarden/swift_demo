var RSAKeyConfig = {
		key : ''
};

initKey = function(){
	
	 setMaxDigits(130);  
	 RSAKeyConfig.key = new RSAKeyPair("10001","","8754eb2b4b18b4809999e00533e9c88959f3f5d5bcbc1a31043f08f4c74fdba8c032f3bf33aa3ff294b3228224d86bb48ff3c52223c5626e92636fc52ff31f05e315525c7f3dc145eca99646d373cfe30003432277b340b8c71b4ca9ed86efd41eecb870e828d380397d6a66f8915abc7de29e80762667d93f34e66efe1adc75");     
	 
}

initKey();

/**
 * 返回加密字符串
 * @param value
 * @returns
 */
getEncryptedString = function(value){
	return  encryptedString(RSAKeyConfig.key, encodeURI(encodeURI(String(value))));
}

/**
 * 返回加密对象
 * @param obj
 * @returns
 */
getEncryptedObj = function(obj){
	for(var index in obj){
		obj[index] = encryptedString(RSAKeyConfig.key, encodeURI(encodeURI(String(obj[index]))));
	}
	return obj;
}

/**
 * 返回加密对象拼接字符串
 * @param obj
 * @returns {String}
 */
getEncryptedObjString = function(obj){
	
	var str = '';
	for(var index in obj){
		obj[index] = encryptedString(RSAKeyConfig.key, encodeURI(encodeURI(String(obj[index]))));
		str+=index+"="+ obj[index]+"&";
	}
	if(str.length>0){
		str = str.substring(0, str.length-1);
	}
	
	return str;
	
}


setAllInputEncrypted = function(){
	
	$("input").each(function(){
		
		console.log($(this).attr("name"))
		$(this).val(encryptedString(RSAKeyConfig.key, encodeURI(encodeURI(String($(this).val())))));
		
	})
	
}
