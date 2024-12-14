package com.thered.stocksignal.presentation.newScenario

import android.graphics.Color
import android.os.Bundle
import android.widget.ImageView
import android.widget.TextView
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import androidx.databinding.DataBindingUtil
import androidx.lifecycle.ViewModelProvider
import com.bumptech.glide.Glide
import com.bumptech.glide.load.resource.bitmap.RoundedCorners
import com.bumptech.glide.request.RequestOptions
import com.github.mikephil.charting.charts.LineChart
import com.github.mikephil.charting.data.Entry
import com.github.mikephil.charting.data.LineData
import com.github.mikephil.charting.data.LineDataSet
import com.github.mikephil.charting.highlight.Highlight
import com.github.mikephil.charting.listener.OnChartValueSelectedListener
import com.thered.stocksignal.R
import com.thered.stocksignal.databinding.ActivityNewScenarioBinding

class NewScenarioActivity : AppCompatActivity() {

    lateinit var binding: ActivityNewScenarioBinding
    lateinit var newScenarioViewModel: NewScenarioViewModel
    private lateinit var dataList: List<Int>

    val entryList = ArrayList<Entry>()
    val lineChart: LineChart by lazy { findViewById(R.id.line_chart) }
    val imageView: ImageView by lazy { findViewById(R.id.imageView) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        binding = DataBindingUtil.setContentView(this, R.layout.activity_new_scenario)
        newScenarioViewModel = ViewModelProvider(this).get(NewScenarioViewModel::class.java)
        binding.viewModel = newScenarioViewModel
        binding.lifecycleOwner = this

        dataList = newScenarioViewModel.loadChartData()
        newScenarioViewModel.settingInitPrice(dataList[dataList.size - 1], 3.45f)

        Glide.with(this)
            .load("https://openchat-phinf.pstatic.net/MjAyMzExMjlfMTM0/MDAxNzAxMjE4OTc1OTcz.FmWyTUNBX_8Zq0XSsr5oHK5TaLQtbFecwnskVcGSSlEg.13XMoPlR2bY5SeOJFdmJRYkrhPofPtTaOKoZbhCGwOQg.PNG/jZhwE4H5QsyHlQobWR97Ng.png")
            .apply(RequestOptions().transform(RoundedCorners(80)))
            .into(imageView)

        // 그래프 설정 메소드 호출
        setupChart(lineChart, dataList)
    }

    // 그래프 설정 메소드
    fun setupChart(lineChart: LineChart, dataList: List<Int>) {
        // 데이터 포인트를 그래프에 맞게 변환
        val entryList = ArrayList<Entry>()
        dataList.forEachIndexed { index, data ->
            entryList.add(Entry(index.toFloat(), data.toFloat()))
        }

        lineChart.apply {
            // zoom disabled.
            setPinchZoom(false)
            setScaleEnabled(false)
            isDoubleTapToZoomEnabled = false

            // right, left, x axis disabled.
            // legend, description disabled.
            axisRight.isEnabled = false
            axisLeft.isEnabled = false
            xAxis.isEnabled = false
            legend.isEnabled = false
            description.isEnabled = true

            setOnChartValueSelectedListener(
                object : OnChartValueSelectedListener {
                    override fun onValueSelected(e: Entry?, h: Highlight?) {
                        e?.let {
                            newScenarioViewModel.setPrice(e.y.toInt())
                        }
                    }

                    override fun onNothingSelected() {
                        newScenarioViewModel.settingInitPrice(dataList[dataList.size - 1], 3.45f)
                    }
                }
            )
        }

        // LineDataSet에 Entry 추가
        val lineDataSet = LineDataSet(entryList, "Price Data")

        lineDataSet.mode = LineDataSet.Mode.CUBIC_BEZIER // 베지어 곡선 모드 설정
        lineDataSet.setDrawCircles(false) // 데이터 포인트에 원 그리지 않음
        lineDataSet.setDrawValues(false)  // 데이터 값을 표시하지 않음
        lineDataSet.lineWidth = 2f        // 선의 두께 설정
        lineDataSet.color = Color.BLUE

        // 최대값과 최소값 구하기
        val maxEntry = entryList.maxByOrNull { it.y }  // 최대값 Entry
        val minEntry = entryList.minByOrNull { it.y }  // 최소값 Entry

        val maxY = entryList.maxByOrNull { it.y }?.y ?: 0f  // 최대값
        val minY = entryList.minByOrNull { it.y }?.y ?: 0f  // 최소값

        // 최대/최소값만 표시할 데이터셋
        val maxMinEntries = mutableListOf<Entry>()
        maxEntry?.let { maxMinEntries.add(Entry(it.x, maxY)) }
        minEntry?.let { maxMinEntries.add(Entry(it.x, minY)) }

        val maxMinDataSet = LineDataSet(maxMinEntries, "Max/Min Data")
        maxMinDataSet.valueTextSize = 15.0F // 각 지점의 데이터 텍스트 크기
        maxMinDataSet.color = Color.WHITE
        maxMinDataSet.setDrawCircles(true)  // 최대/최소 값에만 원 모양 표시
        maxMinDataSet.setDrawCircleHole(false)
        maxMinDataSet.circleRadius = 3f
        maxMinDataSet.setDrawValues(false)  // 값 표시
        maxMinDataSet.lineWidth = 0f

        // LineData에 두 개의 DataSet 추가
        val lineData = LineData(lineDataSet, maxMinDataSet)

        // LineChart에 데이터 설정
        lineChart.data = lineData
        lineChart.setVisibleXRangeMaximum(100f)
        lineChart.animateX(1500)  // X축 방향으로 애니메이션
        lineChart.description.isEnabled = false  // 차트 설명 비활성화

        // 오른쪽 Y축 설정
        val rightAxis = lineChart.axisRight
        rightAxis.isEnabled = true // 오른쪽 Y축 활성화
        rightAxis.setDrawGridLines(false) // 가로선 제거
        rightAxis.axisMaximum = maxY  // 오른쪽 Y축의 최대값
        rightAxis.axisMinimum = minY  // 오른쪽 Y축의 최소값
        rightAxis.textColor = resources.getColor(android.R.color.darker_gray) // 텍스트 색상 변경

        // 차트 새로고침
        lineChart.invalidate()
    }
}
