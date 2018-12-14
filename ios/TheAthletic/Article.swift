//
//  Article.swift
//  TheAthletic
//
//  Created by Suna on 2018/12/12.
//  Copyright © 2018年 角南佑季. All rights reserved.
//

import UIKit

class Article: NSObject {
    // MARK: 後でidとkeyのどちらかにする
    var id: String? = String()
    var dbKey: String? = String()
    var title: String? = String()
    var bgImg: UIImage = UIImage()
    var content: String? = String()
    var author: String? = String()
    var updatedAt: String? = String()
}
