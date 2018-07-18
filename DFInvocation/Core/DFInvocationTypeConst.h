//
//  DFInvocationTypeConst.h
//  DFInvocation
//
//  Created by RaymondChen on 2018/7/17.
//  Copyright © 2018 DevilFinger. All rights reserved.
//

#import <Foundation/Foundation.h>


static NSInteger const DFInvocationArgumentIndexOffset = 2;

typedef NS_ENUM(char, DFArgumentTypePrefix) {
    /** const */
    DFArgumentTypePrefix_Const    = 'r',
    /** in */
    DFArgumentTypePrefix_In       = 'n',
     /** inout */
    DFArgumentTypePrefix_Inout    = 'N',
    /** out */
    DFArgumentTypePrefix_Out      = 'O',
    /** bycopy */
    DFArgumentTypePrefix_ByCopy   = 'o',
     /** byref */
    DFArgumentTypePrefix_ByRef    = 'R',
    /** oneway */
    DFArgumentTypePrefix_OneWay   = 'V',
    /** void */
    DFArgumentTypePrefix_Void              = 'v',
    /** bool */
    DFArgumentTypePrefix_Bool              = 'B',
    /** char */
    DFArgumentTypePrefix_Char              = 'c',
    /** unsigned char */
    DFArgumentTypePrefix_UnsignedChar      = 'C',
    /** short */
    DFArgumentTypePrefix_short             = 's',
    /** unsigned short */
    DFArgumentTypePrefix_UnsignedShort     = 'S',
    /** like "int" or "NSInterger"(but is 32bit) */
    DFArgumentTypePrefix_Int               = 'i',
    /** like "unsigned int" or "NSUInteger"(but is 32bit) */
    DFArgumentTypePrefix_UnsignedInt       = 'I',
    /** long(but is 32bit) */
    DFArgumentTypePrefix_Long              = 'l',
    /** unsigned long(but is 32bit) */
    DFArgumentTypePrefix_UnsignedLong      = 'L',
    /** "float" or "CGFloat"(but is 32bit) */
    DFArgumentTypePrefix_Float             = 'f',
    /** like "long long" or "long"(but is 64bit) or "NSInteger"(but is 64bit) */
    DFArgumentTypePrefix_Longlong          = 'q',
    /** like "unsigned long long" or "unsigned long"(but is 64bit) or "NSUInteger"(but is 64bit) */
    DFArgumentTypePrefix_UnsignedLonglong  = 'Q',
    /** like "double" or "CGFloat"(but is 64bit) */
    DFArgumentTypePrefix_Double            = 'd',
    /** char * */
    DFArgumentTypePrefix_CharPointer       = '*',
    /** pointer */
    DFArgumentTypePrefix_Pointer           = '^',
    /** id(all Objective-C object,like NSDictionary, NSArray, block...etc) */
    DFArgumentTypePrefix_ID                = '@',
    /** struct */
    DFArgumentTypePrefix_Struct            = '{',
    /** union */
    DFArgumentTypePrefix_Union             = '(',
    /** not sure type,may be is array(not "NSArray" or "NSMutableArray") */
    DFArgumentTypePrefix_Array             = '[',
    
};

