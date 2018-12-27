# SwiftAnimations

### Description
SwiftAnimations it's library created to visualize changes to array. It might be a helpful tool for studying  sorting algorithms. 

The source code contains example of using the library with bubble sort. 

Here is original Bubble Sort code copied from awesome Swift Algorithms Club: https://github.com/raywenderlich/swift-algorithm-club

```

func originalBubbleSort(_  array:inout [Int]){
    for _ in 0..<array.count {
        for j in 1..<array.count {
            if array[j] < array[j-1] {
                let tmp = array[j-1]
                array[j-1] = array[j]
                array[j] = tmp
            }
        }
    }
}
```
In order to use library you have to:
1, Create an instance of the library
```let visualizer:ArrayAnimationView<Int> = ArrayAnimationView(frame: CGRect(x: 0, y: 0, width: 380, height: 50))```
2. Add it to the view
``` self.view.addSubview(visualizer) ```
3. Display array  

```
    var a = [3,2,0,8,5,10,6,9]
    visualizer.displayArray(a)
```

4. Create an extension with animation:


