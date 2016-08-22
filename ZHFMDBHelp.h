//
//  ZHFMDBHelp.h
//  StoryBoard助手
//
//  Created by mac on 16/4/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "SearchCellModel.h"

@interface ZHFMDBHelp : NSObject
+ (instancetype)defaultZHFMDBHelp;
- (FMDatabase *)curFMdatabase;
//1.根据数据库名,来打开一个数据库,如果打开成功,返回这个权柄(测试成功)
- (FMDatabase *)openDataBase;
- (void)closeDataBase;
//2.判断表中是否已经有这条记录
- (BOOL)HasExistInfo:(NSString *)title;
//4.添加数据(测试成功)
- (BOOL)insertDataWithMyID:(NSString *)MyID withCategory:(NSString *)category withCondition:(NSString *)condition withImagename:(NSString *)imagename withStoryboard:(NSString *)storyboard withDetail:(NSString *)detail withViewcontroller:(NSString *)viewcontroller;
//4.删除某一条数据(测试成功)
- (void)deleteDataWithTitle:(NSString *)MyID;
//4.修改某条数据(测试成功)
- (void)updataDataWithTitle:(NSString *)MyID withCategory:(NSString *)category withCondition:(NSString *)condition withImagename:(NSString *)imagename withStoryboard:(NSString *)storyboard withDetail:(NSString *)detail withViewcontroller:(NSString *)viewcontroller;
//4.查询数据ID
- (SearchCellModel *)selectDataWithTitle:(NSString *)MyID;
/**查询数据库数据条数*/
- (NSInteger)selectDataCount;
//4.查询数据根据分类
- (NSMutableArray *)selectDataWithCategory:(NSString *)category;
//4.根据表格进行 插入 修改 删除 3种命令 (测试成功)
- (BOOL)operateDataToDataBase:(NSString *)DataBaseName withCode:(NSString *)code ;
//3.如果主目录不存在,就创建主目录
- (void)creatMainPath;
//处理数据存储单引号所引起的问题
- (NSString *)enCode:(NSString *)text;
- (NSString *)deCode:(NSString *)text;
- (NSMutableArray *)updataCategoryArr;

//4.每次查询后都将访问次数加1
- (void)addCountById:(NSString *)MyID;
- (void)allSubCountValue;
//4.1如果访问次数都变的很大,可以尝试将所有访问次数减去最小值
- (void)subCount;
@end
