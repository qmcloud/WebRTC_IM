var audioSelect = window.localStorage.getItem("audio");
if(audioSelect=="" || audioSelect==null){
	audioSelect= $("#audioSource").val();
}
var videoSelect = window.localStorage.getItem("video");
var client, localStream, camera, microphone;
var myflag=0;
var youflag=0;
function join(conobj) {
  	  //document.getElementById("join").disabled = true;
  	  //document.getElementById("video").disabled = true;
	  var auth_key =window.localStorage.getItem("key");
	  var channel=window.localStorage.getItem("channel");
  	  if(auth_key=="" || auth_key==null){ alert("如若没有密钥，请联系Q群274904994群主");return false;}
  	  if(channel=="" || channel==null){channel=window.localStorage.getItem("channel")}
  	  if(audioSelect=="" || audioSelect==null){ alert("请先在设置中至少选择一个音频");return false;}
  	  if(videoSelect=="" || videoSelect==null){ videoSelect= $("#videoSource").val()}
  	  if(auth_key && audioSelect){
  	  var channel_key = null;
  	  console.log("Init AgoraRTC client with vendor key: " + auth_key);
  	  client = AgoraRTC.createClient({mode: 'interop'});
  	  client.init(auth_key, function () {
  	    console.log("AgoraRTC client initialized");
  	    client.join(channel_key, channel, null, function(uid) {
  	      console.log("User " + uid + " join channel successfully");
  	        camera = videoSelect;
  	        microphone = audioSelect;
  	        if(conobj=="video"){
				localStream = AgoraRTC.createStream({streamID: uid, audio: true, cameraId: camera, microphoneId: microphone, video: videoSelect, screen: false});
  	        }else if(conobj=="audio"){
				localStream = AgoraRTC.createStream({streamID: uid, audio: true, cameraId: false, microphoneId: microphone, video: false, screen: false});
			}else if(conobj=="screen"){
				 localStream = AgoraRTC.createStream({streamID: uid, audio: true, cameraId: camera, microphoneId: microphone, video: false, screen: true, extensionId: 'minllpmhdgpndnkomcoccfekfegnlikg'});
			}
			
  	        //localStream = AgoraRTC.createStream({streamID: uid, audio: false, cameraId: camera, microphoneId: microphone, video: false, screen: true, extensionId: 'minllpmhdgpndnkomcoccfekfegnlikg'});
  	        localStream.setVideoProfile('480p_3');
  	        // The user has granted access to the camera and mic.
  	        localStream.on("accessAllowed", function() {
  	          console.log("accessAllowed");
  	        });

  	        // The user has denied access to the camera and mic.
  	        localStream.on("accessDenied", function() {
  	          console.log("accessDenied");
  	        });
			
  	        localStream.init(function() {
  	          console.log("getUserMedia successfully");
  	          if(myflag==0){
  	        	localStream.play('myvideo');
  	        	myflag+=1;
  	          }
  	          client.publish(localStream, function (err) {
  	            console.log("Publish local stream error: " + err);
  	          });

  	          client.on('stream-published', function (evt) {
  	            console.log("Publish local stream successfully");
  	          });
  	        }, function (err) {
  	          console.log("getUserMedia failed", err);
  	        });
  	      
  	    }, function(err) {
  	      console.log("Join channel failed", err);
  	    });
  	  }, function (err) {
  	    console.log("AgoraRTC client init failed", err);
  	  });	  
  	  channelKey = "";
  	  client.on('error', function(err) {
  	    console.log("Got error msg:", err.reason);
  	    if (err.reason === 'DYNAMIC_KEY_TIMEOUT') {
  	      client.renewChannelKey(channelKey, function(){
  	        console.log("Renew channel key successfully");
  	      }, function(err){
  	        console.log("Renew channel key failed: ", err);
  	      });
  	    }
  	  });


  	  client.on('stream-added', function (evt) {
  	    var stream = evt.stream;
  	    console.log("New stream added: " + stream.getId());
  	    console.log("Subscribe ", stream);
  	    client.subscribe(stream, function (err) {
  	      console.log("Subscribe stream failed", err);
  	    });
  	  });

  	  client.on('stream-subscribed', function (evt) {
		var stream = evt.stream;
		console.log("Subscribe remote stream successfully: " + stream.getId());
        if(youflag==0){
           stream.play("otvideo");
           youflag+=1;
        }
		
	  });

  	  client.on('stream-removed', function (evt) {
  	    var stream = evt.stream;
  	    stream.stop();
  	    $('#otvideo').remove();
  	    youflag=0;
  	    console.log("Remote stream is removed " + stream.getId());
  	  });

  	  client.on('peer-leave', function (evt) {
  	    var stream = evt.stream;
  	    if (stream) {
  	      stream.stop();
  	      $('#otvideo').remove();
  	      youflag=0;
  	      console.log(evt.uid + " leaved from this channel");
  	      alert("对方已经离开了")
  	    }
  	  });
  	}
}
  	function leave() {
  	  document.getElementById("leave").disabled = true;
  	  client.leave(function () {
  	    console.log("Leavel channel successfully");
  	  }, function (err) {
  	    console.log("Leave channel failed");
  	  });
  	}

  	function publish() {
  	  document.getElementById("publish").disabled = true;
  	  document.getElementById("unpublish").disabled = false;
  	  client.publish(localStream, function (err) {
  	    console.log("Publish local stream error: " + err);
  	  });
  	}

  	function unpublish() {
  	  document.getElementById("publish").disabled = false;
  	  document.getElementById("unpublish").disabled = true;
  	  client.unpublish(localStream, function (err) {
  	    console.log("Unpublish local stream failed" + err);
  	  });
  	}

  	function getDevices() {
  	    
  		AgoraRTC.getDevices(function (devices) {
  	    for (var i = 0; i !== devices.length; ++i) {
  	      var device = devices[i];
  	      //alert(device)
  	      //var option = document.createElement('option');
  	      //option.value = device.deviceId;
  	      if (device.kind === 'audioinput') {
  	        //option.text = device.label || 'microphone ' + (audioSelect.length + 1);
  	        //audioSelect.appendChild(option);
  	        var appendstr="<option value='"+device.deviceId+"'>"+device.label+"</option>";
  	        $("#audioSource").append(appendstr);
  	        //window.audio=device.deviceId;
  	        
  	      } else if (device.kind === 'videoinput') {
  	    	var appendvdstr="<option value='"+device.deviceId+"'>"+device.label+"</option>";
  	        $("#videoSource").append(appendvdstr);
  	        //window.video=device.deviceId
  	        
  	      } else {
  	        console.log('Some other kind of source/device: ', device);
  	      }
  	    }
  	    //console.log( window.audio +"----"+ window.video);
		var channel=window.localStorage.getItem("channel");
		if(channel=="" || channel==null){
			var num = Math.random()*1000 + 1;
			num = parseInt(num, 10);
			window.localStorage.setItem("channel", num);
			$("#channel").val(channel)	
		}
		$("#channel").val(num)	
		window.localStorage.setItem("video", $("#videoSource").val());
		window.localStorage.setItem("audio", $("#audioSource").val());
  	  });
  	}

