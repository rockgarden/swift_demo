//
//  MADispatchQueue.m
//  MADispatch
//
//  Created by Michael Ash on 8/31/15.
//  Copyright © 2015 mikeash. All rights reserved.
//

#import "MADispatchQueue.h"

#import "MAThreadPool.h"


@implementation MADispatchQueue {
    NSLock *_lock; //互斥锁
    NSMutableArray *_pendingBlocks; //待分配 block 的队列
    BOOL _serial;
    BOOL _serialRunning; //是否有 block 正在线程池中被执行
}

static MADispatchQueue *gGlobalQueue;
static MAThreadPool *gThreadPool;

+ (void)initialize {
    if(self == [MADispatchQueue class]) {
        gGlobalQueue = [[MADispatchQueue alloc] initSerial: NO]; //全局队列被存储在一个全局变量中
        gThreadPool = [[MAThreadPool alloc] init]; //全局共享线程池存储在一个全局变量中
    }
}

+ (MADispatchQueue *)globalQueue {
    return gGlobalQueue;
}

/**
 *  初始化队列
 *
 *  @param serial <#serial description#>
 *
 *  @return <#return value description#>
 */
- (id)initSerial: (BOOL)serial {
    if ((self = [super init])) {
        _lock = [[NSLock alloc] init]; //创建锁
        _pendingBlocks = [[NSMutableArray alloc] init]; //创建待分配 block 队列
        _serial = serial;
    }
    return self;
}

- (void)dispatchAsync: (dispatch_block_t)block {
    [_lock lock];
    [_pendingBlocks addObject: block];
    
    if(_serial && !_serialRunning) { //如果一个串行队列是空闲的，把它的状态设置为正在运行
        _serialRunning = YES;
        [self dispatchOneBlock];
    } else if (!_serial) { //并发的，那么无条件地调用dispatchOneBlock
        [self dispatchOneBlock];
    }
    
    [_lock unlock];
}

- (void)dispatchSync: (dispatch_block_t)block {
    NSCondition *condition = [[NSCondition alloc] init];
    __block BOOL done = NO; //done变量来表示 block 什么时候执行完毕
    [self dispatchAsync: ^{ //异步的调度一个 block
        block();
        [condition lock];
        done = YES;
        [condition signal];
        [condition unlock];
    }];
    [condition lock];
    while (!done) {
        [condition wait];
    }
    [condition unlock];
}

/**
 *  在线程池中调度一个 block，然后再隐式地调用自身去执行另外一个 block
 *  添加的 block 会被创建，但是得等到正在处理的 block 完成才会被激活
 */
- (void)dispatchOneBlock {
    [gThreadPool addBlock: ^{
        [_lock lock];
        dispatch_block_t block = [_pendingBlocks firstObject];
        [_pendingBlocks removeObjectAtIndex: 0]; //获取到了队列中的第一个 block
        [_lock unlock];
        
        block();
        
        if(_serial) {
            [_lock lock];
            if([_pendingBlocks count] > 0) { //检查是否还有 block 在队列中等待
                [self dispatchOneBlock];
            } else {
                _serialRunning = NO; //队列的运行状态置为NO
            }
            [_lock unlock];
        }
    }];
}

@end
