//
//  UIApplication+Extension.swift
//  SecureApp
//
//  Created by Богдан Зыков on 10.01.2022.
//

import UIKit

extension UIApplication{
    func endEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

