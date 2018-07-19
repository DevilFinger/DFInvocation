//
//  NSObject+DFInvocation.m
//  DevilFinger Team
//
//  Created by RaymondChen on 15/03/2018.
//  Copyright © 2018 DevilFinger Team. All rights reserved.
//

#import "NSObject+DFInvocation.h"


@implementation NSObject (DFDynamicSelector)


-(void)dfPerformSelectorWithKeyPath:(NSString *)keyPath value:(id)value
{
    if (!value) { return;}
    if (!keyPath || keyPath.length <= 0) { return;}
    
    id keyPahtObj = [self valueForKeyPath:keyPath];
    if (keyPahtObj) {
        [self setValue:value forKeyPath:keyPath];
    }
}

-(id)dfPerformSelector:(SEL)sel
{
    NSArray *args = [NSArray array];
    return [self dfPerformSelector:sel arguments:args];
}



-(id)dfPerformSelector:(SEL)sel argument:(id)argument
{
    NSArray *args = nil;
    if(!argument)
        args = [NSArray array];
    else
        args = @[argument];
    return [self dfPerformSelector:sel arguments:args];
}


-(id)dfPerformSelector:(SEL)sel arguments:(NSArray *)arguments
{
    if (!arguments) {
        arguments = [NSArray array];
    }
    
    NSMethodSignature * sig = [self methodSignatureForSelector:sel];
    ///Oops, I cant remember why i should wrote this line code
    [sig isOneway];
    
    if (!sig){
        if ([DFInvocationHelper sharedHelper].isCatchAndThrow) {
            [self doesNotRecognizeSelector:sel];
        }
        else
           return nil;
    }
    
    NSInvocation *inv = [NSInvocation invocationWithMethodSignature:sig];
    if (!inv){
        if ([DFInvocationHelper sharedHelper].isCatchAndThrow) {
            [self doesNotRecognizeSelector:sel];
        }
        else
            return nil;
    }
    
    [inv setTarget:self];
    
    [inv setSelector:sel];
    //Because the argument index 0 and argument index 1  are for “selector”” and “target” to use
    if (sig.numberOfArguments == arguments.count + DFInvocationArgumentIndexOffset) {
        [arguments enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSInteger index = idx + DFInvocationArgumentIndexOffset;
            [DFInvocationHelper setMethodArgumentAtIndex:index invocation:inv methodSignature:sig object:obj];
        }];
        [inv invoke];
        id returnValue = nil;
        returnValue = [DFInvocationHelper getMethodReturnValueWithInv:inv sig:sig];
        return returnValue;
        
    } else {
        if ([DFInvocationHelper sharedHelper].isCatchAndThrow) {
            const char *selName = sel_getName(sel);
            NSString *msg = [NSString stringWithFormat:@"the number of arguments your give(%@) is not match the number of arguments(%@) of the method(%s)",@(arguments.count), @(sig.numberOfArguments), selName];
            NSAssert(NO, msg);
        }
        return nil;
    }
}

