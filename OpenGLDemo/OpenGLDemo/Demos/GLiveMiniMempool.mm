#import "GLiveMiniMempool.h"
#include <map>
#include <vector>

#define MAX_MEM_SIZE 10
@implementation GLiveMiniMempool
{
    std::map<size_t, std::vector<uint8_t*>> _listMemPool;
}

- (uint8_t*)mallocSpaceWithSize:(size_t)szMem
{
    //@synchronized (self) {
        std::map<size_t, std::vector<uint8_t*>>::iterator it =  _listMemPool.find(szMem);
        if (it ==_listMemPool.end()) {
            std::vector<uint8_t*> temp;
            temp.reserve(MAX_MEM_SIZE);
            uint8_t* newMem = (uint8_t*)malloc(szMem + 1);
            *(uint8_t*)newMem = 1;
            temp.push_back(newMem);
            _listMemPool[szMem] = temp;
            return newMem + 1;
        }else{
            std::vector<uint8_t*>& temp = it->second;
            unsigned long size = temp.size();
            for (int i=0; i<size; i++) {
                uint8_t* freeMem = temp[i];
                if (*(uint8_t*)freeMem == 0) {
                    *(uint8_t*)freeMem = 1;
                    return freeMem +1;
                }
            }
            
            uint8_t* newMem = (uint8_t*)malloc(szMem + 1);
            *(uint8_t*)newMem = 1;
            temp.push_back(newMem);
            return newMem + 1;
        }
    //}

    return nil;
}

- (void)freeSpaceWithSize:(size_t)szMem memPtr:(uint8_t*)pMem
{
    //@synchronized (self) {
        //主要考虑该内存是否是minimempool，这是个大问题
        uint8_t* fullMem = (uint8_t*)pMem -1;
        memset(fullMem, 0, szMem+1);
    //}
}

+ (instancetype)shareInstance
{
    static GLiveMiniMempool* g_sharedInstance = nil;
    @synchronized (g_sharedInstance) {
        if (!g_sharedInstance) {
            g_sharedInstance = [[GLiveMiniMempool alloc] init];
        }
        return g_sharedInstance;
    }

}

@end

