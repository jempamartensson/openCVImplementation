//
//  JMPRflannMatcher.m
//  openCVImplementation
//
//  Created by johndoe on 24/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRflannMatcher.h"

using namespace cv;

@implementation JMPRflannMatcher

Mat testFlann(Mat cameraM, Mat distM, Mat &img_drawkey){

    Mat img_1 = cv::imread("/Users/johndoe/Develop/statue_picture/img1.jpg", CV_LOAD_IMAGE_GRAYSCALE );
    Mat img_2 = cv::imread("/Users/johndoe/Develop/statue_picture/img2.jpg", CV_LOAD_IMAGE_GRAYSCALE );

    Mat unimg_1;
    Mat unimg_2;
    
    undistort(img_1, unimg_1, cameraM, distM);
    undistort(img_2, unimg_2, cameraM, distM);


    if( !img_1.data || !img_2.data )
    { std::cout<< " --(!) Error reading images " << std::endl; }
    
    //-- Step 1: Detect the keypoints using SURF Detector
    int minHessian = 10;
    
    SurfFeatureDetector detector( minHessian );
    
    std::vector<KeyPoint> keypoints_1, keypoints_2;
    
    detector.detect( img_1, keypoints_1 );
    detector.detect( img_2, keypoints_2 );
    
    //-- Step 2: Calculate descriptors (feature vectors)
    SurfDescriptorExtractor extractor;
    
    Mat descriptors_1, descriptors_2;
    
    extractor.compute( img_1, keypoints_1, descriptors_1 );
    extractor.compute( img_2, keypoints_2, descriptors_2 );
    
    //-- Step 3: Matching descriptor vectors using FLANN matcher
    FlannBasedMatcher matcher;
    std::vector< DMatch > matches;
    matcher.match( descriptors_1, descriptors_2, matches );
    
    double max_dist = 0; double min_dist = 100;
    
    //-- Quick calculation of max and min distances between keypoints
    for( int i = 0; i < descriptors_1.rows; i++ )
    { double dist = matches[i].distance;
        if( dist < min_dist ) min_dist = dist;
        if( dist > max_dist ) max_dist = dist;
        
        
    }
    
    printf("-- Max dist : %f \n", max_dist );
    printf("-- Min dist : %f \n", min_dist );
    
    //-- Draw only "good" matches (i.e. whose distance is less than 2*min_dist,
    //-- or a small arbitary value ( 0.02 ) in the event that min_dist is very
    //-- small)
    //-- PS.- radiusMatch can also be used here.
    
    
    //convert from KeyPoint to vector 2 float
    std::vector<cv::Point2f> imgpt1,imgpt2;
    cv::KeyPoint::convert(keypoints_1, imgpt1);
    cv::KeyPoint::convert(keypoints_2, imgpt2);
    
    drawKeypoints(img_1, keypoints_1, img_drawkey);
    
    
    
    std::vector< DMatch > good_matches;
    
    for( int i = 0; i < descriptors_1.rows; i++ )
    { if( matches[i].distance <= max(2*min_dist, 0.02) )
    { good_matches.push_back( matches[i]); }
    }
    
    //-- Draw only "good" matches
    Mat img_matches;
    drawMatches( img_1, keypoints_1, img_2, keypoints_2,
                good_matches, img_matches, Scalar::all(-1), Scalar::all(-1),
                vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
    
//    //-- Show detected matches
//    imshow( "Good Matches", img_matches );
    
    for( int i = 0; i < (int)good_matches.size(); i++ )
    {
    printf("Matches have this distance : %f \t", good_matches[i].distance);
     printf( "-- Good Match [%d] Keypoint 1: %d  -- Keypoint 2: %d  \n", i, good_matches[i].queryIdx, good_matches[i].trainIdx );
}
    
    
    return img_matches;
}


@end
