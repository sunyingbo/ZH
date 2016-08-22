#import <UIKit/UIKit.h>
#import "SearchCellModel.h"
@interface SearchTableViewCell : UITableViewCell
- (UIImageView *)getMyIconImageView;
- (void)refreshUI:(SearchCellModel *)dataModel;
@end