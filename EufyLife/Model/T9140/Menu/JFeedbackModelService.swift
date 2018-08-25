//
//  JFeedbackModelService.swift
//  Jouz
//
//  Created by doubll on 2018/6/6.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

extension JFeedbackModelService: JFeedbackModelServiceDelegate {
    func submitFeedback(content: String, completion: ((Bool, String?) -> Void)?) {
        let model = JFeedbackRequestModel()
        model.message = content
        let url = model.url()
        let body = model.toBody()
        let header = model.toHeader()
        ZNetwork().request(strUrl: url, strMethod: "PUT", parameters: body, encoding: ZNetwork.Encoding.jsonBody.toUrlEncoding(), headers: header) { (value, error) in
            if let response = value?.replacingOccurrences(of: "\n", with: "") {
                if let data = response.data(using: .utf8) {
                    let model = try? JSONDecoder().decode(JFeedbackResponseModel.self, from: data)
                    let msg = model!.message ?? ""
                    completion?(model?.res_code == 1, msg.count > 0 ? msg : "cnn_help_feedback_sent_tips".localized())
                } else {
                    completion?(false, "cnn_update_firmware_error_try".localized())
                }
            } else {
                if error != nil {
                    let err = error! as NSError
                    if err.code == kErrorNetworkOffline {
                        completion?(false, "\(kErrorNetworkOffline)")
                    } else {
                        completion?(false, "cnn_update_firmware_error_try".localized())
                    }
                }
            }
        }
    }
}

class JFeedbackModelService: NSObject {
    var presenter: JFeedbackPresenterDelegate?
    init(presenter: JFeedbackPresenterDelegate) {
        super.init()
        self.presenter = presenter
    }
}
