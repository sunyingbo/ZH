#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    GetSBViewControllerTypePureHand,
    GetSBViewControllerTypeMVC
} GetSBViewControllerType;
@interface GetSBViewController : UIViewController
@property (nonatomic,assign)GetSBViewControllerType type;
@end