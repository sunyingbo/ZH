#import "SearchCellModel.h"
@implementation SearchCellModel
- (void)setIconImage:(NSString *)iconImage{
    _iconImage=iconImage;
    if ([[NSFileManager defaultManager]fileExistsAtPath:iconImage]) {
        UIImage *image=[UIImage imageWithContentsOfFile:iconImage];
        _imageHeigh=CGImageGetHeight(image.CGImage);
        _imageWidth=CGImageGetWidth(image.CGImage);
    }
}
@end