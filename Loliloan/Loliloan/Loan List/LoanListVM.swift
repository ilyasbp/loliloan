//
//  LoanListVM.swift
//  Loliloan
//
//  Created by Ilyas Bintang Prayogi on 24/02/24.
//

import RxSwift
import RxRelay

// MARK: - ENUM
extension LoanListVM {
    enum ErrorService{
        case ok
        case loan
    }
    
    enum LoadingAt{
        case loan
    }
}


// MARK: - INIT
class LoanListVM {
    
    /// - Note: Parameter
    
    /// - Note: Result
    let loans = BehaviorRelay<[Loan]>(value: [])
    
    /// - Note: Error & Loading
    let error = BehaviorRelay<(ErrorService, Error)>(value: (.ok, NSError(domain: "", code: 0)))
    let loading = BehaviorRelay<(LoadingAt, Bool)>(value: (.loan, false))
}


// MARK: - SERVICE
extension LoanListVM{
    func fetchLoanList(){
        guard let url = URL(string: "https://raw.githubusercontent.com/andreascandle/p2p_json_test/main/api/json/loans.json") else { return }
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                self?.error.accept((.loan, error ?? NSError(domain: "", code: 0)))
                return
            }
            do {
                let loans = try JSONDecoder().decode([Loan].self, from: data)
                self?.loading.accept((.loan, false))
                self?.loans.accept(loans)
            }
            catch {
                self?.error.accept((.loan, error))
            }
        }
        self.loading.accept((.loan, true))
        task.resume()
    }
}
