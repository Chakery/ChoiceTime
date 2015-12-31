//
//  ChoiceTimeView.swift
//  时间选择
//
//  Created by Chakery on 15/12/30.
//  Copyright © 2015年 Chakery. All rights reserved.
//

import UIKit

private let numberOfDay = 10    // 天数
private let startDate = 8       // 开始时间
private let endDate = 21        // 结束时间
private let timeLength = 3      // 时长

protocol ChoiceTimeViewDelegate {
    func timeDidSelected(time: NSDate, timeLong: Double)
}

class ChoiceTimeView: UIViewController {
    var delegate: ChoiceTimeViewDelegate?
    var datasource = TimeDataSource().datasource
    var x: Int = 0
    var y: Int = 0
    var z: Int = 0
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        drawView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - add View
    private func drawView() {
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.addSubview(backView)
        backView.addSubview(headTitleLabel)
        backView.addSubview(pickerView)
        backView.addSubview(okButton)
        backView.addSubview(cancelButton)
        backView.addSubview(HLineView)
        backView.addSubview(VLineView)
        
        setupConstraint()
    }
    
    // MARK: - set Contraint
    private func setupConstraint() {
        // backView
        view.addConstraint(NSLayoutConstraint(item: backView, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: backView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 210))
        view.addConstraint(NSLayoutConstraint(item: backView, attribute: .Leading, relatedBy: .Equal, toItem: view, attribute: .Leading, multiplier: 1, constant: 20))
        view.addConstraint(NSLayoutConstraint(item: backView, attribute: .Trailing, relatedBy: .Equal, toItem: view, attribute: .Trailing, multiplier: 1, constant: -20))
        // headTitleLabel
        backView.addConstraint(NSLayoutConstraint(item: headTitleLabel, attribute: .CenterX, relatedBy: .Equal, toItem: backView, attribute: .CenterX, multiplier: 1, constant: 0))
        backView.addConstraint(NSLayoutConstraint(item: headTitleLabel, attribute: .Width, relatedBy: .GreaterThanOrEqual, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 0))
        backView.addConstraint(NSLayoutConstraint(item: headTitleLabel, attribute: .Top, relatedBy: .Equal, toItem: backView, attribute: .Top, multiplier: 1, constant: 20))
        backView.addConstraint(NSLayoutConstraint(item: headTitleLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 14))
        // pickerView
        backView.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .Leading, relatedBy: .Equal, toItem: backView, attribute: .Leading, multiplier: 1, constant: 0))
        backView.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .Trailing, relatedBy: .Equal, toItem: backView, attribute: .Trailing, multiplier: 1, constant: 0))
        backView.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .Top, relatedBy: .Equal, toItem: headTitleLabel, attribute: .Bottom, multiplier: 1, constant: 0))
        backView.addConstraint(NSLayoutConstraint(item: pickerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 120))
        // HLineView
        backView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[HLineView]-0-|", options: [], metrics: nil, views: ["HLineView":HLineView]))
        backView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[HLineView(1)]-45-|", options: [], metrics: nil, views: ["HLineView":HLineView]))
        // VLineView
        backView.addConstraint(NSLayoutConstraint(item: VLineView, attribute: .CenterX, relatedBy: .Equal, toItem: backView, attribute: .CenterX, multiplier: 1, constant: 0))
        backView.addConstraint(NSLayoutConstraint(item: VLineView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 1))
        backView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[VLineView(44)]-0-|", options: [], metrics: nil, views: ["VLineView":VLineView]))
        // okButton
        backView.addConstraint(NSLayoutConstraint(item: okButton, attribute: .Trailing, relatedBy: .Equal, toItem: backView, attribute: .Trailing, multiplier: 1, constant: 0))
        backView.addConstraint(NSLayoutConstraint(item: okButton, attribute: .Width, relatedBy: .Equal, toItem: backView, attribute: .Width, multiplier: 0.5, constant: 0))
        backView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[okButton(44)]-0-|", options: [], metrics: nil, views: ["okButton":okButton]))
        // cancelButton
        backView.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .Leading, relatedBy: .Equal, toItem: backView, attribute: .Leading, multiplier: 1, constant: 0))
        backView.addConstraint(NSLayoutConstraint(item: cancelButton, attribute: .Width, relatedBy: .Equal, toItem: backView, attribute: .Width, multiplier: 0.5, constant: 0))
        backView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[cancelButton(44)]-0-|", options: [], metrics: nil, views: ["cancelButton":cancelButton]))
    }
    
    // MARK: - view
    // 背景
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.whiteColor()
        view.layer.cornerRadius = 4
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // 标题
    private lazy var headTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "请选择开始时间及时长"
        label.textColor = UIColor.ChoiceTimeViewDefaultColor()
        label.font = UIFont.systemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    // 选择时间
    private lazy var pickerView: UIPickerView = {
        let pickView = UIPickerView()
        pickView.showsSelectionIndicator = true
        pickView.delegate = self
        pickView.dataSource = self
        pickView.selectRow(0, inComponent: 0, animated: true)
        pickView.selectRow(0, inComponent: 1, animated: true)
        pickView.selectRow(0, inComponent: 2, animated: true)
        pickView.translatesAutoresizingMaskIntoConstraints = false
        return pickView
    }()
    // 确定
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.tag = 111
        button.setTitle("OK", forState: .Normal)
        button.setTitleColor(UIColor.ChoiceTimeViewSelectedColor(), forState: .Normal)
        button.addTarget(self, action: "buttonClickEvent:", forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // 取消
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.tag = 222
        button.setTitle("Cancel", forState: .Normal)
        button.setTitleColor(UIColor.ChoiceTimeViewDefaultColor(), forState: .Normal)
        button.addTarget(self, action: "buttonClickEvent:", forControlEvents: .TouchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    // 横线
    private lazy var HLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ChoiceTimeViewDefaultColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    // 竖线
    private lazy var VLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ChoiceTimeViewDefaultColor()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Botton
    func buttonClickEvent(button: UIButton) {
        switch button.tag {
        case 111:
            let object = getTime(datasource, x: x, y: y, z: z)
            delegate?.timeDidSelected(object.0, timeLong: object.1)
        default:
            break
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // 获取时间
    func getTime(datasource:[AnyObject], x: Int, y: Int, z: Int) -> (NSDate, Double) {
        
        var timeLong: Double?
        let str: String = datasource[2][z] as! String
        timeLong = Double(str)
        
        let strTime: String = "\(datasource[0][x]!) \(datasource[1][y]!)"
        let formatt = NSDateFormatter()
        formatt.dateFormat = "yyyy-MM-dd HH:mm"
        formatt.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let date = formatt.dateFromString(strTime)
        return (date!, timeLong!)
    }
}

extension ChoiceTimeView: UIPickerViewDelegate {
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        let str = datasource[component][row] as? String
        let label = UILabel()
        label.textAlignment = .Center
        if component == 2 {
            label.text = "\(str!)小时"
        } else {
            label.text = str
        }
        label.font = UIFont.systemFontOfSize(16)
        return label
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            x = row
        case 1:
            y = row
        case 2:
            z = row
        default:
            break
        }
    }
}

// MARK: - UIPickerView Delegate and DataSource
extension ChoiceTimeView: UIPickerViewDataSource {
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return datasource.count
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource[component].count
    }
}

