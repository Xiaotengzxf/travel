/*
 * ToastView.swift
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *                    Version 2, December 2004
 *
 * Copyright (C) 2013-2015 Su Yeol Jeon
 *
 * Everyone is permitted to copy and distribute verbatim or modified
 * copies of this license document, and changing it is allowed as long
 * as the name is changed.
 *
 *            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
 *   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 *
 *  0. You just DO WHAT THE FUCK YOU WANT TO.
 *
 */

import UIKit

open class ToastView: UIView {

  // MARK: Properties
    private var special = false

  open var text: String? {
    get { return self.textLabel.text }
    set {
        self.textLabel.text = newValue
    }
  }

  // MARK: Appearance

  /// The background view's color.
  override open dynamic var backgroundColor: UIColor? {
    get { return self.backgroundView.backgroundColor }
    set { self.backgroundView.backgroundColor = newValue }
  }

  /// The background view's corner radius.
  open var cornerRadius: CGFloat {
    get { return self.backgroundView.layer.cornerRadius }
    set { self.backgroundView.layer.cornerRadius = newValue }
  }

  /// The inset of the text label.
  open var textInsets = UIEdgeInsets(top: 28, left: 16, bottom: 28, right: 16)

  /// The color of the text label's text.
  open var textColor: UIColor? {
    get { return self.textLabel.textColor }
    set { self.textLabel.textColor = newValue }
  }

  /// The font of the text label.
  open var font: UIFont? {
    get { return self.textLabel.font }
    set { self.textLabel.font = newValue }
  }

  /// The bottom offset from the screen's bottom in portrait mode.
  open var bottomOffsetPortrait: CGFloat = {
    switch UIDevice.current.userInterfaceIdiom {
    case .unspecified: return 30
    case .phone: return 30
    case .pad: return 60
    case .tv: return 90
    case .carPlay: return 30
    }
  }()

  /// The bottom offset from the screen's bottom in landscape mode.
  open var bottomOffsetLandscape: CGFloat = {
    switch UIDevice.current.userInterfaceIdiom {
    case .unspecified: return 20
    case .phone: return 20
    case .pad: return 40
    case .tv: return 60
    case .carPlay: return 20
    }
  }()


  // MARK: UI

  private let backgroundView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    view.layer.cornerRadius = 14
    view.clipsToBounds = true
    return view
  }()
    
  private let textLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.backgroundColor = .clear
    label.font = {
      switch UIDevice.current.userInterfaceIdiom {
      case .unspecified: return .systemFont(ofSize: 12)
      case .phone: return .systemFont(ofSize: 16)
      case .pad: return .systemFont(ofSize: 16)
      case .tv: return .systemFont(ofSize: 20)
      case .carPlay: return .systemFont(ofSize: 12)
      }
    }()
    label.numberOfLines = 0
    label.textAlignment = .center
    return label
  }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "add_icon_bluetooth"))
        return imageView
    }()


  // MARK: Initializing

  public init() {
    super.init(frame: .zero)
    self.isUserInteractionEnabled = false
    self.addSubview(self.backgroundView)
    self.addSubview(self.textLabel)
  }

    public func addIcon() {
        special = true
        self.addSubview(self.iconImageView)
    }

  required convenience public init?(coder aDecoder: NSCoder) {
    self.init()
  }


  // MARK: Layout

  override open func layoutSubviews() {
    super.layoutSubviews()
    let containerSize = ToastWindow.shared.frame.size
    let constraintSize = CGSize(
      width: containerSize.width * (270.0 / 375.0) - 32,
      height: CGFloat.greatestFiniteMagnitude
    )
    if special {
        self.iconImageView.frame = CGRect(
            x: (constraintSize.width + 32) / 2 - 24,
            y: 28,
            width: 48,
            height: 48
        )
    }
    let textLabelSize = self.textLabel.sizeThatFits(constraintSize)
    self.textLabel.frame = CGRect(
      x: self.textInsets.left,
      y: special ? (self.textInsets.top + 64) : self.textInsets.top,
      width: textLabelSize.width,
      height: textLabelSize.height
    )
    
    self.backgroundView.frame = CGRect(
      x: 0,
      y: 0,
      width: max(self.textLabel.frame.size.width + self.textInsets.left + self.textInsets.right, 250),
      height: max(self.textLabel.frame.size.height + self.textLabel.frame.origin.y + self.textInsets.bottom, 85)
    )
    if !special {
        self.textLabel.center = self.backgroundView.center;
    }

    var x: CGFloat
    var y: CGFloat
    var width: CGFloat
    //var height: CGFloat

    let orientation = UIApplication.shared.statusBarOrientation
    if orientation.isPortrait || !ToastWindow.shared.shouldRotateManually {
      width = containerSize.width
      //height = containerSize.height
      y = self.bottomOffsetPortrait
    } else {
      width = containerSize.height
      //height = containerSize.width
      y = self.bottomOffsetLandscape
    }

    let backgroundViewSize = self.backgroundView.frame.size
    x = (width - backgroundViewSize.width) * 0.5
    y = (containerSize.height - backgroundViewSize.height) / 2
    self.frame = CGRect(
      x: x,
      y: y,
      width: backgroundViewSize.width,
      height: backgroundViewSize.height
    )
    
  }

  override open func hitTest(_ point: CGPoint, with event: UIEvent!) -> UIView? {
    if let superview = self.superview {
      let pointInWindow = self.convert(point, to: superview)
      let contains = self.frame.contains(pointInWindow)
      if contains && self.isUserInteractionEnabled {
        return self
      }
    }
    return nil
  }

}
