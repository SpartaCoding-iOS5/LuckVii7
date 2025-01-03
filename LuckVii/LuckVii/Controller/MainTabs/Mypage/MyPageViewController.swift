//
//  MyPageViewController.swift
//  LuckVii
//
//  Created by Jamong on 12/17/24.
//

import UIKit
import SnapKit
import SwiftUI

final class MyPageViewController: UIViewController {

    // MypageView Components 가져오기
    private let myPageView = MyPageView()

    private let loginManager = LoginManager(userDefaultsManager: UserDefaultsManager.shared)

    private var isLoggedin = false

    private var ticketCount = 0

    private var reservations: [ReservationInfoData] = []

    override func loadView() {
        self.view = myPageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        setupAction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUserData()
        loadReserVations()
    }
    

    private func setupUI() {
        view.backgroundColor = .white
        navigationItem.title = "마이페이지"
    }

    private func setupTableView() {
        myPageView.movieReservationTableView.delegate = self
        myPageView.movieReservationTableView.dataSource = self
    }

    private func setupAction() {
        myPageView.loginButton.addAction(UIAction { [weak self] _ in
            self?.loginButtonTapped()
        }, for: .touchUpInside)
    }

    private func loginButtonTapped() {
        if isLoggedin {
            UserDefaultsManager.shared.setLoggedInStatus(false)
            isLoggedin = false
            myPageView.setupLogoutUI()
            loadReserVations()
        } else {
            loginManager.ensurePresentLoginModal(viewController: self)
            loadReserVations()
        }
    }

    private func loadUserData() {
        isLoggedin = UserDefaultsManager.shared.getLoggedInStatus()

        if isLoggedin {
            let userID = UserDefaultsManager.shared.getUserId()
            let userPW = UserDefaultsManager.shared.getUserPw()
            let userNick = UserDataManger.shared.checkNick(userID, userPW)
            print(userID, userPW, isLoggedin)
            myPageView.setupLoginUI(userNick!, ticketCount)
        } else {
            myPageView.setupLogoutUI()
            myPageView.movieReservationTableView.reloadData()
        }
    }

    private func loadReserVations() {
        // CoreData 예매 정보 가져옴
        let id = UserDefaultsManager.shared.getUserId()

        if isLoggedin {
            guard let user = UserDataManger.shared.fetchUserById(id) else { return }
            reservations = UserDataManger.shared.fetchReservations(for: user)
            self.ticketCount = reservations.count
        } else {
            reservations = []
            ticketCount = 0
        }
        myPageView.updateTableViewHeight(numberOfRows: reservations.count)
        myPageView.movieReservationTableView.reloadData()
        myPageView.setupTicketCount(ticketCount)
    }

}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reservations.count
    }

        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MovieReservationCell.identifier, for: indexPath) as? MovieReservationCell else {
            return UITableViewCell()
        }
        
        let reservation = reservations[indexPath.row]
        let movieData = ReservationInfoData(
            title: reservation.title,
            dateTime: reservation.dateTime,
            theater: reservation.theater,
            posterImage: reservation.posterImage,
            ticketCount: reservation.ticketCount,
            price: reservation.price,
            seatNumber: reservation.seatNumber
        )
       
        cell.configure(with: movieData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let reservation = reservations[indexPath.row]
        let detailVC = ReservationDetailViewController()
        detailVC.configure(with: reservation)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension MyPageViewController: LoginViewControllerDelegate {
    func updateUserData(_ viewController: LoginViewController, nickName: String) {
        isLoggedin = true
        loadReserVations()
        myPageView.setupLoginUI(nickName, ticketCount)
    }
}
