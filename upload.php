<?php  
$img = isset($_POST['img'])? $_POST['img'] : '';  
  
// 获取图片  
list($type, $data) = explode(',', $img);  
  
// 判断类型  
if(strstr($type,'image/jpeg')!=''){  
    $ext = '.jpg';  
}elseif(strstr($type,'image/gif')!=''){  
    $ext = '.gif';  
}elseif(strstr($type,'image/png')!=''){  
    $ext = '.png';  
}  
  
// 生成的文件名
$name= time().$ext;
$ret_show = '/upload/'.$name;
$photo = '/alidata/www/default/IM/webroot'.$ret_show;  
file_put_contents($photo, base64_decode($data), true);
$per=0.3;
list($width, $height)=getimagesize($photo);
$n_w=$width*$per;
$n_h=$height*$per;
$new=imagecreatetruecolor($n_w, $n_h);
$img=imagecreatefromjpeg($photo);
//copy部分图像并调整
imagecopyresized($new, $img,0, 0,0, 0,$n_w, $n_h, $width, $height);
//图像输出新图片、另存为
imagejpeg($new, $photo);
imagedestroy($img);
//file_put_contents($photo, base64_decode($data), true);
// 返回
header('content-type:application/json;charset=utf-8');
$ret = array('img'=>$ret_show);
echo json_encode($ret);
 
?>  