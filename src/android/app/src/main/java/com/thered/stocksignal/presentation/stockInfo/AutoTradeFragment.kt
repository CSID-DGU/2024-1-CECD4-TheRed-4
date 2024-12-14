package com.thered.stocksignal.presentation.stockinfo

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.ImageButton
import androidx.fragment.app.Fragment
import androidx.lifecycle.lifecycleScope
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import com.thered.stocksignal.presentation.newScenario.NewScenarioConditionActivity
import com.thered.stocksignal.BuildConfig
import com.thered.stocksignal.Data.Network.ProfitRateListener
import com.thered.stocksignal.Data.Network.RetrofitClient
import com.thered.stocksignal.Data.Network.ScenarioApiService
import com.thered.stocksignal.Data.model.ScenarioData
import com.thered.stocksignal.Data.model.ApiResponse
import com.thered.stocksignal.R
import com.thered.stocksignal.presentation.newScenario.NewScenarioActivity
import kotlinx.coroutines.launch
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class AutoTradeFragment : Fragment(), ProfitRateListener {  // ProfitRateListener 구현

    private lateinit var conditionAdapter: ConditionAdapter
    private val conditionList = mutableListOf<com.thered.stocksignal.Data.model.Condition>() // 타입 수정
    private val token = BuildConfig.API_TOKEN // BuildConfig에서 API 토큰을 가져옵니다.
    private var profitRateListener: ProfitRateListener? = null

    private val scenarioApiService: ScenarioApiService = Retrofit.Builder()
        .baseUrl("https://pposiraun.com/")
        .addConverterFactory(GsonConverterFactory.create())
        .build()
        .create(ScenarioApiService::class.java)

    override fun onCreateView(
        inflater: LayoutInflater, container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? {
        return inflater.inflate(R.layout.fragment_auto_trade, container, false)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        // 데이터를 API에서 받아오기
        getScenarioData()

        // RecyclerView 설정
        val recyclerView: RecyclerView = view.findViewById(R.id.conditions_recycler_view)
        recyclerView.layoutManager = LinearLayoutManager(context)
        conditionAdapter = ConditionAdapter(conditionList) { condition ->
            // 시나리오 리스트 항목을 클릭하면 NewScenarioActivity로 이동 (데이터 전달 없음)
            val intent = Intent(activity, NewScenarioActivity::class.java)
            startActivity(intent)
        }
        recyclerView.adapter = conditionAdapter

        // '+ 버튼' 클릭 리스너 설정
        val addButton: Button = view.findViewById(R.id.add_condition)// 해당 버튼의 ID
        addButton.setOnClickListener {
            // NewScenarioConditionActivity 전환
            val intent = Intent(activity, NewScenarioConditionActivity::class.java)
            startActivity(intent)
        }
    }
    private fun getScenarioData() {
        lifecycleScope.launch {
            try {
                val response = RetrofitClient.scenarioApi.getScenarios("Bearer $token")
                Log.d("자동매매", "Response code: ${response.code()}")
                Log.d("자동매매", "Response body: ${response.body()}")  // 응답 본문 출력

                if (response.isSuccessful && response.body() != null) {
                    val apiResponse = response.body() // ApiResponse로 변환된 응답

                    if (apiResponse != null && apiResponse.code == "200" && apiResponse.result == "SUCCESS") {
                        val scenarioDataList = apiResponse.data // ScenarioData 리스트

                        if (scenarioDataList.isNullOrEmpty()) {
                            showEmptyDataMessage()
                        } else {
                            conditionList.clear()
                            scenarioDataList.forEach { scenarioData ->
                                conditionList.add(
                                    com.thered.stocksignal.Data.model.Condition(
                                        name = scenarioData.scenarioName,
                                        profitRate = calculateProfitRate(scenarioData.initialPrice, scenarioData.currentPrice)
                                    )
                                )
                            }
                            conditionAdapter.notifyDataSetChanged()
                        }
                    } else {
                        showErrorMessage("API 응답이 비정상적입니다. code: ${apiResponse?.code}")
                    }
                } else {
                    showErrorMessage("API 요청 실패. 응답 코드: ${response.code()}")
                }
            } catch (e: Exception) {
                Log.e("AutoTradeFragment", "Error fetching data: ${e.message}")
                showErrorMessage("네트워크 오류: ${e.message}")
            }
        }
    }

    private fun showEmptyDataMessage() {
        // 데이터 없음
        Log.d("AutoTradeFragment", "No data available")
    }

    private fun showErrorMessage(message: String) {
        Log.d("AutoTradeFragment", "Error: $message")
    }

    private fun calculateProfitRate(initialPrice: Double, currentPrice: Double): String {
        if (initialPrice == 0.0) return "N/A"
        val profit = (currentPrice - initialPrice) / initialPrice * 100
        val profitRate = String.format("+%.2f%%", profit)

        Log.d("AutoTradeFragment", "Calculated Profit Rate: $profitRate")
        // ProfitRateListener를 통해 수익률을 전달
        profitRateListener?.onProfitRateCalculated(profitRate)
        return profitRate
    }

    override fun onProfitRateCalculated(profitRate: String) {
        // 수익률 계산 후 할 작업을 구현
        Log.d("AutoTradeFragment", "Calculated profit rate: $profitRate")
    }

    override fun onAttach(context: Context) {
        super.onAttach(context)
        if (context is ProfitRateListener) {
            profitRateListener = context
        } else {
            // ProfitRateListener를 구현하지 않은 경우 처리 (필요시 예외 처리)
        }
    }

    override fun onDetach() {
        super.onDetach()
        profitRateListener = null
    }
}
