package com.thered.stocksignal.presentation.login

import android.net.Uri
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.ImageButton
import android.widget.Toast
import androidx.activity.result.ActivityResultLauncher
import androidx.activity.result.contract.ActivityResultContracts
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import com.kakao.sdk.auth.model.OAuthToken
import com.kakao.sdk.common.KakaoSdk
import com.kakao.sdk.common.util.Utility
import com.kakao.sdk.user.UserApiClient
import com.thered.stocksignal.R
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.http.POST
import com.thered.stocksignal.Data.model.TokenResponse
import com.thered.stocksignal.Data.Network.LoginApiService
import com.thered.stocksignal.Data.Network.LoginRequest
import com.thered.stocksignal.presentation.main.MainActivity

class LoginActivity : AppCompatActivity() {
    private val loginButton: ImageButton by lazy { findViewById(R.id.kakao_login_button) }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_login)

        val uri = intent?.data
        if (uri != null) {
            Log.d("KakaoLogin", "onCreate called with URI: $uri")
            handleRedirect(uri)
        }

        // 카카오 SDK 초기화
        KakaoSdk.init(this, "c93bfd494630d7b92e90714929d816e3")
        val keyHash = Utility.getKeyHash(this)
        Log.d("Hash", keyHash)

        // 로그인 버튼 클릭 시 로그인 시작
        loginButton.setOnClickListener {
//            Log.d("KakaoLogin", "Click the login button")
//            startKakaoLogin()
            val intent = Intent(this, MainActivity::class.java)
            startActivity(intent)
            finish()
        }
    }
    // 카카오 로그인 시작
//    private fun startKakaoLogin() {
//        val clientId = "859897bc7ad1eed0ca3e9bac1b83bb68"
//        val redirectUri = "https://pposiraun.com/api/auth/kakao/callback"
//        val authUrl = "https://kauth.kakao.com/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code"
//        Log.d("KakaoLogin_start", "Request Authorization Code URL: $authUrl")
//        // 로그인 인텐트 실행
//        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(authUrl))
//        Log.d("KakaoLogin_start", "Launching intent for login")
//        Log.d("KakaoLogin_start", "Launching activity for login result")
//        loginResultLauncher.launch(intent)  // 로그인 결과 처리
//    }

    private fun startKakaoLogin() {
        val clientId = "859897bc7ad1eed0ca3e9bac1b83bb68"
        val redirectUri = "https://pposiraun.com/api/auth/kakao/callback"
        val authUrl = "https://kauth.kakao.com/oauth/authorize?client_id=$clientId&redirect_uri=$redirectUri&response_type=code"
        Log.d("KakaoLogin", "Request URL: $authUrl")
        // intent가 처리 가능한지 확인하기
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(authUrl))
        if (intent.resolveActivity(packageManager) != null) {
            Log.d("KakaoLogin", "Launching Intent for URL")
            startActivity(intent)
        } else {
            Log.e("KakaoLogin", "No activity found to handle this intent.")
            Toast.makeText(this, "브라우저를 실행할 수 없습니다. 기본 브라우저를 설정해주세요.", Toast.LENGTH_SHORT).show()
        }
    }
    override fun onNewIntent(intent: Intent?) {
        super.onNewIntent(intent)
        // Intent에서 URI를 추출
        val uri = intent?.data
        // URI가 null이 아닌지 확인하고 로그 찍기
        if (uri != null) {
            Log.d("KakaoLogin", "onNewIntent called with URI: $uri")
            // URI 처리 함수 호출
            handleRedirect(uri)
        } else {
            Log.d("KakaoLogin", "onNewIntent called with null URI.")
        }
    }
        // 로그인 결과를 처리할 ActivityResultLauncher 초기화
//    private val loginResultLauncher: ActivityResultLauncher<Intent> =
//        registerForActivityResult(ActivityResultContracts.StartActivityForResult()) { result ->
//            Log.d("KakaoLogin", "Result Code: ${result.resultCode}")
//            if (result.resultCode == RESULT_OK) {
//                val uri = result.data?.data
//                Log.d("KakaoLogin", "Returned URI: $uri")  // URI 로그 확인
//                if (uri == null) {
//                    Log.d("KakaoLogin", "Intent data is null!")  // URI가 null일 경우
//                } else {
//                    Log.d("KakaoLogin", "Intent data: $uri")  // URI가 정상적으로 전달된 경우
//                }
//                handleRedirect(uri)  // URI 처리
//            } else {
//                Log.d("KakaoLogin", "Login result not OK")
//            }
//        }

    // 리디렉션 URI 처리
    private fun handleRedirect(uri: Uri?) {
        Log.d("KakaoLogin_handleRedirect", "handleRedirect called with URI: $uri")
        if (uri == null) {
            Log.d("Kakao_handleRedirect", "URI is null.")
            return
        }
        val code = uri.getQueryParameter("code")
        if (code != null) {
            Log.d("Kakao_handleRedirect", "Extracted authorization code: $code")
            sendAuthorizationCodeToServer(code)
        } else {
            Log.d("Kakao_handleRedirect", "Authorization code not present.")
            // 사용자에게 알림 (예: Toast)
            Toast.makeText(this, "로그인에 실패했습니다. 다시 시도해주세요.", Toast.LENGTH_SHORT).show()
        }
    }
    // 서버로 인증 코드 전송
    private fun sendAuthorizationCodeToServer(code: String) {
        val retrofit = Retrofit.Builder()
            .baseUrl("https://pposiraun.com/") // 백엔드 URL
            .addConverterFactory(GsonConverterFactory.create())
            .build()
        val apiService = retrofit.create(LoginApiService::class.java)
        val loginRequest = LoginRequest(code) // 인가 코드를 LoginRequest 객체로 전달
        apiService.loginWithKakao(loginRequest).enqueue(object : Callback<TokenResponse> {
            override fun onResponse(call: Call<TokenResponse>, response: Response<TokenResponse>) {
                if (response.isSuccessful) {
                    response.body()?.let { tokenResponse ->
                        val accessToken = tokenResponse.data?.token
                        val userId = tokenResponse.data?.userId
                        Log.d("AccessToken", "Access token: $accessToken")
                        Log.d("UserId", "User ID: $userId")
                        // 로그인 성공 시 MainActivity로 이동
                        val intent = Intent(this@LoginActivity, MainActivity::class.java)
                        startActivity(intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP))
                        finish()
                    } ?: Log.d("KakaoAuthCode", "TokenResponse body is null.")
                } else {
                    Log.e("KakaoAuthCode", "Response error: Code ${response.code()}, Message: ${response.message()}")
                    // 사용자에게 서버 오류 메시지 표시 (예: Toast)
                    Toast.makeText(this@LoginActivity, "서버 오류 발생. 다시 시도해주세요.", Toast.LENGTH_SHORT).show()
                }
            }
            override fun onFailure(call: Call<TokenResponse>, t: Throwable) {
                // 로딩 숨김
                Log.e("Error", "Network Error: ${t.message}")
                // 네트워크 오류 메시지 표시 (예: Toast)
                Toast.makeText(this@LoginActivity, "네트워크 오류 발생", Toast.LENGTH_SHORT).show()
            }
        })
    }
}
