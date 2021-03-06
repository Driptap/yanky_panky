function getTrack(){
	$('marquee > h2').text("loading track.. " );
	$.ajax({
	  url: newTrackUrl
	}).done(function(url) {
	  $('audio > source').attr("src", url);
	  $('audio').load();
	  $('marquee > h2').text("identifying.. ");
	  identifyTrack(url);
	});
}
function identifyTrack(url) {
	ID3.loadTags(url, function() {
		var tags = ID3.getAllTags(url);
		$('marquee > h2').text("Now playing: " + tags.artist + " - " + tags.title );
		(function titleScroller(text) {
		    document.title = text;
		    setTimeout(function () {
		        titleScroller(text.substr(1) + text.substr(0, 1));
			}, 300);
		}("Now playing: " + tags.artist + " - " + tags.title + " -- Yanky Panky - The Dropbox MP3 Player "));	
		storeTrackInfo(tags);
	});
}
function storeTrackInfo(tags) {
	$.post(storeTrackInfoUrl, { track_title: tags.title, track_album: tags.album, track_artist: tags.artist}, 
    function(returnedData){
         console.log(returnedData);
	});
}
$(document).ready(function(){
	getTrack();
	$("#cord").click(function(){
		$(this).toggleClass('yanked');
		getTrack();
    });
});