//
//  FilterVC.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 24/02/24.
//

import UIKit

import UIKit
import RxSwift
import RxCocoa
 
// MARK: - INITIAL
class FilterVC: UIViewController {
    // SUB: Reactive
    let disposeBag = DisposeBag()
    let vm = FilterVM()
    // SUB: UI
    @IBOutlet weak var v_background: UIView!
    @IBOutlet weak var b_close: UIButton!
    @IBOutlet weak var cv_purpose: UICollectionView!
    @IBOutlet weak var cv_term: UICollectionView!
    @IBOutlet weak var cv_risk: UICollectionView!
    @IBOutlet weak var b_apply: UIButton!
    // SUB: Variable
    
    static func create() -> FilterVC {
        let vc = FilterVC(nibName: String(describing: self), bundle: nil)
        return vc
    }
}
 
 
// MARK: - LIFECYCLE
extension FilterVC {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
}
 
// MARK: - UI & BINDING
extension FilterVC {
    func setupUI(){
        v_background.layer.cornerRadius = 30
        v_background.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        v_background.addShadow()
        
        b_apply.layer.cornerRadius = 6
        b_apply.layer.masksToBounds = true
    }
    
    func setupBinding(){
        b_close.rx.tap.bind { [weak self] in
            guard let strself = self else { return }
            strself.dismiss(animated: true)
        }.disposed(by: disposeBag)
        
        // PURPOSE LIST
        cv_purpose.register(UINib(nibName: String(describing: FilterCell.self), bundle: nil), forCellWithReuseIdentifier: FilterCell.identifier)
        
        vm.purposeList.bind(to: cv_purpose.rx.items(cellIdentifier: FilterCell.identifier, cellType: FilterCell.self)) { (row, data, cell) in
            cell.lb_filter.text = data.name
            cell.isActived = data.isActive
        }.disposed(by: disposeBag)
        
        cv_purpose.rx.itemSelected.bind { [weak self] indexPath in
            guard let strself = self else { return }
            var list = strself.vm.purposeList.value
            list[indexPath.row].isActive.toggle()
            strself.vm.purposeList.accept(list)
            strself.countFilter(isAdd: list[indexPath.row].isActive)
        }.disposed(by: disposeBag)
        
        cv_purpose.rx.setDelegate(self).disposed(by: disposeBag)
        
        // TERM LIST
        cv_term.register(UINib(nibName: String(describing: FilterCell.self), bundle: nil), forCellWithReuseIdentifier: FilterCell.identifier)
        
        vm.termList.bind(to: cv_term.rx.items(cellIdentifier: FilterCell.identifier, cellType: FilterCell.self)) { (row, data, cell) in
            cell.lb_filter.text = data.name
            cell.isActived = data.isActive
        }.disposed(by: disposeBag)
        
        cv_term.rx.itemSelected.bind { [weak self] indexPath in
            guard let strself = self else { return }
            var list = strself.vm.termList.value
            list[indexPath.row].isActive.toggle()
            strself.vm.termList.accept(list)
            strself.countFilter(isAdd: list[indexPath.row].isActive)
        }.disposed(by: disposeBag)
        
        cv_term.rx.setDelegate(self).disposed(by: disposeBag)
        
        // PURPOSE LIST
        cv_risk.register(UINib(nibName: String(describing: FilterCell.self), bundle: nil), forCellWithReuseIdentifier: FilterCell.identifier)
        
        vm.riskList.bind(to: cv_risk.rx.items(cellIdentifier: FilterCell.identifier, cellType: FilterCell.self)) { (row, data, cell) in
            cell.lb_filter.text = data.name
            cell.isActived = data.isActive
        }.disposed(by: disposeBag)
        
        cv_risk.rx.itemSelected.bind { [weak self] indexPath in
            guard let strself = self else { return }
            var list = strself.vm.riskList.value
            list[indexPath.row].isActive.toggle()
            strself.vm.riskList.accept(list)
            strself.countFilter(isAdd: list[indexPath.row].isActive)
        }.disposed(by: disposeBag)
        
        cv_risk.rx.setDelegate(self).disposed(by: disposeBag)
        
        // APPLY
        self.vm.filterCount.bind { [weak self] counter in
            guard let strself = self else { return }
            strself.b_apply.setTitle("APPLY (\(counter))", for: .normal)
            strself.b_apply.isHidden = false
        }.disposed(by: disposeBag)
        
        self.b_apply.rx.tap.bind { [weak self] in
            guard let strself = self else { return }
            strself.vm.publishAllFilter()
            strself.dismiss(animated: true)
            strself.b_apply.isHidden = true
        }.disposed(by: disposeBag)
    }
    
    func countFilter(isAdd: Bool) {
        var filterCount = vm.filterCount.value
        if isAdd {
            filterCount += 1
        }
        else {
            filterCount -= 1
        }
        vm.filterCount.accept(filterCount)
    }
}

// MARK: COLLECTION VIEW
extension FilterVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 30
        switch collectionView {
        case cv_purpose:
            let text = self.vm.purposeList.value[indexPath.row].name
            let width = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]).width + 20
            return CGSize(width: width, height: height)
        case cv_term:
            let text = self.vm.termList.value[indexPath.row].name
            let width = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]).width + 20
            return CGSize(width: width, height: height)
        case cv_risk:
            let text = self.vm.riskList.value[indexPath.row].name
            let width = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .regular)]).width + 20
            return CGSize(width: width, height: height)
        default:
            return CGSize()
        }
    }
}
