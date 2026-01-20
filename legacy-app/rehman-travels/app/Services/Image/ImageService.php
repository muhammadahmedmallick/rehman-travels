<?php

namespace App\Services;


class ImageService{
    public static function __Upload($input) {
        if ($input == true) :
            $dir = 'images/';
            $photo = $input;
            $file =  $photo->getClientOriginalName() . $photo->getClientOriginalExtension();
            self::__delete_image($dir . $file);
            self::__resize($photo, $dir, $file);
            $path = public_path($dir . 'large');
            $photo->move($path, $file);
            return $file;
        else:
            return false;
        endif;
    }

    public static function __delete_image($file_path) {
        if (file_exists($file_path)) :
            @unlink($file_path);
        endif;
    }

    public static function __resize($photo, $dir = '', $file = '') {
        if (!empty($photo)):
            $path = public_path($dir . 'thumb/' . $file);
            $real = Image::make($photo->getRealPath());
            $real->resize(100, 100, function ($constraint) {
                $constraint->aspectRatio();
            })->save($path);
        endif;
    }

}