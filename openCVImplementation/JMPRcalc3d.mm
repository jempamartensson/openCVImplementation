//
//  JMPRcalc3d.m
//  openCVImplementation
//
//  Created by johndoe on 22/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import "JMPRcalc3d.h"

using namespace std;
using namespace cv;


@implementation JMPRcalc3d



typedef struct Calc3d
{
    cv::Matx34d P1;
    cv::Matx34d P2;
    std::vector<cv::Point2f> ImagePoints1;
    std::vector<cv::Point2f> ImagePoints2;
    cv::Mat Image;
    std::vector<cv::Point3f> pointCloud;
}Calc3d;


Calc3d getP1(cv::Mat img1,cv::Mat img2, cv::Mat cameraM,cv::Mat distM)
{
    cv::Mat_<double> E;

    Mat bwimg1;
    Mat bwimg2;
    
    Mat bwimg1und;
    Mat bwimg2und;
    
    cvtColor(img1, bwimg1, CV_BGR2GRAY);
    cvtColor(img2, bwimg2, CV_BGR2GRAY);
    
    undistort(bwimg1, bwimg1und, cameraM, distM);
    undistort(bwimg2, bwimg2und, cameraM, distM);
    
    
    
    // detectingkeypoints
    int minHessian = 400;
    SurfFeatureDetector detector(minHessian);
    vector<KeyPoint> keypoints_1, keypoints_2;
    detector.detect(bwimg1, keypoints_1);
    detector.detect(bwimg2, keypoints_2);
    
    // computing descriptors
    SurfDescriptorExtractor extractor;
    Mat descriptors_1, descriptors_2;
    extractor.compute(bwimg1, keypoints_1, descriptors_1);
    extractor.compute(bwimg2, keypoints_2, descriptors_2);
    
    
//    cv::BFMatcher matcher(cv::NORM_L1, true);
//    std::vector< cv::DMatch > matches;
//    matcher.match( descriptors_1, descriptors_2, matches );
    
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

    std::vector< DMatch > good_matches;
    
    for( int i = 0; i < descriptors_1.rows; i++ )
    { if( matches[i].distance <= max(2*min_dist, 0.02) )
    { good_matches.push_back( matches[i]); }
    }
    cout<<"Good matches are : "<<good_matches.size()<<"\n";
    
    
    
    
    
    

    
    
    //convert from KeyPoint to vector 2 float
    std::vector<cv::Point2f> _pt_set1_pt,_pt_set2_pt;
    cv::KeyPoint::convert(keypoints_1, _pt_set1_pt);
    cv::KeyPoint::convert(keypoints_2, _pt_set2_pt);
    
    std::vector<cv::Point2f>imgpts1,imgpts2;
    for( unsigned int i = 0; i<matches.size(); i++){
        imgpts1.push_back(keypoints_1[matches[i].queryIdx].pt);
        imgpts2.push_back(keypoints_2[matches[i].trainIdx].pt);
    }
    
    std::vector<cv::Point2f>imgpts1good,imgpts2good;
    for( unsigned int i = 0; i<good_matches.size(); i++){
        imgpts1good.push_back(keypoints_1[good_matches[i].queryIdx].pt);
        imgpts2good.push_back(keypoints_2[good_matches[i].trainIdx].pt);
    }
    std::vector<cv::Point2f>imgpts1goodund,imgpts2goodund;
    
    undistortPoints(imgpts1, imgpts1goodund, cameraM, distM);
    undistortPoints(imgpts2, imgpts2goodund, cameraM, distM);
    
    int pts_size = int(keypoints_1.size());
    
    //draw the matches
    cv::Mat img_matches;
    drawMatches( img1, keypoints_1, img2, keypoints_2,
                matches, img_matches, Scalar::all(-1), Scalar::all(-1),
                vector<char>(), DrawMatchesFlags::NOT_DRAW_SINGLE_POINTS );
    
    cout<<"Size of imgpts1 is :"<<imgpts1.size()<<"\n";
    
    
    cv::Mat F=findFundamentalMat(imgpts1goodund,imgpts2goodund,cv::FM_RANSAC,3.0, 0.99);
    cout<<"Fundamental M done \n";
    cout<<"F has :"<<F.rows<<" rows\n";
    
    
    E = cameraM.t() * F * cameraM;
    SVD svd( E );
    static const Mat W = (Mat_<double>(3, 3) <<
                          0, -1, 0,
                          1, 0, 0,
                          0, 0, 1);
    
    static const Mat W_inv = W.inv();
    
    Mat_<double> R1 = svd.u * W * svd.vt;
    Mat_<double> t1 = svd.u.col( 2 );
    
    Mat_<double> R2 = svd.u * W_inv * svd.vt;
    Mat_<double> t2 = -svd.u.col( 2 );
    
    static const Mat P1 = Mat::eye(3, 4, CV_64FC1 );
    Mat P2 =( Mat_<double>(3, 4) <<
             R1(0, 0), R1(0, 1), R1(0, 2), t1(0),
             R1(1, 0), R1(1, 1), R1(1, 2), t1(1),
             R1(2, 0), R1(2, 1), R1(2, 2), t1(2));
    
    cout<<"R, t P1 and P2 done \n";
    
    
    cout<<"Undistort done \n";
    

    cv::Mat pt_3d_h(1,pts_size,CV_32FC4);
    
    cv::triangulatePoints(P1, P2, imgpts1goodund, imgpts2goodund, pt_3d_h);
    
//    vector<Mat> splitted = {
//        pt_3d_h.row(0) / pt_3d_h.row(3),
//        pt_3d_h.row(1) / pt_3d_h.row(3),
//        pt_3d_h.row(2) / pt_3d_h.row(3)
//    };
//    
//    merge( splitted, pt_3d_h );
    
    cout<<"Triangulate done \n";
    
    std::vector<cv::Point3f> pt_3d;
    cv::convertPointsHomogeneous(pt_3d_h.reshape(4, 1), pt_3d);
    cv::Vec3d rvec; Rodrigues(R1 ,rvec);
    cv::Vec3d tvec(t1(0,3),t1(1,3),t1(2,3));
    std::vector<cv::Point2f> reprojected_pt_set1;
    cv::projectPoints(pt_3d,rvec,tvec,cameraM,distM,reprojected_pt_set1);
    
    cout<<"3d points size : "<<pt_3d.size()<<"\n";
    
    //cout<<"Reprojected point 1: "<<reprojected_pt_set1.at(1)<<"\n";
    //cout<<"Original point 1: "<<imgpts1.at(1)<<"\n";
    
    cout<<"Reprojected points: "<<reprojected_pt_set1.size()<<"\n";
    
    cout<<"Original points: "<<imgpts1.size()<<"\n";
    
    for (unsigned int i = 0; i < reprojected_pt_set1.size(); i++){
        Point2f pt_3d_distance;
        pt_3d_distance = reprojected_pt_set1.at(i);
        Point2f pt_2d_distance;
        pt_2d_distance = imgpts1.at(i);
        
        double distance;
        distance = sqrt(pow((pt_3d_distance.x - pt_2d_distance.x),2)+pow((pt_3d_distance.y - pt_2d_distance.y),2));
        if (distance < 100) {
            cout<<"The distance is :"<<distance<<"\n";
        }
    
        }
    
//	for (unsigned int i=0; i<pts_size; i++) {
//		CloudPoint cp;
//		cp.pt = pt_3d[i];
//		pointcloud.push_back(cp);
//		reproj_error.push_back(norm(_pt_set1_pt[i]-reprojected_pt_set1[i]));
//	}


    Calc3d calc;
    
    calc.ImagePoints1 = imgpts1goodund;
    calc.ImagePoints2 = imgpts2goodund;
    calc.P1 = P1;
    calc.P2 = P2;
    calc.Image = img_matches;
    calc.pointCloud = pt_3d;

    cout<<"Calc done \n";
    
    cout<<"Camera P1: "<<calc.P1;
    
    
    return calc;
}

@end