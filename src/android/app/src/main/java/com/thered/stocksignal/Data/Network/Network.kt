package com.thered.stocksignal.data.network

import com.thered.stocksignal.BuildConfig
import com.thered.stocksignal.Data.Network.RetrofitClient
import okhttp3.Interceptor
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

open class Network {

    val client = OkHttpClient.Builder()
        .addInterceptor { chain ->
            val request = chain.request().newBuilder()
                .addHeader("accept", "*/*")
                .addHeader("Authorization", "Bearer eyJhbGciOiJIUzI1NiJ9.eyJ1c2VySWQiOjEsIm5pY2tuYW1lIjoi7ZmN7JuQ7KSAIiwiaWF0IjoxNzMxMDU0NzczLCJleHAiOjE3MzQ2NTQ3NzN9.gWoR45M4tTpwx1gyk8oiZqUQfvw3aHuaqDxXdKqilDs'")
                .build()
            chain.proceed(request)
        }
        .build()

    val serverUrl: String = "https://pposiraun.com/"
    val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(serverUrl)
        .client(client)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

}