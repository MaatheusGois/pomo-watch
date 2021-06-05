//
//  ContentView.swift
//  pomodoro WatchKit Extension
//
//  Created by Matheus Gois on 04/06/21.
//

import SwiftUI

struct CountView: View {

    // MARK: - Properties

    @ObservedObject var viewModel = CountViewModel()

    // MARK: - Views

    var body: some View {
        VStack {
            buildTimerCountView()
            buildActionButton()
            buildCountView()
        }.onAppear {
            NotificationManager.requestAuthorization()
        }
    }
}

// MARK: - Build Views

fileprivate extension CountView {
    func buildTimerCountView() -> some View {
        VStack {
            Spacer()
            Text(viewModel.timerTitle)
                .font(.system(size: Constants.Font.timer))
                .foregroundColor(viewModel.workTime ? .red : .blue)
                .onReceive(viewModel.timer) { _ in
                    viewModel.incrementTimer()
                }

        }
        .padding([.top])
        .padding([.top])
    }

    func buildActionButton() -> some View {
        Button(action: {}, label: {
            Text(viewModel.buttonTitle)
        })
        .simultaneousGesture(
            LongPressGesture().onEnded { _ in
                viewModel.reset()
            }
        )
        .highPriorityGesture(
            TapGesture().onEnded { _ in
                viewModel.isRunning.toggle()
        })
        .padding([.leading, .trailing])
    }

    func buildCountView() -> some View {
        HStack {
            Text(viewModel.countTitle)
            Spacer()
            Text(viewModel.times.inTime)
        }.padding()
    }
}

// MARK: - Constants

fileprivate extension CountView {
    enum Constants {
        enum Font {
            static let timer: CGFloat = 72
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            CountView()
                .preferredColorScheme(.dark)
                .previewDevice("Apple Watch Series 6 - 44mm")
        }
    }
}
