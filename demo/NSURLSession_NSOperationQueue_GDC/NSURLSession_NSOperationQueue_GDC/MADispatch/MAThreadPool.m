//
//  MAThreadPool.m
//  MADispatch
//
//  Created by Michael Ash on 8/31/15.
//  Copyright © 2015 mikeash. All rights reserved.
//

#import "MAThreadPool.h"


@implementation MAThreadPool {
    NSCondition *_lock; //基本锁
    
    NSUInteger _threadCount;
    NSUInteger _activeThreadCount;
    NSUInteger _threadCountLimit;
    
    NSMutableArray *_blocks;
}

- (id)init {
    if((self = [super init])) {
        _lock = [[NSCondition alloc] init];
        _blocks = [[NSMutableArray alloc] init];
        _threadCountLimit = 128;
    }
    return self;
}

- (void)addBlock: (dispatch_block_t)block {
    [_lock lock];
    
    [_blocks addObject: block];
    
    NSUInteger idleThreads = _threadCount - _activeThreadCount;
    if([_blocks count] > idleThreads && _threadCount < _threadCountLimit) {
        [NSThread detachNewThreadSelector: @selector(workerThreadLoop:) toTarget: self withObject: nil];
        _threadCount++;
    } //没有足够的空闲工作线程来处理这个 block，并且工作线程的数量还没有达到限制，那么就应该再创建一个新的线程
    
    [_lock signal];
    [_lock unlock];
}

- (void)workerThreadLoop: (id)ignore {
    [_lock lock]; //获取锁
    while(1) { //死循环
        while([_blocks count] == 0) { //队列是空的，让锁进入等待状态
            [_lock wait];
        }
        dispatch_block_t block = [_blocks firstObject];
        [_blocks removeObjectAtIndex: 0]; //可用block出列
        _activeThreadCount++;
        [_lock unlock]; //锁释放
        
        block();
        
        [_lock lock];
        _activeThreadCount--;
    }
}

@end
