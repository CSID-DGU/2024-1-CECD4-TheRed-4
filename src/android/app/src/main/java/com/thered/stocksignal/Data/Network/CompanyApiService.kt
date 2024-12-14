package com.thered.stocksignal.Data.Network

import retrofit2.Call
import retrofit2.http.GET
import retrofit2.http.Path
import com.thered.stocksignal.Data.model.CompanyResponse
import retrofit2.http.Headers

interface CompanyApiService {
    // 회사 정보를 가져오는 GET 요청
    @Headers("Content-Type: application/json")
    @GET("api/company/code/{companyName}") // 회사 코드 조회 URL
    fun getCompanyInfo(
        @Path("companyName") companyName: String
    ): Call<CompanyResponse>

    // 회사 로고 정보를 가져오는 GET 요청
    @Headers("Content-Type: application/json")
    @GET("api/company/{companyName}/logo") // 회사 로고 조회 URL
    fun getCompanyLogo(
        @Path("companyName") companyName: String
    ): Call<CompanyResponse>
}
