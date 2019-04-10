#import <Foundation/Foundation.h>
#import <Foundation/NSObjCRuntime.h>
#import "IFalcoComponent.h"
#import "IFalcoBlock.h"

typedef enum {
    VALUE_TYPE_UINT32 = 1,
    VALUE_TYPE_STRING = 2,
    VALUE_TYPE_DOUBLE = 3
}ODVALUETYPE;

//typedef enum {
//    NETWORK_TYPE_UNKNOWN = 1,
//    NETWORK_TYPE_WIFI = 2,
//    NETWORK_TYPE_2G = 3,
//    NETWORK_TYPE_3G = 4,
//    NETWORK_TYPE_4G = 5,
//    NETWORK_TYPE_WIRED = 6
//}ODNETWORKTYPE;


typedef NS_ENUM(NSInteger, ODDatareportChannelType) {
    DATAREPORT_CHANNEL_OPENSSO = 0, //7.3.5版本已经废弃，请不要使用
    DATAREPORT_CHANNEL_QQSSO = 1,   //
};

typedef NS_ENUM(NSInteger, ODDatareportColumnIndex){
    DATAREPORT_COL_INDEX_UNKNOWN = 0,      //未知字段
    DATAREPORT_COL_INDEX_EXTENDCOL1= 1,    //数据库表中保留字段1
    DATAREPORT_COL_INDEX_EXTENDCOL2= 2,    //数据库表中保留字段2
    DATAREPORT_COL_INDEX_EXTENDCOL3= 3,    //数据库表中保留字段3
    DATAREPORT_COL_INDEX_EXTENDCOL4= 4,    //数据库表中保留字段4
    DATAREPORT_COL_INDEX_EXTENDCOL5= 5,    //数据库表中保留字段5
    DATAREPORT_COL_INDEX_EXTENDCOL_BOUNDARY = 6,   //边界值
};

@protocol IFalcoDataReportItem <IFalcoObject>
@required
- (NSString*)tid;
- (void)setTid:(NSString*)tableName;

- (NSString*)opername;
- (void)setOpername:(NSString*)operName;

- (NSString*)module;
- (void)setModule:(NSString*)moduleName;

- (NSString*)action;
- (void)setAction:(NSString*)actionName;

- (uint64_t)actionTime;
- (void)setActionTime:(uint64_t)actionTime;

- (uint64_t)actionOrder;
- (void)setActionOrder:(uint64_t)actionOrder;

- (uint64_t)cycle;
- (void)setCycle:(uint64_t)cycle;

- (uint64_t)dayCycle;
- (void)setDayCycle:(uint64_t)dayCycle;

- (uint64_t)roomId;
- (void)setRoomId:(uint64_t)roomId;

- (ODDatareportChannelType)channelType;
- (void)setChannelType:(ODDatareportChannelType)type;

- (BOOL)realTimeReport;
- (void)setRealTimeReport:(BOOL)real;

- (uint8_t)sendfailRetryCnt;
- (void)setSendfailRetryCnt:(uint8_t)retryCnt;

- (NSMutableArray*)reportValueArr;
- (void)setReportValueArr:(NSMutableArray*)valueArr;

- (void)addExtendColumnValue:(NSString*)colValue
                 withColName:(NSString*)colName;

//- (void)addExtendColumnUIntValue:(unsigned int)value withColumn:(ODDatareportColumnIndex)column;
//- (void)addExtendColumnDoubleValue:(double)value withColumn:(ODDatareportColumnIndex)column;
//- (void)addExtendColumnStringValue:(NSString *)value withColumn:(ODDatareportColumnIndex)column;
//- (void)addExtend_int1_Value:(unsigned int)value;
//- (void)addExtend_int2_Value:(unsigned int)value;
//- (void)addExtend_str1_Value:(NSString *)value;
//- (void)addExtend_str2_Value:(NSString *)value;
@end
