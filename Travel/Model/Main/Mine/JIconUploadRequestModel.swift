//
//  JIconUploadRequestModel.swift
//  Travel
//
//  Created by ANKER on 2018/9/17.
//  Copyright © 2018年 team. All rights reserved.
//

import UIKit

class JIconUploadRequestModel: JBaseRequestModel {
    override func url() -> String {
        return super.url() + "api/upload-file"
    }
}
