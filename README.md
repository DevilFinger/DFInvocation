# DFInvocation
### This project is a reference to other people's code. If I use your code, please let me know.

This project is developed on the basis of NSInvocation. A dynamic call function that can be used for multiple parameters.
At the same time,get the return value of the function .

## Require
* iOS 8.0+
* Objective-C

## Installation

There are two ways to use DFInvocation in your project:

* using CocoaPods
* by cloning the project into your repository

### Installation with CocoaPods
[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries in your projects. See the [Get Started](http://cocoapods.org/#get_started) section for more details.

### Podfile

```
platform :ios, '8.0'
target "ProjectName" do
pod 'DFInvocation' '1.0.0'
end
```

## How to Use
**Import the header file**

```
#import "NSObject+DFInvocation.h"
```

**Call the method which without arguments,just like this :**

```
[self dfPerformSelector:@selector(customClassMethodWithoutArgument)];
```

**Call the method which with only one argument, just like this:**

```
NSArray *arguments = @[@"i am argumen 1", @"i am argumen 2"];
NSArray *resutlA = [self dfPerformSelector:@selector(customClassMethodWithOneArgument:) argument:arguments];
```

**If the method has many arguments,your could call like this:**

```
NSArray *arguments = @[@"i am argumen 1", @"i am argumen 2"];
NSArray *argumentsEx = @[arguments, @(1), @(CGRectMake(0, 0, 100, 200))];
NSArray *resutlEx = [self dfPerformSelector:@selector(customClassMethodWithManyArguments:argument2:argument3:) arguments:argumentsEx];
```
**when the method argument is block, you could call like this:**

First of all, Declaring "block"

```
void (^blk)(NSInteger ) = ^(NSInteger count) {
    NSLog(@"block %@", @(count));
};
```

and then call **dfPerformSelector** like this:

```
[self  dfPerformSelector:@selector(block:) argument:blk];
```

**In the same time, if the method will return value, "dfPerformSelector" also return it.**


##How to Catch An Error
###If your want to catch error when perform selector is mistake, you should change this to "YES".(Default is "NO")

```
[DFInvocationHelper sharedHelper].isCatchAndThrow = YES;
```

###For more usage, see the code in the project






## Communication
- If you **found a bug**, open an issue please.
- If you **have a feature request**, open an issue please.

## Licenses
All source code is licensed under the [MIT License](https://github.com/DevilFinger/DFInvocation/blob/master/LICENSE).
