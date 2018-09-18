//
//  QuoteProtocols.swift
//  QuoteApp
//
//  Created Mohamed Emad Abdalla Hegab on 17.07.18.
//  Copyright © 2018 Mohamed Hegab. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

import Foundation

//MARK: Wireframe -
protocol QuoteWireframeProtocol: class {

}
//MARK: Presenter -
protocol QuotePresenterProtocol: class {
    func getRandomQuote(onComplete: @escaping (Quote) -> Void, onError: @escaping (Error) -> Void)
}

//MARK: Interactor -
protocol QuoteInteractorProtocol: class {
    func getRandomQuote(onComplete: @escaping (Quote) -> Void, onError: @escaping (Error) -> Void)
    var presenter: QuotePresenterProtocol?  { get set }
}

//MARK: View -
protocol QuoteViewProtocol: class {

    var presenter: QuotePresenterProtocol?  { get set }
}
