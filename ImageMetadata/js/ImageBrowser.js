
/* ================================================  
 *    
 * Copyright (c) 2015 Oracle and/or its affiliates.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ================================================ */

var max
var first
var last 

function onPageLoaded() {
   var preview = document.getElementById('imagePreview.1');
 	 resizeImagePreview(preview);
}

function showNext() {	  
	if (last < max) {
    document.getElementById(first).style.display="none";
	  first++;
		last++;
		document.getElementById(last).style.display="inline-block";
	}
}

function showPrev() {	  
  if (first > 1) {
 	  document.getElementById(last).style.display="none";
		first--;
		last--;
		document.getElementById(first).style.display="inline-block"
	}
}

function syncPanels(index) {
	
	var carousel = document.getElementById("thumbnailCarousel");
	var size = carousel.childNodes.length;
	
	for (i = 1; i <= size; i++) {
		var props = document.getElementById('imageProperties.' + i);
		var preview = document.getElementById('imagePreview.' + i);
		if (i == index) {
			props.style.display = "block";
			preview.style.display = "block";
			resizeImagePreview(preview);
	  }
	  else {
	  	props.style.display = "none";
	  	preview.style.display = "none";
	  }
	}
}
	  	
function resizeImagePreview(image) {
 
  var maxWidth    = document.documentElement.offsetWidth - 300;
  var maxHeight   = document.documentElement.offsetHeight - 167 - 150;
  
  if (maxWidth > image.firstChild.naturalWidth) {
  	maxWidth = image.firstChild.naturalWidth;
  }
  
  if (maxHeight > image.firstChild.naturalHeight) {
  	maxHeight = image.firstChild.naturalHeight;
  }
  
  var heightRatio = maxHeight / image.firstChild.naturalHeight;
  var widthRatio = maxWidth / image.firstChild.naturalWidth;
  
  if (widthRatio > heightRatio) {
  	image.style.height = maxHeight + "px"
  	image.firstChild.style.height = maxHeight + "px"
  }
  else {
    image.firstChild.style.width = maxWidth + "px"
  }
}

function rotateCarouselLeft() {
	
	var carousel = document.getElementById("thumbnailCarousel");
	var image = carousel.firstChild;
	carousel.removeChild(image);
	carousel.appendChild(image);
	
}

function rotateCarouselRight() {

	var carousel = document.getElementById("thumbnailCarousel");
	var image = carousel.childNodes[carousel.childNodes.length-1]
	carousel.removeChild(image);
	carousel.insertBefore(image,carousel.firstChild);

}