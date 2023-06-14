//
//  ChartLearnView.swift
//  FlashSpeak
//
//  Created by Denis Dmitriev on 13.06.2023.
//

import SwiftUI
import Charts

struct ChartLearnView: View {
    var viewModels: [ChartLearnViewModel]
    var color: Color = .green
    
    var body: some View {
        Chart(viewModels.sorted(by: { $0.date < $1.date }), id: \.date) { model in
            LineMark(
                x: .value("Date", model.date),
                y: .value("Result", model.result)
            )
            .foregroundStyle(color)
//            .foregroundStyle(by: .value("Result", model.stat))
            
            PointMark(
                x: .value("Date", model.date),
                y: .value("Result", model.result)
            )
            .foregroundStyle(color)
//            .foregroundStyle(by: .value("Result", model.stat))
            
            AreaMark(
                x: .value("Date", model.date),
                y: .value("Result", model.result)
            )
            .foregroundStyle(Gradient(colors: [color, .clear]))
        }
        .chartForegroundStyleScale([
            "\(viewModels.first?.stat.primitivePlottable ?? "Result")": color
        ])
        .chartYAxisLabel(position: .trailing, alignment: .center) {
            Text("Result")
        }
        .chartXAxisLabel(position: .bottom, alignment: .center) {
            Text("Date")
        }
    }
}

struct ChartLearnView_Previews: PreviewProvider {
    static var previews: some View {
        ChartLearnView(viewModels: [
            ChartLearnViewModel(stat: .rights, date: Date.now - 100, result: .random(in: 0...50)),
            ChartLearnViewModel(stat: .rights, date: Date.now, result: .random(in: 0...50)),
            ChartLearnViewModel(stat: .rights, date: Date.now + 100, result: .random(in: 0...50)),
            ChartLearnViewModel(stat: .duration, date: Date.now - 100, result: .random(in: 0...100)),
            ChartLearnViewModel(stat: .duration, date: Date.now, result: .random(in: 0...100)),
            ChartLearnViewModel(stat: .duration, date: Date.now + 100, result: .random(in: 0...100))
        ])
        .previewLayout(.fixed(width: 300, height: 150))
    }
}
