import Cocoa

let lunches = [
    "Cheeseburger",
    "Veggie Pizza",
    "Chicken Caesar Salad",
    "Black Bean Burrito",
    "Falafel Wrap"
]
var reversedLunch = [String]()
reversedLunch = lunches.reversed()

for lunchitem in lunches {
  print(String(format: "1 the lunch item is %@\n", lunchitem))
}

for lunchitem in reversedLunch {
  print(String(format: "the lunch item is %@\n", lunchitem))
}
var greeting = "Hello, playground"
