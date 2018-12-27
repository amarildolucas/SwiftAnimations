import Foundation
import UIKit

public class Theme{
    static let selectedBackgroundColor:UIColor = .blue
    static let unselectedBackgroundColor:UIColor  = .clear
    static let selectedFontColor:UIColor = .white
    static let unselectedFontColor:UIColor  = .black
    static let width:CGFloat = 25;
    static let height:CGFloat = 25;
    static let horizontalTimeInterval:TimeInterval = 0.15
    static let verticalTimeInterval:TimeInterval = 0.15
    
}

public class Animation{
    let delay:TimeInterval
    let dx:[CGFloat]
    let dy:[CGFloat]
    let duration:TimeInterval
    let views:[UIView]
    var colors:[UIColor]?
    
    init(delay:TimeInterval, dx:[CGFloat], dy:[CGFloat], duration:TimeInterval, views:[UIView]) {
        self.delay = delay
        self.dx = dx
        self.dy = dy
        self.duration = duration
        self.views = views
    }
    
    convenience init(delay:TimeInterval, dx:[CGFloat], dy:[CGFloat], duration:TimeInterval, views:[UIView],colors:[UIColor]) {
        self.init(delay: delay, dx: dx, dy: dy, duration: duration, views: views )
        self.colors = colors
    }
}


public class ArrayElement:UILabel{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        styleIt()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func styleIt(){
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.textAlignment = .center
        
        
        
    }
}

public class ArrayAnimationView<Value:Comparable>:UIView{
    
   public var arrayElements = [ArrayElement]()
    var animations = [Animation]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    func getElement(_ value:Int)->ArrayElement?{
        let list = self.arrayElements.filter { (arrayElement) -> Bool in
            return arrayElement.text == "\(value)"
        }
        
        return list.first
    }
    
    func moveToIndex(_ value:Int, _ targetIndex:Int){
        guard let element = getElement(value) else{
            return
        }
        
        //check current index
        if let index = arrayElements.firstIndex(of: element)
        {
            moveToIndex(value, index, targetIndex)
        }
    }
    
    
   public func swapElements(_ value1:Int, _ value2:Int, index1:Int, index2:Int){
        
        //move elements down
        guard let element1 = getElement(value1), let element2 = getElement(value2) else{
            return
        }
        
        swapElements(element1, element2, index1, index2)
    }
    
     public func swapElements(_ element1:ArrayElement, _ element2:ArrayElement, _ index1:Int, _ index2:Int){
        selectElements([element1,element2], [true,true])
        moveVertically([element1,element2], false)
        moveHorizontally([element1,element2], [(index2 - index1),(index1 - index2)])
        moveVertically([element1,element2], true)
        
        //make sure that internal model is in check
        self.arrayElements.swapAt(index1, index2)
        
        //Deselect
        selectElements([element1,element2], [false,false])
    }
    
    
     public func moveToIndex(_ value:Int, _ currentIndex:Int, _ targetIndex:Int){
        
        guard let element = getElement(value) else{
            return
        }
        
        //select
        selectElements([element],[true])
        //move down
        moveVertically([element], false)
        //move horizontally
        
        moveHorizontally([element], [targetIndex - currentIndex])
        //        //move elements to make space
        //        //check if we are moving right or left
        if targetIndex > currentIndex{ //Shift elements to the left
            for i in currentIndex + 1 ... targetIndex{
                let el = self.arrayElements[i]
                moveHorizontally([el], [-1])
            }
        }
        else{
            for i in targetIndex ..< currentIndex{
                let el = self.arrayElements[i]
                //                print(el.text)
                moveHorizontally([el], [1])
            }
        }
        
        //move up
        moveVertically([element], true)
        
        //Deselect
        selectElements([element],[true])
        
        //remove and insert (cleanup internal data model)
        let r = arrayElements.remove(at: currentIndex)
        if(targetIndex == arrayElements.count){
            arrayElements.append(r)
        }
        else{
            arrayElements.insert(r, at: targetIndex)
        }
    }
    
