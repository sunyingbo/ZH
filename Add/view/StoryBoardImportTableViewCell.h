#import <UIKit/UIKit.h>
#import "StoryBoardImportCellModel.h"
#import "DetailCellModel.h"
@interface StoryBoardImportTableViewCell : UITableViewCell
@property (nonatomic,weak)DetailCellModel *detailModel;
- (void)refreshUI:(StoryBoardImportCellModel *)dataModel;
@end
