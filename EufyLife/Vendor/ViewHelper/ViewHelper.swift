//
//  ViewHelper.swift
//  Jouz
//
//  Created by doubll on 2018/5/23.
//  Copyright © 2018年 team. All rights reserved.
//

import Foundation

//MARK: - 线条view

extension UIView {
    func add(line:CellLineView, offset: CGFloat = 0) {
        self.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(offset)
            make.right.equalToSuperview().offset(-offset)
            let height = 1
            make.height.equalTo(height)
            if line.position == .upper {
                make.top.equalToSuperview()
            } else {
                make.bottom.equalToSuperview()
            }
        }
    }

    func makeLineView(for position:CellLineViewPosition) -> CellLineView {
        let v = CellLineView(position: position)
        v.backgroundColor = .black
        return v
    }
}



//MARK: - 线条位置
enum CellLineViewPosition {case upper, lower}

class CellLineView: UIView {
    var position: CellLineViewPosition = .lower
    init(position: CellLineViewPosition) {
        super.init(frame: .zero)
        self.backgroundColor = .black
        self.position = position
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private let leftColor = c1
private let rightColor = ZColorManager.sharedInstance.colorWithHexString(hex: "73D1C3")

//MARK: - 字母缩略图
class SymbolView: UIView {
    var txt: String? {
        didSet {
            self.txtLabel.text = txt?.prefix(1).uppercased()
        }
    }
    private lazy var txtLabel: UILabel = {
        let l = UILabel()
        l.backgroundColor = .clear
        l.textColor = c7
        l.textAlignment = .center
        l.text = txt
        l.frame = .zero
        l.font = t1
        return l
    }()

    var colors: [UIColor]! {
        didSet {
            setNeedsDisplay()
        }
    }



    init(with symbol: String? = nil, colors:[UIColor] = [leftColor, rightColor]) {
        super.init(frame: .zero)
        self.txt = symbol
        self.colors = colors
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var gradientLayer: CAGradientLayer!

    override func draw(_ rect: CGRect) {
        if self.gradientLayer?.superlayer != nil {
            self.gradientLayer.removeFromSuperlayer()
        }

        self.gradientLayer = makeGradientLayer(at: rect, colors: colors, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        self.gradientLayer = makeGradientLayer(colors: colors)
        self.layer.addSublayer(self.gradientLayer)
        gradientLayer.frame = rect
        self.txtLabel.frame = rect
        // 会多次触发，保证只加一次
        if self.txtLabel.layer.superlayer != self.layer {
            self.txtLabel.layer.removeFromSuperlayer()
        }
        self.layer.addSublayer(self.txtLabel.layer)
        let bpath = UIBezierPath(roundedRect: rect, cornerRadius: rect.width/2)
        let maskLayer = CAShapeLayer()
        maskLayer.path = bpath.cgPath
        self.layer.mask = maskLayer
    }
}

extension UIView {
    //MARK: - 图片layer
    func makeImageLayer(image: UIImage) -> CALayer {
        let imgv = UIImageView.init(image: image)
        imgv.contentMode = .scaleAspectFit
        return imgv.layer
    }

    //MARK: - 渐变layer
    func makeGradientLayer(at rect: CGRect = .zero, colors: [UIColor], startPoint: CGPoint = .zero, endPoint: CGPoint = CGPoint(x: 1, y: 1)) -> CAGradientLayer{
        let gLayer = CAGradientLayer()
        gLayer.colors = colors.map({$0.cgColor})
        gLayer.frame = rect
        gLayer.startPoint = startPoint
        gLayer.endPoint = endPoint
        return gLayer
    }

    //MARK: - 圆layer
    func makeRoundLayer(rect: CGRect, radius: CGFloat) -> CAShapeLayer {
        let bpath = UIBezierPath.init(roundedRect:rect, cornerRadius: radius)
        let roundLayer = CAShapeLayer()
        roundLayer.path = bpath.cgPath
        return roundLayer
    }
}



extension UIView {
    /// 生成渐变色图片
    ///
    /// - Parameters:
    ///   - gradientColors: 渐变色
    ///   - contentColor: 边框中间的颜色
    ///   - borderWidth: 边框颜色
    ///   - showBorder: 是否显示边框
    /// - Returns: 渐变色图片
    func makeImage(gradientColors: [UIColor], contentColor: UIColor, borderWidth: CGFloat, radius: CGFloat = 0, gradientStartPoint: CGPoint = .zero, endPoint: CGPoint = CGPoint(x: 1, y: 0.5)) -> UIImage? {
        let grad = makeGradientLayer(at: bounds, colors: gradientColors, startPoint: gradientStartPoint, endPoint: endPoint)
        var innerRect = bounds
        if borderWidth > 0 {
            innerRect = bounds.insetBy(dx: borderWidth/2, dy: borderWidth/2)
        }

        let round = makeRoundLayer(rect: innerRect, radius: radius)

        round.strokeColor = UIColor.white.cgColor
        if borderWidth > 0 {
            round.lineWidth = borderWidth
            round.fillColor = UIColor.clear.cgColor
        } else {
            round.lineWidth = 0
            round.fillColor = UIColor.white.cgColor
        }

        grad.mask = round

        if borderWidth > 0 {
            let bkg = makeRoundLayer(rect: innerRect, radius: innerRect.height/2)
            bkg.lineWidth = 0
            bkg.strokeColor = UIColor.white.cgColor
            bkg.fillColor = contentColor.cgColor
            bkg.addSublayer(grad)
            return layerToImage(layer: bkg, size: bounds.size)
        }
        return layerToImage(layer: grad, size: bounds.size)
    }

    private func layerToImage(layer: CALayer, size: CGSize) -> UIImage? {
        // 必须加上屏幕的scale，否则生成的图片不清晰
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        guard context != nil else {
            return nil
        }
        layer.render(in: context!)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img;
    }
}
