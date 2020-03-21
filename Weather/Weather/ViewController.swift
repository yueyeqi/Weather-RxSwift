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
import MBProgressHUD
import TZImagePickerController

public let ScreenW = UIScreen.main.bounds.size.width
public let ScreenH = UIScreen.main.bounds.size.height

class ViewController: UIViewController {
        
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bgImageView: UIImageView!
    
    var headerView: HeaderView = Bundle.main.loadNibNamed("HeaderView", owner: nil, options: nil)?.first as! HeaderView
    
//    var weatherModel: WeatherModel! = nil            //天气模型
    var hamburgerButton: HamburgerButton! = nil      //动效按钮
    var menuView: UIView! = nil                      //菜单视图
    var itemInfo: [String] = []                      //菜单数据源
    var menuType: Int = 1                            //1代表一级菜单，2代表设置菜单
    
    //TableView数据源
    let dataSource = PublishSubject<[DailyForecast]>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let imagePath = NSHomeDirectory().appending("/Documents/bg.png")
        
        //本地背景图片读取
        if let image = UIImage.init(contentsOfFile: imagePath) {
            bgImageView.image = image
        } else {
            bgImageView.image = UIImage(named: "5")
        }
        
        //本地城市名称读取
        if UserDefaults.standard.object(forKey: "cityName") != nil {
            CityName = UserDefaults.standard.object(forKey: "cityName") as! String
        }
        
        tableView.dataSource = nil
        tableView.delegate = nil
        configTableView()
        
        // 菜单按钮
        hamburgerButton = HamburgerButton(frame: CGRect(x: ScreenW - 60, y: 40, width: 45, height: 45))
        hamburgerButton.rx.tap.bind { [weak self] in
            self?.toggle()
        }.disposed(by: disposeBag)
        view.addSubview(hamburgerButton)
        
        // 刷新按钮
        headerView.refreshButton.rx.tap.bind { [weak self] in
            self?.requestData()
        }.disposed(by: disposeBag)
        
        //请求数据
        requestData()
        
    }
    
    override func viewDidLayoutSubviews() {
        configHeaderView()
    }
    
    //MARK: - 配置HeaderView
    func configHeaderView() {
        headerView.frame = CGRect(x: 0, y: 0, width: ScreenW, height: ScreenH - 20)
        tableView.isPagingEnabled = true
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = headerView
    }
    
    func requestData() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        WeatherProvider.rx.request(.now).mapJSON().asObservable()
            .bind { [weak self] (model) in
                guard let self = self else { return }
                MBProgressHUD.hide(for: self.view, animated: true)
                guard let respDic = model as? [String: Any] else { return }
                guard let model = WeatherModel(JSON: respDic) else { return }
                print(model)
                guard let array = model.heWeather6 else { return }
                let item = array[0]
                //取出第一天的数据
                if (item.dailyForecast ?? []).count > 0 {
                    self.dataSource.onNext(item.dailyForecast ?? [])
                    let first = (item.dailyForecast ?? [])[0]
                    self.headerView.tmpLabel.text = "\(first.hum ?? "NA")°"
                    self.headerView.maxminLabel.text = "\(first.tmpMin ?? "NA")°/\(first.tmpMax ?? "NA")°"
                    self.headerView.tmpImageView.image = UIImage(named: "\(first.condCodeD ?? "100")")
                    self.headerView.txtLabel.text = first.condTxtD
                }
                self.headerView.cityLabel.text = item.basic?.location
                self.headerView.updateTimeLabel.text = "更新时间:\(item.update?.loc ?? "NA")"
        }.disposed(by: disposeBag)
    }
    
    //MARK: - 配置TableView
    func configTableView() {
        dataSource.asObservable().bind(to: tableView.rx.items(cellIdentifier: "WeatherCell", cellType: WeatherTableViewCell.self)) {_, weatherDetail, cell in
            //Config Cell
            cell.dateLabel.text = weatherDetail.date
            cell.maxminLabel.text = "\(weatherDetail.tmpMin ?? "NA")°/\(weatherDetail.tmpMax ?? "NA")°"
            cell.txtLabel.text = weatherDetail.condTxtD
            if let condCodeD = weatherDetail.condCodeD {
                cell.weatherImageView.image = UIImage(named: condCodeD)
            }
        }.disposed(by: disposeBag)
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
        
        menuView = UIView(frame: CGRect(x: ScreenW, y: 80, width: 100, height: 50 * CGFloat(itemInfo.count)))
        menuView.isUserInteractionEnabled = true
        view.addSubview(menuView)
        
        menuView.pop_removeAllAnimations()
        
        let animation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        animation!.toValue = NSValue(cgPoint: CGPoint(x: ScreenW - 50, y: 80))
        animation!.springBounciness = 10
        animation!.springSpeed = 12
        menuView.layer.pop_add(animation, forKey: "Position")
    
        for (index, name) in itemInfo.enumerated() {
            let btn = UIButton(type: .custom)
            btn.tag = 1000 * index
            btn.frame = CGRect(x: menuView.frame.width, y: 50 * CGFloat(index), width: menuView.frame.width, height: 50)
            btn.setTitle(name, for: .normal)
            btn.rx.tap.bind { [weak self] in
                self?.didBtnAction(index: index)
            }.disposed(by: disposeBag)
            menuView.addSubview(btn)
            
            let btnAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
            btnAnimation!.toValue = NSValue(cgPoint: CGPoint(x: menuView.frame.width - 50, y: 50 * CGFloat(index)))
            btnAnimation!.springBounciness = 10
            btnAnimation!.springSpeed = 12
            btnAnimation!.beginTime = CACurrentMediaTime() + Double(index) * 0.2
            btn.pop_add(btnAnimation, forKey: "BtnPosition\(index)")
            
        }
    }
    
    //推出菜单视图
    func disMenu() {
        menuView.pop_removeAllAnimations()
        let disAnimation = POPSpringAnimation(propertyNamed: kPOPLayerPositionX)
        disAnimation!.toValue = NSValue(cgPoint: CGPoint(x: ScreenW + 50, y: 0))
        disAnimation!.springBounciness = 10
        disAnimation!.springSpeed = 12
        menuView.layer.pop_add(disAnimation, forKey: "DisPosition")
        menuView = nil
    }
    
    //MARK: - 调用相册
    func photoLib() {
        let imagePickerViewController = TZImagePickerController(maxImagesCount: 1, delegate: self)
        imagePickerViewController!.didFinishPickingPhotosHandle = {(imageArray, objects, isOriginalPhoto) -> Void in
            let bgImage = imageArray?.first
            let imagePath = NSHomeDirectory().appending("/Documents/bg.png")
            try? bgImage?.pngData()?.write(to: URL(string: imagePath)!, options: .atomic)
            self.bgImageView.image = bgImage
        }
        
        self.present(imagePickerViewController!, animated: true, completion: nil)

    }
    
    //MARK: - 更换城市
    func changeCity() {
        let alertController = UIAlertController(title: "更换城市", message: "输入更换城市名称", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "城市名称"
        }
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: { (alert) in
            let cityName = ((alertController.textFields?.first)! as UITextField).text
            if (cityName?.count ?? 0) > 0 {
                CityName = cityName!
                UserDefaults.standard.set(CityName, forKey: "cityName")
                self.requestData()
            }
        }))
        self.present(alertController, animated: true, completion: nil)
    }

    //MARK: - 关于
    func about() {
        let alertController = UIAlertController(title: "关于", message: "这是一个天气APP", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确认", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

extension ViewController: TZImagePickerControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
}