// MARK: - Color
extension UIColor {
    class func ChoiceTimeViewDefaultColor() -> UIColor {
        return UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
    }
    class func ChoiceTimeViewSelectedColor() -> UIColor {
        return UIColor(red: 54/255.0, green: 136/255.0, blue: 251/255.0, alpha: 1)
    }
}

struct TimeDataSource {
    let timeZone: NSTimeInterval = 8 * 60 * 60
    var currentDate: NSDate
    var datasource: [AnyObject] = []
    
    init () {
        currentDate = NSDate(timeIntervalSinceNow: timeZone)
        datasource.append(monthArray)
        datasource.append(hourArray)
        datasource.append(timeLengthArray)
    }
    
    lazy var monthArray: [String] = {
        var array = [String]()
        for i in 0..<numberOfDay {
            let str = NSDate.getDateToString(NSTimeInterval(i), dateType: "yyyy-MM-dd")
            array.append(str)
        }
        return array
    }()
    lazy var hourArray: [String] = {
        var array = [String]()
        for i in startDate..<endDate {
            var str: String
            if i < 10 {
                str = "0\(i)"
            } else {
                str = "\(i)"
            }
            for j in 0...1 {
                var minut = ""
                if j%2 == 0 {
                    minut = ":00"
                } else {
                    minut = ":30"
                }
                array.append("\(str)\(minut)")
            }
        }
        return array
    }()
    lazy var timeLengthArray: [String] = {
        var array = [String]()
        for i in 1...timeLength {
            array.append("\(i)")
        }
        return array
    }()
    
}

extension NSDate {
    public class func getDateWith(day: NSTimeInterval) -> NSDate {
        if day < 0 { fatalError("天数不能小于0") }
        let timeZone: NSTimeInterval = 8 * 60 * 60
        let timeNumber: NSTimeInterval = 24 * 60 * 60
        let date = NSDate(timeIntervalSinceNow: timeZone + (timeNumber * day))
        return date
    }
    public class func getDateToString(day: NSTimeInterval, dateType: String) -> String {
        let date = NSDate.getDateWith(day)
        let formatt = NSDateFormatter()
        formatt.dateFormat = dateType
        formatt.timeZone = NSTimeZone(forSecondsFromGMT: 0)
        let strTime = formatt.stringFromDate(date)
        return strTime
    }
}

