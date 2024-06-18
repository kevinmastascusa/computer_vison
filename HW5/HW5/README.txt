README
------

This README file accompanies the MATLAB scripts for the Computational Photography assignment on Parametric Shapes.

Unique Features:
----------------
- The scripts are designed to create synthetic edge data and apply the Hough Transform to detect geometric shapes such as lines and circles.
- Custom functions have been developed to generate binary images of lines and circles without using MATLAB's built-in functions.
- An advanced 3D non-maximum suppression technique is implemented to accurately identify circles in a noisy image environment.
- The detection process involves incrementally filling a Hough space and applying a threshold to identify significant circular patterns.
- Users can easily adjust the Gaussian smoothing parameter ('sigma') and the threshold multiplier for Hough space according to their specific requirements. These parameters are crucial for the preprocessing of images and the circle detection process, providing flexibility to handle images with varying levels of noise and detail.


Dependencies:
-------------
- MATLAB (R2023a or compatible version)
- Image Processing Toolbox for MATLAB

Functions used from the Image Processing Toolbox include:
- imread: For reading images from files.
- imwrite: For saving images to files.
- rgb2gray: For converting color images to grayscale.
- imgaussfilt: For applying Gaussian filtering to images.
- edge: For detecting edges in images.
- find: For locating non-zero elements in arrays.
- ind2sub: For converting linear indices to subscript equivalents.
- viscircles: For visualizing circles on images.
- imshow: For displaying images.
- saveas: For saving MATLAB figures as image files.
- datestr: For converting date and time to string format.
- colormap, colorbar: For customizing figure color maps and adding color bars.
- imagesc: For scaling image data and displaying it as an image.


Instructions for Running the Script:
------------------------------------
1. Place all MATLAB scripts ('HW5.m', 'part5.m', 'part6.m') and the image file 'circles1.gif' in your MATLAB working directory.
2. Open MATLAB and navigate to the working directory containing the scripts.
3. Run the 'HW5.m' script to perform the Hough Transform for lines and circles on synthetic data. This will generate output images and save them in the working directory.
4. Run the 'part5.m' script to apply circle detection on the real image 'circles1.gif'. The script will display and save the images with detected circles.
5. Run the 'part6.m' script to detect multiple circles and apply advanced 3D non-maximum suppression in the real image. The results will be displayed and saved alongside the parameters of the detected circles.
6. Review the output images and text files with circle parameters in your working directory after running the scripts.

To adjust the Gaussian filter's 'sigma' value and the threshold multiplier for the Hough space:
- In 'part5.m', locate the line with 'imgaussfilt(img, 1)' and change the second argument to the desired 'sigma' value.
- In 'part6.m', find the line with 'imgaussfilt(imgGray, 1)' to adjust the 'sigma' value for smoothing the image before edge detection.

Source Files:
-------------
- 'HW5.m': Generates synthetic data and applies the Hough Transform for lines and circles.
- 'part5.m': Applies circle detection on a real image and saves the results.
- 'part6.m': Detects multiple circles in a real image using advanced techniques and saves the detailed results.

Test Image:
-----------
- 'circles1.gif': This image is a crucial part of the project, serving as a real-world test case for the circle detection algorithms developed in the MATLAB scripts. It features one or more circles with varying sizes, positions, and possibly overlapping, set against a background. The image is used to validate the effectiveness of the Hough Transform and other image processing techniques implemented in the scripts. The goal is to accurately identify all circles, determining their centers and radii, under various image conditions.
