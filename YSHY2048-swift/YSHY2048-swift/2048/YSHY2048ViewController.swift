//
//  YSHY2048ViewController.swift
//  YSHYSWift
//
//  Created by 杨淑园 on 2017/7/7.
//  Copyright © 2017年 杨淑园. All rights reserved.
//

import UIKit

class YSHY2048ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate {
    var mainScrollView:UICollectionView?
    var scoreLab:UILabel?
    var score:Int = 0
    var bestScroe:Int = 0
    var targetScore:Int = 2048
    var bestScoreLab:UILabel?
    var tipLab:UILabel?
    var myArray:NSMutableArray = NSMutableArray.init(capacity: 16)
    var visiableArray:NSMutableArray = NSMutableArray.init(capacity: 16)
    var top5List = [0,0,0,0,0]
    var isGameOver:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.creatUI()
        self.addGesture()
        self.getDataFromCacha()
        if(myArray.count > 0){
            mainScrollView?.reloadData()
            self.setLabText()
        }else{
            self.initData()
        }
    }
    
    func initData()  {
        for i in 0 ..< 4 {
            for j in 0..<4 {
                let obj:YSHY2048Obj = YSHY2048Obj.init()
                obj.title = 0
                obj.x = i
                obj.y = j
                myArray.add(obj)
            }
        }
        visiableArray = myArray.mutableCopy() as! NSMutableArray
        self.nextShow()
        self.nextShow()
    }
    
    func nextShow() {
        if(visiableArray.count <= 0)
        {
            print("游戏结束")
            self.gameOver()
            return
        }
        // 在可显示的数组中 获取下一个显示位置和数字
        let index = Int(arc4random_uniform(UInt32(visiableArray.count)))
        let title = Double(arc4random() % 1)  > 0.8 ? 4:2
        
        let obj:YSHY2048Obj = visiableArray[index] as! YSHY2048Obj
        // 获取显示的数据在数据源中的位置
        let tempIndex = myArray.index(of: obj)
        obj.title = title
        visiableArray.remove(obj)
        mainScrollView?.reloadItems(at: [IndexPath.init(row: tempIndex, section: 0)])
    }
    
    func saveToCacha() {
        let defualt: UserDefaults =  UserDefaults.standard
        defualt.set(score, forKey: "score")
        defualt.set(bestScroe, forKey: "bestScroe")
        defualt.set(top5List, forKey: "top5List")
        let top5ListArchiver = NSKeyedArchiver.archivedData(withRootObject: top5List)
        defualt.set(top5ListArchiver, forKey: "top5List")
        
        let myArrayArchiver = NSKeyedArchiver.archivedData(withRootObject: myArray)
        defualt.set(myArrayArchiver, forKey: "myArray")
        
        let visiableArrayArchiver = NSKeyedArchiver.archivedData(withRootObject: visiableArray)
        defualt.set(visiableArrayArchiver, forKey: "visiableArray")
        defualt.synchronize()
    }
    func getDataFromCacha()
    {
        let defualt: UserDefaults =  UserDefaults.standard
        bestScroe = defualt.integer(forKey: "bestScroe")
        score = defualt.integer(forKey: "score")
        
        if let top5ListData = defualt.array(forKey: "top5List") {
            top5List = top5ListData as! [Int]
        }
        
        let myArrayData = defualt.object(forKey: "myArray")
        if let myArrayDecode = myArrayData {
            myArray = NSKeyedUnarchiver.unarchiveObject(with: myArrayDecode as! Data) as! NSMutableArray
        }
        
        let visiableArrayData = defualt.value(forKey: "visiableArray")
        if let visiableArraydecode = visiableArrayData {
            visiableArray = (NSKeyedUnarchiver.unarchiveObject(with: visiableArraydecode as! Data) as! NSMutableArray)
        }
    }
    
    func reStart() {
        self.saveToCacha()
        score = 0;
        self.setLabText()
        myArray.removeAllObjects()
        visiableArray.removeAllObjects()
        mainScrollView?.reloadData()
        self.initData()
    }
    
    func setLabText() {
        scoreLab?.text = "分数\n\(score)"
        bestScoreLab?.text = "历史最高分数\n\(bestScroe)"
    }
    
    func getLab(text:String, frame:CGRect,textColor:UIColor,font:CGFloat,backgroundColor:UIColor ) -> UILabel {
        let lab = UILabel.init(frame: frame)
        self.view.addSubview(lab)
        lab.text = text
        lab.layer.cornerRadius = 5
        lab.layer.masksToBounds = true
        lab.textColor = textColor
        lab.backgroundColor = backgroundColor
        lab.textAlignment = NSTextAlignment.center
        if #available(iOS 8.2, *) {
            lab.font = UIFont.systemFont(ofSize: font, weight: 10)
        } else {
            // Fallback on earlier versions
            lab.font = UIFont.systemFont(ofSize: font)
        }
        return lab
        
    }
    
    func creatUI() -> Void {
        self.view.backgroundColor = UIColor.white
        
        _ = self.getLab(text: "2048", frame: CGRect(x: 15, y: 25, width: 120, height: 120), textColor: UIColor.white, font: 28, backgroundColor: UIColor.init(colorLiteralRed: 238/255.0, green:220/255.0, blue:25/255.0,alpha:1))
        
        scoreLab = self.getLab(text: "分数\n\(score)", frame: CGRect(x: 150, y: 25, width: 90, height: 70), textColor: UIColor.white, font: 15, backgroundColor: UIColor.init(colorLiteralRed: 187/255.0, green:174/255.9, blue:162/255.0, alpha:1))
        scoreLab?.numberOfLines = 2
        
        bestScoreLab = self.getLab(text: "历史最高分数\n\(bestScroe)", frame: CGRect(x: 255, y: 25, width: 90, height: 70), textColor: UIColor.white, font: 13, backgroundColor: UIColor.init(colorLiteralRed: 187/255.0, green:174/255.9, blue:162/255.0, alpha:1))
        bestScoreLab?.numberOfLines = 2
        
        let menuBtn:UIButton = UIButton.init(type: UIButtonType.custom)
        menuBtn.frame = CGRect(x: 150, y: 110, width: 90, height: 30)
        menuBtn.layer.cornerRadius = 5
        menuBtn.layer.masksToBounds = true
        menuBtn.backgroundColor = UIColor.init(colorLiteralRed:238/255.0, green:113/255.0, blue:63/255.0, alpha:1)
        menuBtn.setTitle("菜单", for: UIControlState.normal)
        menuBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        menuBtn.addTarget(self, action: #selector(gameStop), for: UIControlEvents.touchUpInside)
        self.view.addSubview(menuBtn)
        
        let bestScrolBtn:UIButton = UIButton.init(type: UIButtonType.custom)
        bestScrolBtn.frame = CGRect(x: 250, y: 110, width: 90, height: 30)
        bestScrolBtn.layer.cornerRadius = 5
        bestScrolBtn.layer.masksToBounds = true
        bestScrolBtn.backgroundColor = UIColor.init(colorLiteralRed:238/255.0, green:113/255.0, blue:63/255.0, alpha:1)
        bestScrolBtn.setTitle("排行榜", for: UIControlState.normal)
        bestScrolBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        bestScrolBtn.addTarget(self, action: #selector(bestScoreList), for: UIControlEvents.touchUpInside)
        self.view.addSubview(bestScrolBtn)
        
        
        tipLab = self.getLab(text: "您的新挑战是获得\(targetScore)方块", frame: CGRect(x: 15, y: 160, width: self.view.frame.size.width - 30, height: 25), textColor: UIColor.white, font: 20, backgroundColor:UIColor.white)
        tipLab?.textColor =  UIColor.init(colorLiteralRed:187/255.0, green:174/255.9, blue:162/255.0, alpha:1)
        tipLab?.numberOfLines = 2
        tipLab?.layer.masksToBounds = false
        tipLab?.textAlignment = NSTextAlignment.left
        
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsetsMake(18, 10, 0, 10)
        
        mainScrollView = UICollectionView.init(frame: CGRect(x: 10, y: 200, width: self.view.frame.size.width - 20, height: self.view.frame.size.width - 20), collectionViewLayout: layout)
        mainScrollView?.bounces = false  //  关闭弹簧效果
        self.view.addSubview(mainScrollView!)
        mainScrollView?.isPagingEnabled = true
        mainScrollView?.dataSource = self
        mainScrollView?.delegate = self
        mainScrollView?.backgroundColor = UIColor.init(colorLiteralRed:187/255.0, green:174/255.9, blue:162/255.0, alpha:1)
        
        mainScrollView?.register(YSHY2048Cell.self, forCellWithReuseIdentifier: "cellID")
        
        
    }
    
    func addGesture() {
        
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action:#selector(panAction(gesture:)) )
        pan.delegate = self
        self.view?.addGestureRecognizer(pan)
        
    }
    
    func panAction(gesture:UIPanGestureRecognizer)  {
        let potin:CGPoint = gesture.translation(in: self.mainScrollView)
        let direction:Int = self.panDirection(translate: potin)
        if(gesture.state == UIGestureRecognizerState.ended)
        {
            if(direction == 1)
            {
                self .swipRight()
                
            }else if(direction == 2)
            {
                self.swipLeft()
            }else if(direction == 3)
            {
                self.swipDown()
            }else if(direction == 4)
            {
                self.swipUp()
            }
            mainScrollView?.reloadData()
            self.perform( #selector(nextShow), with: nil, afterDelay: 0.25)
        }
        
    }
    
    func panDirection(translate:CGPoint) ->Int{
        let dx:CGFloat = translate.x;
        let dy:CGFloat = translate.y;
        
        let ABSdx:CGFloat = fabs(dx);
        let ABSdy:CGFloat = fabs(dy);
        
        if(ABSdx > ABSdy && dx > 0 )  //  向右滑动
        {
            return 1;
        }else  if(ABSdx > ABSdy && dx < 0 )  // 向左滑动
        {
            return 2;
        }
        
        if(ABSdx < ABSdy && dy > 0 )  //  向下滑动
        {
            return 3;
        }else  if(ABSdx < ABSdy && dy < 0 )  // 向上滑动
        {
            return 4;
        }
        return 0;
    }
    
    func swipRight() {
        for k in (0 ..< 4)
        {
            // 确定 i 的范围
            for  i  in (k*4 ..< k*4 + 4).reversed() {
                
                for  j in (k*4 ..< i).reversed()
                {
                    //                    print("i = \(i)  j = \(j)")
                    let obj1:YSHY2048Obj = myArray[i] as! YSHY2048Obj
                    let obj2:YSHY2048Obj = myArray[j] as! YSHY2048Obj
                    let isBreak:Bool = self.exchangePosition(obj1: obj1, obj2: obj2)
                    if isBreak {
                        break
                    }
                }
            }
        }
    }
    
    func swipLeft() {
        for k in (0 ..< 4)
        {
            // 确定 i 的范围
            for  i  in (k*4 ..< k*4 + 4) {
                
                for  j in (i+1 ..< k*4 + 4)
                {
                    //                    print("i = \(i)  j = \(j)")
                    let obj1:YSHY2048Obj = myArray[i] as! YSHY2048Obj
                    let obj2:YSHY2048Obj = myArray[j] as! YSHY2048Obj
                    let isBreak:Bool = self.exchangePosition(obj1: obj1, obj2: obj2)
                    if isBreak {
                        break
                    }
                }
            }
        }
    }
    
    func swipUp() {
        var k:Int = 0
        while k < 4 {
            var i =  k
            while i <= 3*4+k {
                var j = i + 4
                while j <= 3*4+k {
                    //                    print("i = \(i)  j = \(j)")
                    let obj1:YSHY2048Obj = myArray[i] as! YSHY2048Obj
                    let obj2:YSHY2048Obj = myArray[j] as! YSHY2048Obj
                    let isBreak:Bool = self.exchangePosition(obj1: obj1, obj2: obj2)
                    if isBreak {
                        break
                    }
                    j += 4
                }
                i += 4
            }
            k += 1
        }
    }
    
    func swipDown() {
        var k:Int = 0
        while k < 4 {
            var i = 3*4 + k
            while i > 0 {
                var j = i - 4
                while j >= 0 {
                    //                    print("i = \(i)  j = \(j)")
                    let obj1:YSHY2048Obj = myArray[i] as! YSHY2048Obj
                    let obj2:YSHY2048Obj = myArray[j] as! YSHY2048Obj
                    let isBreak:Bool = self.exchangePosition(obj1: obj1, obj2: obj2)
                    if isBreak {
                        break
                    }
                    j -= 4
                }
                i -= 4
            }
            k += 1
        }
    }
    
    func exchangePosition(obj1:YSHY2048Obj,obj2:YSHY2048Obj) -> Bool {
        
        if obj1.title == 0  && obj2.title != 0{
            obj1.title = obj2.title
            obj2.title = 0
            visiableArray.remove(obj1)
            visiableArray.add(obj2)
        }
        else if obj1.title == obj2.title && obj1.title != 0 && obj2.title != 0
        {
            obj1.title = obj1.title  * 2
            obj2.title = 0
            visiableArray.add(obj2)
            score += obj1.title
            bestScroe = score > bestScroe ?score: bestScroe
            self.setLabText()
            if(bestScroe >= targetScore)
            {
                targetScore = targetScore * 2
                tipLab?.text = "您的新挑战是获得\(targetScore)方块"
            }
            return true
        }
        return false
        
    }
    
    
    
    //mark ---collectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:YSHY2048Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! YSHY2048Cell
        let obj:YSHY2048Obj = myArray[indexPath.row] as! YSHY2048Obj
        //         print("------- \(indexPath.row)   --- title \(obj.title)")
        cell.configData(obj:obj)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 70)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.saveToCacha()
    }
    
    func gameStop()  {
        let alertView:UIAlertController = UIAlertController.init(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        alertView.addAction(UIAlertAction.init(title: "继续", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            
        }))
        
        alertView.addAction(UIAlertAction.init(title: "重新开始", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.reStart()
        }))
        
        alertView.addAction(UIAlertAction.init(title: "取消", style: UIAlertActionStyle.cancel, handler: { (UIAlertAction) -> Void in
            
        }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func gameOver() -> Void {
        
        let alertView:UIAlertController = UIAlertController.init(title: "游戏结束", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        alertView.addAction(UIAlertAction.init(title: "重新开始", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
            self.reStart()
        }))
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func bestScoreList() -> Void {
        for (index, topScore) in top5List.enumerated() {
            if score  == topScore {
                break
            }
            if score > topScore {
                top5List.insert(score, at: index)
                break
            }
        }
        
        let top5ListView:Top5ListView = Top5ListView.init(frame:self.view.bounds)
        top5ListView.configData(data1:top5List)
        self.view.addSubview(top5ListView)
    }
    
    
}
