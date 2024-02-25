//
//  SortVC.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 24/02/24.
//

import UIKit
import RxSwift
import RxCocoa
 
// MARK: - INITIAL
class SortVC: UIViewController {
    // SUB: Reactive
    let disposeBag = DisposeBag()
    // SUB: UI
    @IBOutlet weak var v_background: UIView!
    @IBOutlet weak var b_close: UIButton!
    @IBOutlet weak var tv_sort: UITableView!
    @IBOutlet weak var us_asc: UISwitch!
    // SUB: Variable
    let sortingList = BehaviorRelay<[String]>(value: ["Name", "Amount", "Term", "Purpose", "Risk"])
    let publishSelection = PublishSubject<(String, Bool)>()
    
    static func create() -> SortVC {
        let vc = SortVC(nibName: String(describing: self), bundle: nil)
        return vc
    }
}
 
 
// MARK: - LIFECYCLE
extension SortVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
}
 
// MARK: - UI & BINDING
extension SortVC {
    func setupUI(){
        v_background.layer.cornerRadius = 30
        v_background.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        v_background.addShadow()
    }
    
    func setupBinding(){
        b_close.rx.tap.bind { [weak self] in
            guard let strself = self, let index = strself.tv_sort.indexPathForSelectedRow else {
                self?.dismiss(animated: true)
                return
            }
            strself.publishSelection.onNext((strself.sortingList.value[index.row], strself.us_asc.isOn))
            strself.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        // SORT LIST
        tv_sort.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        sortingList.bind(to: self.tv_sort.rx.items(cellIdentifier: "Cell")) { index, data, cell in
            cell.textLabel?.text = data
        }.disposed(by: disposeBag)
        
        tv_sort.rx.itemSelected.bind { indexPath in
            self.publishSelection.onNext((self.sortingList.value[indexPath.row], self.us_asc.isOn))
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
