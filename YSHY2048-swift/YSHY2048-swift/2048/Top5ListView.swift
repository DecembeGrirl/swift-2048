//
//  top5ListView.swift
//  YSHYSWift
//
//  Created by 杨淑园 on 2017/7/10.
//  Copyright © 2017年 杨淑园. All rights reserved.
//

import UIKit

class Top5ListView: UIView,UITableViewDelegate,UITableViewDataSource {

    var data = [Int]()
    var myTableView:UITableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.creatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func creatUI() {
        self.backgroundColor = UIColor.init(colorLiteralRed: 0, green: 0, blue: 0, alpha: 0.5)
        myTableView = UITableView.init(frame: CGRect(x: 60, y: 200, width: CONTEXTWIDTH - 120 , height: 200), style: UITableViewStyle.plain)
        myTableView?.delegate = self
        myTableView?.dataSource = self
        myTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        self.addSubview(myTableView!)
        
    }
    
    func configData(data1:[Int]) {
        data  = data1
        myTableView?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "cellID"
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = "第\(indexPath.row + 1)名 \(data[indexPath.row])分"
        cell.textLabel?.textAlignment = NSTextAlignment.center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.removeFromSuperview()
    }
}
