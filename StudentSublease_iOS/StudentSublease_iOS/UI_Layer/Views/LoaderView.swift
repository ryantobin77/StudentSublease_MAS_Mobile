//
//  LoaderView.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class LoaderView: UIView {

    var title: String!
    private var bgView: UIVisualEffectView!
    private var loadLabel: UILabel!
    private var activityIndicator: UIActivityIndicatorView!
    private var presenterView: UIView!
    private var presenterAlpha: CGFloat!
    private var presenterBackgroundColor: UIColor!
    
    init(title: String, onView: UIView) {
        let frame = CGRect(x: onView.frame.midX - 80, y: onView.frame.midY - 23, width: 160, height: 46)
        super.init(frame: frame)
        
        self.title = title
        self.presenterView = onView
        self.layer.cornerRadius = 10.0
        self.layer.masksToBounds = true
        
        bgView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        bgView.frame = CGRect(x: 0, y: 0, width: 160, height: 46)
        bgView.layer.cornerRadius = 10.0
        bgView.layer.masksToBounds = true
        
        loadLabel = UILabel(frame: CGRect(x: 10, y: 0, width: 150, height: 46))
        loadLabel.text = title
        loadLabel.textAlignment = .center
        loadLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.medium)
        loadLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        activityIndicator.frame = CGRect(x: 10, y: 0, width: 46, height: 46)
        
        self.bgView.contentView.addSubview(loadLabel)
        self.bgView.contentView.addSubview(activityIndicator)
        self.addSubview(bgView)
        self.isHidden = true
        self.presenterAlpha = onView.alpha
        self.presenterBackgroundColor = onView.backgroundColor
    }
    
    func load() {
        DispatchQueue.main.async {
            self.isHidden = false
            self.activityIndicator.startAnimating()
            UIView.animate(withDuration: 0.2, animations: {
                self.presenterView.backgroundColor = .black
                self.presenterView.alpha = 0.7
            })
        }
    }
    
    func stopLoading() {
        DispatchQueue.main.async {
            self.isHidden = true
            self.activityIndicator.stopAnimating()
            self.presenterView.backgroundColor = self.presenterBackgroundColor
            self.presenterView.alpha = self.presenterAlpha
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
