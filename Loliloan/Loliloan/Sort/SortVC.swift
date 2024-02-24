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
    private let vm = LoanListVM()
    // SUB: UI
    // SUB: Variable
    
    static func create() -> SortVC {
        let vc = SortVC(nibName: String(describing: self), bundle: nil)
        return vc
    }
}
 
 
// MARK: - LIFECYCLE
extension SortVC{
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
        
        vm.fetchLoanList()
    }
}
 
// MARK: - UI & BINDING
extension SortVC{
    func setupUI(){
        title = "Loan List"
        
        v_sortfilter.layer.cornerRadius = 6
        v_sortfilter.clipsToBounds = true
    }
    
    func setupBinding(){
        // FILTER LIST
    }
}
