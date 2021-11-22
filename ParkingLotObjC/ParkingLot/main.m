//
//  main.m
//  ParkingLot
//
//  Created by Mark Shen on 11/19/21.
//

#import <Foundation/Foundation.h>

@interface Vehicle : NSObject <NSCopying>
@property (nonatomic, strong) NSString* licensePlate;
@end

@implementation Vehicle

- (id)copyWithZone:(NSZone *)zone {
  Vehicle *newVehicle = [[[self class] allocWithZone:zone] init];
  if (newVehicle) {
    newVehicle.licensePlate = self.licensePlate;
  }
  return newVehicle;
}

@end


@interface ParkingLot : NSObject

- (instancetype)initWithLotSize:(int)lotSize;
- (BOOL)isLotFull;
- (BOOL)attemptToParkCar:(Vehicle *)car time:(float)time;
- (float)feesDueRetrievingCar:(Vehicle *)car time:(float)exitTime;

@end

@implementation ParkingLot {
  int _lotSize;
  NSMutableDictionary *_carLot;
  
}
- (instancetype)initWithLotSize:(int)lotSize {
  self = [super init];
  if (self) {
    _lotSize = lotSize;
    _carLot = [[NSMutableDictionary alloc] init];
  }
  return self;
}
- (BOOL)isLotFull {
  if ([_carLot count] >= _lotSize) {
    return YES;
  }
  return NO;
}
- (BOOL)attemptToParkCar:(Vehicle *)car time:(float)time {
  if ([self isLotFull]) {
    return NO;
  }
  NSNumber *entryTime = [NSNumber numberWithFloat:time];
  [_carLot setObject:entryTime forKey:car.licensePlate];
  return YES;
}


// Assume time is an int from 0 - 1440 where each unit is a minute.

- (float)feesDueRetrievingCar:(Vehicle *)car time:(float)exitTime {
  if ([_carLot valueForKey:car.licensePlate] == nil) {
    return 0;
  }
  NSNumber *entryTime = _carLot[car.licensePlate];
  float entryTimeFloat = [entryTime floatValue];
  float totalFee = 0;
  float hourlyRate[4];
  hourlyRate[0] = 0;
  hourlyRate[1] = 3;
  hourlyRate[2] = 1;
  hourlyRate[3] = 0;
//  NSMutableArray *timeRanges = [[NSMutableArray alloc] init];
  NSRange parkingTimeRanges[4];
  parkingTimeRanges[0] = NSMakeRange(0, 6);
  parkingTimeRanges[1] = NSMakeRange(6, 3); // 6 to 9
  parkingTimeRanges[2] = NSMakeRange(9, 3); // 9 to 12
  parkingTimeRanges[3] = NSMakeRange(12, 12);
  
//  [timeRanges insertObject:[NSMakeRange(0, 6)] atIndex:0];
//  [timeRanges insertObject:[NSMakeRange(6, 9)] atIndex:1];
//  [timeRanges insertObject:[NSMakeRange(6, 9)] atIndex:1];
  printf("entry time %f exit time %f total fee so far: %f\n", entryTimeFloat, exitTime, totalFee);
  for (int i = 0; i < 4; i++) {
    printf("entry time %f exit time %f total fee so far: %f, iterating on range %d to %d\n", entryTimeFloat, exitTime, totalFee, parkingTimeRanges[i].location, parkingTimeRanges[i].location + parkingTimeRanges[i].length);
    if (entryTimeFloat < (parkingTimeRanges[i].location + parkingTimeRanges[i].length)) {
      totalFee += hourlyRate[i] * ((parkingTimeRanges[i].location + parkingTimeRanges[i].length) - MAX(parkingTimeRanges[i].location, entryTimeFloat));
      printf("ADD Total fee is now %f\n", totalFee);
    }
    if (exitTime < parkingTimeRanges[i].location + parkingTimeRanges[i].length) {
      totalFee -= hourlyRate[i] * (parkingTimeRanges[i].location + parkingTimeRanges[i].length  - MAX(parkingTimeRanges[i].location, exitTime));
      printf("SUBTRACT Total fee is now %f\n", totalFee);
    }
  }
  return totalFee;
}

@end

int main(int argc, const char * argv[]) {
  @autoreleasepool {
      // insert code here...
      NSLog(@"Hello, World!");
    ParkingLot *myLot = [[ParkingLot alloc] initWithLotSize:5];
    Vehicle *vehicle = [[Vehicle alloc] init];
    vehicle.licensePlate =  @"Hello";
    [myLot attemptToParkCar:vehicle time:5];
    float fees = [myLot feesDueRetrievingCar:vehicle time:11.5];
    printf("The fees are %f\n", fees);
  }
  return 0;
}
