package com.thered.stocksignal.Data.model

// API 응답의 데이터를 나타내는 클래스
data class ApiResponse(
    val code: String,
    val result: String,
    val message: String,
    val data: List<ScenarioData> // ScenarioData를 사용
)

// 시나리오 데이터를 나타내는 클래스
data class ScenarioData(
    val scenarioId: Int,
    val scenarioName: String,
    val companyName: String,
    val initialPrice: Double,
    val currentPrice: Double
)

// Condition 클래스는 화면에 표시할 데이터를 나타냄
data class Condition(
    val name: String,
    val profitRate: String,
    val name2: String? = null, // 두 번째 조건이 있을 수 있음
    val profitRate2: String? = null // 두 번째 조건의 profitRate
)

// API 응답을 받아서 Condition으로 변환하는 함수
fun convertToConditions(scenarioDataList: List<ScenarioData>): List<Condition> {
    return scenarioDataList.map { scenarioData ->
        Condition(
            name = scenarioData.scenarioName,
            profitRate = calculateProfitRate(scenarioData.initialPrice, scenarioData.currentPrice)
        )
    }
}

// 수익률을 계산하는 함수
fun calculateProfitRate(initialPrice: Double, currentPrice: Double): String {
    val profit = (currentPrice - initialPrice) / initialPrice * 100
    return String.format("+%.2f%%", profit)
}

// Scenario 데이터 모델
data class Scenario(
    val scenarioId: Int,
    val scenarioName: String,
    val companyName: String,
    val initialPrice: Double,
    val currentPrice: Double
)

// API 응답 모델
data class ScenarioResponse(
    val code: String,
    val result: String,
    val message: String,
    val data: List<Scenario> // data는 Scenario 객체의 리스트
)
