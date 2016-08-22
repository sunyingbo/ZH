#import <UIKit/UIKit.h>
#import "DetailCellModel.h"
@interface DetailTableViewCell : UITableViewCell
- (void)refreshUI:(DetailCellModel *)dataModel;
@end
