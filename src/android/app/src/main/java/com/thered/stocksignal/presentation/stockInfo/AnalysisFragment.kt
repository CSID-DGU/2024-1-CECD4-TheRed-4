package com.thered.stocksignal.presentation.stockinfo

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.fragment.app.Fragment
import android.widget.SeekBar
import android.widget.TextView
import com.thered.stocksignal.R
import android.widget.Toast
import com.thered.stocksignal.Data.Network.RetrofitClient
import com.thered.stocksignal.Data.model.CompanyInfoResponse
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import com.thered.stocksignal.Data.Network.StockInfoApiService
import com.thered.stocksignal.Data.model.CurrentPriceResponse
import com.thered.stocksignal.Data.model.StockData

class AnalysisFragment : Fragment() {

    private lateinit var companyNameTextView: TextView // 회사명
    private var companyData: StockData? = null
    private var currentPrice: Int = 0
    private lateinit var currentPriceTextView: TextView
    private lateinit var startPriceTextView: TextView
    private lateinit var endPriceTextView: TextView
    private lateinit var volumeTextView: TextView
    private lateinit var tradeAmountTextView: TextView
    private lateinit var dayseekbar: SeekBar
    private lateinit var yearSeekBar: SeekBar
    private lateinit var yearLowPriceTextView: TextView  // 1년 최저가 TextView
    private lateinit var yearHighPriceTextView: TextView // 1년 최고가 TextView
    private lateinit var dayLowPriceTextView: TextView  // 1년 최저가 TextView
    private lateinit var dayHighPriceTextView: TextView // 1년 최고가 TextView
    companion object {
        private const val TAG = "API"
    }
    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_analysis, container, false)
    }
    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        companyNameTextView = view.findViewById(R.id.company_title)

        val companyName = arguments?.getString("company_name")
        Log.d("ReceivedCompanyName", "받은 회사 이름: $companyName")

        if (!companyName.isNullOrBlank()) {
            fetchCompanyInfo(companyName)
            companyNameTextView = view.findViewById(R.id.company_title)

        }
        // UI 요소들 연결
        currentPriceTextView=view.findViewById(R.id.current_value)
        startPriceTextView = view.findViewById(R.id.start_price)
        endPriceTextView = view.findViewById(R.id.end_price)
        volumeTextView = view.findViewById(R.id.volume)
        tradeAmountTextView = view.findViewById(R.id.trade_amount)
        // 1년 최저가/최고가 TextView 연결
        yearLowPriceTextView = view.findViewById(R.id.one_year_low_price)
        yearHighPriceTextView = view.findViewById(R.id.one_year_high_price)
        // 1일 최저가/최고가 TextView 연결
        dayLowPriceTextView = view.findViewById(R.id.one_day_low_price)
        dayHighPriceTextView = view.findViewById(R.id.one_day_high_price)
        // SeekBar들
        dayseekbar = view.findViewById(R.id.day_seekbar)
        yearSeekBar = view.findViewById(R.id.year_seekbar)
        dayseekbar.isEnabled = false
        yearSeekBar.isEnabled = false
    }
    private fun fetchCompanyInfo(companyName: String) {
        Log.d(TAG, "Fetching company info for: $companyName")
        RetrofitClient.stockInfoApi.getCompanyInfo(companyName)
            .enqueue(object : Callback<CompanyInfoResponse> {
                override fun onResponse(
                    call: Call<CompanyInfoResponse>,
                    response: Response<CompanyInfoResponse>
                ) {
                    if (response.isSuccessful && response.body() != null) {
                        Log.d(TAG, "API complete: ${response.body()}")
                        companyData = response.body()?.data
                        // 데이터가 로드되면 UI 업데이트
                            activity?.runOnUiThread {
                                updateUI()
                            }
                        fetchCurrentPrice(companyName)
                    } else {
                        Log.e(TAG, "API fail: ${response.errorBody()?.string()}")
                        Toast.makeText(context, "분석 데이터를 불러오는데 실패했습니다.", Toast.LENGTH_SHORT).show()
                    }
                }
                override fun onFailure(call: Call<CompanyInfoResponse>, t: Throwable) {
                    Log.e(TAG, "API fail: ${t.message}", t)
                    Toast.makeText(context, "API 호출 실패: ${t.message}", Toast.LENGTH_SHORT).show()
                }
            })
    }
    private fun fetchCurrentPrice(companyName: String) {
        Log.d(TAG, "Fetching current price for: $companyName")
        RetrofitClient.stockInfoApi.getCurrentPrice(companyName)
            .enqueue(object : Callback<CurrentPriceResponse> {
                override fun onResponse(
                    call: Call<CurrentPriceResponse>,
                    response: Response<CurrentPriceResponse>
                ) {
                    if (response.isSuccessful && response.body() != null) {
                        val currentPrice = response.body()?.data?.currentPrice ?: 0
                        // 현재가를 companyData에 병합
                        companyData?.currentPrice = currentPrice

                        // 데이터가 로드되면 UI 업데이트
                        activity?.runOnUiThread {
                            updateUI()
                        }
                        Log.d(TAG, "Current price: $currentPrice")
                        // SeekBar 업데이트
                        activity?.runOnUiThread {
                            // 1일 최고가와 최저가를 SeekBar에 반영
                            val dayLowPrice = companyData?.lowPrice ?: 0
                            val dayHighPrice = companyData?.highPrice ?: 0
                            dayseekbar.max = dayHighPrice - dayLowPrice  // SeekBar의 최대값은 (최고가 - 최저가)
                            dayseekbar.progress = currentPrice - dayLowPrice  // progress는 (현재가 - 최저가)로 설정
                            // 1년 최고가와 최저가를 Year SeekBar에 반영
                            val yearLowPrice = companyData?.oneYearLowPrice ?: 0
                            val yearHighPrice = companyData?.oneYearHighPrice ?: 0
                            yearSeekBar.max = yearHighPrice - yearLowPrice  // SeekBar의 최대값은 (1년 최고가 - 1년 최저가)
                            yearSeekBar.progress = currentPrice - yearLowPrice  // progress는 (현재가 - 1년 최저가)로 설정
                        }
                    } else {
                        Log.e(TAG, "Current price API fail: ${response.errorBody()?.string()}")
                        Toast.makeText(context, "현재가를 불러오는데 실패했습니다.", Toast.LENGTH_SHORT).show()
                    }
                }
                override fun onFailure(call: Call<CurrentPriceResponse>, t: Throwable) {
                    Log.e(TAG, "Current price API fail: ${t.message}", t)
                    Toast.makeText(context, "API 호출 실패: ${t.message}", Toast.LENGTH_SHORT).show()
                }
            })
    }
    private fun updateUI() {
        companyData?.let { data ->
            currentPriceTextView.text = "${data.currentPrice ?: "N/A"}원" // currentPrice 사용
            startPriceTextView.text = "${data.openPrice}원"
            endPriceTextView.text = "${data.closePrice}원"
            volumeTextView.text = "${data.tradingVolume}주"
            tradeAmountTextView.text = "${data.tradingValue / 100000000}억 원"
            yearLowPriceTextView.text = "${data.oneYearLowPrice}원"
            yearHighPriceTextView.text = "${data.oneYearHighPrice}원"
            dayLowPriceTextView.text = "${data.lowPrice}원"
            dayHighPriceTextView.text = "${data.highPrice}원"
        }
        // SeekBar 초기화
        dayseekbar.max = companyData?.oneYearHighPrice ?: 0
    }
}