//
//  YSHY2048Cell.swift
//  YSHYSWift
//
//  Created by 杨淑园 on 2017/7/7.
//  Copyright © 2017年 杨淑园. All rights reserved.
//

import UIKit

class YSHY2048Cell: UICollectionViewCell {
    
    var  lab:UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatUI() -> Void {
        self.layer.cornerRadius = 5
        self.layer.masksToBounds = true
        self.lab = UILabel.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width))
        self.addSubview(self.lab!)
        self.lab?.textAlignment = NSTextAlignment.center
        self.lab?.font = UIFont.systemFont(ofSize: 30)
        self.lab?.backgroundColor = UIColor.white
    }
    
    func configData(obj:YSHY2048Obj) {
        if obj.title == 0
        {
            self.lab?.text = ""
            self.lab?.backgroundColor = UIColor.white
        }else {
            self.lab?.text = "\(obj.title )"
            self.setLabBackgroundColor(obj: obj)
            self.setLabTextColor(obj: obj)
            
        }
       
    }
    func setLabTextColor(obj:YSHY2048Obj) {
        
        if obj.title == 2 || obj.title == 4
        {
            self.lab?.textColor = UIColor.init(colorLiteralRed:76/255.0, green:73/255.0, blue:80/255.0, alpha:1)
        }
        else
        {
            self.lab?.textColor = UIColor.white;
        }
    }
    
    func setLabBackgroundColor(obj:YSHY2048Obj) {
        var color:UIColor;
        if(obj.title == 2)
        {
            color = UIColor.init(colorLiteralRed:239/255.0, green:230/255.0, blue:220/255.0, alpha:1)
            
        }else if (obj.title == 4)
        {
            color = UIColor.init(colorLiteralRed:239/255.0, green:213/255.0, blue:202/255.0, alpha:1)
        }
        else if (obj.title == 8)
        {
            color = UIColor.init(colorLiteralRed:238/255.0, green:190/255.0, blue:186/255.0, alpha:1)
        }
        else if (obj.title == 16)
        {
            color = UIColor.init(colorLiteralRed:238/255.0, green:165/255.0, blue:152/255.0, alpha:1)
        }
        else if (obj.title == 32)
        {
            color = UIColor.init(colorLiteralRed:238/255.0, green:152/255.0, blue:152/255.0, alpha:1)
            
        }else if (obj.title == 64)
        {
            color = UIColor.init(colorLiteralRed:238/255.0, green:152/255.0, blue:116/255.0, alpha:1)
        }
        else if (obj.title == 128)
        {
            color = UIColor.init(colorLiteralRed:238/255.0, green:132/255.0, blue:155/255.0, alpha:1)
        }
        else if (obj.title == 256)
        {
            color = UIColor.init(colorLiteralRed:238/255.0, green:113/255.0, blue:63/255.0, alpha:1)
        }
        else if (obj.title == 512)
        {
            color = UIColor.init(colorLiteralRed:238/255.0, green:95/255.0, blue:63/255.0, alpha:1)
            
        }else if (obj.title == 1024)
        {
            color = UIColor.init(colorLiteralRed:238/255.0, green:196/255.0, blue:63/255.0, alpha:1)
        }
        else if (obj.title == 2048)
        {
            self.lab?.font = UIFont.systemFont(ofSize: 25)
            color = UIColor.init(colorLiteralRed:238/255.0, green:220/255.0, blue:25/255.0, alpha:1)
        }else
        {
            color = UIColor.init(colorLiteralRed:232/255.0, green:247/255.0, blue:34/255.0, alpha:1)
        }
        self.lab?.backgroundColor =  color
    }
    
    
}
