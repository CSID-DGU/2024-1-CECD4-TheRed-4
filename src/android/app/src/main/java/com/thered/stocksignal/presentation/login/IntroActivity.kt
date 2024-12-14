package com.thered.stocksignal.presentation.login

import android.content.Intent
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import androidx.appcompat.app.AppCompatActivity
import com.thered.stocksignal.presentation.login.LoginActivity
import com.thered.stocksignal.R

class IntroActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_intro) // 인트로 화면 레이아웃 설정

        // 3초 후에 LoginActivity로 이동
        Handler(Looper.getMainLooper()).postDelayed({
            val intent = Intent(this, LoginActivity::class.java)
            startActivity(intent)
            finish() // IntroActivity 종료
        }, 3000) // 3000 밀리초로 변경
    }
}

