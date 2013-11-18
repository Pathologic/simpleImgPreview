//<?php
/**
 * simpleImgPreview
 * 
 * Creates previews and wraps them into link to original image
 *
 * @category 	plugin
 * @version 	0.1
 * @license 	http://www.gnu.org/copyleft/gpl.html GNU Public License (GPL)
 * @author      Pathologic (maxx@np.by)
 * @internal	@properties &options=PHP Thumb options;text;zc_1 &previews_folder=Previews folder;text;previews  &img_classname=Preview class name;text;preview &a_classname=Link class name;text;fancybox 
 * @internal	@events OnBeforeDocFormSave
 * @internal    @installset base
 * @internal    @legacy_names simpleImgPreview
 */
 
global $modx,$content;
$e = &$modx->Event;
if ($e->name == 'OnBeforeDocFormSave' && !empty($content)){
	if (!class_exists('simple_html_dom_node'))include_once(MODX_BASE_PATH.'assets/plugins/simpleimgpreview/simple_html_dom.php');
	if (!class_exists('phpthumb'))include_once(MODX_BASE_PATH.'assets/snippets/phpthumb/phpthumb.class.php');
	$html = str_get_html(stripslashes(str_ireplace(array("\r","\n",'\r','\n'),'',$content)));
	$options = strtr($options, Array("," => "&", "_" => "="));
	parse_str($options, $params);
	$imgs = $html->find('img.'.$img_classname);
	foreach ($imgs as $img) {
		$input = $img->src;
		$width = $img->width;
		$height = $img->height;
		$path_parts = pathinfo($input);
		if (empty($params['f'])) {
			$params['f'] = $path_parts['extension'];
  		}
		if (!strpos($input,'/'.$previews_folder)) {
			$folder = MODX_BASE_PATH.$path_parts['dirname'].'/'.$previews_folder;
			$outputFilename = $folder.'/'.$path_parts['filename'].'.'.$params['f'];
			if(!is_dir($folder)) mkdir($folder);
			$phpThumb = new phpthumb();
  			$phpThumb->setSourceFilename(MODX_BASE_PATH . $input);
			$params['w'] = $width;
			$params['h'] = $height;
  			foreach ($params as $key => $value) {
	    		$phpThumb->setParameter($key, $value);
	  		}
	  		if ($phpThumb->GenerateThumbnail()) {
				$phpThumb->RenderToFile($outputFilename);
				$img->src = str_replace(MODX_BASE_PATH,'',$outputFilename);
				$parent = $img->parent();
				if ($parent->class !== $a_classname) {
					$img->outertext = '<a href="'.$input.'" class="'.$a_classname.'">'.$img->outertext.'</a>';
				}
				else {
					$parent->href = $input;
		  		}
			}
			else {
				$modx->logEvent(0, 3, implode('<br/>', $phpThumb->debugmessages), 'phpthumb');
		  	}
		}
	}
$content = $modx->db->escape($html);
$html->clear(); 
unset($html);
}
