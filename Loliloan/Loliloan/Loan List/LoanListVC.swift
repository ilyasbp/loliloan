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
    @IBOutlet weak var aiv_loading: UIActivityIndicatorView!
    // SUB: Variable
    let sortVC = SortVC.create()
    let filterVC = FilterVC.create()
    
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
        v_sortfilter.addShadow()
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
        
        // LOADING
        self.vm.loading.skip(1).bind { [weak self] (at, isLoading) in
            guard let strself = self else { return }
            DispatchQueue.main.async {
                if isLoading {
                    strself.aiv_loading.startAnimating()
                } else {
                    strself.aiv_loading.stopAnimating()
                }
            }
        }.disposed(by: disposeBag)
        
        // ERROR
        self.vm.error.skip(1).bind { [weak self] _ in
            guard let strself = self else { return }
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: "Periksa kembali internet anda dan ulangi sekali lagi", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default){ _ in
                    strself.vm.fetchLoanList()
                })
                strself.present(alert, animated: true,completion: nil)
            }
        }.disposed(by: disposeBag)
        
        // SORT
        b_sort.rx.tap.bind { [weak self] in
            guard let strself = self else { return }
            strself.present(strself.sortVC, animated: true)
        }.disposed(by: disposeBag)
        
        sortVC.publishSelection.bind { [weak self] (sorting, isAsc) in
            guard let strself = self else { return }
            strself.vm.sorting = sorting
            strself.vm.isDesc = !isAsc
            if !isAsc {
                strself.b_sort.setTitle("↓ " + sorting, for: .normal)
            }
            else {
                strself.b_sort.setTitle("↑ " + sorting, for: .normal)
            }
            strself.vm.sortLoanList()
        }.disposed(by: disposeBag)
        
        // FILTER
        b_filter.rx.tap.bind { [weak self] in
            guard let strself = self else { return }
            strself.present(strself.filterVC, animated: true)
        }.disposed(by: disposeBag)
        
        filterVC.vm.publishFilter.bind { [weak self] (purpose, term, risk) in
            guard let strself = self else { return }
            strself.vm.purposeFilter = purpose
            strself.vm.termFilter = term
            strself.vm.riskFilter = risk
            strself.vm.fetchLoanList()
        }.disposed(by: disposeBag)
        
        // SEARCH
        tf_search.rx.controlEvent(.primaryActionTriggered).bind { [weak self] in
            guard let strself = self, let text = strself.tf_search.text else { return }
            strself.vm.keywords = text.lowercased()
            strself.vm.fetchLoanList()
            strself.view.endEditing(true)
        }.disposed(by: disposeBag)
    }
}

// MARK: COLLECTION VIEW
extension LoanListVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width - 40, height: 126)
    }
    
}
