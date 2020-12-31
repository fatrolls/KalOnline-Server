<?php

class Captcha 
{
    private $font = 'arial.ttf';

    function generateCode($characters) {
        $possible = '23456789bcdfghjkmnpqrstvwxyz';
        $code = '';
        for($i=0;$i<$characters;$i++) {
            $code .= substr($possible, mt_rand(0, strlen($possible)-1), 1);
        }
        return $code;
    }
    
    function __construct($width='120',$height='40',$characters='6') {
        $code = $this->generateCode($characters);
        $_SESSION['captcha'] = $code;
        $font_size = $height * 0.60;
        $image     = imagecreate($width, $height);
        $background_color = imagecolorallocate($image, 0, 0, 0);
        $text_color  = imagecolorallocate($image, 255, 255, 80);
        $noise_color = imagecolorallocate($image, 255, 100, 80);
        for($i=0; $i<($width*$height)/3;$i++) {
            imagefilledellipse($image,mt_rand(0,$width)
                              ,mt_rand(0,$height)
                              ,1,1
                              ,$noise_color);
        }
        for($i=0;$i<($width*$height)/150;$i++) {
            imageline($image,mt_rand(0,$width)
                     ,mt_rand(0,$height)
                     ,mt_rand(0,$width)
                     ,mt_rand(0,$height)
                     ,$noise_color);
        }
        $textbox = imagettfbbox($font_size, 0, $this->font, $code);
        $x = ($width - $textbox[4])/2;
        $y = ($height - $textbox[5])/2;
        imagettftext($image, $font_size, 0, $x, $y, $text_color, $this->font , $code);

        header('Content-Type: image/jpeg');
        imagejpeg($image);
        imagedestroy($image);
    }
}


?> 