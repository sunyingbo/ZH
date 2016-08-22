//
//  ZHFMDBHelp.m
//  StoryBoard助手
//
//  Created by mac on 16/4/8.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ZHFMDBHelp.h"

static ZHFMDBHelp *ZHHelpFMDB;

#define MyMainTable @"MainTable"
#define MyDataBaseName @"myDataBase.rdb"

@interface ZHFMDBHelp ()
@property (nonatomic,copy)NSString *FilePath;
@property (nonatomic,copy)NSString *DataBasePath;
@property (strong,nonatomic)FMDatabase *curFMdatabase;
@end
@implementation ZHFMDBHelp
+ (instancetype)defaultZHFMDBHelp{
    //添加线程锁
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(ZHHelpFMDB==nil){
            ZHHelpFMDB=[[ZHFMDBHelp alloc]init];
        }
    });
    return ZHHelpFMDB;
}
- (NSString *)FilePath{
    if (_FilePath.length<=0) {
        NSString *saveSslectImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:@"SQlite"];
        _FilePath=saveSslectImagePath;
    }
    return _FilePath;
}
- (NSString *)DataBasePath{
    if (_DataBasePath.length<=0) {
        NSString *saveSslectImagePath=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:@"SQlite"];
        saveSslectImagePath=[saveSslectImagePath stringByAppendingPathComponent:MyDataBaseName];
        _DataBasePath=saveSslectImagePath;
    }
    return _DataBasePath;
}

#pragma mark----------数据库相关操作
- (FMDatabase *)curFMdatabase{
    if(_curFMdatabase==nil){
        if([[NSFileManager defaultManager] fileExistsAtPath:self.DataBasePath]==NO){//判断数据库是否存在
            [self creatMainPath];
            FMDatabase *fmdateBase = [[FMDatabase alloc] initWithPath:self.DataBasePath];
            if ([fmdateBase open]) {
                NSString *codeMainTable=@"create table if not exists MainTable (id integer primary key autoincrement,MyID text,category text,condition text,imagename text,storyboard text,detail text,viewcontroller text,count integer)";
                if(![fmdateBase executeUpdate:codeMainTable]){
                    NSLog(@"创建表格失败");
                }else{
                    NSLog(@"创建表格成功");
                }
                //创建成功后需要关闭该数据库
                [fmdateBase close];
            }else{
                NSLog(@"创建数据库失败");
            }
        }
        _curFMdatabase=[self openDataBase];
        if(_curFMdatabase==nil){
            NSLog(@"%@",@"打开数据库失败");
        }
    }
    return _curFMdatabase;
}
//1.根据数据库名,来打开一个数据库,如果打开成功,返回这个权柄(测试成功)
- (FMDatabase *)openDataBase{
    
    FMDatabase *fmdateBase = [[FMDatabase alloc] initWithPath:self.DataBasePath];
    if ([fmdateBase open]) {
        return fmdateBase;
    }
    return nil;//如果打开失败,返回空
}
- (void)closeDataBase{
    [self.curFMdatabase close];
}
//2.判断表中是否已经有这条记录
- (BOOL)HasExistInfo:(NSString *)title{
    if(self.curFMdatabase!=nil){//如果打开数据库成功
        NSString *code=[NSString stringWithFormat:@"select count(*) as 'count' from %@ where  MyID = '%@'", @"MainTable", title];
        FMResultSet *rs = [self.curFMdatabase executeQuery:code];
        while ([rs next]){
            NSInteger count = [rs intForColumn:@"count"];
            if (0 == count){
                [rs close];
                return NO;
            }else{
                [rs close];
                return YES;
                break;
            }
        }
    }
    return NO;
}
//4.添加数据(测试成功)
- (BOOL)insertDataWithMyID:(NSString *)MyID withCategory:(NSString *)category withCondition:(NSString *)condition withImagename:(NSString *)imagename withStoryboard:(NSString *)storyboard withDetail:(NSString *)detail withViewcontroller:(NSString *)viewcontroller{
    if([self HasExistInfo:MyID]==YES){
        return NO;
    }
    NSString *code=[NSString stringWithFormat:@"insert into %@ (MyID,category,condition,imagename,storyboard,detail,viewcontroller,count) values ('%@','%@','%@','%@','%@','%@','%@','%@')",@"MainTable",MyID,category,[self enCode:condition],imagename,storyboard,detail,viewcontroller,@0];
    if([self operateDataToDataBase:@"myDataBase.rdb" withCode:code]){
        return YES;
    }else{
        [ZHHelp AlertMsg:@"添加失败"];
        return NO;
    }
    return YES;
}
//4.删除某一条数据(测试成功)
- (void)deleteDataWithTitle:(NSString *)MyID{
    if([self HasExistInfo:MyID]==YES){
        NSString *code=[NSString stringWithFormat:@"delete from %@ where MyID = '%@'",@"MainTable",MyID];
        if([self operateDataToDataBase:@"myDataBase.rdb" withCode:code]){
        }else{
            [ZHHelp AlertMsg:@"删除数据失败"];
        }
    }else{
        [ZHHelp AlertMsg:@"你要删除的数据不存在"];
    }
}
//4.修改某条数据(测试成功)
- (void)updataDataWithTitle:(NSString *)MyID withCategory:(NSString *)category withCondition:(NSString *)condition withImagename:(NSString *)imagename withStoryboard:(NSString *)storyboard withDetail:(NSString *)detail withViewcontroller:(NSString *)viewcontroller{
    if([self HasExistInfo:MyID]==YES){
        NSString *code=[NSString stringWithFormat:@"update %@ set category = '%@',condition='%@',imagename='%@',storyboard='%@',detail='%@' ,viewcontroller='%@' where MyID = '%@'",MyMainTable ,category,[self enCode:condition],imagename,storyboard,detail,viewcontroller,MyID];
        if([self operateDataToDataBase:MyDataBaseName withCode:code]){
        }else{
            [ZHHelp AlertMsg:@"修改失败"];
        }
    }else{
        [ZHHelp AlertMsg:@"你要修改的数据不存在"];
    }
}
//4.查询数据
- (SearchCellModel *)selectDataWithTitle:(NSString *)MyID{
    SearchCellModel *model=[SearchCellModel new];
    NSString *code=[NSString stringWithFormat:@"select * from MainTable where MyID = '%@'",MyID];
    if(self.curFMdatabase !=nil){//如果打开数据库成功
        FMResultSet *set = [self.curFMdatabase executeQuery:code];
        while ([set next]) {
            model.iconImage=[set stringForColumn:@"imagename"];
            model.detailText=[set stringForColumn:@"detail"];
            model.storyboard=[set stringForColumn:@"storyboard"];
            model.MyID=[set stringForColumn:@"MyID"];
            model.condition=[set stringForColumn:@"condition"];
            model.category=[set stringForColumn:@"category"];
            model.viewcontroller=[set stringForColumn:@"viewcontroller"];
            
            model.storyboard=[ZHHelp getCurFilePathFromApp:model.storyboard];
            model.iconImage=[ZHHelp getCurFilePathFromApp:model.iconImage];
        }
        [set close];
        if (model.MyID.length>0) {
            return model;
        }else{
            [ZHHelp AlertMsg:@"这条数据已经不存在"];
        }
    }
    return nil;
}
- (NSInteger)selectDataCount{
    NSString *code=[NSString stringWithFormat:@"select * from MainTable"];
    NSInteger count=0;
    if(self.curFMdatabase !=nil){//如果打开数据库成功
        FMResultSet *set = [self.curFMdatabase executeQuery:code];
        while ([set next]) {
            count++;
        }
        [set close];
    }
    return count;
}

