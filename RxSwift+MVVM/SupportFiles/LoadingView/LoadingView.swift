//
//  LoadingView.swift
//  RxSwift+MVVM
//
//  Created by Mustafa GUNES on 12.02.2019.
//  Copyright © 2019 Mustafa GUNES. All rights reserved.
//

import UIKit

class LoadingView: UIView {
    
    // MARK : - Outlets
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var animateView: AnimateLoadingView!

    public var loadingViewMessage: String! {
        didSet {
            messageLabel.text = loadingViewMessage
        }
    }
    
    public func startAnimating() {
        if animateView.isAnimating { return }
        animateView.startAnimating()
    }
    
    public func stopAnimating() {
        animateView.stopAnimating()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        containerView.addBlurAreaForLoading(area: containerView.bounds, style: .dark)
        containerView.bringSubview(toFront: messageLabel)
    }
}

extension UIView {
    func addBlurAreaForLoading(area: CGRect, style: UIBlurEffectStyle) {
        let effect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: effect)
        let container = UIView(frame: area)
        blurView.frame = CGRect(x: 0, y: 0, width: area.width, height: area.height)
        container.addSubview(blurView)
        self.insertSubview(container, at: 1)
    }
}
