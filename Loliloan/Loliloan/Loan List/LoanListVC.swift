//
//  LoanListVC.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 24/02/24.
//

import UIKit
import RxSwift
import RxCocoa
 
// MARK: - INITIAL
class LoanListVC: UIViewController {
    // SUB: Reactive
    let disposeBag = DisposeBag()
    private let vm = LoanListVM()
    // SUB: UI
    @IBOutlet weak var tf_search: UITextField!
    @IBOutlet weak var cv_loanList: UICollectionView!
    @IBOutlet weak var v_sortfilter: UIView!
    @IBOutlet weak var b_sort: UIButton!
    @IBOutlet weak var b_filter: UIButton!
    // SUB: Variable
    let sortVC = SortVC.create()
    
    static func create() -> LoanListVC {
        let vc = LoanListVC(nibName: String(describing: self), bundle: nil)
        return vc
    }
}
 
 
// MARK: - LIFECYCLE
extension LoanListVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        
        vm.fetchLoanList()
    }
}
 
// MARK: - UI & BINDING
extension LoanListVC{
    func setupUI(){
        title = "Loan List"
        
        v_sortfilter.layer.cornerRadius = 6
        v_sortfilter.clipsToBounds = true
        
        sortVC.modalPresentationStyle = .overFullScreen
    }
    
    func setupBinding(){
        // LOAN LIST
        cv_loanList.register(UINib(nibName: String(describing: LoanCell.self), bundle: nil), forCellWithReuseIdentifier: LoanCell.identifier)
        
        vm.loans.bind(to: cv_loanList.rx.items(cellIdentifier: LoanCell.identifier, cellType: LoanCell.self)) { (row, data, cell) in
            cell.lb_name.text = data.borrower?.name
            cell.lb_amount.text = "Rp. \(data.amount ?? 0)"
            cell.lb_purpose.text = data.purpose?.rawValue
            cell.lb_term.text = "\(data.term ?? 0) months"
            cell.lb_risk.text = data.riskRating?.rawValue
            cell.lb_interest.text = "\(data.interestRate ?? 0)%"
        }.disposed(by: disposeBag)
        
        cv_loanList.rx.modelSelected(Loan.self).bind { loan in
            if let nc = self.navigationController {
//                let vc = ChatAsterbotVC.create(percakapanId: chat.percakapanId ?? 0)
//                nc.pushViewController(vc, animated: true)
            }
        }.disposed(by: disposeBag)
        
        cv_loanList.rx.setDelegate(self).disposed(by: disposeBag)
        
        // SORT
        sortVC.publishSelection.bind { [weak self] selection in
            guard let strself = self else { return }
            strself.vm.isDesc = strself.vm.sort == selection && !strself.vm.isDesc
            if strself.vm.isDesc {
                strself.b_sort.setTitle("↓ " + selection, for: .normal)
            }
            else {
                strself.b_sort.setTitle("↑ " + selection, for: .normal)
            }
            strself.vm.sortLoanList(selection: selection)
        }.disposed(by: disposeBag)
        
        b_sort.rx.tap.bind { [weak self] in
            guard let strself = self else { return }
            strself.present(strself.sortVC, animated: true)
        }.disposed(by: disposeBag)
        
        // FILTER
        b_filter.rx.tap.bind { [weak self] in
            
        }.disposed(by: disposeBag)
        
        // SEARCH
    }
}

// MARK: COLLECTION VIEW
extension LoanListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 126)
    }
    
}
