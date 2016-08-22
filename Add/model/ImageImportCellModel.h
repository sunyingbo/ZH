#import <UIKit/UIKit.h>

@interface ImageImportCellModel : NSObject
@property (nonatomic,copy)NSString *imagePath;
@property (nonatomic,copy)NSString *ImagePathNew;
@property (nonatomic,assign)BOOL noChange;
@end