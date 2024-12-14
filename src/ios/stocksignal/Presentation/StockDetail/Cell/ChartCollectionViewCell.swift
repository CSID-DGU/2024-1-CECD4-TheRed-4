//
//  StockDetailChatCollectionViewCell.swift
//  stocksignal
//
//  Created by 신예빈 on 9/6/24.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher
import DGCharts
import RxSwift


final class ChartCollectionViewCell: UICollectionViewCell {
    static let id = "ChartCollectionViewCell"
    
    let data = [80200, 80100, 78800, 78900, 78400, 78200, 76500, 76400, 74600, 75000, 75000, 74700, 74300, 71200, 71200, 69700, 68200, 67300, 64500, 66600, 64500, 62200, 64700, 62200, 61500, 65400, 61500, 59900, 59600, 59500, 59400, 58900, 58900, 60800, 61000, 59500, 59700, 59200, 59000, 57700, 59100, 56600, 55900, 58100, 59600, 59100, 59200]
    
    let lineButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "linechart"), for: .normal)
        
        button.backgroundColor = .customBlue.withAlphaComponent(0)
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.customBlue.withAlphaComponent(0).cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let candleButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "candlestick"), for: .normal)
        
        button.backgroundColor = .customBlue.withAlphaComponent(0.2)
        button.clipsToBounds = true
        button.layer.cornerRadius = 3
        button.layer.borderColor = UIColor.customBlue.withAlphaComponent(0.5).cgColor
        button.layer.borderWidth = 1
        return button
    } ()
    
    let lineChartView: LineChartView = {
        let date = ["8.16", "8.19", "8.20", "8.21", "8.22", "8.23", "8.26", "8.27", "8.28", "8.29", "8.30", "9.2", "9.3", "9.4", "9.5", "9.6", "9.9", "9.10", "9.11", "9.12", "9.13", "9.19", "9.20", "9.23", "9.24", "9.25", "9.26", "9.27", "9.30", "10.2", "10.4", "10.7", "10.8", "10.10", "10.11", "10.14", "10.15", "10.16", "10.17", "10.18", "10.21", "10.22", "10.23", "10.24", "10.25", "10.28", "10.29", "10.30", "10.31", "11.1", "11.4", "11.5", "11.6", "11.7", "11.8", "11.11", "11.12", "11.13", "11.14", "11.15", "11.18", "11.19", "11.20", "11.21", "11.22", "11.25", "11.26", "11.27", "11.28", "11.29", "12.2", "12.3", "12.4", "12.5", "12.6", "12.7", "12.8"]
        
        let chartView = LineChartView()
        
        chartView.translatesAutoresizingMaskIntoConstraints = true
        chartView.backgroundColor = .clear
        
        // Chart 설정 - Legend, Description, Gridlines 제거
        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        
        // X축 설정 - 라벨 및 그리드 제거
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: date)
        //chartView.xAxis.granularity = 1 // X축 간격을 1로 설정하여 모든 레이블이 표시되도록 함
        chartView.xAxis.drawLabelsEnabled = true // X축 레이블 활성화
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.labelPosition = .bottom
        
//        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = 100
        chartView.setVisibleXRangeMaximum(100)
        
        // Y축 설정 - 왼쪽, 오른쪽 축 제거
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = true
        chartView.rightAxis.drawGridLinesEnabled = false

        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.dragEnabled = true
        
        return chartView
    }()
    
    let candleStickChartView: CandleStickChartView = {
        let date = ["8.16", "8.19", "8.20", "8.21", "8.22", "8.23", "8.26", "8.27", "8.28", "8.29", "8.30", "9.2", "9.3", "9.4", "9.5", "9.6", "9.9", "9.10", "9.11", "9.12", "9.13", "9.19", "9.20", "9.23", "9.24", "9.25", "9.26", "9.27", "9.30", "10.2", "10.4", "10.7", "10.8", "10.10", "10.11", "10.14", "10.15", "10.16", "10.17", "10.18", "10.21", "10.22", "10.23", "10.24", "10.25", "10.28", "10.29", "10.30", "10.31", "11.1", "11.4", "11.5", "11.6", "11.7", "11.8", "11.11", "11.12", "11.13", "11.14", "11.15", "11.18", "11.19", "11.20", "11.21", "11.22", "11.25", "11.26", "11.27", "11.28", "11.29", "12.2", "12.3", "12.4", "12.5", "12.6", "12.7", "12.8"]
        
        let chartView = CandleStickChartView()
        
        chartView.translatesAutoresizingMaskIntoConstraints = true
        chartView.backgroundColor = .clear
        
        // Chart 설정 - Legend, Description, Gridlines 제거
        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        
        // X축 설정 - 라벨 및 그리드 제거
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: date)
        //chartView.xAxis.granularity = 1 // X축 간격을 1로 설정하여 모든 레이블이 표시되도록 함
        chartView.xAxis.drawLabelsEnabled = true // X축 레이블 활성화
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.labelPosition = .bottom
        
