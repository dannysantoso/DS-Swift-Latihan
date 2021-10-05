import UIKit

// BINARY SEARCH -----------------------------------------------------------------------------------------------------------------------------------------

let array = [1,2,4,6,8,9,11,13,16,17,20]

func binarySearch(searchValue: Int, array: [Int]) -> Bool {
    var leftIndex = 0
    var rightIndex = array.count - 1
    
    while leftIndex <= rightIndex {
        
        let middleIndex = (leftIndex + rightIndex) / 2
        let middleValue = array[middleIndex]
        
        if searchValue == middleValue {
            return true
        }
        
        if searchValue < middleValue {
            rightIndex = middleIndex - 1
        }
        
        if searchValue > middleValue {
            leftIndex = middleIndex + 1
        }
    }
    return false
}

print(binarySearch(searchValue: 10, array: array))

// LINEAR SEARCH -----------------------------------------------------------------------------------------------------------------------------------------

func linearSearch(searchValue: Int, array: [Int]) -> Bool {
    for i in array {
        if i == searchValue {
            return true
        }
    }
    return false
}

print(linearSearch(searchValue: 10, array: array))

// LINKED LIST -----------------------------------------------------------------------------------------------------------------------------------------

class NodeList {
    let value: Int
    var next: NodeList?
    
    init(value: Int, next: NodeList?) {
        self.value = value
        self.next = next
    }
}

class LinkedList {
    
    var head: NodeList?
    
    func setupDummyNodes() {
        let three = NodeList(value: 3, next: nil)
        let two = NodeList(value: 2, next: three)
        head = NodeList(value: 1, next: two)
    }
    
    func displayListItems() {
        print("Here is whats inside of your list:")
        var current = head
        while current != nil {
            print(current?.value ?? "")
            current = current?.next
        }
    }
    
    func insert(value: Int) {
        // empty list
        if head == nil {
            head = NodeList(value: value, next: nil)
            return
        }
        
        var current = head
        while current?.next != nil {
            current = current?.next
        }
        current?.next = NodeList(value: value, next: nil)
    }
    
    // #2 Delete
    func delete(value: Int) {
        if head?.value == value {
            head = head?.next
        }
        
        var prev: NodeList?
        var current = head
        
        while current != nil && current?.value != value  {
            prev = current
            current = current?.next
        }
        
        prev?.next = current?.next
    }
    
    // "Special Insert"
    // // 1 -> 2 -> 4 -> 5 -> nil
    func insertInOrder(value: Int) {
        if head == nil || head?.value ?? Int.min >= value {
            let newNode = NodeList(value: value, next: head)
            head = newNode
            return
        }
        var currentNode: NodeList? = head
        while currentNode?.next != nil && currentNode?.next?.value ?? Int.min < value {
            currentNode = currentNode?.next
        }
        
        currentNode?.next = NodeList(value: value, next: currentNode?.next)
    }
}

let sampleList = LinkedList()
//sampleList.setupDummyNodes()
sampleList.insert(value: 1)
sampleList.insert(value: 2)
sampleList.insert(value: 4)
sampleList.insert(value: 5)
sampleList.insertInOrder(value: 3)
sampleList.displayListItems()


// BINARY TREE -----------------------------------------------------------------------------------------------------------------------------------------

// 1.
//          10
//         /  \
//        5    14
//       /    /  \
//      1    11   20

// 2.
class Node {
    let value: Int
    var leftChild: Node?
    var rightChild: Node?
    
    init(value: Int, leftChild: Node?, rightChild: Node?) {
        self.value = value
        self.leftChild = leftChild
        self.rightChild = rightChild
    }
}

//left branch
let oneNode = Node(value: 1, leftChild: nil, rightChild: nil)
let fiveNode = Node(value: 5, leftChild: oneNode, rightChild: nil)

//right branch
let elevenNode = Node(value: 11, leftChild: nil, rightChild: nil)
let twentyNode = Node(value: 20, leftChild: nil, rightChild: nil)
let fourteenNode = Node(value: 14, leftChild: elevenNode, rightChild: twentyNode)

let tenRootNode = Node(value: 10, leftChild: fiveNode, rightChild: fourteenNode)

//          10
//         /  \
//        5    14
//       /    /  \
//      1    11   20

// 3.
//Interviewer's question: Implement a search algorithm that searches through this tree for a particular searchValue
func search(node: Node?, searchValue: Int) -> Bool {
    if node == nil {
        return false
    }
    
    if node?.value == searchValue {
        return true
    } else if searchValue < node!.value {
        return search(node: node?.leftChild, searchValue: searchValue)
    } else {
        return search(node: node?.rightChild, searchValue: searchValue)
    }
}

search(node: tenRootNode, searchValue: 30)

// 4.
//What is the point of all this?

//let's talk about efficiency
let list = [1, 5, 10, 11, 14, 20]
let index = list.firstIndex(where: {$0 == 30})

