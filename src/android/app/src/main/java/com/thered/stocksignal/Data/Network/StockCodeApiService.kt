package com.thered.stocksignal.Data.Network
import com.thered.stocksignal.Data.model.StockCodeResponse

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path

interface StockCodeApiService {
    @GET("api/company/{companyName}/code")
    fun getStockCode(
        @Path("companyName") companyName: String
    ): Call<StockCodeResponse>
}
