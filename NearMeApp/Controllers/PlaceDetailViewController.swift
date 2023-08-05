//
//  PlaceDetailViewController.swift
//  NearMeApp
//
//  Created by Enigma Kod on 09/07/2023.
//

import Foundation
import UIKit

class PlaceDetailViewController: UIViewController {
    let place: PlaceAnnotation
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.title1)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        label.alpha = 0.4
        return label
    }()
    
    lazy var directionButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Direction", for: .normal)
        return button
    }()
    
    lazy var callButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.bordered())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Call", for: .normal)
        return button
    }()
    
    init(place: PlaceAnnotation) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        
        setUpUI()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUpUI() {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.spacing = UIStackView.spacingUseSystem
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20)
        
        nameLabel.text = place.name
        addressLabel.text = place.address
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(addressLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 10)
        ])
        
        let stackContactView = UIStackView()
        stackContactView.translatesAutoresizingMaskIntoConstraints = false
        stackContactView.axis = .horizontal
        stackContactView.spacing = UIStackView.spacingUseSystem
        
        stackContactView.addArrangedSubview(directionButton)
        stackContactView.addArrangedSubview(callButton)
        
        directionButton.addTarget(self, action: #selector(directionButtonTapped), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
        
        stackView.addArrangedSubview(stackContactView)
        view.addSubview(stackView)
    }
    
    @objc private func directionButtonTapped(_ sender: UIButton) {
        place.mapItem.openInMaps()
//        let coordinate = place.location.coordinate
//        guard let url = URL(string: "https://maps.apple.com?daddr=\(coordinate.latitude),\(coordinate.longitude)") else { return }
//        UIApplication.shared.open(url)
    }
    
    @objc private func callButtonTapped(_ sender: UIButton) {
        guard let url = URL(string: "tel://\(place.phone.formattedPhoneForCall())") else { return }
        UIApplication.shared.open(url)
    }
}
