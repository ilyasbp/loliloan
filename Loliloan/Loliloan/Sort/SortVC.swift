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
    @IBOutlet weak var tv_sort: UITableView!
    // SUB: Variable
    let sortByList = BehaviorRelay<[String]>(value: ["Name", "Term", "Purpose", "Risk"])
    let publishSelection = PublishSubject<String>()
    
    static func create() -> SortVC {
        let vc = SortVC(nibName: String(describing: self), bundle: nil)
        return vc
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true)
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
        // FILTER LIST
        tv_sort.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        sortByList.bind(to: self.tv_sort.rx.items(cellIdentifier: "Cell")) { index, data, cell in
            cell.textLabel?.text = data
        }.disposed(by: disposeBag)
        
        tv_sort.rx.itemSelected.bind { indexPath in
            self.publishSelection.onNext(self.sortByList.value[indexPath.row])
            self.dismiss(animated: true)
        }.disposed(by: disposeBag)
    }
}
