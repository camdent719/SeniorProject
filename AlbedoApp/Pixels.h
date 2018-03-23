//
//  Pixels.h
//  AlbedoApp
//
//  Created by AlbedoDev on 3/22/18.
//

//#ifndef Pixels_h
//#define Pixels_h
//#endif /* Pixels_h */

#import <AVFoundation/AVFoundation.h>

@interface Pixels : NSObject

@property (strong, nonatomic) id myProperty;

+ (int *) getPixelData:(CMSampleBufferRef *)sampleBuffer;

@end
