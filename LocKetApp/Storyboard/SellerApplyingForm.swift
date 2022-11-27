//
//  SellerApplyingForm.swift
//  LocKetApp
//
//  Created by 나유진 on 2022/11/26.
//

import SwiftUI

struct SellerApplyingForm: View {
    @State var sns: String = ""
    @State var description: String = ""
    
    var body: some View {
        VStack{
            Image("default")
                .clipShape(Circle())
                .overlay {
                    Circle().stroke(.white, lineWidth: 4)
                        
                }
                .shadow(radius: 7)
                .offset(y: -130)
                .padding(.bottom, -130)
                .imageScale(.small)
            TextField("SNS 주소", text: $sns)
               // .background(Color(uiColor: .secondarySystemBackground))
                .textFieldStyle(.roundedBorder)
            TextField("설명", text: $description)
                .textFieldStyle(.roundedBorder)
        }.padding()
    }
}

struct SellerApplyingForm_Previews: PreviewProvider {
    static var previews: some View {
        SellerApplyingForm()
    }
}
