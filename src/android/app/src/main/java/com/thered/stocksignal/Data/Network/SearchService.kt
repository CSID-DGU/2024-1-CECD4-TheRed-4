package com.thered.stocksignal.data.network

import com.thered.stocksignal.domain.entites.StockCode
import retrofit2.http.GET
import retrofit2.Call
import retrofit2.http.Path

interface SearchService {

    @GET("testapp/api/company/code/{companyName}")
    fun getStockCode(@Path("companyName") companyName: String): Call<StockCode>

}