// Morris, t = O(N), both average & worst s = O(1)
func inorderTraversal(_ r: Node?) -> [Int] {
    var root = r
    if root == nil {
        return []
    } else {
        var res: [Int] = []
        var pre: Node? = nil
        while root != nil {
            if root?.leftChild == nil {
                res.append((root?.value)!)
                root = root?.rightChild
            } else {
                pre = root?.leftChild
                while pre?.rightChild != nil && pre?.rightChild! !== root {
                    pre = pre?.rightChild
                }
                if pre?.rightChild == nil {
                    pre?.rightChild = root
                    root = root?.leftChild
                } else {
                    pre?.rightChild = nil
                    res.append((root?.value)!)
                    root = root?.rightChild
                }
            }
        }
        return res
    }
}

print(inorderTraversal(tenRootNode))

// Recursion, t = O(N), average s = O(log(N)), worst s = O(N)

func inorderTraversal_recursion_helper(root: Node?, arr: inout [Int]) {
    guard let root = root else { return }
    inorderTraversal_recursion_helper(root: root.leftChild, arr: &arr)
    arr.append(root.value)
    inorderTraversal_recursion_helper(root: root.rightChild, arr: &arr)
}

func inorderTraversal_recursion(_ root: Node?) -> [Int] {
    var res: [Int] = []
    inorderTraversal_recursion_helper(root: root, arr: &res)
    return res
}

print(inorderTraversal_recursion(tenRootNode))

// Recursion, t = O(N), average s = O(log(N)), worst s = O(N)

func preorderTraversal_recursion_helper(root: Node?, arr: inout [Int]) {
    guard let root = root else { return }
    arr.append(root.value)
    preorderTraversal_recursion_helper(root: root.leftChild, arr: &arr)
    preorderTraversal_recursion_helper(root: root.rightChild, arr: &arr)
}

func preorderTraversal_recursion(_ root: Node?) -> [Int] {
    var res: [Int] = []
    preorderTraversal_recursion_helper(root: root, arr: &res)
    return res
}

print(preorderTraversal_recursion(tenRootNode))

// Recursion, t = O(N), average s = O(log(N)), worst s = O(N)

func postorderTraversal_recursion_helper(root: Node?, arr: inout [Int]) {
    guard let root = root else { return }
    postorderTraversal_recursion_helper(root: root.leftChild, arr: &arr)
    postorderTraversal_recursion_helper(root: root.rightChild, arr: &arr)
    arr.append(root.value)
}

func postorderTraversal_recursion(_ root: Node?) -> [Int] {
    var res: [Int] = []
    postorderTraversal_recursion_helper(root: root, arr: &res)
    return res
}

print(postorderTraversal_recursion(tenRootNode))

// GENERIC STACK -----------------------------------------------------------------------------------------------------------------------------------------

class NodeStack<T> {
    let value: T
    var next: NodeStack?
    init(value: T) {
        self.value = value
    }
}

class Stack<T> {
    var top: NodeStack<T>?
    
    func push(_ value: T) {
        let oldTop = top
        top = NodeStack(value: value)
        top?.next = oldTop
    }
    
    func pop() -> T? {
        let currentTop = top
        top = top?.next
        return currentTop?.value
    }
    
    func peek() -> T? {
        return top?.value
    }
}

// LIFO STACK -----------------------------------------------------------------------------------------------------------------------------------------

print(lifoStack(arr : ["1","2","+","4","*"]))
print(lifoStack(arr : ["3","*","+","5","6"]))
print(lifoStack(arr : ["0","3","5","+","*","6","8","/","3","+","*"]))

func lifoStack(arr: [String]) -> String {
    var stackNumber: [String] = []
    var stackOperation: [String] = []
    var result = ""

    for i in arr {
        if isOperation(i) {
            stackOperation.append(i)
            if result != "" {
                let pop1 = stackNumber.popLast()
                let popOperation = stackOperation.popLast()
                result += " \(popOperation ?? "") \(pop1 ?? "")"
            } else {
                if stackNumber.count > 1 {
                    let pop1 = stackNumber.popLast()
                    let pop2 = stackNumber.popLast()
                    let popOperation = stackOperation.popLast()
                    result += "\(pop1 ?? "") \(popOperation ?? "") \(pop2 ?? "")"
                }
            }
        } else {
            stackNumber.append(i)
            if stackOperation.count > 1 {
                let pop1 = stackNumber.popLast()
                let pop2 = stackNumber.popLast()
                let popOperation = stackOperation.popLast()
                result += "\(pop1 ?? "") \(popOperation ?? "") \(pop2 ?? "")"
            } else {
                if result != "" && stackOperation.count != 0 {
                    let pop1 = stackNumber.popLast()
                    let popOperation = stackOperation.popLast()
                    result += " \(popOperation ?? "") \(pop1 ?? "")"
                }
            }
        }
    }
    return result
}

func isOperation(_ value: String) -> Bool {
    if String("+-*/").contains(value) {
        return true
    }
    return false
}

