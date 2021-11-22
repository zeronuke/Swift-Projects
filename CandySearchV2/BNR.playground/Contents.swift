import UIKit

var bucketList: Array<String>
var bucketList2 = ["Climb mt everst"]
bucketList2.append("Read war and peace")
bucketList2.count
bucketList2.remove(at: 0)
bucketList2.count
bucketList2
bucketList2.insert("Toboggan across Alaska", at: 1)
bucketList2.insert("Eat Candyland Grapes", at: 1)
bucketList2.insert("Visit the great bridge troll", at: 1)
bucketList2.insert("Swim the atlantic ocean", at: 1)

var reversedBucketList = [String]()
for item in bucketList2 {
  reversedBucketList.insert(item, at: 0)
}
bucketList2
reversedBucketList
