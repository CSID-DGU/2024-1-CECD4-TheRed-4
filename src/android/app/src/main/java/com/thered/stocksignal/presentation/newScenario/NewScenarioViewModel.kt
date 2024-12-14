package com.thered.stocksignal.presentation.newScenario

import android.annotation.SuppressLint
import android.graphics.Color
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import com.thered.stocksignal.R
import java.security.KeyStore
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.data.LineData
import com.github.mikephil.charting.data.LineDataSet

class NewScenarioViewModel: ViewModel() {

    var initPrice: Int = 0
    var initRate: Float = 0f
    var price: MutableLiveData<String> = MutableLiveData("")
    var rate: MutableLiveData<String> = MutableLiveData("")
    var rateColor: MutableLiveData<Int> = MutableLiveData(0)

    private var dataPoints = listOf(77600, 79600, 78900, 80000, 82200, 83700, 84100, 83600, 84500, 84500, 85300, 84100, 85000, 82000, 82400, 80800, 79800, 79900, 78200, 78900, 79300, 76900, 72800, 72800, 72300, 74300, 74100, 73300, 72400, 73300, 72200, 72900, 73700, 74900, 73400, 73200, 72900, 72800, 72900, 73100, 73000, 73300, 73800, 72800, 73000, 74000, 75200, 74100, 75000, 74400, 74300, 75200, 73600, 72700, 74300, 74400, 73400, 74100, 74000, 75200, 75100, 74700, 71700, 71000, 72600, 73900, 73100, 73200, 73600, 74700, 76500, 76600, 76600, 77000, 79600, 78500, 78000, 76600, 75900, 75000, 74800, 73400, 72900, 73300, 73100, 72800, 73500, 73000, 72600, 71500, 71700, 71200, 72600, 72000, 72800, 72700, 72700, 71300, 71700, 72400)

    fun loadChartData(): List<Int> {
        return dataPoints
    }

    fun settingInitPrice(n: Int, r: Float) {
        val formattedNumber = String.format("%,d", n)
        val formattedRate = String.format("%.2f", r)
        initPrice = n
        price.value = "$formattedNumber 원"
        rate.value = "+$formattedRate%"

        if (initRate < 0f) {
            rateColor.value = Color.parseColor("#0080FF")
            rate.value = "$formattedRate%"
        } else if (initRate > 0f) {
            rateColor.value = Color.parseColor("#FF5353")
        } else {
            rateColor.value = Color.parseColor("#333333")
        }
    }

    fun setPrice(n: Int) {
        val r: Float = (n - initPrice).toFloat() / initPrice.toFloat() * 100
        val formattedNumber = String.format("%,d", n)
        val formattedRate = String.format("%.2f", r)

        price.value = "$formattedNumber 원"
        rate.value = "+$formattedRate%"

        if (r < 0f) {
            rateColor.value = Color.parseColor("#0080FF")
            rate.value = "$formattedRate%"
        } else if (r > 0f) {
            rateColor.value = Color.parseColor("#FF5353")
        } else {
            rateColor.value = Color.parseColor("#333333")
        }
    }

    fun setupChartData(dataList: List<Int>): LineData {
        val entryList = ArrayList<Entry>()

        dataList.forEachIndexed { index, data ->
            entryList.add(Entry(index.toFloat(), data.toFloat()))
        }

        val lineDataSet = LineDataSet(entryList, "Price Data")
        lineDataSet.mode = LineDataSet.Mode.CUBIC_BEZIER
        lineDataSet.setDrawCircles(false)
        lineDataSet.setDrawValues(false)
        lineDataSet.lineWidth = 2f
        lineDataSet.color = Color.BLUE

        return LineData(lineDataSet)
    }
}
