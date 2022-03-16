//
//  main.swift
//  TransactionCalculator
//
//  Created by Mark Shen on 3/6/22.
//

import Foundation

struct Transaction: Hashable, Equatable {
  var ticker: String?
  var price: Float?
  var qty: Float?
  var buyOrSell: String?
  var dateString: String?
  var date: Date?
  var adjustment: Float?
  var gainLoss: Float?
  var proceeds: Float?
  var costBasis: Float?
  var dateAcquired: String?
}



extension String {
  func fileName() -> String {
    return URL(fileURLWithPath:  self).deletingPathExtension().lastPathComponent
  }
  
  func fileExtension() -> String {
    return URL(fileURLWithPath: self).pathExtension
  }
}

func readCSV(inputFile: String, separator: String) -> [[String]] {
  let fileExtension = inputFile.fileExtension()
  let fileName = inputFile.fileName()
  
  let fileURL = try! FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
  
  let inputFile = fileURL.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
  
  var csvData = [[String]]()
  do {
    let wholeSheet = try! String(contentsOf: inputFile)
    let lines = wholeSheet.split(separator: "\r\n")
    for line in lines {
      var rowData = [String]()
      let columns = line.split(separator: ",")
      for column in columns {
        let column = String(column)
        rowData.append(column)
      }
      csvData.append(rowData)
    }
  }
  return csvData
}


//func processAllEntriesToDictionary(dictionary: Dictionary<String,[Transaction]>, csvData: [[String]]) -> Dictionary<String, [Transaction]> {
//  for line in csvData {
//    // Fourth column contains Ticker
//    if line[3].range(of: #"^[A-Za-z]{1,4}\b"#, options: .regularExpression) != nil {
//      var newTx = Transaction()
//      newTx.ticker = line[3]
//      newTx.price = Float(line[6])
//      newTx.qty = abs(Float(line[5])!)
//      let strategy = Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) \(hour: .twoDigits(clock: .twelveHour, hourCycle: .zeroBased)):\(minute: .twoDigits):\(second: .twoDigits)", timeZone: .current)
//      let date = try? Date("2020-07-14 12:00:00 AM,", strategy: strategy)
//      newTx.dateString = line[0]
//      newTx.buyOrSell = String(line[2])
//
//      if line[2] == "Buy" {
//        if (transactionDictionary[newTx.ticker!] != nil) {
//          transactionDictionary[newTx.ticker!]?.append(newTx)
//        } else {
//          var txQueue = [Transaction]()
//          txQueue.append(newTx)
//          transactionDictionary[newTx.ticker!] = txQueue
//        }
//      } else if line[2] == "Sell" {
//        newTx.buyOrSell = "Sell"
//        newTx.dateString = line[0]
//        var qtyAccum = newTx.qty!
//        var gainLoss : Float = 0
//        var txArray = transactionDictionary[newTx.ticker!]
//        while (qtyAccum > 0) {
//          var fifoTx = txArray?.first! as! Transaction
//          if fifoTx.qty == newTx.qty {
//            qtyAccum -= fifoTx.qty!
//            gainLoss += newTx.price! * newTx.qty! - fifoTx.price!*fifoTx.qty!
//            print(String(format: "%.2f sh of %@ Sold %@ at %.2f with cost basis %.2f, quantity %.2f, total gain/loss %.2f", fifoTx.qty!, newTx.ticker!, fifoTx.price!,  newTx.dateString!, newTx.ticker!, newTx.price!, fifoTx.price!, fifoTx.qty!, gainLoss))
//            newTx.qty! -= fifoTx.qty!
//            txArray?.removeFirst()
//
//          } else if fifoTx.qty! < newTx.qty! {
//            qtyAccum -= fifoTx.qty!
//            // Sell fifoTx.qty worth at this cost basis
//            gainLoss += newTx.price! * fifoTx.qty! - fifoTx.price!*fifoTx.qty!
//            print(String(format: "%@ Sold %@ at %.2f with cost basis %.2f, quantity %.2f, total gain/loss %.2f", newTx.dateString!, newTx.ticker!, newTx.price!, fifoTx.price!, fifoTx.qty!, gainLoss))
//            newTx.qty! -= fifoTx.qty!
//            txArray?.removeFirst()
//          } else if fifoTx.qty! > newTx.qty! {
//            qtyAccum -= newTx.qty!
//            // Sell newTx.qty worth at this cost basis
//            gainLoss += newTx.price! * newTx.qty! - fifoTx.price!*newTx.qty!
//            print(String(format: "%@ Sold %@ at %.2f with cost basis %.2f, quantity %.2f, total gain/loss %.2f", newTx.dateString!, newTx.ticker!, newTx.price!, fifoTx.price!, newTx.qty!, gainLoss))
//            fifoTx.qty! -= newTx.qty!
//            newTx.qty! = 0
//          }
//        }
//      }
//    }
//  }
//}


