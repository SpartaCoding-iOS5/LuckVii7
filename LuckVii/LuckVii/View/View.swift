//
//  View.swift
//  LuckVii
//
//  Created by 김손겸 on 12/13/24.
//

import UIKit
import SnapKit


class MovieDetailView: UIView {
    
    // 포스터 이미지
    private let posterImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        imageview.backgroundColor = .lightGray
        
        return imageview
    }()
    
    // 영화 이름 레이블
    private let movieName: UILabel = {
        let label = UILabel()
        label.text = "영화 이름"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    // 영화 정보 레이블
    private let movieInformation: UILabel = {
        let label = UILabel()
        label.text = "2024.12.15 개봉 | 12세 이상 관람가 | 106분"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()

    // 좋아요 버튼
    private let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("♥ 9,999", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        
        return button
    }()
    
        
    }


