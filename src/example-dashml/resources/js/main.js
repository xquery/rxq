(function(){
var to;

   
	function pieceHeights(){
		to = setTimeout(function(){
			$(".pure-g-r").each(function(i,el){
				var contentPieces = $(el).find(".dashboard-piece");
				var max = 0;
				contentPieces.css("min-height","");
				$.grep(contentPieces, function(el,i){
					max = Math.max($(el).outerHeight(),max);
				});
				contentPieces.css("min-height", max);
			});
		}, 400);
	}

	$(window).on("resize", function(){
		clearTimeout(to);
		pieceHeights();
	}).trigger("resize");

    if(getParameterByName("live") == "true"){
        $('#makelive').prop('checked', true);
           setTimeout(function(){
               window.location.href= window.location.href.replace(/\?.*/,'') + '?live=true'
           }, 30000);
     }

    $('#makelive').change(function(){
       if (this.checked){
           setTimeout(function(){
               window.location.href= window.location.href.replace(/\?.*/,'') + '?live=true'
           }, 30000);
       }else{
               window.location.href=window.location.href.replace(/\?.*/,'')
       }
    });

    $('#period').change(function(){
        window.location.href=window.location.href.replace(/\?.*/,'') + '?period=' + $('#period').val()
    });

}());


function getParameterByName(name) {
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
    return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
}
