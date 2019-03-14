# goim-sdk

1、此sdk在原来的goim基础上做了修改，auth时候不会自动分配room=0
会根据
PushClient cb = new PushClient(InetAddress.getByName("10.160.61.129"), 8080 , 1, "game");
中的game各个字母的asics生成roomId

