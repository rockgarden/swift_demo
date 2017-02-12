/*@funciton:基于jquery/zepto的控件（下拉框，多选框,输入框）事件定义;
  @author:jim;
  @date:2016-11-30
*/
(function(){
	var select ={};
	//*************************下拉单选框*********************/
	select.click = function(selector, beforeDo, afterDo){
		var selector = selector || '.select';
		$(selector).on('click',function( e ){
			if(typeof beforeDo == "function"){
				beforeDo.call($(this));
			}
			$(this).toggleClass('sopen');
			if(typeof afterDo == "function"){
				afterDo.call($(this));
			}
			e.stopPropagation();
		});
	}
	//func为单击后执行的函数
	select.itemClick = function(selector, afterDo){
		var selector = selector || '.select';
		$(selector + ' > ul li').on('click',function(e){
			var v_this = $(this);
			var v_ul =v_this.parent().parent();
			v_this.addClass('selected').siblings().removeClass('selected');
			v_ul.attr('data-value',v_this.attr('data-value'));
			//关联异常小类
			//addIntoSmall(v_this.attr('data-value'));
			var time = window.setTimeout(function(){
				v_ul.removeClass('sopen');
				if(typeof afterDo == "function"){
					afterDo.call(v_this,selector);
				}
				clearTimeout(time);
			},50);
			e.stopPropagation();
		});
	}
	select.value = function(selector){
		var selector = selector || '.select';
		var result = {};
		var selects = $(selector);
		for(var i=0; i<selects.length; i++){
			var key =$(selects[i]).attr('id');
			var v =$(selects[i]).attr('data-value') || '';
			result[key] = v;
		}
		return result;
	}
	select.insertItems = function(selector, data, appendAdd,afterDo){
		var selector = selector || '.select';
		if(!appendAdd){
			$(selector +" ul").children(('li')).remove();
		}
		for(var i in data){
			var v_li = $('<li></li>');
			v_li.attr('data-value',data[i]);
			v_li.text(data[i]);
			$(selector+" ul").append(v_li);
		}
		//为li注册事件
		select.itemClick(selector,afterDo);
	}
	
	//************************下拉框*********************//
	var dropdown ={};
	dropdown.click = function(selector, beforeDo, afterDo){
		var selector = selector;
		$(selector).on('click',function(e){
			if(typeof beforeDo == "function"){
				if(!beforeDo.call($(this))){
					return;
				}
				
			}
			$(this).toggleClass('cbopen');
			if(typeof beforeDo == "function"){
				afterDo.call($(this));
			}
//			var k = checkbox.value();
			e.stopPropagation();
		});
	}
	
	//**************************复选框**********************//
	var checkbox ={};
	checkbox.value = function(selector){
		var selector = selector || '.checkbox';
		var result = {};
		var selects = $(selector);
		for(var i=0; i<selects.length; i++){
			var v;
			var key = $(selects[i]).attr('id');
			var str = $(selects[i]).attr('data-value');
			
			if(key == "PERSON"){//特例：代维人员
				result["name"] = [];
				result["telephone"] = [];
				var reg = /[:|]/;
				var arr = [];
				
				if(str != null && str != ''){
					arr = str.split(reg);
				}
				
				for(var i =0;i<arr.length;i++){
					if(i%2==0){
						result["name"].push(arr[i]);
					}else{
						result["telephone"].push(arr[i]);
					}
				}
			}
			else{
				if(str == "" || str == null){
					v = [];
				}
				else{
					v = str.split('|');
				}
				result[key] = v;
			}
		}
		return result;
	}
	
	checkbox.insertItems = function(selector, data, appendAdd,afterDo,afterDo2){
		var selector = selector || '.checkbox';
		var v_ul = $(selector);
		if(!appendAdd){
			v_ul.empty();//或者v_ul.children(('li')).remove();
		}
		
		for(var ele in data){
			var v_li = $('<li>');
			v_li.text(ele);
			v_li.attr('data-value',data[ele]);
			v_ul.append(v_li);
		}
		//为复选框添加事件
		$('li',v_ul).on('click',function(e){
			var v_this = $(this);
			var value ="";
			v_this.toggleClass('selected');
			
			if(typeof afterDo == "function"){
				afterDo.call($(this));
			}
			if(typeof afterDo2 == "function"){
				afterDo2.call($(this),$(this));
			}
			for(var i =0 ;i< v_ul.children('li').length;i++){
				if($(v_ul.children('li')[i]).hasClass('selected')){
					value +=($(v_ul.children()[i]).attr('data-value'))+"|";
				}
			}
			
			value = value.substring(0,value.length - 1) ;
			$(selector).attr('data-value',value);

			e.stopPropagation();
		});
	}
	
	//***********************输入框********************************//
	var input = {};
	input.value = function(selector){
		var selector = selector || 'input';
		var result = {};
		var inputs = $(selector);
		for(var i=0; i<inputs.length; i++){
			var key =$(inputs[i]).attr('id');
			var v =$(inputs[i]).val();
			result[key] = v;
		}
		return result;
	}
	//多行文本框
	var textarea={};
	textarea.value = function(selector){
		var selector = selector || 'textarea';
		var result = {};
		var inputs = $(selector);
		for(var i=0; i<inputs.length; i++){
			var key =$(inputs[i]).attr('id');
			var v =$(inputs[i]).val();
			result[key] = v;
		}
		return result;
	}
	//******************自定义输入框****************
	var inputlabel = {};
	inputlabel.value = function(selector,value){
		var selector = selector || '.inputlabel';
		var result = {};
		var inputs = $(selector);
		
		for(var i=0; i<inputs.length; i++){
			var key =$(inputs[i]).attr('id');
			if(!value){
				var v =$(inputs[i]).text();
				result[key] = v;
			}else{
				$(inputs[i]).text(value);
			}
		}
		return result;
	}
	
	window.select = select;
	window.dropdown = dropdown;
	window.checkbox = checkbox;
	window.input = input;
	window.textarea = textarea;
	window.inputlabel = inputlabel;
	
	/// window.b=function(){ // 代码 } 全局函数 设置信息
	window.setInfo = function(data){
	
		eval("data =" + data);
		for(var key in data){
			var v_control = $('#'+key);
			if(v_control.hasClass('checkbox') && v_control[0].tagName =='UL'){
				checkbox.insertItems('#'+key,data[key]["VALUE"],false);
			}
			else if(v_control.hasClass('inputlabel') && v_control[0].tagName =='P'){
				inputlabel.value('#'+key,data[key]);
			}
			else if(v_control.hasClass('select') && v_control[0].tagName =='DIV'){
				if(!data[key]["data"]){
					select.insertItems('#'+key,data[key]["VALUE"],false,toggleMark);
				}else{
					var largedata = [];
					var arrdata={};
					var largeKey ="";
					var bind = data[key]["CHILDAT"];
					
					data[key]["data"].sort(up);   //按异常小类长度递增排序
					for(var i in data[key]["data"]){
						var largetemp = data[key]["data"][i][key]
//						if(largeKey != largetemp){
//							largeKey = largetemp;
//							arrdata[largeKey] = {};
//						}
						if(arrdata[largetemp] == undefined){
							arrdata[largetemp] = {};
						}
						var v= data[key]["data"][i][bind];
						arrdata[largetemp][v] = v;
						
					}
					for(var index in arrdata){
						largedata.push(index);
					}
					select.insertItems('#'+key,largedata,false,function(selector){
						var select_value = select.value(selector);
						var key = selector.substr(1,selector.length-1);
						
						var d = arrdata[select_value[key]];
						if(data[key]["CHILDSTYLE"] == "CHECKBOX"){
							checkbox.insertItems("#"+bind,d,false);
						}
						v_mark[0].style.display = '';
					});
				}
			}
		}
	}
	//获取信息
	window.getInfo = function(){
		var result = {};
		var v_form = $('.form');
		var selectorArr = ['.select','.checkbox','input[type="text"]','textarea','.inputlabel'];
		
		for(var i = 0; i <selectorArr.length; i++){
			var v;
			var control = $(selectorArr[i],v_form);
			if(control.length>0){
				if(i == 0 ){
					v = select.value();
				}
				else if(i == 1 ){
					v = checkbox.value();
				}
				else if(i == 2){
					v = input.value();
				}
				else if(i == 3){
					v = textarea.value();
				}
				else if(i == 4){
					v = inputlabel.value();
				}
				for(var index in v){
					result[index] = v[index];
				}
			}
		}
		console.log(result);
		//return result;
		myJs.getContent(JSON.stringify(result));
	}
	
	
	var toggleMark = function(){
		v_mark = $('#mark');
		if(!v_mark[0].style.display){
			//v_mark.slideDown();
			v_mark[0].style.display = 'block';
		}
		else{
			v_mark[0].style.display = '';
		}
	}
	function up(x,y){
		var xstr =x["EXCEPTION_SMALL_CLASS"].replace(/[^\u0000-\u00FF]/g,'').length;//单字节数目
		var ystr =y["EXCEPTION_SMALL_CLASS"].replace(/[^\u0000-\u00FF]/g,'').length;
		return (x["EXCEPTION_SMALL_CLASS"].length-xstr/2)-(y["EXCEPTION_SMALL_CLASS"].length-ystr/2);
	}
	
})();
