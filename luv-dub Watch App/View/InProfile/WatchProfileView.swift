//
//  WatchProfileView.swift
//  luv-dub Watch App
//
//  Created by 조한동 on 2023/07/18.
//

import SwiftUI

struct ProfileView: View {
    @State var switchNotification: Bool = true
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 13)
                    .foregroundColor(Color(red: 29 / 255, green: 29 / 255, blue: 29 / 255))
                    .frame(height: 44)
                    .padding(.horizontal, 7)
                Toggle("Notification", isOn: $switchNotification)
                    .toggleStyle(SwitchToggleStyle(tint: Color.pink))
                    .padding(.horizontal, 17)
            }
            .padding(.bottom, 14)
            .padding(.top, 6)
            HStack{
                NicknameView(isMe: true)
                    .padding(.leading, 8)
                    .padding(.trailing, 4)
                NicknameView(isMe: false)
                    .padding(.leading, 4)
                    .padding(.trailing, 8)
            }
            .overlay {
                LinearGradient(
                stops: [
                Gradient.Stop(color: Color(red: 1, green: 0.3, blue: 0.48), location: 0.00),
                Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.92, y: 0.1),
                endPoint: UnitPoint(x: 0.15, y: 0.87)
                )
                .mask(Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .padding(.top, 35))
            }
        }
    }
}

struct NicknameView: View {
    var isMe : Bool
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 15)
                .strokeBorder(Color.pink, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 15).foregroundColor(isMe ? Color.pink : Color.black))
                .frame(width: isMe ? 28 : 47, height: 17, alignment: .center)
                .overlay {
                    Text(isMe ? "ME" : "LOVER")
                        .font(.system(size: 11))
                        .fontWeight(.heavy)
                }
                .padding(.bottom, 5)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(isMe ? Color.pink : Color.gray)
                VStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [.black, .gray]), startPoint: .top, endPoint: .bottom)
                        .opacity(0.25)
                        .cornerRadius(11, corners: [.topLeft, .topRight])
                    LinearGradient(gradient: Gradient(colors: [.gray, .black]), startPoint: .top, endPoint: .bottom)
                        .cornerRadius(11, corners: [.bottomLeft, .bottomRight])
                        .opacity(0.25)
                    
                }
                VStack{
                    Text(isMe ? "Rimee" : "Jay")
                        .font(.system(size: 25))
                        .fontWeight(.bold)
                    Text(isMe ? "Hyelim Lee" : "Ildong Jo")
                        .font(.system(size: 13))
                }
            }
        }
    }
}
//
//struct ProfileView_Previews: PreviewProvider {
//    static var previews: some View {
//        ProfileView()
//    }
//}

//CornerRadius를 특정 모서리에만 줄 수 있도록 하는 익스텐션
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

//CornerRadius를 특정 모서리에만 줄 수 있도록 하는 struct
struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

