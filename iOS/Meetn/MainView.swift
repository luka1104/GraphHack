// Copyright © 2022 Planogy Inc. All rights reserved.

import Alamofire
import PromiseKit
import SwiftUI
import Web3
import Web3ContractABI

struct MainView: View {
  @State private var balance: BigUInt = 0
  let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

  let web3 = Web3(rpcURL: "https://matic-mumbai--jsonrpc.datahub.figment.io/apikey/ff793c0e7575c24e8853a33e3c093b0c")
  let contractAddress = "0xc644e1e7A927EE75B558A8305e47e948238C7F5E"
  let privateKey = "<Your Testnet Private Key Goes Here>"

  var body: some View {
    VStack {
      // Welcome and bean count
      HStack {
        Text("Hey Bulent\nWelcome back")
          .font(.title)
          .fontWeight(.semibold)
          .padding()
        Spacer()
        HStack {
          Text(balance.formatted())
            .font(.system(size: 54))
            .fontWeight(.semibold)
          Image("Bean")
        }
        .padding()
      }
      .padding()
      Spacer()

      // Card
      // CardView(card: Card.example)
      //  .padding(30)
      // Spacer()

      // Bump it
      Button(action: {
        Task {
          try await bump()
        }
      }, label: {
        Text("Bump Phones\nto Earn Beans")
          .fontWeight(.semibold)
          .font(.title2)
          .foregroundColor(.white)
          .padding(.horizontal, 50)
          .padding(.vertical, 20)
          .background(Color("Brown"))
          .clipShape(Capsule())
      })
      Spacer()
    }
    .onReceive(timer) { _ in
      getBalance()
    }
    .onShake {
      Task {
        print("SHOOK")
        try await bump()
      }
    }
  }

  func bump() async throws {
    let headers: HTTPHeaders = ["Accept": "application/json"]
//    let welcome = try await AF.request("https://httpbin.org/json", method: .get, headers: headers)
//      .serializingDecodable(Welcome.self).value
//    debugPrint(welcome)

    let account = try! EthereumPrivateKey(hexPrivateKey: privateKey)
    let parameters = account.address
    do {
      let postValue = try await AF.request("https://meetn-web.vercel.app/api/transfer", method: .post, parameters: parameters, encoder: .json, headers: headers).serializingString().value
      debugPrint(postValue)
    } catch {
      print("ERROR: ", error)
    }
  }

  func getBalance() {
    do {
      let account = try! EthereumPrivateKey(hexPrivateKey: privateKey)

      let contractAddress = try EthereumAddress(hex: contractAddress, eip55: true)
      let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)

      // Get balance of some address
      firstly {
        contract.balanceOf(address: account.address).call()
      }.done { outputs in
        balance = outputs["_balance"] as! BigUInt / BigUInt(100_000_000)
        print(balance)
      }.catch { error in
        print("BALANCE ERROR: " + error.localizedDescription)
      }

    } catch {
      print("ERROR: " + error.localizedDescription)
    }
  }
}

struct MainView_Previews: PreviewProvider {
  static var previews: some View {
    MainView()
  }
}

// MARK: - Welcome

struct Welcome: Codable {
  let slideshow: Slideshow
}

// MARK: - Slideshow

struct Slideshow: Codable {
  let author, date: String
  let slides: [Slide]
  let title: String
}

// MARK: - Slide

struct Slide: Codable {
  let title, type: String
  let items: [String]?
}