    func styleIt(){
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 0.5
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public  func resetAnimations(){
        self.animations.removeAll()
    }
    
     public func displayArray(_ array:Array<Value>){
        
        for element in self.arrayElements{
            element.removeFromSuperview()
        }
        self.arrayElements.removeAll()
        
        
        for (index,element) in array.enumerated(){
            let frame = CGRect(x: CGFloat(index) * Theme.width, y: 20, width: Theme.width, height: Theme.height)
            let label = ArrayElement(frame: frame)
            label.text = "\(element)"
            self.addSubview(label)
            self.arrayElements.append(label)
        }
    }
    
    
    
     public func selectElements(_ elements:[ArrayElement], _ selected:[Bool]){
        
        var colors = [UIColor]()
        
        for (index,_) in elements.enumerated(){
            if selected[index]{
                colors.append(Theme.selectedBackgroundColor)
            }
            else{
                colors.append(Theme.unselectedBackgroundColor)
            }
        }
        
        let offsets = Array(repeating: CGFloat(0), count: elements.count)
        let animation = Animation(delay: 0, dx: offsets, dy: offsets, duration: 0.5, views: elements, colors: colors)
        animations.append(animation)
        
    }
    
     public func selectElement(_ value:Value){
        
        self.arrayElements.map { (arrayElement) -> ArrayElement in
            return arrayElement
        }
        
        _ = self.arrayElements.filter { (arrayElement) -> Bool in
            return arrayElement.text == "\(value)"
        }
        
        //        if let element = list.first{
        ////            element.selected = !element.selected
        //
        //        }
    }
    
    public  func up(_ element:ArrayElement){
        self.moveVertically([element], true)
    }
    
     public func up(_ elements:[ArrayElement]){
        self.moveVertically(elements, true)
    }
    
     public func down(_ element:ArrayElement){
        self.moveVertically([element], false)
    }
    
    public  func down(_ elements:[ArrayElement]){
        self.moveVertically(elements, false)
    }
    
     public func leftRight(_ element:ArrayElement, offset:Int){
        self.moveHorizontally([element], [offset])
    }
    
     public func leftRight(_ elements:[ArrayElement], offsets:[Int]){
        self.moveHorizontally(elements, offsets)
    }
    
    func moveVertically(_ elements:[ArrayElement], _ up:Bool){
        
        var dx = [CGFloat]()
        var dy = [CGFloat]()
        
        
        for element in elements{
            let offsetY =  up ? -element.frame.height : element.frame.height
            dy.append(offsetY)
            dx.append(0)
        }
        
        animations.append(Animation(delay: 0, dx: dx, dy: dy, duration: Theme.verticalTimeInterval, views: elements))
    }
    
    func moveHorizontally(_ elements:[ArrayElement], _ offset:[Int] ) -> Void{
        var dx = [CGFloat]()
        var dy = [CGFloat]()
        
        for (index,element) in elements.enumerated(){
            dy.append(0)
            dx.append(CGFloat(offset[index]) * element.frame.width)
        }
        
        animations.append(Animation(delay: 0, dx: dx, dy: dy, duration: Theme.horizontalTimeInterval, views: elements))
    }
    
    
    
     public func animateChanges(){
        let totalDuration = animations.reduce(0) { (result, animation) -> TimeInterval in
            return result + animation.duration
        }
        
        
        UIView.animateKeyframes(withDuration: totalDuration, delay: 0, options: .calculationModeLinear, animations: { [weak self] in
            var currentTime:TimeInterval = 0
            guard let weakself = self else{
                return
            }
            
            for animation in weakself.animations{
                
                let relativeDuration = animation.duration / totalDuration
                let elapsedTime = currentTime / totalDuration
                
                
                UIView.addKeyframe(withRelativeStartTime: elapsedTime , relativeDuration: relativeDuration, animations: {
                    print("Relative Duration: \(relativeDuration)")
                    print("Current Time: \(currentTime)")
                    print("Elapsed Time: \(elapsedTime)")
                    
                    for (index, view) in animation.views.enumerated(){
                        view.frame = view.frame.offsetBy(dx: animation.dx[index], dy: animation.dy[index])
                        
                        
                        if let colors = animation.colors{
                            
                            if let v = view as? ArrayElement{
                                if colors[index] == Theme.selectedBackgroundColor
                                {
                                    view.layer.backgroundColor = Theme.selectedBackgroundColor.cgColor
                                    v.textColor = Theme.selectedFontColor
                                }
                                else{
                                    view.layer.backgroundColor = Theme.unselectedBackgroundColor.cgColor
                                    v.textColor = Theme.unselectedFontColor
                                }
                            }
                        }
                    }
                })
                currentTime = currentTime + animation.duration
            }
        }) { (completed) in
            if completed{
                
            }
        }
    }
}
