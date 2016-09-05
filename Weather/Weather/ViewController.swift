//
//  ViewController.swift
//  Weather
//
//  Created by yueyeqi on 8/24/16.
//  Copyright © 2016 yueyeqi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import pop
import Moya_SwiftyJSONMapper
import MBProgressHUD
import TZImagePickerController

public let ScreenW = UIScreen.mainScreen().bounds.size.width
public let ScreenH = UIScreen.mainScreen().bounds.size.height

class ViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    var headerView: HeaderView = NSBundle.mainBundle().loadNibNamed("HeaderView", owner: nil, options: nil).first as! HeaderView
    
    var weatherModel: WeatherModel! = nil            //天气模型
    var hamburgerButton: HamburgerButton! = nil      //动效按钮
    var menuView: UIView! = nil                      //菜单视图
    var itemInfo: [String] = []                      //菜单数据源
    var menuType: Int = 1                            //1代表一级菜单，2代表设置菜单
    
    //TableView数据源
    let dataSource = Variable([WeatherDetailModel]())
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let homeDirectory = NSHomeDirectory()
        let imagePath = homeDirectory.stringByAppendingString("/Documents/bg.png")
        
        //本地背景图片读取
        if let image = UIImage.init(contentsOfFile: imagePath) {
            bgImageView.image = image
        } else {
            bgImageView.image = UIImage(named: "5")
        }
        
        //本地城市名称读取
        if NSUserDefaults.standardUserDefaults().objectForKey("cityName") != nil {
            CityName = NSUserDefaults.standardUserDefaults().objectForKey("cityName") as! String
        }
        
        tableView.dataSource = nil
        tableView.delegate = nil
        configTableView()
        
        // 菜单按钮
        hamburgerButton = HamburgerButton(frame: CGRectMake(ScreenW - 60, 20, 45, 45))
        hamburgerButton.rx_tap
            .subscribeNext { () in
                self.toggle()
        }.addDisposableTo(disposeBag)
        view.addSubview(hamburgerButton)
        
        //请求数据
        requestData()
        
    }
    
    override func viewDidLayoutSubviews() {
        configHeaderView()
    }
    
    //MARK: - 配置HeaderView
    func configHeaderView() {
        headerView.frame = CGRectMake(0, 0, ScreenW, ScreenH - 20)
        tableView.pagingEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = headerView
    }
    
    func requestData() {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        let _ = WeatherProvider
            .request(.now)
            .mapObject(WeatherModel)
            .subscribe { (event) in
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                switch event {
                case .Next(let model):
                    
                    //Config HeaderView
                    self.headerView.cityLabel.text = model.city
                    self.headerView.updateTimeLabel.text = "更新时间:\(self.dateSub(model.update))"
                    self.headerView.tmpLabel.text = "\(model.tmp)°"
                    self.headerView.maxminLabel.text = "\(model.min)°/\(model.max)°"
                    self.headerView.tmpImageView.image = UIImage(named: "\(model.code)")
                    self.headerView.txtLabel.text = model.txt
                    self.weatherModel = model
                    
                    // 刷新按钮
                    self.headerView.refreshButton.rx_tap
                        .subscribeNext { () in
                            self.requestData()
                        }.addDisposableTo(self.disposeBag)
            
                    self.dataSource.value = self.weatherModel.daily
                    
                case .Error(let error):
                    print(error)
                default:
                    break
                }
            }.addDisposableTo(disposeBag)
    }

    //MARK: - 时间截取
    func dateSub(date: String) -> String {
        return (date as NSString).substringWithRange(NSMakeRange(5, 11))
    }
    
    //MARK: - 配置TableView
    func configTableView() {
        dataSource.asObservable()
            .bindTo(tableView.rx_itemsWithCellIdentifier("WeatherCell", cellType: WeatherTableViewCell.self)) {
                (_, weatherDetail, cell) in
                
                //Config Cell
                cell.dateLabel.text = weatherDetail.date
                cell.maxminLabel.text = "\(weatherDetail.min)°/\(weatherDetail.max)°"
                cell.txtLabel.text = weatherDetail.txt
                cell.weatherImageView.image = UIImage(named: weatherDetail.code)
                
        }.addDisposableTo(disposeBag)
    }
    
    //MARK: - 菜单按钮点击事件
    func toggle() {
        hamburgerButton.showsMenu = !hamburgerButton.showsMenu
        if hamburgerButton.showsMenu {
            popMenu()
        } else {
            disMenu()
            menuType = 1
        }
    }
    
    //MARK: - 菜单子类选择事件
    func didBtnAction(index: Int) {
        switch menuType {
        case 1:
            switch index {
            case 0:
                menuType = 2
                disMenu()
                popMenu()
            case 1:
                about()
            default:
                break
            }
        case 2:
            switch index {
            case 0:
                changeCity()
            case 1:
                photoLib()
            case 2:
                menuType = 1
                disMenu()
                popMenu()
            default:
                break
            }
        default:
            break
        }
    }
        
    //MARK: - 菜单动画
    
    ///弹出菜单视图
    func popMenu() {
        
        switch menuType {
        case 1:
            itemInfo = ["设置", "关于"]
        case 2:
            itemInfo = ["切换城市", "更换背景", "返回"]
        default:
            break
        }
        
        menuView = UIView(frame: CGRectMake(ScreenW, 80, 100, 50 * CGFloat(itemInfo.count)))
        menuView.userInteractionEnabled = true
        view.addSubview(menuView)
        
        menuView.pop_removeAllAnimations()
        
        let animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        animation.toValue = NSValue(CGPoint: CGPointMake(ScreenW - 50, 80))
        animation.springBounciness = 10
        animation.springSpeed = 12
        menuView.layer.pop_addAnimation(animation, forKey: "Position")
        
        for (index, name) in itemInfo.enumerate() {
            let btn = UIButton(type: .Custom)
            btn.tag = 1000 * index
            btn.frame = CGRectMake(menuView.frame.width, 50 * CGFloat(index), menuView.frame.width, 50)
            btn.setTitle(name, forState: .Normal)
            btn.rx_tap.subscribeNext({ () in
                self.didBtnAction(index)
            }).addDisposableTo(disposeBag)
            menuView.addSubview(btn)
            
            let btnAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            btnAnimation.toValue = NSValue(CGPoint: CGPointMake(menuView.frame.width - 50, 50 * CGFloat(index)))
            btnAnimation.springBounciness = 10
            btnAnimation.springSpeed = 12
            btnAnimation.beginTime = CACurrentMediaTime() + Double(index) * 0.2
            btn.pop_addAnimation(btnAnimation, forKey: "BtnPosition\(index)")
            
        }
    }
    
    //推出菜单视图
    func disMenu() {
        menuView.pop_removeAllAnimations()
        let disAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        disAnimation.toValue = NSValue(CGPoint: CGPointMake(ScreenW + 50, 0))
        disAnimation.springBounciness = 10
        disAnimation.springSpeed = 12
        menuView.layer.pop_addAnimation(disAnimation, forKey: "DisPosition")
        menuView = nil
    }
    
    //MARK: - 调用相册
    func photoLib() {
        let imagePickerViewController = TZImagePickerController(maxImagesCount: 1, delegate: self)
        imagePickerViewController.didFinishPickingPhotosHandle = {(imageArray, objects, isOriginalPhoto) -> Void in
            let bgImage = imageArray.first
            let homeDirectory = NSHomeDirectory()
            let imagePath = homeDirectory.stringByAppendingString("/Documents/bg.png")
            UIImagePNGRepresentation(bgImage!)?.writeToFile(imagePath, atomically: true)
            self.bgImageView.image = bgImage
        }
        
        self.presentViewController(imagePickerViewController, animated: true, completion: nil)

    }
    
    //MARK: - 更换城市
    func changeCity() {
        let alertController = UIAlertController(title: "更换城市", message: "输入更换城市名称", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "城市名称"
        }
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确认", style: .Default, handler: { (alert) in
            let cityName = ((alertController.textFields?.first)! as UITextField).text
            if cityName?.characters.count > 0 {
                CityName = cityName!
                NSUserDefaults.standardUserDefaults().setObject(CityName, forKey: "cityName")
                self.requestData()
            }
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    //MARK: - 关于
    func about() {
        let alertController = UIAlertController(title: "关于", message: "这是一个天气APP", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "确认", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
}

extension ViewController: TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}