- (NSMutableArray *)selectDataWithCategory:(NSString *)category{
    
    NSString *code=[NSString stringWithFormat:@"select * from MainTable where category = '%@' order by count desc",category];
    if(self.curFMdatabase !=nil){//如果打开数据库成功
        FMResultSet *set = [self.curFMdatabase executeQuery:code];
        NSMutableArray *arrM=[NSMutableArray array];
        while ([set next]) {
            SearchCellModel *model=[SearchCellModel new];
            
            model.storyboard=[set stringForColumn:@"storyboard"];
            model.iconImage=[set stringForColumn:@"imagename"];
            model.detailText=[set stringForColumn:@"detail"];
            model.MyID=[set stringForColumn:@"MyID"];
            model.condition=[set stringForColumn:@"condition"];
            model.category=[set stringForColumn:@"category"];
            model.viewcontroller=[set stringForColumn:@"viewcontroller"];
            
            model.storyboard=[ZHHelp getCurFilePathFromApp:model.storyboard];
            model.iconImage=[ZHHelp getCurFilePathFromApp:model.iconImage];
            
            if (model.MyID.length>0) {
                [arrM addObject:model];
            }
        }
        [set close];
        
        if (arrM.count>0) {
            return arrM;
        }
    }
    return nil;
}
//4.根据表格进行 插入 修改 删除 3种命令 (测试成功)
- (BOOL)operateDataToDataBase:(NSString *)DataBaseName withCode:(NSString *)code {
    if(self.curFMdatabase!=nil){//如果打开数据库成功
        if(![self.curFMdatabase executeUpdate:code]){
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}
//3.如果主目录不存在,就创建主目录
//如果主目录不存在,就创建主目录
- (void)creatMainPath{
    BOOL temp;
    if(![[NSFileManager defaultManager] fileExistsAtPath:self.FilePath isDirectory:&temp])
        [[NSFileManager defaultManager] createDirectoryAtPath:self.FilePath withIntermediateDirectories:YES attributes:nil error:nil];
}
//处理数据存储单引号所引起的问题
- (NSString *)enCode:(NSString *)text{
    NSMutableString *temp=[NSMutableString string];
    NSInteger lenth=text.length;
    unichar ch;
    for(NSInteger i=0;i<lenth;i++){
        ch=[text characterAtIndex:i];
        if(ch=='\''){
            [temp appendString:@"@@"];
        }
        else [temp appendFormat:@"%C",ch];
    }
    return temp;
}
- (NSString *)deCode:(NSString *)text{
    NSMutableString *temp=[NSMutableString string];
    NSInteger lenth=text.length;
    unichar ch;
    for(NSInteger i=0;i<lenth-1;i++){
        ch=[text characterAtIndex:i];
        if(ch=='@'&&[text characterAtIndex:i+1]=='@'){
            [temp appendString:@"'"];
            i++;
        }
        else [temp appendFormat:@"%C",ch];
    }
    if([text characterAtIndex:lenth-1]!='@')
        [temp appendFormat:@"%C",[text characterAtIndex:lenth-1]];
    return temp;
}

//4.每次查询后都将访问次数加1
- (void)addCountById:(NSString *)MyID{
    NSString *code=[NSString stringWithFormat:@"update MainTable set count = count +1 where MyID = '%@'", MyID];
    if([self operateDataToDataBase:MyDataBaseName withCode:code]){
//        NSLog(@"count+1成功");
    }else{
//        NSLog(@"count+1失败");
    }
    
}

//4.1如果访问次数都变的很大,可以尝试将所有访问次数减去最小值
- (void)subCount{
    NSString *code=[NSString stringWithFormat:@"select min(count) as 'count' from %@", MyMainTable];
    NSInteger count=0;
    if(self.curFMdatabase !=nil){//如果打开数据库成功
        FMResultSet *rs = [self.curFMdatabase executeQuery:code];
        while ([rs next])
        {
            count= [rs intForColumn:@"count"];
            [rs close];
            break;
        }
    }
    if (count>0){
        //每个值减去最小值
        [self allSubCountValue:count];
    }
}
- (void)allSubCountValue:(NSInteger)count{
    
    NSString *code=[NSString stringWithFormat:@"update %@ set count = count -%ld ", MyMainTable,count];
    if([self operateDataToDataBase:MyDataBaseName withCode:code]){
//        NSLog(@"访问次数减去最小数成功");
    }else{
//        NSLog(@"访问次数减去最小数失败");
    }
}
- (void)subCountWhenScond{
    NSString *code=[NSString stringWithFormat:@"select min(count) as 'count' from %@ where count >0", MyMainTable];
    NSInteger count=0;
    if(self.curFMdatabase !=nil){//如果打开数据库成功
        FMResultSet *rs = [self.curFMdatabase executeQuery:code];
        while ([rs next])
        {
            count= [rs intForColumn:@"count"];
            [rs close];
            break;
        }
    }
    if (count>1){
        NSString *code=[NSString stringWithFormat:@"update %@ set count = count -1 where count >1", MyMainTable];
        if([self operateDataToDataBase:MyDataBaseName withCode:code]){
//            NSLog(@"访问次数减去最小数成功");
        }else{
//            NSLog(@"访问次数减去最小数失败");
        }
    }
}

- (void)allSubCountValue{
    //三种情况
    //1.如果最小数不为0
    [self subCount];
    //2.如果倒数第2小的数为1 (不动)
    //3.如果倒数第2小的数不为1 (所有大于1的数都要-1)
    [self subCountWhenScond];
}

//转移数据到本数据库
- (void)transferDataToThisDataBase{
    NSString *othDataBaseName=@"/Users/mac/Desktop/StoryBoard助手V3.0/myDataBase.rdb";
    FMDatabase *fmdateBase = [[FMDatabase alloc] initWithPath:othDataBaseName];
    if ([fmdateBase open]) {
        //开始进行操作
        
        //读取数据
        NSString *code=[NSString stringWithFormat:@"select * from MainTable"];
        BOOL addSuccess=YES;
        if(fmdateBase !=nil){//如果打开数据库成功
            FMResultSet *set = [fmdateBase executeQuery:code];
            while ([set next]) {
                NSString *iconImage=[set stringForColumn:@"imagename"];
                NSString *detailText=[set stringForColumn:@"detail"];
                NSString *storyboard=[set stringForColumn:@"storyboard"];
                NSString *MyID=[set stringForColumn:@"MyID"];
                NSString *condition=[set stringForColumn:@"condition"];
                NSString *category=[set stringForColumn:@"category"];
                NSString *viewcontroller=[set stringForColumn:@"viewcontroller"];
                //插入数据
                if([self HasExistInfo:MyID]==YES){
                    continue;
                }
                
                NSString *code=[NSString stringWithFormat:@"insert into %@ (MyID,category,condition,imagename,storyboard,detail,viewcontroller,count) values ('%@','%@','%@','%@','%@','%@','%@','%@')",@"MainTable",MyID,category,[self enCode:condition],iconImage,storyboard,detailText,viewcontroller,@0];
                if([self operateDataToDataBase:@"myDataBase.rdb" withCode:code]){
                }else{
                    addSuccess=NO;
                }
            }
            [set close];
            if (addSuccess) {
                [ZHHelp AlertMsg:@"导入数据成功"];
            }else{
                [ZHHelp AlertMsg:@"中途有数据导入失败"];
            }
        }
    }
    [fmdateBase close];
}
@end