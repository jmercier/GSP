#include "ImageViewer.hpp"

#include <opencv/highgui.h>
#include <cstring>
#include <gtk/gtk.h>

#include <stdio.h>
#include <iostream>

ImageViewer::ImageViewer()
	:name_(0)
{}

void ImageViewer::initModule()
{
}

void ImageViewer::stopModule()
{
	if(name_)
	{
		gdk_threads_enter();
		cvDestroyWindow( name_ );
		cvWaitKey(5);
		gdk_threads_leave();
		delete[] name_;
	}
}

void ImageViewer::setName(char *name)
{
	if(name_)
	{
		gdk_threads_enter();
		cvDestroyWindow( name_ );
		gdk_threads_leave();
		delete[] name_;
	}
	
	name_ = new char[strlen(name)];
	
	strcpy(name_, name);
	
	gdk_threads_enter();
	cvNamedWindow(name_);
	gdk_threads_leave();
}


void ImageViewer::input(IplImage* img)
{
  gdk_threads_enter();
  cvShowImage(name_, img);
  //cvWaitKey(10);
  gdk_threads_leave();
}
