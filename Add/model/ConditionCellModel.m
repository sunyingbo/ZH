#import "ConditionCellModel.h"


@implementation ConditionCellModel
- (NSMutableArray *)conditionArrM{
    if (!_conditionArrM) {
        _conditionArrM=[NSMutableArray array];
    }
    return _conditionArrM;
}
@end

