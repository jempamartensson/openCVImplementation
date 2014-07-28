//
//  JMPRAppController.h
//  openCVImplementation
//
//  Created by johndoe on 15/07/2014.
//  Copyright (c) 2014 Jens Martensson. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JMPRAppController : NSObject
{
   
    IBOutlet NSImageView *imageViewOne;
    IBOutlet NSImageView *imageViewTwo;
    IBOutlet NSTextField *pathLabelOne;
    IBOutlet NSTextField *pathLabelTwo;
    IBOutlet NSTextField *rowslabel;
    IBOutlet NSTextField *collabel;
    IBOutlet NSTextField *folderPath;
    IBOutlet NSWindow *windowController;


}

@property (retain) NSMutableArray *DistCoeff;
@property (assign) IBOutlet NSWindow *window;



- (IBAction)openImageOne:(id)sender;
- (IBAction)openImageTwo:(id)sender;

- (IBAction)findChessPattern:(id)sender;
- (IBAction)chooseCheesboardFolder:(id)sender;
- (IBAction)printCoeffs:(id)sender;


@end

