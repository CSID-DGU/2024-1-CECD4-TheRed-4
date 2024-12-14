package com.thered.stocksignal.Data.Network

import com.thered.stocksignal.Data.model.CompanyCodeResponse
import com.thered.stocksignal.Data.model.CompanyInfoResponse
import com.thered.stocksignal.Data.model.CurrentPriceResponse
import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path

interface StockInfoApiService {
    @GET("/api/company/{companyName}")
    fun getCompanyInfo(
        @Path("companyName") companyName: String
    ): Call<CompanyInfoResponse>

    @GET("/api/company/{companyName}/current-price")
    fun getCurrentPrice(
        @Path("companyName") companyName: String
    ): Call<CurrentPriceResponse>

    @GET("api/company/{companyName}/code")
    fun getCompanyCode(
        @Path("companyName") companyName: String
    ): Call<CompanyCodeResponse>
}
