//: A UIKit based Playground for presenting user interface
import UIKit
import PlaygroundSupport



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

extension  ArrayAnimationView{
    func bubbleSort(_  array:inout [Int]){
        for _ in 0..<array.count {
            for j in 1..<array.count {
                //Compare two elements: so slide down
                if array[j] < array[j-1] {
                    let tmp = array[j-1]
                    array[j-1] = array[j]
                    array[j] = tmp
                    swapElements(arrayElements[j], arrayElements[j-1], j, j-1)
                }
                else{

                selectElements([arrayElements[j], arrayElements[j-1]], [true,true])
                down([arrayElements[j], arrayElements[j-1]])
                up([arrayElements[j], arrayElements[j-1]])

                selectElements([arrayElements[j], arrayElements[j-1]], [false,false])
                    
                }
            }
        }
    }

}

var a = [3,2,0,8,5,10,6,9]
var visualizer:ArrayAnimationView<Int> = ArrayAnimationView(frame: CGRect(x: 0, y: 0, width: 380, height: 50))

visualizer.displayArray(a)



class MyViewController : UIViewController {
    var visualizer:ArrayAnimationView<Int>!
    var button:UIButton!
    
  
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        self.view = view
        visualizer = ArrayAnimationView(frame: CGRect(x: 75, y: 20, width: 380, height: 50))
        self.view.addSubview(visualizer)
    
        button = UIButton()
        button.frame = CGRect(x: 120, y: 200, width: 125, height: 25)
        
        
        self.view.addSubview(button)
        
        button.addTarget(self, action: #selector(buttonPressed), for: UIControl.Event.touchUpInside)
        button.setTitle("Animate", for: .normal)
        button.backgroundColor = .blue

    }
    

    
    @objc func buttonPressed(){
        var a = [3,2,0,8,5,10,6]
        visualizer.resetAnimations()
        visualizer.displayArray(a)
        visualizer.bubbleSort(&a)
        visualizer.animateChanges()
     }
}




// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