//-(id)getReturnValueWithInv:(NSInvocation *)inv sig:(NSMethodSignature *)sig
//{
//    const char *returnType = sig.methodReturnType;
//    __autoreleasing id returnValue = nil;
//    if( !strcmp(returnType, @encode(void)))//如果没有返回值，也就是消息声明为void，那么returnValue=nil
//    { returnValue =  nil;}
//    else if (!strcmp(returnType, @encode(id)))//如果返回值为对象，那么为变量赋值
//    { [inv getReturnValue:&returnValue];}
//    else//如果返回值为普通类型NSInteger  BOOL
//    {
//        NSUInteger length = [sig methodReturnLength];
//        //根据长度申请内存
//        void *buffer = (void *)malloc(length);
//        [inv getReturnValue:buffer];
//        if( !strcmp(returnType, @encode(BOOL)) ) {
//            returnValue = [NSNumber numberWithBool:*((BOOL*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(NSInteger)) ){
//            returnValue = [NSNumber numberWithInteger:*((NSInteger*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(char)) ){
//            returnValue = [NSNumber numberWithChar:*((char*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(unsigned char)) ){
//            returnValue = [NSNumber numberWithUnsignedChar:*((unsigned char*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(short)) ){
//            returnValue = [NSNumber numberWithShort:*((short*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(unsigned short)) ){
//            returnValue = [NSNumber numberWithUnsignedShort:*((unsigned short*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(int)) ){
//            returnValue = [NSNumber numberWithInt:*((int*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(unsigned int)) ){
//            returnValue = [NSNumber numberWithUnsignedInt:*((unsigned int*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(long)) ){
//            returnValue = [NSNumber numberWithLong:*((long*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(unsigned long)) ){
//            returnValue = [NSNumber numberWithUnsignedLong:*((unsigned long*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(long long)) ){
//            returnValue = [NSNumber numberWithLongLong:*((long long*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(unsigned long long)) ){
//            returnValue = [NSNumber numberWithUnsignedLongLong:*((unsigned long long*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(float)) ){
//            returnValue = [NSNumber numberWithFloat:*((float*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(double)) ){
//            returnValue = [NSNumber numberWithDouble:*((double*)buffer)];
//        }
//        else if( !strcmp(returnType, @encode(NSUInteger)) ){
//            returnValue = [NSNumber numberWithUnsignedInteger:*((NSUInteger*)buffer)];
//        }
//        else
//            returnValue = [NSValue valueWithBytes:buffer objCType:returnType];
//    }
//    return returnValue;
//}
//
//-(void)setInv:(NSInvocation *)inv Sig:(NSMethodSignature *)sig Obj:(id)obj Index:(NSInteger)index{
//    
//    if (sig.numberOfArguments <= index) return;
//    
//    char *type = (char *)[sig getArgumentTypeAtIndex:index];
//    
//    while (*type == 'r' || // const
//           *type == 'n' || // in
//           *type == 'N' || // inout
//           *type == 'o' || // out
//           *type == 'O' || // bycopy
//           *type == 'R' || // byref
//           *type == 'V') { // oneway
//        type++; // cutoff useless prefix
//    }
//    
//    BOOL unsupportedType = NO;
//    switch (*type) {
//        case 'v': // 1: void
//        case 'B': // 1: bool
//        case 'c': // 1: char / BOOL
//        case 'C': // 1: unsigned char
//        case 's': // 2: short
//        case 'S': // 2: unsigned short
//        case 'i': // 4: int / NSInteger(32bit)
//        case 'I': // 4: unsigned int / NSUInteger(32bit)
//        case 'l': // 4: long(32bit)
//        case 'L': // 4: unsigned long(32bit)
//        { // 'char' and 'short' will be promoted to 'int'.
//            int value = [obj intValue];
//            [inv setArgument:&value atIndex:index];
//        } break;
//            
//        case 'q': // 8: long long / long(64bit) / NSInteger(64bit)
//        case 'Q': // 8: unsigned long long / unsigned long(64bit) / NSUInteger(64bit)
//        {
//            long long value = [obj longLongValue];
//            [inv setArgument:&value atIndex:index];
//        } break;
//            
//        case 'f': // 4: float / CGFloat(32bit)
//        { // 'float' will be promoted to 'double'.
//            double value = [obj doubleValue];
//            float valuef = value;
//            [inv setArgument:&valuef atIndex:index];
//        } break;
//            
//        case 'd': // 8: double / CGFloat(64bit)
//        {
//            double value = [obj doubleValue];
//            [inv setArgument:&value atIndex:index];
//        } break;
//            
//        case '*': // char *
//        case '^': // pointer
//        {
//            if ([obj isKindOfClass:UIColor.class]) obj = (id)[obj CGColor]; //CGColor转换
//            if ([obj isKindOfClass:UIImage.class]) obj = (id)[obj CGImage]; //CGImage转换
//            void *value = (__bridge void *)obj;
//            [inv setArgument:&value atIndex:index];
//        } break;
//            
//        case '@': // id
//        {
//            id value = obj;
//            [inv setArgument:&value atIndex:index];
//        } break;
//            
//        case '{': // struct
//        {
//            if (strcmp(type, @encode(CGPoint)) == 0) {
//                CGPoint value = [obj CGPointValue];
//                [inv setArgument:&value atIndex:index];
//            } else if (strcmp(type, @encode(CGSize)) == 0) {
//                CGSize value = [obj CGSizeValue];
//                [inv setArgument:&value atIndex:index];
//            } else if (strcmp(type, @encode(CGRect)) == 0) {
//                CGRect value = [obj CGRectValue];
//                [inv setArgument:&value atIndex:index];
//            } else if (strcmp(type, @encode(CGVector)) == 0) {
//                CGVector value = [obj CGVectorValue];
//                [inv setArgument:&value atIndex:index];
//            } else if (strcmp(type, @encode(CGAffineTransform)) == 0) {
//                CGAffineTransform value = [obj CGAffineTransformValue];
//                [inv setArgument:&value atIndex:index];
//            } else if (strcmp(type, @encode(CATransform3D)) == 0) {
//                CATransform3D value = [obj CATransform3DValue];
//                [inv setArgument:&value atIndex:index];
//            } else if (strcmp(type, @encode(NSRange)) == 0) {
//                NSRange value = [obj rangeValue];
//                [inv setArgument:&value atIndex:index];
//            } else if (strcmp(type, @encode(UIOffset)) == 0) {
//                UIOffset value = [obj UIOffsetValue];
//                [inv setArgument:&value atIndex:index];
//            } else if (strcmp(type, @encode(UIEdgeInsets)) == 0) {
//                UIEdgeInsets value = [obj UIEdgeInsetsValue];
//                [inv setArgument:&value atIndex:index];
//            } else {
//                unsupportedType = YES;
//            }
//        } break;
//            
//        case '(': // union
//        {
//            unsupportedType = YES;
//        } break;
//            
//        case '[': // array
//        {
//            unsupportedType = YES;
//        } break;
//            
//        default: // what?!
//        {
//            unsupportedType = YES;
//        } break;
//    }
//    NSAssert(unsupportedType == NO, @"方法的参数类型暂不支持");
//}

@end
