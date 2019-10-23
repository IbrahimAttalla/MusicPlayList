//
//  ViewDesignable.swift
//  MusicPlayList
//
//  Created by it thinkers on 10/22/19.
//  Copyright © 2019 ibrahim-attalla. All rights reserved.
//

import UIKit
//@IBDesignable

class ViewDesignable: UIView {
    
    
    @IBInspectable var cornerRadius: Float = 6.0 {
        didSet{
            setView()
        }
    }
    @IBInspectable var shadowOpacity: Float = 39.5 {
        didSet{
            setView()
        }
    }
    @IBInspectable var shadowRadius: Float = 4.0 {
        didSet{
            setView()
        }
    }
    @IBInspectable var shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0) {
        didSet{
            setView()
        }
    }
    @IBInspectable var shadowColor:CGColor = UIColor(red: 188.0/255.0, green:
        128.0/255.0, blue: 47.0/255.0, alpha: 7.0).cgColor {
        didSet{
            setView()
        }
    }
    
    @IBInspectable
    var shadowColor2: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    override func prepareForInterfaceBuilder() {
        setView()
    }
    
    func setView() {
        layer.cornerRadius = CGFloat(cornerRadius)
        //        layer.shadowColor = shadowColor
        //        layer.shadowColor = shadowColor2 as! CGColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = CGFloat(shadowRadius)
    }
}

