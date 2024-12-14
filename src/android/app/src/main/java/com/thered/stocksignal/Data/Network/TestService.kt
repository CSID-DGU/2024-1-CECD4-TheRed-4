package com.thered.stocksignal.data.network

import com.thered.stocksignal.domain.entites.TestEntry
import retrofit2.http.GET
import retrofit2.Call
import retrofit2.http.Query

interface TestService {
    @GET("/api/auth/kakao/callback")
    fun getTest(@Query("code") code: String): Call<TestEntry>

    @GET("/api/auth/kakao/login")
    fun getLogin(@Query("code") code: String): Call<TestEntry>
}