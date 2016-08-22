#import <UIKit/UIKit.h>
#import "ConditionCellModel.h"
@interface ConditionTableViewCell : UITableViewCell
- (void)refreshUI:(ConditionCellModel *)dataModel;
@end