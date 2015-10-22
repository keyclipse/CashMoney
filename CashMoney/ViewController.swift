//
//  ViewController.swift
//  CashMoney
//
//  Created by Samuel Kitono on 19/10/2015.
//  Copyright © 2015 Samuel Kitono. All rights reserved.
//

import UIKit

let CELL_WIDTH:CGFloat = 125
let CELL_SPACING:CGFloat = 10
let LABEL_TAG = 11

class ViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate, UIScrollViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var inputCurrencyTextField: DashedBorderTextField!
    @IBOutlet weak var currencyCollectionView: UICollectionView!
    var currencySelectionArray:Array<String>!
    var scrollViewInitialOffset:CGFloat = 0
    var currentlySelectedCurrency = 0
    var currentString:String = ""
    @IBOutlet weak var outputCurrencyLabel: UILabel!
    @IBOutlet weak var loadingView: UIView!
    
    var ratesDictionary:NSDictionary!
    
    var centerOffset:CGFloat = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        print("locale all \(NSLocale.availableLocaleIdentifiers())")
        
        currencySelectionArray = ["CAD", "EUR", "GBP", "JPY", "USD"];
        
        
        // Add shadow for the top view
        self.topView.layer.shadowOffset = CGSizeMake(0, 3);
        self.topView.layer.shadowOpacity = 0.5;
        self.topView.layer.shadowColor = UIColor.blackColor().CGColor
        
        getCurrencyRates()
    }
    
    override func viewDidLayoutSubviews() {
        let flow = self.currencyCollectionView.collectionViewLayout as! UICollectionViewFlowLayout;
        centerOffset = self.view.frame.size.width/2 - CELL_WIDTH/2;
        flow.sectionInset = UIEdgeInsetsMake(0, centerOffset, 0, centerOffset);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getCurrencyRates(){
        let urlPath: String = "https://api.fixer.io/latest?base=AUD"
        let url: NSURL = NSURL(string: urlPath)!
        let request: NSURLRequest = NSURLRequest(URL: url)

        

        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
            
            // notice that I can omit the types of data, response and error
            
            // your code
            
            do {
                let resultJson = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! [String:AnyObject]
                self.ratesDictionary = resultJson["rates"] as! NSDictionary
                self.formatCurrency("0")
                print(resultJson)
                // use anyObj here
            } catch {
                print("json error: \(error)")
            }
            
            self.loadingView.hidden = true
            
        });
        task.resume()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.currencySelectionArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CurrencyCollectionCell", forIndexPath: indexPath)
        
        if indexPath.row == currentlySelectedCurrency{
            cell.alpha = 1
        }else{
            cell.alpha = 0.3
        }
        
        let currencyString = self.currencySelectionArray[indexPath.row]
        
        let label = cell.viewWithTag(LABEL_TAG) as! UILabel
        label.text = currencyString
        
        return cell;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cellWidthWithSpacing:CGFloat = CELL_WIDTH + CELL_SPACING
        self.currencyCollectionView.setContentOffset(CGPointMake((CGFloat(indexPath.row) * cellWidthWithSpacing), 0), animated: true)
        self.currentlySelectedCurrency = indexPath.row
        self.currencyCollectionView.reloadData()
        formatCurrency(currentString)
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollViewInitialOffset = scrollView.contentOffset.x

    }
    
    //Textfield delegates
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            currentString += string
            print(currentString)
            formatCurrency(currentString)
        default:
            if string.characters.count == 0 && currentString.characters.count > 0{
                currentString.removeAtIndex(currentString.endIndex.predecessor())
                formatCurrency(currentString)
            }
        }
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.endEditing(false)
        return true
    }
    
    func formatCurrency(string: String) {
        print("format \(string)")
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        formatter.locale = NSLocale(localeIdentifier: "en_AU")
        let numberFromField = (NSString(string: currentString).doubleValue)/100
        self.inputCurrencyTextField.text = formatter.stringFromNumber(numberFromField)
        print(self.inputCurrencyTextField.text )
        
        // en_CA = Canada
        // en_IE = Euro
        // ja_JP = Japan
        // en_GB = GBP
        // en_US = USD
        
        
        var outputString = ""
        
        let currencyCode = self.currencySelectionArray[currentlySelectedCurrency]
        switch currencyCode{
            case "CAD":
                outputString = "en_CA"
            case "EUR":
                outputString = "en_IE"
            case "GBP":
                outputString = "en_GB"
            case "JPY":
                outputString = "ja_JP"
            case "USD":
                outputString = "en_US"
            default:
                outputString = "en_US"
        }
        
        let exchangeRateNumber = self.ratesDictionary[currencyCode] as! Double
        let exchangeOutputNumber = numberFromField * exchangeRateNumber
        
        
        let outputFormatter = NSNumberFormatter()
        outputFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
        outputFormatter.locale = NSLocale(localeIdentifier: outputString)
        self.outputCurrencyLabel.text = outputFormatter.stringFromNumber(exchangeOutputNumber)
        
    }
    
    
    
    // This is for paging effect of the scrollview not exactly smooth tho
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        
        let cellWidthWithSpacing:CGFloat = CELL_WIDTH + CELL_SPACING;
        
        let nextIndex:Int = Int(targetContentOffset.memory.x/cellWidthWithSpacing);
        var finalIndex = nextIndex
        
        if velocity.x == 0{
            let diffRange = targetContentOffset.memory.x - self.scrollViewInitialOffset
            
            //we are swiping to the right
            if diffRange > (cellWidthWithSpacing/2){
                if nextIndex+1 < self.currencySelectionArray.count{
                    finalIndex = nextIndex + 1
                }
            }
        }else if velocity.x > 0{
            if nextIndex+1 < self.currencySelectionArray.count{
                finalIndex = nextIndex + 1
            }
        }else{
            if nextIndex-1 >= 0{
                finalIndex = nextIndex - 1
            }
        }
        
        targetContentOffset.memory.x = (CGFloat(finalIndex) * cellWidthWithSpacing);
        
        currentlySelectedCurrency = finalIndex
        formatCurrency(currentString)
        self.currencyCollectionView.reloadData()
    }


}

