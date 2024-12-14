package com.thered.stocksignal.Data.Network

import com.google.gson.GsonBuilder
import com.thered.stocksignal.BuildConfig
import okhttp3.Interceptor
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import okhttp3.OkHttpClient
import okhttp3.logging.HttpLoggingInterceptor

object RetrofitClient {
    private const val BASE_URL = "http://pposiraun.com/"

    // Authorization 헤더를 추가하는 Interceptor
    private val headerInterceptor = Interceptor { chain ->
        val originalRequest = chain.request()

        // Authorization 값 설정 (추후 로그인 구현 시, 실제 토큰으로 교체 필요)
        val newRequest = originalRequest.newBuilder()
            .header("Authorization", BuildConfig.API_TOKEN) // 동적으로 API 토큰을 가져옴
            .build()

        chain.proceed(newRequest)
    }

    private val logging = HttpLoggingInterceptor().apply {
        level = HttpLoggingInterceptor.Level.BODY
    }

    // Gson 객체 생성 시, setLenient(true) 설정 추가
    private val gson = GsonBuilder()
        .setLenient() // JSON 파싱에 lenient 모드 활성화
        .create()

    // OkHttpClient 설정에 Interceptor 추가
    private val client = OkHttpClient.Builder()
        .addInterceptor(headerInterceptor) // Authorization 헤더를 자동으로 추가하는 Interceptor
        .addInterceptor(logging) // 로그 출력
        .build()

    // Retrofit 객체 생성
    private val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(BASE_URL)
        .client(client) // OkHttpClient 설정을 Retrofit에 적용
        .addConverterFactory(GsonConverterFactory.create(gson)) // 수정된 Gson을 사용하여 파싱
        .build()

    // API 서비스 인스턴스들
    val loginApi: LoginApiService by lazy {
        retrofit.create(LoginApiService::class.java)
    }

    val companyApi: CompanyApiService by lazy {
        retrofit.create(CompanyApiService::class.java)
    }

    val newsApi: NewsApiService by lazy {
        retrofit.create(NewsApiService::class.java)
    }

    val stockInfoApi: StockInfoApiService by lazy {
        retrofit.create(StockInfoApiService::class.java)
    }

    val stockCodeApi: StockCodeApiService by lazy {
        retrofit.create(StockCodeApiService::class.java)
    }
    val scenarioApi: ScenarioApiService by lazy {
        retrofit.create(ScenarioApiService::class.java)
    }

}
