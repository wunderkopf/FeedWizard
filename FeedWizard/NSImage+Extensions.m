//
//  NSImage+Extensions.m
//  FeedWizard
//
//  Created by Sasha Kurylenko on 9/12/11.
//  Copyright 2011 Wunderkopf. All rights reserved.
//

#import "NSImage+Extensions.h"

@implementation NSImage (Extensions)

- (void)saveAsPNGWithName:(NSString *)fileName atURL:(NSURL *)url
{
    NSData *imageData = [self TIFFRepresentation];
    NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:imageData];
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:1.0] forKey: NSImageCompressionFactor];
    imageData = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
    NSURL *path = [url URLByAppendingPathComponent:fileName]; 
    [imageData writeToURL:path atomically:NO]; 
}

@end
