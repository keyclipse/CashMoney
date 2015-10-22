//
//  DashedBorderTextField.swift
//  CashMoney
//
//  Created by Samuel Kitono on 19/10/2015.
//  Copyright © 2015 Samuel Kitono. All rights reserved.
//

import UIKit

class DashedBorderTextField: UITextField {
    
    var border:CAShapeLayer!;
    
    private func initCommon(){
        border = CAShapeLayer()
        
        //[UIColor colorWithRed:67/255.0f green:37/255.0f blue:83/255.0f alpha:1].CGColor;
        border.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).CGColor
        border.fillColor = UIColor.clearColor().CGColor
        border.lineDashPattern = [10,7];
        border.lineWidth = 5
    }
    

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initCommon()
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        initCommon()
    }
    
    override func layoutSubviews() {
        
        /*
        _border.path = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
        _border.frame = self.bounds;

*/
        border.path = UIBezierPath(rect: CGRectMake(0, self.bounds.size.height, self.bounds.size.width, 3)).CGPath
        border.frame = self.bounds
        self.layer.addSublayer(border);
        
        super.layoutSubviews()
    }

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
