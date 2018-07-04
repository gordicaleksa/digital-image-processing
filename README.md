# Digital Image Processing projects
This is a series of 6 faculty projects I did for my Digital Image Processing (DIP) course. <br />
Link to [School of Electrical Engineering](https://www.etf.bg.ac.rs/), University of Belgrade web site.

### Requirements
To run the programs you will need:
* MATLAB (any version should be ok)

### Table of contents:
- [project 1 - Mosaic](#toc_1)
- [project 2 - Spanish Castle Illusion & color systems](#toc_2)
- [project 3 - Image enhancement & implementation of CLAHE algorithm](#toc_3)

### <h3 id="toc_1">Project 1 - Mosaic ([code](https://github.com/gordicaleksa/digital-image-processing/blob/master/project1/))</h3> 

**Getting started:**

* Download the code and **run the main.m** (2 new figures will popup and 2 new files will be saved to **example_output/**)
* If you wish to use your own images just **change the paths in the main.m** to a path to your images
* Images are **automatically saved to example_output/** directory as files simple_mosaic.png and mosaic.png 
* You can play with 2 implementations [here](https://github.com/gordicaleksa/digital-image-processing/blob/master/project1/create_mosaic.m) and see the results sometimes the contrast is better with 1. implementation.
(images should be small so that the output image is not too big for displaying)

**Results:**

small/building block image:

![alt text](https://github.com/gordicaleksa/digital-image-processing/blob/master/project1/example_input/cartman.png)

big image whose mosaic you want to create out of small images:

![alt text](https://github.com/gordicaleksa/digital-image-processing/blob/master/project1/example_input/mona_lisa.png)

intermediate result:

![alt text](https://github.com/gordicaleksa/digital-image-processing/blob/master/project1/example_output/simple_mosaic.png)

as the final result you get this (using the second implementation from [here](https://github.com/gordicaleksa/digital-image-processing/blob/master/project1/create_mosaic.m))

![alt text](https://github.com/gordicaleksa/digital-image-processing/blob/master/project1/example_output/mosaic.png)

### <h3 id="toc_2">project 2 - Spanish Castle Illusion & color systems ([code](https://github.com/gordicaleksa/digital-image-processing/blob/master/project2/))</h3>

The projects contains implementations of conversion functions between sRGB and: Y'CbCr, XYZ and Lab color systems. <br />
You can find a nice resource I found while learning about color systems [here](https://www.youtube.com/watch?v=iDsrzKDB_tA).

It also contains a function **create_illusion.m** which you can use to create your own spanish-castle-like illusion (you can play with different color systems for processing).

**Getting started:**

* Download the project and **run the section "main initialization logic"** (original sRGB image will popup)
* run the section **"using the create_illusion function - YCbCr color system"** for example
* illusion images will popup and you can play with the illusion :) 
* **change the paths in the section "main initialization logic"** to a path to your images
* Images are **automatically saved to example_output/** directory as files gray.jpg and neg.jpg 

**Results:**

From the original image:

![alt text](https://github.com/gordicaleksa/digital-image-processing/blob/master/project2/example_input/parrots.jpg)

You get 2 new images that together form an illusion.

grayscale image (Y'CbCr was used here)         |  negative image
:-------------------------:|:-------------------------:
![](https://github.com/gordicaleksa/digital-image-processing/blob/master/project2/example_output/gray.jpg)  |  ![](https://github.com/gordicaleksa/digital-image-processing/blob/master/project2/example_output/neg.jpg)

If you look at the center point of the negative image for about 30 seconds and then look at the grayscale it will appear to be properly colored. As soon as you turn your eyes away you will realize that the image is indeed a grayscale one. 

**Attention:** Transition needs to be fast, place your negative image over your grayscale image and after 30 seconds minimize the negative image. You should see the illusion. ([images are here](https://github.com/gordicaleksa/digital-image-processing/blob/master/project2/example_output/))

### <h3 id="toc_3">project 3 - Image enhancement & implementation of CLAHE algorithm ([code](https://github.com/gordicaleksa/digital-image-processing/blob/master/project3/))</h3>

The project contains a series of image enhancment algorithms. Noise removal, contrast enhancment, binarization etc. <br />
It also contains my own implementation of the CLAHE (contrast-limited adaptive histogram equalization) algorithm.

**Getting started:**

* Download the project and run a section and you will see a bad input image being enhanced step by step
* Enhanced images are **automatically saved to example_output/** directory 
* Play with the parameters for the dos_clahe function and watch the output change quality

**Enhancements Examples:**

Original noisy image (impulse/salt-and-pepper noise)           |  Enhanced image
:-------------------------:|:-------------------------:
![](https://github.com/gordicaleksa/digital-image-processing/blob/master/project3/example_input/enigma.png)  |  ![](https://github.com/gordicaleksa/digital-image-processing/blob/master/project3/example_output/enigma_out.jpg)

Original image           |  Enhanced image
:-------------------------:|:-------------------------:
![](https://github.com/gordicaleksa/digital-image-processing/blob/master/project3/example_input/text_stripes.png)  |  ![](https://github.com/gordicaleksa/digital-image-processing/blob/master/project3/example_output/binarization.png)

**Histogram Equalization Examples:**

Original image <br /> (high contrast)           |  Regular HE algorithm  |       CLAHE algorithm
:-------------------------:|:-------------------------:|:-------------------------:
![](https://github.com/gordicaleksa/digital-image-processing/blob/master/project3/example_input/mars_moon.png)  |  ![](https://github.com/gordicaleksa/digital-image-processing/blob/master/project3/example_output/mars_clahe_he.jpg) | ![](https://github.com/gordicaleksa/digital-image-processing/blob/master/project3/example_output/mars_clahe_best.jpg) 
