package com.thered.stocksignal.Data.Network

import com.thered.stocksignal.Data.model.ScenarioResponse
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.Response


interface ScenarioApiService {
    @GET("api/scenario") // 실제 엔드포인트 URL로 변경
    suspend fun getScenarios(
        @Header("Authorization") token: String
    ): Response<ScenarioResponse> // Response<ScenarioResponse>로 변경
}
interface ProfitRateListener {
    fun onProfitRateCalculated(profitRate: String)
}
