package com.thered.stocksignal.Data.model

data class CompanyInfoResponse(
    val code: Int,
    val result: String,
    val message: String,
    val data: StockData // 여기서 CompanyData를 StockData로 변경
)

data class StockData( // 클래스 이름을 CompanyData에서 StockData로 변경
    val openPrice: Int,
    val closePrice: Int,
    val tradingVolume: Int,
    val tradingValue: Long,
    val lowPrice: Int,
    val highPrice: Int,
    val oneYearLowPrice: Int,
    val oneYearHighPrice: Int,

    var currentPrice: Int? = null

)
data class CompanyResponse(
    val code: String,
    val result: String,
    val message: String,
    val data: CompanyData?
)

data class CompanyData(
    val companyCode: String?,
    val logoImage: String? // 로고 이미지 경로를 담을 필드 추가
)
data class StockCodeResponse(
    val code: Int,
    val result: String,
    val message: String,
    val data: StockCodeData
)

data class StockCodeData(
    val companyCode: String // 종목 코드를 포함한 필드
)

data class CurrentPriceResponse(
    val code: String,
    val result: String,
    val message: String,
    val data: CurrentPriceData
)

data class CurrentPriceData(
    val currentPrice: Int
)
data class CompanyCodeResponse(
    val code: String,
    val result: String,
    val message: String,
    val data: Data
) {
    data class Data(
        val companyCode: String
    )
}