//
//  DFInvocationHelper.m
//  DFInvocation
//
//  Created by RaymondChen on 2018/7/18.
//  Copyright © 2018 DevilFinger. All rights reserved.
//

#import "DFInvocationHelper.h"


@implementation DFInvocationHelper
static DFInvocationHelper *_helper = nil;

+ (instancetype)sharedHelper
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _helper = [[DFInvocationHelper alloc] init];
    });
    return _helper;
}

-(instancetype) init
{
    self = [super init];
    if (self) {
        self.isCatchAndThrow = NO;
    }
    return self;
}


+(void)setMethodArgumentAtIndex:(NSInteger)index invocation:(NSInvocation *)inv methodSignature:(NSMethodSignature *)sig object:(id)obj
{
    if (sig. numberOfArguments <= index) {
        return;
    }
    
    char *type = (char *)[sig getArgumentTypeAtIndex:index];
    
    while (*type == DFArgumentTypePrefix_Const ||
           *type == DFArgumentTypePrefix_In ||
           *type == DFArgumentTypePrefix_Inout ||
           *type == DFArgumentTypePrefix_Out ||
           *type == DFArgumentTypePrefix_ByCopy ||
           *type == DFArgumentTypePrefix_ByRef ||
           *type == DFArgumentTypePrefix_OneWay) {
        /*all of this argument as the follow is useless prefix, should cutoff */
        type++;
    }
    
    BOOL unsupportedType = NO;
    switch (*type) {
        case DFArgumentTypePrefix_Void:
        case DFArgumentTypePrefix_Bool:
        case DFArgumentTypePrefix_Char:
        case DFArgumentTypePrefix_UnsignedChar:
        case DFArgumentTypePrefix_short:
        case DFArgumentTypePrefix_UnsignedShort:
        case DFArgumentTypePrefix_Int:
        case DFArgumentTypePrefix_UnsignedInt:
        case DFArgumentTypePrefix_Long:
        case DFArgumentTypePrefix_UnsignedLong:
        {
            // 'char' and 'short' will be promoted to 'int'.
            int value = [obj intValue];
            [inv setArgument:&value atIndex:index];
        }
            break;
            
        case DFArgumentTypePrefix_Longlong:
        case DFArgumentTypePrefix_UnsignedLonglong:
        {
            long long value = [obj longLongValue];
            [inv setArgument:&value atIndex:index];
        }
            break;
            
        case DFArgumentTypePrefix_Float:
        { // 'float' will be promoted to 'double'.
            double value = [obj doubleValue];
            float valuef = value;
            [inv setArgument:&valuef atIndex:index];
        }
            break;
            
        case DFArgumentTypePrefix_Double:
        {
            double value = [obj doubleValue];
            [inv setArgument:&value atIndex:index];
        }
            break;
            
        case DFArgumentTypePrefix_CharPointer:
        case DFArgumentTypePrefix_Pointer:
        {
            if ([obj isKindOfClass:UIColor.class]) {
                //Convert to CGColor
                obj = (id)[obj CGColor];
            }
            if ([obj isKindOfClass:UIImage.class]) {
                //Convert to CGImage
                obj = (id)[obj CGImage];
            }
            void *value = (__bridge void *)obj;
            [inv setArgument:&value atIndex:index];
        }
            break;
            
        case DFArgumentTypePrefix_ID:
        {
            id value = obj;
            [inv setArgument:&value atIndex:index];
        }
            break;
            
        case DFArgumentTypePrefix_Struct:
        {
            if (strcmp(type, @encode(CGPoint)) == 0) {
                CGPoint value = [obj CGPointValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGSize)) == 0) {
                CGSize value = [obj CGSizeValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGRect)) == 0) {
                CGRect value = [obj CGRectValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGVector)) == 0) {
                CGVector value = [obj CGVectorValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
                CGAffineTransform value = [obj CGAffineTransformValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(CATransform3D)) == 0) {
                CATransform3D value = [obj CATransform3DValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(NSRange)) == 0) {
                NSRange value = [obj rangeValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(UIOffset)) == 0) {
                UIOffset value = [obj UIOffsetValue];
                [inv setArgument:&value atIndex:index];
            } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
                UIEdgeInsets value = [obj UIEdgeInsetsValue];
                [inv setArgument:&value atIndex:index];
            } else {
                unsupportedType = YES;
            }
        }
            break;
            
        case DFArgumentTypePrefix_Union: // union
        {
            unsupportedType = YES;
        }
            break;
            
        case DFArgumentTypePrefix_Array: // array
        {
            unsupportedType = YES;
        }
            break;
            
        default: // what?!
        {
            unsupportedType = YES;
        }
            break;
    }
    
    if ([DFInvocationHelper sharedHelper].isCatchAndThrow) {
        const char *selName = sel_getName(inv.selector);
        NSString *msg = [NSString stringWithFormat:@"methon(%s) arguments in index(%@) is type(%s) is not support",selName,@(index),type];
        NSAssert(unsupportedType == NO, msg);
    }
    
}