func createCSVFile(input: Dictionary<String,[Transaction]>) {
        var csvString = "Description Of Property, Date Acquired (yyyy-mm-dd), Date sold or Disposed of (yyyy-mm-dd), Proceeds, Cost or other basis, Code(s), Amount of Adjustment, Gain or (Loss)\n"
        for transaction in input {
          let txArray = transaction.value
          for printTx in txArray {
            let description = String(format:"%.2f sh of %@", printTx.qty!, printTx.ticker!)
            let dateAcq = String(format: "%@", printTx.dateAcquired!)
            let dateDisposed = String(format: "%@", printTx.dateString!)
            let proceeds = String(format: "%.2f", printTx.proceeds!)
            let costBasis = String(format: "%.2f", printTx.costBasis!)
            var code: String?
            var adjustments: String?
            if (printTx.adjustment! != 0) {
              code = "W"
              adjustments = String(format: "%.2f", printTx.adjustment!)
            }
            var gainLoss = String()
            if printTx.gainLoss! > 0 {
              gainLoss = String(format: "%.2f", printTx.gainLoss!)
            } else {
              gainLoss = String(format:"(%.2f)", abs(printTx.gainLoss!))
            }
            let dataString = "\(description),\(dateAcq),\(dateDisposed),\(proceeds),\(costBasis),\(code ?? " "),\(adjustments ?? " "),\(gainLoss)\n"
            print("DATA: \(dataString)")
            csvString = csvString.appending(dataString)
          }
        }

        let fileManager = FileManager.default
        do {
            let path = try fileManager.url(for: .documentDirectory, in: .allDomainsMask, appropriateFor: nil, create: false)
            print("PATH: \(path)")
            let fileURL = path.appendingPathComponent("CSVData.csv")
            try csvString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("error creating file")
        }
    }


// All
var finalTransactionBook = Dictionary<String,[Transaction]>()

// All buys are recorded here, and used to store FIFO order of shares. As shares are sold, they are
// removed from the queue, FIFO.
var transactionDictionary = Dictionary<String,[Transaction]>()
var buyFIFODictionary = Dictionary<String,[Transaction]>()
// All sales at a loss are put into this dictionary to use for reference for wash loss.
var sellLossFIFODictionary = Dictionary<String,[Transaction]>()

print("Hello, World!")
var myData = readCSV(inputFile: "input.csv", separator: ",")
//print (myData)

