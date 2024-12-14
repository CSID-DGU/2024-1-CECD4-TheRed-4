package com.thered.stocksignal.Data.Network

import retrofit2.Call
import retrofit2.http.Body
import retrofit2.http.Headers
import retrofit2.http.POST
import com.thered.stocksignal.Data.model.TokenResponse

data class LoginRequest(
    val code: String // POST 요청에 포함할 인가 코드
)

interface LoginApiService {
    // 프론트에서 인가 코드를 백엔드로 전달하는 경로
    @Headers("Content-Type: application/json")
    @POST("api/auth/kakao/login/code")
    fun loginWithKakao(
        @Body request: LoginRequest // 인가 코드를 요청 바디로 전송
    ): Call<TokenResponse>
}
