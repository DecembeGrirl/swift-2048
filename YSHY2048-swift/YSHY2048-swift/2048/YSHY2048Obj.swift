//
//  YSHY2048Obj.swift
//  YSHYSWift
//
//  Created by 杨淑园 on 2017/7/7.
//  Copyright © 2017年 杨淑园. All rights reserved.
//

import UIKit

class YSHY2048Obj: NSObject, NSCoding {
    var title:Int = 0
    var x:Int = 0
    var y:Int = 0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        self.x = aDecoder.decodeInteger(forKey: "x")
        self.y = aDecoder.decodeInteger(forKey: "y")
        self.title = aDecoder.decodeInteger(forKey: "title")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.x, forKey: "x")
        aCoder.encode(self.y, forKey: "y")
        aCoder.encode(self.title, forKey: "title")
    }
    
    
}
