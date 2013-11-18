simpleImgPreview
================

This plugin creates previews and wraps them into link to original image - similar to directResize. But when directResize creates previews during page rendering, this plugins changes html code of content field during page saving. 

Options:
PHP Thumb options - options for phpthumb snippet, use underscore and comma instead of equal sign and ampersand, default is zc_1
Previews folder - name of folder to save previews. It's created into the folder that contains original image. Default is previews.
Preview class name - class name for image to be previewed, default is preview
Link class name - class name of link that wraps preview to use with fancybox or any other lightbox script. Default is fancybox.

How it works.
We insert large image with tinyMCE, then we set new width and height (smaller than original ones) and class. The code is <img src="assets/images/our_original_image_name.jpg" class="preview" height="100" width="100" />. Then we save page. Now the code is <a href="assets/images/our_original_image_name.jpg" class="fancybox"><img src="assets/images/previews/our_original_image_name.jpg" class="preview" height="100" width="100" /></a>.