for line in myData {
  if line[3].range(of: #"^[A-Za-z]{1,4}$"#, options: .regularExpression) != nil {
//  if line[3].range(of: #"^[A-Za-z]{1,4}\b"#, options: .regularExpression) != nil {
//  if line[3].range(of: #"^[A-Za-z]{1,4}\W*$"#, options: .regularExpression) != nil {
    
//    print(String(format: "%@  %@ quantity %.2f\n", line[2], line[3],abs(Float(line[5])!)))
    var newTx = Transaction()
    newTx.ticker = line[3]
    newTx.price = Float(line[6])
    newTx.qty = abs(Float(line[5])!)
    let dateParse = line[0].split(separator: " ")
    let newDateString = dateParse[0];
    let strategy = Date.ParseStrategy(format: "\(year: .defaultDigits)-\(month: .twoDigits)-\(day: .twoDigits) ", timeZone: .current)
    let parsedDate = try? Date(newDateString, strategy: strategy)
    let dateFormatter = DateFormatter()
    dateFormatter.timeStyle = .none
    dateFormatter.dateStyle = .full
    dateFormatter.timeZone = TimeZone.current
    newTx.dateString = String(newDateString)
    newTx.date = parsedDate
    if line[2].caseInsensitiveCompare("Buy") == .orderedSame {
      if (sellLossFIFODictionary[newTx.ticker!] != nil) {
        var txArray = sellLossFIFODictionary[newTx.ticker!]
        var qtyAccum = newTx.qty!
        var totalAdjustment = 0
        newTx.adjustment = 0
        // Add wash loss adjustments.
        while (qtyAccum > 0 && txArray?.count ?? 0 > 0) {
          var fifoTx = txArray?.first! as! Transaction
          let numberOfDays = Calendar.current.dateComponents([.day], from: fifoTx.date!, to: newTx.date!)
          let actualNumberOfDays = numberOfDays.day! + 1
          // No wash losses because no tx within last 30 days
          if (actualNumberOfDays > 30) {
            qtyAccum = 0;
            txArray?.removeAll()
            break;
          } else {
            // Sell FIFO first tx has equal amount as sell lot.
            if fifoTx.qty == qtyAccum {
              qtyAccum -= fifoTx.qty!
              newTx.adjustment! += abs(fifoTx.gainLoss!)
//              print(String(format: "Adding a wash loss adjustment of %.2f from sale on %@ on ticker %@ qty %.2F for a loss of %.2f", abs(fifoTx.gainLoss!), fifoTx.dateString!, fifoTx.ticker!, fifoTx.qty!, fifoTx.gainLoss!))
              txArray?.removeFirst()
              sellLossFIFODictionary[fifoTx.ticker!] = txArray
            }
            // Buy FIFO first tx has LESS amount than sell lot.
            else if fifoTx.qty! < qtyAccum {
              qtyAccum -= fifoTx.qty!
              newTx.adjustment! += abs(fifoTx.gainLoss!)
//              print(String(format: "Adding a wash loss adjustment of %.2f from sale on %@ on ticker %@ qty %.2F for a loss of %.2f", abs(fifoTx.gainLoss!), fifoTx.dateString!, fifoTx.ticker!, fifoTx.qty!, fifoTx.gainLoss!))
              txArray?.removeFirst()
              sellLossFIFODictionary[fifoTx.ticker!] = txArray
            }
            // Buy FIFO first tx has MORE amount than sell lot.
            else if fifoTx.qty! > qtyAccum {
              newTx.adjustment! += abs((qtyAccum / fifoTx.qty!) * fifoTx.gainLoss!)
//              print(String(format: "Adding a wash loss adjustment of %.2f from sale on %@ on ticker %@ qty %.2F for a loss of %.2f", abs((qtyAccum / fifoTx.qty!) * fifoTx.gainLoss!), fifoTx.dateString!, fifoTx.ticker!, qtyAccum, fifoTx.gainLoss!))
              // Adjust the remaining loss in the sold transaction.
              fifoTx.gainLoss! += abs((qtyAccum / fifoTx.qty!) * fifoTx.gainLoss!)
              fifoTx.qty! -= qtyAccum
              txArray?.removeFirst()
              txArray?.insert(fifoTx, at: 0)
              sellLossFIFODictionary[fifoTx.ticker!] = txArray
              qtyAccum -= qtyAccum
            }
          }
        }
      }
      if (transactionDictionary[newTx.ticker!] != nil) {
        transactionDictionary[newTx.ticker!]?.append(newTx)
      } else {
        var txQueue = [Transaction]()
        txQueue.append(newTx)
        transactionDictionary[newTx.ticker!] = txQueue
      }
    } else if line[2].caseInsensitiveCompare("Sell") == .orderedSame {
      newTx.buyOrSell = "Sell"
      var qtyAccum = newTx.qty!
      var gainLoss : Float = 0
      var txArray = transactionDictionary[newTx.ticker!]
      // Figure out cost bases by dequeuing buy lots.
      while (qtyAccum > 0) {
        var fifoTx = txArray?.first! as! Transaction
        // Buy FIFO first tx has equal amount as sell lot.
        if fifoTx.qty == qtyAccum {
          qtyAccum -= fifoTx.qty!
          gainLoss = newTx.price! * newTx.qty! - fifoTx.price!*fifoTx.qty! - (fifoTx.adjustment ?? 0)
          var gainLossString: String?
          if (gainLoss >= 0) {
            gainLossString = String(format: "%.2f", gainLoss)
          } else {
            gainLossString = String(format: "(%.2f)", gainLoss)
          }
          print(String(format: "%.2f sh of %@, Proceeds: %.2f, Cost or other basis: %.2f, Amount of adjustment: %.2f, Date Acquired: %@, Date Disposed %@, Gain or (loss): %.2f ", fifoTx.qty!, newTx.ticker!,newTx.price! * newTx.qty!, fifoTx.price!*fifoTx.qty! + (fifoTx.adjustment ?? 0), fifoTx.adjustment ?? 0, fifoTx.dateString!, newTx.dateString!, gainLoss))
          // TODO Figure out if item was sold at a loss. If it was, record the total loss.
          if (gainLoss < 0) {
            var lossTx = Transaction()
            lossTx = newTx
            // Qty is the amount sold in this lot.
            lossTx.qty = newTx.qty
            lossTx.gainLoss = gainLoss
            if (sellLossFIFODictionary[lossTx.ticker!] != nil) {
              sellLossFIFODictionary[lossTx.ticker!]?.append(lossTx)
            } else {
              var txQueue = [Transaction]()
              txQueue.append(lossTx)
              sellLossFIFODictionary[newTx.ticker!] = txQueue
            }
          }

          // Store the final transaction including all proceeds, bases, sale date, ticker, qty, gain/loss, adjustments
          var finalTx = newTx
          finalTx.gainLoss = gainLoss
          finalTx.adjustment =  (fifoTx.adjustment ?? 0)
          finalTx.qty = fifoTx.qty!
          finalTx.proceeds = newTx.price! * newTx.qty!
          finalTx.costBasis = fifoTx.price!*fifoTx.qty!
          finalTx.adjustment = fifoTx.adjustment ?? 0
          finalTx.dateAcquired = fifoTx.dateString!
          
          if (finalTransactionBook[finalTx.ticker!] != nil) {
            finalTransactionBook[finalTx.ticker!]?.append(finalTx)
          } else {
            var txQueue = [Transaction]()
            txQueue.append(finalTx)
            finalTransactionBook[finalTx.ticker!] = txQueue
          }
          
          newTx.qty! -= fifoTx.qty!
          txArray?.removeFirst()
          transactionDictionary[fifoTx.ticker!] = txArray

        }
        // Buy FIFO first tx has LESS amount than sell lot.
        else if fifoTx.qty! < newTx.qty! {
          qtyAccum -= fifoTx.qty!
          // Sell fifoTx.qty worth at this cost basis
          gainLoss = newTx.price! * fifoTx.qty! - fifoTx.price!*fifoTx.qty! - (fifoTx.adjustment ?? 0)
          var gainLossString: String?
          if (gainLoss >= 0) {
            gainLossString = String(format: "%.2f", gainLoss)
          } else {
            gainLossString = String(format: "(%.2f)", gainLoss)
          }
          print(String(format: "%.2f sh of %@, Proceeds: %.2f, Cost or other basis: %.2f, Amount of adjustment: %.2f, Date Acquired: %@, Date Disposed %@, Gain or (loss): %.2f ", fifoTx.qty!, newTx.ticker!, newTx.price! * fifoTx.qty!, fifoTx.price!*fifoTx.qty! + (fifoTx.adjustment ?? 0), fifoTx.adjustment ?? 0, fifoTx.dateString!, newTx.dateString!, gainLoss))
          // TODO Figure out if item was sold at a loss.
          if (gainLoss < 0) {
            var lossTx = Transaction()
            lossTx = newTx
            // Qty is the amount sold in this lot.
            lossTx.qty = fifoTx.qty!
            lossTx.gainLoss = gainLoss
            if (sellLossFIFODictionary[lossTx.ticker!] != nil) {
              sellLossFIFODictionary[lossTx.ticker!]?.append(lossTx)
            } else {
              var txQueue = [Transaction]()
              txQueue.append(lossTx)
              sellLossFIFODictionary[lossTx.ticker!] = txQueue
            }
          }
          newTx.qty! -= fifoTx.qty!
          txArray?.removeFirst()
          transactionDictionary[fifoTx.ticker!] = txArray

          // Store the final transaction including all proceeds, bases, sale date, ticker, qty, gain/loss, adjustments
          var finalTx = newTx
          finalTx.gainLoss = gainLoss
          finalTx.adjustment =  (fifoTx.adjustment ?? 0)
          finalTx.qty! = fifoTx.qty!
          finalTx.proceeds = newTx.price! * fifoTx.qty!
          finalTx.costBasis = fifoTx.price! * fifoTx.qty!
          finalTx.adjustment = fifoTx.adjustment ?? 0
          finalTx.dateAcquired = fifoTx.dateString!
          
          if (finalTransactionBook[finalTx.ticker!] != nil) {
            finalTransactionBook[finalTx.ticker!]?.append(finalTx)
          } else {
            var txQueue = [Transaction]()
            txQueue.append(finalTx)
            finalTransactionBook[finalTx.ticker!] = txQueue
          }
          
        }
        // Buy FIFO first tx has MORE amount than sell lot.
        else if fifoTx.qty! > newTx.qty! {
          qtyAccum -= newTx.qty!
          // Sell newTx.qty worth at this cost basis
          let adjustment =  ((fifoTx.adjustment ?? 0) * (newTx.qty!/fifoTx.qty!))
          gainLoss = newTx.price! * newTx.qty! - fifoTx.price!*newTx.qty!  -  adjustment
          var gainLossString: String?
          if (gainLoss >= 0) {
            gainLossString = String(format: "%.02f", gainLoss)
          } else {
            gainLossString = String(format: "(%.02f)", gainLoss)
          }
          print(String(format: "%.2f sh of %@, Proceeds: %.2f, Cost or other basis: %.2f, Amount of adjustment: %.2f, Date Acquired: %@, Date Disposed %@, Gain or (loss): %.2f ", newTx.qty!, newTx.ticker!, newTx.price! * newTx.qty!, fifoTx.price!*newTx.qty! + adjustment, adjustment, fifoTx.dateString!, newTx.dateString!, gainLoss))
          // TODO Figure out if item was sold at a loss.
          if (gainLoss < 0) {
            var lossTx = Transaction()
            // Qty is the amount sold in this lot.
            lossTx = newTx
            lossTx.gainLoss = gainLoss
            if (sellLossFIFODictionary[lossTx.ticker!] != nil) {
              sellLossFIFODictionary[lossTx.ticker!]?.append(lossTx)
            } else {
              var txQueue = [Transaction]()
              txQueue.append(lossTx)
              sellLossFIFODictionary[newTx.ticker!] = txQueue
            }
          }

          // Store the final transaction including all proceeds, bases, sale date, ticker, qty, gain/loss, adjustments
          var finalTx = newTx
          finalTx.gainLoss = gainLoss
          finalTx.adjustment = adjustment
          finalTx.qty = newTx.qty!
          finalTx.proceeds = newTx.price! * newTx.qty!
          finalTx.costBasis = fifoTx.price! * newTx.qty!
          finalTx.adjustment = adjustment
          finalTx.dateAcquired = fifoTx.dateString!
          
          if (finalTransactionBook[finalTx.ticker!] != nil) {
            finalTransactionBook[finalTx.ticker!]?.append(finalTx)
          } else {
            var txQueue = [Transaction]()
            txQueue.append(finalTx)
            finalTransactionBook[finalTx.ticker!] = txQueue
          }

          fifoTx.qty! -= newTx.qty!
          if fifoTx.adjustment != nil {
            fifoTx.adjustment! -= adjustment
          }
          txArray?.removeFirst()
          txArray?.insert(fifoTx, at: 0)
          transactionDictionary[fifoTx.ticker!] = txArray
          newTx.qty! = 0
          
        }
      }
    }
  }
}
createCSVFile(input: finalTransactionBook)

//print("Ticker: ")
//var input : String?
//repeat {
//  input = readLine(strippingNewline: true)
//  var newTx:Transaction = Transaction()
//  newTx.ticker = input
//  print("Buy or Sell? (b/s): ")
//  while let buyOrSell = readLine() {
//    switch buyOrSell {
//    case "b":
//      newTx.buyOrSell = "b";
//      break;
//    case "s":
//      newTx.buyOrSell = "s";
//      break;
//    default:
//      print("not valid\n");
//    }
//    if (buyOrSell == "s" || buyOrSell == "b") {
//      break;
//    }
//  }
//  print ("Price? ")
//  let price = readLine(strippingNewline: true)
//  newTx.price = Float(price!)
//  if (newTx.buyOrSell == "b") {
//    var transactionArray : [Transaction]?
//    if transactionDictionary[newTx.ticker!] != nil {
//      transactionArray = transactionDictionary[newTx.ticker!]
//    } else {
//      transactionArray = [Transaction]()
//    }
//    transactionArray?.append(newTx)
//  }
//} while input != "!"
//

