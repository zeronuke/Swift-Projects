//
//  main.swift
//  ParkingLotSwift
//
//  Created by Mark Shen on 11/21/21.
//

import Foundation

class Vehicle {
  var licensePlate: String
  
  init(licensePlate: String) {
    self.licensePlate = licensePlate
  }
}

class ParkingLot {
  var lot: Dictionary<String, Float>
  var lotSize: Int
  
  init(lotSize: Int) {
    self.lot = Dictionary<String, Float>()
    self.lotSize = lotSize
  }
  
  func parkCar(vehicle: Vehicle, time:Float) {
    if (lot.count >= lotSize || lot[vehicle.licensePlate] != nil) {
      print(String(format: "This lot cannot park this vehicle.\n"));
    }
    lot[vehicle.licensePlate] = time;
  }
  
  func retrieveCar(vehicle: Vehicle, exitTime:Float) -> Float {
    var total: Float = 0
    var feeRates:[Float] = [0, 3, 1, 0]
    var timeRanges:[ClosedRange<Float>] = [(0...6), (6...9), (9...12),(12...24)]
    guard let startTime = lot[vehicle.licensePlate] else {
      return 0
    }
   
    for index in 0...timeRanges.count-1 {
      if (startTime < timeRanges[index].upperBound) {
        total += (timeRanges[index].upperBound - max(startTime, timeRanges[index].lowerBound)) * feeRates[index]
      }
      if (exitTime < timeRanges[index].upperBound) {
        total -= (timeRanges[index].upperBound - max(exitTime, timeRanges[index].lowerBound)) * feeRates[index]
      }
    }
    return total
  }
}

var myCar:Vehicle = Vehicle.init(licensePlate: "hello")
var myLot:ParkingLot = ParkingLot.init(lotSize: 5)
myLot.parkCar(vehicle: myCar, time: 6)
let fees = myLot.retrieveCar(vehicle: myCar, exitTime: 12)
print("The fees are ", fees)

print("Hello, World!")

