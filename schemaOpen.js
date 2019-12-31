function openApp(){
	
	// var iOSUrl = "projectcomApp://";

	var iOSUrl = "projectcomApp://?product_id=10302";

	var u = navigator.userAgent;
	var isIOS = !!u.match(/\i[^;]+;(U;)? CPU.+Mac OS X/);

	//判断是否是iOS
	if(isIOS){

		window.location.href = iOSUrl;

		var loadDataTime = Date.now();
		setTimeOut(function()){
			var timeOutDateTime = Date.now();
			if(timeOutDateTime - loadDataTime < 1000){
				window.location.href = "https://www.app.com/download.html";//下载App落地页
			}
		}, 25);

	}
}