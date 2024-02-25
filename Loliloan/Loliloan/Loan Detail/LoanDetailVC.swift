//
//  LoanDetailVC.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 25/02/24.
//

import UIKit
import RxSwift
import RxCocoa
 
// MARK: - INITIAL
class LoanDetailVC: UIViewController {
    // SUB: Reactive
    let disposeBag = DisposeBag()
    let vm = LoanDetailVM()
    // SUB: UI
    @IBOutlet weak var v_borrower: UIView!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_email: UILabel!
    @IBOutlet weak var lb_creditscore: UILabel!
    @IBOutlet weak var v_collateral: UIView!
    @IBOutlet weak var lb_collateraltype: UILabel!
    @IBOutlet weak var lb_collateralvalue: UILabel!
    @IBOutlet weak var cv_payment: UICollectionView!
    @IBOutlet weak var cv_document: UICollectionView!
    @IBOutlet weak var v_emptydoc: UIView!
    // SUB: Variable
    
    static func create(loan: Loan) -> LoanDetailVC {
        let vc = LoanDetailVC(nibName: String(describing: self), bundle: nil)
        vc.vm.loan.accept(loan)
        return vc
    }
}
 
 
// MARK: - LIFECYCLE
extension LoanDetailVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
}
 
// MARK: - UI & BINDING
extension LoanDetailVC{
    func setupUI(){
        title = "Loan Detail"
        v_borrower.roundCorner()
        v_collateral.roundCorner()
    }
    
    func setupBinding(){
        vm.loan.bind { [weak self] loan in
            guard let strself = self else { return }
            strself.lb_name.text = loan.borrower?.name
            strself.lb_email.text = loan.borrower?.email
            if let creditScore = loan.borrower?.creditScore {
                strself.lb_creditscore.text = String(creditScore)
                if creditScore > 740 {
                    strself.lb_creditscore.textColor = .darkgreen
                }
                else if creditScore > 670 {
                    strself.lb_creditscore.textColor = .orangeyellow
                }
                else {
                    strself.lb_creditscore.textColor = .orangered
                }
            }
            strself.lb_collateraltype.text = loan.collateral?.type?.rawValue
            strself.lb_collateralvalue.text = MoneyUtils.toRupiah(loan.collateral?.value ?? 0)
            
            strself.vm.installments.accept(loan.repaymentSchedule?.installments ?? [])
            
            guard let documents = loan.documents else { return }
            strself.v_emptydoc.isHidden = !documents.isEmpty
            strself.vm.documents.accept(documents)
        }.disposed(by: disposeBag)
        
        // PAYMENT LIST
        cv_payment.register(UINib(nibName: String(describing: PaymentCell.self), bundle: nil), forCellWithReuseIdentifier: PaymentCell.identifier)
        
        vm.installments.bind(to: cv_payment.rx.items(cellIdentifier: PaymentCell.identifier, cellType: PaymentCell.self)) { (row, data, cell) in
            cell.lb_date.text = data.dueDate
            cell.lb_amount.text = MoneyUtils.toRupiah(data.amountDue ?? 0)
        }.disposed(by: disposeBag)
        
        // DOC LIST
        cv_document.register(UINib(nibName: String(describing: DocumentCell.self), bundle: nil), forCellWithReuseIdentifier: DocumentCell.identifier)
        
        vm.documents.bind(to: cv_document.rx.items(cellIdentifier: DocumentCell.identifier, cellType: DocumentCell.self)) { (row, data, cell) in
            cell.lb_docname.text = data.type?.rawValue
        }.disposed(by: disposeBag)
        
        cv_document.rx.modelSelected(Document.self).bind { [weak self] doc in
            if let nc = self?.navigationController {
                let vc = DocumentVC.create(document: doc)
                nc.pushViewController(vc, animated: true)
            }
        }.disposed(by: disposeBag)
    }
}