+(id)getMethodReturnValueWithInv:(NSInvocation *)inv sig:(NSMethodSignature *)sig
{
    const char *returnType = sig.methodReturnType;
    
    __autoreleasing id returnValue = nil;
    
    if( !strcmp(returnType, @encode(void))){
        returnValue =  nil;
    }
    else if (!strcmp(returnType, @encode(id))){
        [inv getReturnValue:&returnValue];
    }
    else
    {
        NSUInteger length = [sig methodReturnLength];
        
        void *buffer = (void *)malloc(length);
        [inv getReturnValue:buffer];
        
        if( !strcmp(returnType, @encode(BOOL)) ) {
            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
        }
        else if( !strcmp(returnType, @encode(NSInteger)) ){
            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
        }
        else if( !strcmp(returnType, @encode(char)) ){
            returnValue = [NSNumber numberWithChar:*((char*)buffer)];
        }
        else if( !strcmp(returnType, @encode(unsigned char)) ){
            returnValue = [NSNumber numberWithUnsignedChar:*((unsigned char*)buffer)];
        }
        else if( !strcmp(returnType, @encode(short)) ){
            returnValue = [NSNumber numberWithShort:*((short*)buffer)];
        }
        else if( !strcmp(returnType, @encode(unsigned short)) ){
            returnValue = [NSNumber numberWithUnsignedShort:*((unsigned short*)buffer)];
        }
        else if( !strcmp(returnType, @encode(int)) ){
            returnValue = [NSNumber numberWithInt:*((int*)buffer)];
        }
        else if( !strcmp(returnType, @encode(unsigned int)) ){
            returnValue = [NSNumber numberWithUnsignedInt:*((unsigned int*)buffer)];
        }
        else if( !strcmp(returnType, @encode(long)) ){
            returnValue = [NSNumber numberWithLong:*((long*)buffer)];
        }
        else if( !strcmp(returnType, @encode(unsigned long)) ){
            returnValue = [NSNumber numberWithUnsignedLong:*((unsigned long*)buffer)];
        }
        else if( !strcmp(returnType, @encode(long long)) ){
            returnValue = [NSNumber numberWithLongLong:*((long long*)buffer)];
        }
        else if( !strcmp(returnType, @encode(unsigned long long)) ){
            returnValue = [NSNumber numberWithUnsignedLongLong:*((unsigned long long*)buffer)];
        }
        else if( !strcmp(returnType, @encode(float)) ){
            returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
        }
        else if( !strcmp(returnType, @encode(double)) ){
            returnValue = [NSNumber numberWithDouble:*((double*)buffer)];
        }
        else if( !strcmp(returnType, @encode(NSUInteger)) ){
            returnValue = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
        }
        else
            returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
    }
    return returnValue;
}



@end