//        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = 100
        chartView.setVisibleXRangeMaximum(100)
        
        // Y축 설정 - 왼쪽, 오른쪽 축 제거
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = true
        chartView.rightAxis.drawGridLinesEnabled = false

        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.dragEnabled = true
        
        return chartView
    }()
    
    var barChartView: BarChartView = {
        
        let chartView = BarChartView()
        
        chartView.translatesAutoresizingMaskIntoConstraints = true
        chartView.backgroundColor = .clear
        
        // Chart 설정 - Legend, Description, Gridlines 제거
        chartView.chartDescription.enabled = false
        chartView.legend.enabled = false
        
        //chartView.xAxis.granularity = 1 // X축 간격을 1로 설정하여 모든 레이블이 표시되도록 함
        chartView.xAxis.drawLabelsEnabled = true // X축 레이블 활성화
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.drawAxisLineEnabled = false
        chartView.xAxis.labelPosition = .bottom
        
//        chartView.xAxis.axisMinimum = 0
        chartView.xAxis.axisMaximum = 100
        chartView.setVisibleXRangeMaximum(50)
        
        // Y축 설정 - 왼쪽, 오른쪽 축 제거
        chartView.leftAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.rightAxis.drawGridLinesEnabled = false

        chartView.highlightPerDragEnabled = false
        chartView.highlightPerTapEnabled = false
        chartView.dragEnabled = true
        chartView.extraTopOffset = 10
        
        return chartView
    } ()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        //configure(with: entryData(values: data, startIdx: 0))
        
        self.addSubview(lineButton)
        self.addSubview(candleButton)
        
        self.addSubview(candleStickChartView)
        self.addSubview(lineChartView)
        self.addSubview(barChartView)
        
        lineButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.width.equalTo(35)
            make.height.equalTo(25)
        }
        
        candleButton.snp.makeConstraints { make in
            make.top.equalTo(lineButton.snp.top)
            make.leading.equalTo(lineButton.snp.trailing).offset(10)
            make.width.equalTo(35)
            make.height.equalTo(25)
        }
        
        candleStickChartView.snp.makeConstraints { make in
            make.top.equalTo(lineButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        lineChartView.snp.makeConstraints { make in
            make.top.equalTo(lineButton.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0)
        }
        
//        barChartView.snp.makeConstraints { make in
//            make.leading.trailing.bottom.equalToSuperview()
//            make.height.equalTo(100)
//        }
        setButton()
    }
    
    private var disposeBag = DisposeBag()
    
    private func setButton() {
        lineButton.rx.tap.observeOn(MainScheduler.instance).bind {[weak self] _ in
            self?.lineChartView.snp.updateConstraints { make in
                make.height.equalTo(200)
            }
            self?.candleStickChartView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self?.lineButton.layer.borderColor = UIColor.customBlue.withAlphaComponent(0.5).cgColor
            self?.lineButton.backgroundColor = .customBlue.withAlphaComponent(0.2)
            
            self?.candleButton.layer.borderColor = UIColor.customBlue.withAlphaComponent(0).cgColor
            self?.candleButton.backgroundColor = .customBlue.withAlphaComponent(0)
        }.disposed(by: disposeBag)
        
        candleButton.rx.tap.observeOn(MainScheduler.instance).bind {[weak self] _ in
            self?.lineChartView.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            self?.candleStickChartView.snp.updateConstraints { make in
                make.height.equalTo(200)
            }
            self?.lineButton.layer.borderColor = UIColor.customBlue.withAlphaComponent(0).cgColor
            self?.lineButton.backgroundColor = .customBlue.withAlphaComponent(0)
            
            self?.candleButton.layer.borderColor = UIColor.customBlue.withAlphaComponent(0.5).cgColor
            self?.candleButton.backgroundColor = .customBlue.withAlphaComponent(0.2)
        }.disposed(by: disposeBag)
    }

    func configure(with dataEntries: [ChartDataEntry]) {
        let dataSet = LineChartDataSet(entries: dataEntries, label: "Sample Data")

        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.2
        dataSet.lineWidth = 2.0
        dataSet.drawCirclesEnabled = false  // 원(circle) 비활성화
        dataSet.drawValuesEnabled = false  // 데이터 값 숨김

        //lineChartView.xAxis.axisMaximum = Double(self.data.count)
        let data = LineChartData(dataSet: dataSet)
        candleStickChartView.data = data
    }
    
    func configure(items: [Dates], page:String) {
        
        if (page == "scenario") {
            candleButton.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
            lineButton.snp.updateConstraints { make in
                make.height.equalTo(0)
            }
        }
        
        var value = items.map { $0.closePrice }
        var date = items.map {
            let month = $0.date[$0.date.index($0.date.startIndex, offsetBy: 4)...$0.date.index($0.date.startIndex, offsetBy: 5)]
                let day = $0.date[$0.date.index($0.date.startIndex, offsetBy: 6)...$0.date.index($0.date.startIndex, offsetBy: 7)]
            return "\(month).\(day)"
        }
        
        value = value.reversed()
        date = date.reversed()
        let item = Array(items.reversed())
        
        let dataSet = CandleChartDataSet(entries: entryData(values: item, startIdx: 0), label: "Sample Data")
        dataSet.colors = [NSUIColor.customBlack] // 라인 색상
        dataSet.decreasingColor = NSUIColor.customBlue // 하락 색상
        dataSet.increasingColor = NSUIColor.customRed // 상승 색상
        dataSet.neutralColor = NSUIColor.customBlack // 변동 없음 색상
        dataSet.decreasingFilled = true // 하락 시 캔들 채우기
        dataSet.increasingFilled = true // 상승 시 캔들 채우기
        dataSet.drawValuesEnabled = false  // 데이터 값 숨김
        
        candleStickChartView.setVisibleXRangeMaximum(100)
        //lineChartView.xAxis.axisMaximum = Double(self.data.count)
        let data = CandleChartData(dataSet: dataSet)
        candleStickChartView.data = data
        candleStickChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: date)
        
        let lineDataSet = LineChartDataSet(entries: lineEntryData(values: item, startIdx: 0), label: "line")
        
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.drawValuesEnabled = false
        lineDataSet.colors = [.systemBlue] // 라인 색상
        lineDataSet.circleColors = [.systemRed] // 데이터 포인트 색상
        lineDataSet.circleRadius = 4.0 // 데이터 포인트 크기
        lineDataSet.lineWidth = 2.0 // 라인 두께
        lineDataSet.valueColors = [.black] // 데이터 값 색상
        lineDataSet.mode = .cubicBezier
        let lineData = LineChartData(dataSets: [lineDataSet])
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: date)
        lineChartView.data = lineData
    }
    
    func practiceConfigure(items: [Dates]) {
        let item = Array(items.reversed())
        let date = items.enumerated().map { (index, element) in
            return String(index)
        }
        
        let dataSet = CandleChartDataSet(entries: entryData(values: item, startIdx: 0), label: "candle")
        dataSet.colors = [NSUIColor.customBlack] // 라인 색상
        dataSet.decreasingColor = NSUIColor.customBlue // 하락 색상
        dataSet.increasingColor = NSUIColor.customRed // 상승 색상
        dataSet.neutralColor = NSUIColor.customBlack // 변동 없음 색상
        dataSet.decreasingFilled = true // 하락 시 캔들 채우기
        dataSet.increasingFilled = true // 상승 시 캔들 채우기
        dataSet.drawValuesEnabled = false  // 데이터 값 숨김
    
        let data = CandleChartData(dataSet: dataSet)
        candleStickChartView.setVisibleXRangeMaximum(50)
        candleStickChartView.data = data
        candleStickChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: date)
        candleStickChartView.notifyDataSetChanged()
        
        let barDataSet = BarChartDataSet(entries: barchartEntryData(values: item, startIdx: 0), label: "bar")
        barDataSet.drawValuesEnabled = false  // 데이터 값 숨김
        let barData = BarChartData(dataSet: barDataSet)
        barChartView.data = barData
        barChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: date)
        barChartView.setVisibleXRangeMaximum(50)
        barChartView.notifyDataSetChanged()
        
        
        let lineDataSet = LineChartDataSet(entries: lineEntryData(values: item, startIdx: 0), label: "line")
        
        lineDataSet.drawCirclesEnabled = false
        lineDataSet.drawValuesEnabled = false
        lineDataSet.colors = [.systemBlue] // 라인 색상
        lineDataSet.circleColors = [.systemRed] // 데이터 포인트 색상
        lineDataSet.circleRadius = 4.0 // 데이터 포인트 크기
        lineDataSet.lineWidth = 2.0 // 라인 두께
        lineDataSet.valueColors = [.black] // 데이터 값 색상
        lineDataSet.mode = .cubicBezier
        let lineData = LineChartData(dataSets: [lineDataSet])
        lineChartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: date)
        lineChartView.data = lineData
        lineChartView.setVisibleXRangeMaximum(50)
        lineChartView.notifyDataSetChanged()
    }

    // entry 만들기
    func entryData(values: [Dates], startIdx:Int) -> [CandleChartDataEntry] {
        // entry 담을 array
        var candleChartDataEntries: [CandleChartDataEntry] = []
        // 담기
        for i in 0 ..< values.count {
            let candleChartDataEntry = CandleChartDataEntry(x: Double(i+startIdx), shadowH: Double(values[i].highPrice), shadowL: Double(values[i].lowPrice), open: Double(values[i].startPrice), close: Double(values[i].closePrice))
            candleChartDataEntries.append(candleChartDataEntry)
        }
        // 반환
        return candleChartDataEntries
    }
    
    func barchartEntryData(values: [Dates], startIdx:Int) -> [BarChartDataEntry] {
        // entry 담을 array
        var barChartDataEntries: [BarChartDataEntry] = []
        // 담기
        for i in 0 ..< values.count {
            let barChartDataEntry = BarChartDataEntry(x: Double(i+startIdx), y: Double(values[i].tradingVolume))
            barChartDataEntries.append(barChartDataEntry)
        }
        // 반환
        return barChartDataEntries
    }
    
    func lineEntryData(values: [Dates], startIdx:Int) -> [ChartDataEntry] {
        // entry 담을 array
        var chartDataEntries: [ChartDataEntry] = []
        // 담기
        for i in 0 ..< values.count {
            let chartDataEntry = ChartDataEntry(x: Double(i+startIdx), y: Double(values[i].closePrice))
            chartDataEntries.append(chartDataEntry)
        }
        // 반환
        return chartDataEntries
    }
    
    func lineEntryData(values: [Int], startIdx:Int) -> [ChartDataEntry] {
        // entry 담을 array
        var chartDataEntries: [ChartDataEntry] = []
        // 담기
        for i in 0 ..< values.count {
            let chartDataEntry = ChartDataEntry(x: Double(i+startIdx), y: Double(values[i]))
            chartDataEntries.append(chartDataEntry)
        }
        // 반환
        return chartDataEntries
    }
    
    
    public func predict(data: [Dates], predData: [Int]) {
        configure(items: data, page: "pred")
        
        let item = Array(data.reversed())
        
        let dataSet = LineChartDataSet(entries: lineEntryData(values: item, startIdx: 0), label: "Sample Data")
        dataSet.colors = [.customBlue]
        dataSet.mode = .cubicBezier
        dataSet.cubicIntensity = 0.2
        dataSet.lineWidth = 2.0
        dataSet.drawCirclesEnabled = false  // 원(circle) 비활성화
        dataSet.drawValuesEnabled = false  // 데이터 값 숨김
        
        let predDataSet = LineChartDataSet(entries: lineEntryData(values: predData, startIdx: dataSet.count-1), label: "Pred Data")
        predDataSet.colors = [.customRed]
        predDataSet.mode = .cubicBezier
        predDataSet.cubicIntensity = 0.2
        predDataSet.lineWidth = 2.0
        predDataSet.drawCirclesEnabled = false  // 원(circle) 비활성화
        predDataSet.drawValuesEnabled = false  // 데이터 값 숨김

        lineChartView.xAxis.axisMaximum = Double(dataSet.count + predDataSet.count - 1)
        let data = LineChartData(dataSets: [dataSet, predDataSet])
        lineChartView.data = data
       
        lineChartView.xAxis.axisMaximum = 130
        lineChartView.setVisibleXRangeMaximum(130)
        
        self.lineChartView.snp.updateConstraints { make in
            make.height.equalTo(200)
        }
        self.candleStickChartView.snp.updateConstraints { make in
            make.height.equalTo(0)
        }
        self.lineButton.layer.borderColor = UIColor.customBlue.withAlphaComponent(0.5).cgColor
        self.lineButton.backgroundColor = .customBlue.withAlphaComponent(0.2)
        
        self.candleButton.layer.borderColor = UIColor.customBlue.withAlphaComponent(0).cgColor
        self.candleButton.backgroundColor = .customBlue.withAlphaComponent(0)
        
        lineChartView.notifyDataSetChanged()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
