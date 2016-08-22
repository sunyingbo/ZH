#import <UIKit/UIKit.h>

@interface SearchCellModel : NSObject
@property (nonatomic,copy)NSString *iconImage;
@property (nonatomic,assign)CGFloat imageWidth;
@property (nonatomic,assign)CGFloat imageHeigh;
@property (nonatomic,copy)NSString *detailText;
@property (nonatomic,copy)NSString *storyboard;
@property (nonatomic,copy)NSString *condition;
@property (nonatomic,copy)NSString *MyID;
@property (nonatomic,copy)NSString *category;
@property (nonatomic,copy)NSString *viewcontroller;
@property (nonatomic,assign)BOOL select;
@property (nonatomic,assign)BOOL havCondition;
@end