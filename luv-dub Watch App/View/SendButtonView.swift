//
//  SendButtonView.swift
//  luv-dub Watch App
//
//  Created by 김예림 on 2023/07/25.
//

import SwiftUI

struct SendButtonView: View {
    @EnvironmentObject private var viewModel: ButtonViewModel
    @StateObject private var mainPushViewModel: MainPushViewModel = MainPushViewModel()
    @State private var stateUI: CompleteViewStatus = .SENDING
    
    var body: some View {
        ZStack {
            if viewModel.longPressDetected {
                ProgressBar()
            }
            if viewModel.isProgressComplete {
                switch stateUI {
                case .SENDING:
                    StatusView()
                        .task{ stateUI = await mainPushViewModel.testSuccess() }
                case .SUCCESS:
                    VStack{
                        Circle()
                            .fill(Color(red: 1, green: 0.22, blue: 0.37).opacity(0.2))
                            .frame(width: 30, height: 30)
                            .modifier(CircleCheckmarkStyle(isSuccess: true))
                        
                        Text("전송 완료")
                            .modifier(TextStyle(textSize: 15, textWeight: .semibold, textKerning: 0.015))
                            .padding(5)
                        
                        Text("상대방에게 \n 나의 마음을 보냈어요")
                            .modifier(TextStyle(textSize: 10, textWeight: .regular, textKerning: 0.01))
                    }
                    .task{ stateUI = await mainPushViewModel.testIDLE() }
                    .onAppear{ viewModel.finishSend() }
                case .FAIL:
                    VStack{
                        
                        Circle()
                            .fill(Color(red: 1, green: 0.22, blue: 0.37).opacity(0.2))
                            .frame(width: 30, height: 30)
                            .modifier(CircleCheckmarkStyle(isSuccess: viewModel.isSendComplete))
                        
                        Text("전송 실패")
                            .modifier(TextStyle(textSize: 15, textWeight: .semibold, textKerning: 0.015))
                            .padding(5)
                        
                        Text("알림 전송이 실패했습니다 \n 다시 시도해 주세요")
                            .modifier(TextStyle(textSize: 10, textWeight: .regular, textKerning: 0.01))
                    }
                    .task{ stateUI = await mainPushViewModel.testIDLE() }
                    .onAppear{ viewModel.finishSend() }
                case .IDLE:
                    Text("문제가 발생했습니다.")
                }
            } else {
                Button(action: { }) {
                    Text("SEND")
                        .modifier(ButtonTextStyle())
                }
                .buttonStyle(SendButtonStyle(isPossibleToSend: viewModel.remainingHearts > 0))
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0.0)
                        .onChanged{ _ in
                            viewModel.startProgressAnimation()
                        }
                        .onEnded{ _ in
                            viewModel.longPressDetected = false
                        }
                )
                .onDisappear{ stateUI = .SENDING }
                .disabled(viewModel.remainingHearts == 0)

            }
        }
    }
}



// Button Style
fileprivate struct SendButtonStyle: ButtonStyle {
    let isPossibleToSend: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundColor(configuration.isPressed ? .white.opacity(0.7) : .white)
            .background(
                ZStack {
                    Circle()
                        .fill(
                            isPossibleToSend ? LinearGradient(stops: [
                                Gradient.Stop(color: Color(red: 1, green: 0.3, blue: 0.48), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.98, green: 0.07, blue: 0.31), location: 1.00),
                            ], startPoint: UnitPoint(x: 0.92, y: 0.1), endPoint: UnitPoint(x: 0.15, y: 0.87))
                            : LinearGradient(stops: [
                                Gradient.Stop(color: Color(red: 0.5, green: 0.5, blue: 0.5), location: 0.00),
                                Gradient.Stop(color: Color(red: 0.5, green: 0.5, blue: 0.5), location: 1.00),
                            ], startPoint: UnitPoint(x: 0.92, y: 0.1), endPoint: UnitPoint(x: 0.15, y: 0.87))
                        )
                        .frame(width: 116, height: 116)
                        .shadow(color: .black.opacity(configuration.isPressed ? 0.6 : 0.8), radius: 2, x: 0, y: 0)
                        .mask(Circle())
                    if configuration.isPressed {
                        Circle().fill(
                            Color.black.opacity(0.3)
                        )
                    }
                }
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

// Button Text Style
fileprivate struct ButtonTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(
                Font.custom("Apple SD Gothic Neo", size: 14)
                    .weight(.bold)
            )
            .kerning(0.1)
            .multilineTextAlignment(.center)
        
    }
}




struct SendButtonView_Previews: PreviewProvider {
    static var previews: some View {
        SendButtonView()
            .environmentObject(ButtonViewModel())
    }
}
