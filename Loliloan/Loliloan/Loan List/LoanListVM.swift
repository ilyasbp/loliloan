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
    
    /// - Note: Variable
    var keywords = ""
    var sorting = ""
    var isDesc = false
    var purposeFilter: [String] = []
    var termFilter: [String] = []
    var riskFilter: [String] = []
    
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
            guard let strself = self, let data = data, error == nil else {
                self?.error.accept((.loan, error ?? NSError(domain: "", code: 0)))
                return
            }
            do {
                var loans = try JSONDecoder().decode([Loan].self, from: data)
                strself.loading.accept((.loan, false))
                if !strself.keywords.isEmpty {
                    loans = loans.filter{
                        ($0.borrower?.name ?? "").lowercased().contains(strself.keywords) ||
                        String($0.amount ?? 0).lowercased().contains(strself.keywords) ||
                        ($0.purpose?.rawValue ?? "").lowercased().contains(strself.keywords) ||
                        String($0.term ?? 0).lowercased().contains(strself.keywords) ||
                        ($0.riskRating?.rawValue ?? "").lowercased().contains(strself.keywords)
                    }
                }
                if !strself.purposeFilter.isEmpty {
                    loans = loans.filter{ strself.purposeFilter.contains($0.purpose?.rawValue ?? "") }
                }
                if !strself.termFilter.isEmpty {
                    loans = loans.filter{ strself.termFilter.contains(String($0.term ?? 0)) }
                }
                if !strself.riskFilter.isEmpty {
                    loans = loans.filter{ strself.riskFilter.contains($0.riskRating?.rawValue ?? "") }
                }
                strself.loans.accept(loans)
                strself.sortLoanList()
            }
            catch {
                strself.error.accept((.loan, error))
            }
        }
        self.loading.accept((.loan, true))
        task.resume()
    }
    
    func sortLoanList() {
        var loans = self.loans.value
        switch sorting {
        case "Name":
            if self.isDesc {
                loans = loans.sorted{ $0.borrower?.name ?? "" > $1.borrower?.name ?? "" }
            }
            else {
                loans = loans.sorted{ $0.borrower?.name ?? "" < $1.borrower?.name ?? "" }
            }
        case "Term":
            if self.isDesc {
                loans = loans.sorted{ $0.term ?? 0 > $1.term ?? 0 }
            }
            else {
                loans = loans.sorted{ $0.term ?? 0 < $1.term ?? 0 }
            }
        case "Purpose":
            if self.isDesc {
                loans = loans.sorted{ $0.purpose?.rawValue ?? "" > $1.purpose?.rawValue ?? "" }
            }
            else {
                loans = loans.sorted{ $0.purpose?.rawValue ?? "" < $1.purpose?.rawValue ?? "" }
            }
        case "Risk":
            if self.isDesc {
                loans = loans.sorted{ $0.riskRating?.rawValue ?? "" > $1.riskRating?.rawValue ?? "" }
            }
            else {
                loans = loans.sorted{ $0.riskRating?.rawValue ?? "" < $1.riskRating?.rawValue ?? "" }
            }
        default:
            break
        }
        self.loans.accept(loans)
    }
}
