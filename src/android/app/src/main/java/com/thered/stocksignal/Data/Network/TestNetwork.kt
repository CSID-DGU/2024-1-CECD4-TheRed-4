package com.thered.stocksignal.data.network

import android.util.Log
import com.thered.stocksignal.domain.entites.StockList
import com.thered.stocksignal.domain.entites.TestEntry
import retrofit2.Call
import retrofit2.Callback
import retrofit2.Response
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

class TestNetwork {

    val serverUrl: String = "https://pposiraun.com"
    val retrofit: Retrofit = Retrofit.Builder()
        .baseUrl(serverUrl)
        .addConverterFactory(GsonConverterFactory.create())
        .build()

    val service = retrofit.create(TestService::class.java)

    fun getTest(code:String ,callback: (TestEntry?) -> Unit) {
        service.getTest(code).enqueue(object : Callback<TestEntry> {
            override fun onResponse(call: Call<TestEntry>, response: Response<TestEntry>) {
                if (response.isSuccessful) {
                    // 네트워크 요청이 성공하면 응답을 처리
                    val stockList = response.body()
                    Log.d("Network_success", stockList.toString())
                    callback(stockList)  // 콜백을 통해 결과 전달
                } else {
                    Log.d("Network_error", "Response not successful")
                    val re = TestEntry()
                    re.message = "failure"
                    callback(re)
                }
            }

            override fun onFailure(call: Call<TestEntry>, t: Throwable) {
                // 네트워크 요청이 실패했을 때 처리
                Log.d("Network_failure", t.message ?: "Unknown error")
                val re = TestEntry()
                re.message = "failure"
                callback(re)
            }
        })
    }

    fun getLogin(code:String ,callback: (TestEntry?) -> Unit) {
        service.getLogin(code).enqueue(object : Callback<TestEntry> {
            override fun onResponse(call: Call<TestEntry>, response: Response<TestEntry>) {
                if (response.isSuccessful) {
                    // 네트워크 요청이 성공하면 응답을 처리
                    val stockList = response.body()
                    Log.d("Network_success", stockList.toString())
                    callback(stockList)  // 콜백을 통해 결과 전달
                } else {
                    Log.d("Network_error", "Response not successful")
                    val re = TestEntry()
                    re.message = "failure"
                    callback(re)
                }
            }

            override fun onFailure(call: Call<TestEntry>, t: Throwable) {
                // 네트워크 요청이 실패했을 때 처리
                Log.d("Network_failure", t.message ?: "Unknown error")
                val re = TestEntry()
                re.message = "failure"
                callback(re)
            }
        })
    }
}